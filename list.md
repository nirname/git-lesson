1. Сделать коммит

  ```
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  #-----------------
  echo 'code line' >> code
  git commit -am 'Code'
  ```

1. Сделать слияние feature -> master, где в мастере есть коммит, посмотреть историю

  ```
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  echo 'code line' >> code2
  git commit -am 'New module'
  git checkout -b feature
  echo 'code line 2' >> code
  git commit -am 'Feature implementation'
  #-----------------
  git checkout master
  git merge feature
  ```

1. Сделать слияние feature -> master, где в мастере нет коммитов

  ```
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  echo 'code line' >> code2
  git commit -am 'New module'
  git checkout -b feature
  #-----------------
  git checkout master
  git merge feature
  ```

1. Сделать слияние feature -> master с дополнительным коммитом

  ```
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  echo 'code line' >> code2
  git commit -am 'New module'
  git checkout -b feature
  #-----------------
  git checkout master
  git merge --no-ff feature
  ```

1. Решить конфликт

  ```
  git init .
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  echo 'code line 1' > code
  git commit -am 'Fix'
  git checkout -b feature
  echo 'code line 2' > code
  git commit -am 'Refactoring'
  #-----------------
  git checkout master
  git merge --no-ff feature
  ```

1. Неправильный merge

  [Пример](https://news.ycombinator.com/item?id=9871042)

1. Octopus merge

1. Случайно сделал коммит в мастер, не запушил, а надо было в feature, перенести в feature

1. Сделал несколько коммитов в мастер, а надо было в feature, перенести в feature
1. Случайно сделал коммиты в мастер и запушил, а надо было в feature, сделать ревёрт
1. Сделал ревёрт в мастер, продолжаю работу над feature, хочу запушить изменения в репозитарий
1. Начал делать фичу А, потом начал делать фичу Б, забыл переключиться в мастер, перенести изменения только из Б

1. Сделал локальный коммит, надо переименовать

  ```
  git init .
  echo 'code line' >> code
  git add .
  git commit -m 'Init'
  #-----------------
  git commit -amend -m 'Started new project'
  ```

1. Сделал коммит, запушил, надо переименовать (! опасно)
1. Переименовать удалённую ветку
1. Не могу сделать pull, файлы в локальном репозитории
1. Запушил пароли в репозитарий, надо почистить историю
1. Случайно сделал reset --hard, как вернуть что было
1. Добавил изменения в stash, и очистил, как вернуть что было
1. Было 3 важные строчки, их сломали, тесты не проходят, найти место поломки, и вернуть как было

