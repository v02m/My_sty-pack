#!/bin/bash

# Цвета для подсветки
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Пути
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)" #Определить полный путь к скрипту, перейдя в его директорию
PROJECT_DIR="$SCRIPT_DIR/.."
SRC_DIR="$PROJECT_DIR/src"
OUTPUT_FILE="$PROJECT_DIR/module_packages.txt"

# Проверка папки src
if [[ ! -d "$SRC_DIR" ]]; then
    echo -e "${RED}❌ Ошибка: Папка 'src' не найдена!${NC}" >&2
    exit 1
fi

# Функция для подсветки пакетов
highlight_packages() {
    local search_term="$1"
    local line="$2"
    
    # Разделяем строку на модуль и пакеты
    local module_part=$(echo "$line" | cut -d'|' -f1)
    local packages_part=$(echo "$line" | cut -d'|' -f2-)
    
    # Подсвечиваем только если есть поисковый запрос
    if [ -n "$search_term" ]; then
        packages_part=$(echo "$packages_part" | sed -E "s/($search_term)/${RED}\1${NC}/gi")
    fi
    
    echo -e "${BLUE}$module_part${NC}|$packages_part"
}

# Основная функция анализа
analyze_packages() {
    local search_term="$1"
    local output_mode="$2"
    
    # Создаем временный файл
    local temp_file=$(mktemp)
    
    # Заголовок таблицы (без цвета для файла)
    if [ "$output_mode" = "console" ]; then
        echo -e "${YELLOW}МОДУЛЬ | ПАКЕТЫ${NC}"
        echo -e "${YELLOW}-------|--------${NC}"
    else
        echo "МОДУЛЬ | ПАКЕТЫ" > "$temp_file"
        echo "-------|--------" >> "$temp_file"
    fi
    
    # Анализ файлов
    find "$SRC_DIR" -name "*.sty" -type f | while read -r module; do
        module_name=$(basename "$module")
        
        packages=$(
            grep -v '^[[:space:]]*%' "$module" | \
            grep -oE '\\(usepackage|RequirePackage)(\[[^]]*\])?\{[^}]+\}' | \
            sed -E 's/\\[a-zA-Z]+(\[[^]]*\])?\{([^}]+)\}/\2/' | \
            sort | uniq | tr '\n' ',' | sed 's/,$//; s/,/, /g'
        )
        
        if [ -n "$search_term" ]; then
            filtered_pkgs=$(echo "$packages" | tr ',' '\n' | grep -i "$search_term" | tr '\n' ',' | sed 's/,$//; s/,/, /g')
            if [ -n "$filtered_pkgs" ]; then
                highlight_packages "$search_term" "$module_name | $filtered_pkgs" >> "$temp_file"
            fi
        else
            if [ -z "$packages" ]; then
                highlight_packages "" "$module_name | (нет пакетов)" >> "$temp_file"
            else
                highlight_packages "" "$module_name | $packages" >> "$temp_file"
            fi
        fi
    done
    
    # Сортировка результатов
    sort -o "$temp_file" "$temp_file"
    
    # Вывод результатов
    if [ "$output_mode" = "console" ]; then
        column -t -s "|" < "$temp_file"
    else
        # Для файла убираем цветовые коды
        sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g" "$temp_file" > "$OUTPUT_FILE"
        echo -e "${GREEN}✅ Результаты сохранены в $OUTPUT_FILE${NC}"
    fi
    
    rm "$temp_file"
}

# Меню выбора
echo -e "${YELLOW}Выберите режим вывода:${NC}"
echo "1. Вывести в консоль (с подсветкой)"
echo "2. Сохранить в файл ($OUTPUT_FILE)"
read -p "Ваш выбор (1/2): " output_choice

echo -e "${YELLOW}Хотите найти конкретные пакеты?${NC}"
echo "1. Да (ввести название)"
echo "2. Нет (вывести все)"
read -p "Ваш выбор (1/2): " search_choice

if [ "$search_choice" = "1" ]; then
    read -p "Введите название пакета (или часть): " search_term
else
    search_term=""
fi

# Обработка выбора
case "$output_choice" in
    1) analyze_packages "$search_term" "console" ;;
    2) analyze_packages "$search_term" "file" ;;
    *)
        echo -e "${RED}❌ Неверный выбор!${NC}"
        exit 1
        ;;
esac
