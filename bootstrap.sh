# N=$(($(find . -maxdepth 1 -type d | wc -l) + 0))
#-----------------
DESC='Задание'
createTask(){
  N=$(find . -maxdepth 1 -type d | wc -l)
  git init $N && cd $N
  echo $DESC >> task
  git add .
  git commit -m 'Init'
  $1
  cd ../
}
#-----------------
DESC='Сделать коммит'
x(){}
createTask x
#-----------------
DESC='? Сделать слияние feature -> master, где в мастере нет коммитов'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git checkout -b feature
  echo 'line' >> module
  git add .
  git commit -m 'Module'
}
createTask x
#-----------------
DESC='? Сделать слияние feature -> master, где в мастере есть коммит. Посмотреть историю'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git checkout -b feature
  echo 'line' >> module
  git add .
  git commit -m 'Module'
  git checkout master
  echo 'line' >> code
  git add .
  git commit -m 'Development'
  git checkout feature
}
createTask x
#-----------------
DESC='Случайно сделал коммит в мастер, а надо было в feature. Перенести в feature'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  echo 'line from feature' >> code
  git add .
  git commit -m 'Feature'
}
createTask x
#-----------------
DESC='Случайно сделал несколько коммитов в мастер, а надо было в feature. Перенести в feature'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Fix {}'"
}
createTask x
#-----------------
DESC='Начал делать фичу А, потом начал делать фичу Б, забыл переключиться в мастер. Перенести изменения только из Б'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git checkout -b feature-a
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'For feature A {}'"
  git checkout -b feature-b
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'For feature B {}'"
}
createTask x
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?







