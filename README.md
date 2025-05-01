1. Новая структура проекта  

Теперь структура проекта выглядит так: 

project/

├── script-install/    # Здесь находится ваш скрипт (например, setup_styles.sh)

├── src/      # Здесь находятся ваши файлы стилей (.sty)
|        
└── ...              # Другие файлы и папки


Скрипт должен: 

    Находить файлы стилей в директории src.
    Создавать символические ссылки для них в локальной директории LaTeX (~/texmf/tex/latex/My_sty-pack).
     
     
 3. Объяснение изменений  

    Определение корневой директории проекта : 
    
    SOURCE_DIR="$PROJECT_DIR/src"
    
    Теперь мы явно указываем, что файлы стилей находятся в поддиректории src.
    
    BASENAME=$(basename "$FILE")
    
    
    Это позволяет получить только имя файла (например, bibsetup.sty) без полного пути. 

Создание символической ссылки : 
bash 
 
1 ln -s "$FILE" "$TARGET_DIR/$BASENAME"

Создаём символическую ссылку для каждого файла в целевой директории. 


4. Как использовать скрипт  

    Поместите скрипт в script-install :
    Убедитесь, что файл setup_styles.sh находится в директории script-install. 

    Сделайте скрипт исполняемым :
    Если вы ещё не сделали это, выполните команду: 
    
    1  chmod +x script-install/setup_styles.sh
    
    
    
5. Проверка работы  

    Проверьте, что символические ссылки созданы: 
    bash     
 
1 ls -l ~/texmf/tex/latex/My_sty-pack/
 
Вы должны увидеть что-то вроде: 
 
 
1 bibsetup.sty -> /path/to/project/src/bibsetup.sty
2 enumsetup.sty -> /path/to/project/src/enumsetup.sty
3 ...

Проверьте, что LaTeX видит ваши файлы:
Создайте тестовый .tex файл и попробуйте подключить один из ваших стилей: 
latex
 
 
1 \documentclass{article}
2 \usepackage{bibsetup} % Пример подключения вашего стиля
3 \begin{document}
4 Test
5 \end{document}

Скомпилируйте документ: 
bash
 
 
    1    xelatex test.tex
     
 Если всё настроено правильно, документ cкомпилируется без ошибок. 
 
 
profile
Qwen2.5-Max

Понял! Структура проекта изменилась, и теперь файлы стилей находятся в поддиректории src, а скрипт находится в поддиректории script-install. Мы адаптируем ваш Bash-скрипт, чтобы он работал с новой структурой. 
1. Новая структура проекта  

Теперь структура проекта выглядит так: 
 
 
1
2
3
4
project/
├── script-install/    # Здесь находится ваш скрипт (например, setup_styles.sh)
├── src/               # Здесь находятся ваши файлы стилей (.sty)
└── ...                # Другие файлы и папки
 
 

Скрипт должен: 

    Находить файлы стилей в директории src.
    Создавать символические ссылки для них в локальной директории LaTeX (~/texmf/tex/latex/My_sty-pack).
     

2. Обновленный Bash-скрипт  

Вот обновленный скрипт, который учитывает новую структуру: 
bash
 
 
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
#!/bin/bash

# Определение переменных
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"  # Корневая директория проекта
SOURCE_DIR="$PROJECT_DIR/src"                    # Путь к файлам стилей в src
TARGET_DIR="$HOME/texmf/tex/latex/My_sty-pack"   # Путь к локальной директории LaTeX

# Создание целевой директории, если её нет
mkdir -p "$TARGET_DIR"

# Удаление старых ссылок или файлов в целевой директории
rm -rf "$TARGET_DIR/*"

# Получение списка всех .sty файлов из src
FILES=("$SOURCE_DIR"/*.sty)

# Создание символических ссылок
echo "Creating symbolic links..."
for FILE in "${FILES[@]}"; do
    BASENAME=$(basename "$FILE")  # Имя файла без пути
    ln -s "$FILE" "$TARGET_DIR/$BASENAME"
    echo "Linked $BASENAME"
done

# Обновление базы данных TeX Live
echo "Updating TeX Live database..."
texhash "$HOME/texmf"

echo "Setup complete!"
 
 
3. Объяснение изменений  

    Определение корневой директории проекта : 
    bash
     

 
1
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
 
 

    $0 — это путь к текущему скрипту.
    dirname "$0" — это директория, где находится скрипт (script-install).
    "$(dirname "$0")/.." — это переход на уровень выше (корневая директория проекта).
    pwd — это абсолютный путь к корневой директории.
     

Путь к файлам стилей : 
bash
 
 
1
SOURCE_DIR="$PROJECT_DIR/src"
 
 

Теперь мы явно указываем, что файлы стилей находятся в поддиректории src. 

Получение списка .sty файлов : 
bash
 
 
1
FILES=("$SOURCE_DIR"/*.sty)
 
 

Мы используем маску *.sty, чтобы автоматически найти все файлы стилей в директории src. 

Использование basename : 
bash
 
 
1
BASENAME=$(basename "$FILE")
 
 

Это позволяет получить только имя файла (например, bibsetup.sty) без полного пути. 

Создание символической ссылки : 
bash
 

     
    1
    ln -s "$FILE" "$TARGET_DIR/$BASENAME"
     
     

    Создаём символическую ссылку для каждого файла в целевой директории. 
     

4. Как использовать скрипт  

    Поместите скрипт в script-install :
    Убедитесь, что файл setup_styles.sh находится в директории script-install. 

    Сделайте скрипт исполняемым :
    Если вы ещё не сделали это, выполните команду: 
    bash
     

 
1
chmod +x script-install/setup_styles.sh
 
 

Запустите скрипт :
Выполните скрипт из корневой директории проекта: 
bash
 

     
    1
    ./script-install/setup_styles.sh
     
     
     

5. Проверка работы  

    Проверьте, что символические ссылки созданы: 
    bash
     

 
1
ls -l ~/texmf/tex/latex/My_sty-pack/
 
 

Вы должны увидеть что-то вроде: 
 
 
1
2
3
bibsetup.sty -> /path/to/project/src/bibsetup.sty
enumsetup.sty -> /path/to/project/src/enumsetup.sty
...
 
 

Проверьте, что LaTeX видит ваши файлы:
Создайте тестовый .tex файл и попробуйте подключить один из ваших стилей: 
latex
 
 
1
2
3
4
5
\documentclass{article}
\usepackage{bibsetup} % Пример подключения вашего стиля
\begin{document}
Test
\end{document}
 
 

Скомпилируйте документ: 
bash
 

     
    1
    pdflatex test.tex
     
     

    Если всё настроено правильно, документ скомпилируется без ошибок. 
     

6. Автоматизация (опционально)  

Если вы хотите автоматизировать запуск скрипта при каждом коммите в Git: 
Перейдите в директорию .git/hooks вашего репозитория: 

    bash
    1 cd /path/to/project/.git/hooks 
 

Создайте файл post-commit: 
bash 
1 nano post-commit
 
Добавьте в него вызов скрипта: 
bash
  
1 #!/bin/bash
2 /path/to/project/script-install/setup_styles.sh

Сделайте файл исполняемым: 
bash

    1   chmod +x post-commit 

Теперь скрипт будет автоматически запускаться после каждого коммита. 


Скрипт находит файлы стилей в директории src, создает символические ссылки и копирует их в локальную директорию LaTeX. 

best regards Valery


