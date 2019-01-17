# N=$(($(find . -maxdepth 1 -type d | wc -l) + 0))
#-----------------
DESC='Задание'
createTask(){
  N=$(find . -maxdepth 1 -type d | wc -l)
  git init $N && cd $N
  echo $DESC >> task
  echo "test" >> .gitignore
  git add .
  git commit -m 'Init'
  $1
  cd ../
}

createTest(){
  F=$(find . -maxdepth 1 -type d | sort | tail -1)
  cd $F
  echo "#!/usr/bin/env bash" >> test
  $1
  echo '
  res=$?
  if [ $res -eq 0 ]; then
    echo "ok"
  else
    echo "fail"
  fi
  exit $res' >> test
  chmod 744 test
  cd ../
}
#-----------------
DESC='Сделать коммит'
x(){}
createTask x
t(){
  echo "test \$(git rev-list `git rev-parse HEAD`..master | wc -l) == 1" >> test
}
createTest t
#-----------------
DESC='? Сделать слияние feature -> master, где в мастере есть коммит. Посмотреть историю'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code in master'
  git checkout -b feature
  echo 'line' >> module
  git add .
  git commit -m 'Module in branch'
  git checkout master
  echo 'line' >> code
  git add .
  git commit -m 'Development in master'
  git checkout feature
}
createTask x
t(){
  echo "test \$(git branch --merged master | grep -oE '[^[:alpha:]][^[:alpha:]]feature$' | sort -u | wc -l) == 1" >> test
}
createTest t
#-----------------
DESC='Сделать слияние feature -> master, где в мастере нет коммитов, отменить merge, сделать другой'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code in master'
  git checkout -b feature
  echo 'line' >> module
  git add .
  git commit -m 'Module in branch'
}
createTask x
t(){
  echo "test \$(git rev-list --merges --count master~1..master) == 1" >> test
}
createTest t
#-----------------
DESC='Случайно сделал коммит в мастер, а надо было в feature. Перенести в feature'

x(){
  git branch feature
  git add .
  git commit -m 'Code'
  echo 'line' >> code
  echo 'line for feature' >> code
  git add .
  git commit -m 'Feature'
}
createTask x
t(){
  echo "git rev-list master..feature | grep -Fxq `git rev-parse master`" >> test
}
createTest t
#-----------------
DESC='Случайно сделал несколько коммитов в мастер, а надо было в feature. Перенести в feature'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  seq 4 | xargs -I{} bash -c "echo 'line {} for feature' >> code; git add .; git commit -m 'Fix {}'"
}
createTask x
t(){}
createTest t
#-----------------
DESC='Начал делать задачу А, потом задачу Б, забыл переключиться в мастер.
Сделать так, чтобы ветка по задаче Б была из ветки мастер'

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
#-----------------
DESC='Случайно сделал merge и push. Надо отменить merge'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git branch feature
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Fix in master {}'"
  git chekcout feature
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Feature dev {}'"
}
#-----------------
DESC='Не могу сделать pull, файлы в локальном репозитории'
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?







