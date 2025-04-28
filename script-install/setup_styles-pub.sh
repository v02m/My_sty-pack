#!/bin/bash

# Определение переменных
SOURCE_DIR="$HOME/home/user/.../My_sty-pack"  # Путь к вашему Git-репозиторию
TARGET_DIR="$HOME/texmf/tex/latex/My_sty-pack"                # Путь к локальной директории LaTeX

# Создание целевой директории, если её нет
mkdir -p "$TARGET_DIR"

# Удаление старых ссылок или файлов в целевой директории
rm -rf "$TARGET_DIR/*"

# Список файлов стилей, которые нужно связать
FILES=(
    "bibsetup.sty"
    "enumsetup.sty"
    "fontswitch.sty"
    "geometrysetup.sty"
    "graphicssetup.sty"
    "langsetup.sty"
    "layoutsetup.sty"
    "listingssetup.sty"
    "mysetup-beamer.sty"
    "mysetup-memoir.sty"
    "mysetup.sty"
    "pdf-setup.sty"
    "tablesetup.sty"
    "todo-setup.sty"
)

# Создание символических ссылок
echo "Creating symbolic links..."
for FILE in "${FILES[@]}"; do
    ln -s "$SOURCE_DIR/$FILE" "$TARGET_DIR/$FILE"
    echo "Linked $FILE"
done

# Обновление базы данных TeX Live
echo "Updating TeX Live database..."
texhash "$HOME/texmf"

echo "Setup complete!"

#    LaTeX ищет файлы стилей (.sty) в определённых директориях. Обычно это: 
#    Локальная пользовательская директория: ~/texmf/tex/latex/
#    Системная директория (для всех пользователей): /usr/local/share/texmf/tex/latex/
#    Мы будем использовать локальную директорию (~/texmf/tex/latex/), так как она не требует прав администратора. 
