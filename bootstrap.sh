N=0
#-----------------
DESC='Задание'
create_remote(){
  mkdir -p /.repo
  git init /.repo/$N --bare
  git remote add $1 /.repo/$N
}

create_task(){
  N=$((N+1))
  git init $N && cd $N
  echo $DESC >> task
  echo "test" >> .gitignore
  git add .
  git commit -m 'Init'
  create_remote origin
  git push -u origin master
  $1
  cd ../
}

create_test(){
  cd $N
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
DESC='Сделать коммит.'
x(){}
create_task x
t(){
  echo "test \$(git rev-list `git rev-parse HEAD`..master | wc -l) == 1" >> test
}
create_test t
#-----------------
DESC='Локально сделал коммит с неправильным описанием, надо поправить.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'wROnG Msg'
}
create_task x
#-----------------
DESC='Сделать слияние feature -> master, где в мастере есть коммит. Посмотреть историю.'
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
  git commit -m 'New changes in master'
  git checkout feature
}
create_task x
t(){
  echo "test \$(git branch --merged master | grep -oE '[^[:alpha:]][^[:alpha:]]feature$' | sort -u | wc -l) == 1" >> test
}
create_test t
#-----------------
DESC='Сделать слияние feature -> master, где в мастере нет коммитов.
Посмотреть историю, отменить merge, сделать merge с дополнительным коммитом.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code in master'
  git checkout -b feature
  echo 'line' >> module
  git add .
  git commit -m 'Module in branch'
}
create_task x
t(){
  echo "test \$(git rev-list --merges --count master~1..master) == 1" >> test
}
create_test t
#-----------------
DESC='Случайно сделал коммит в мастер, а надо было в feature. Перенести в feature.'

x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code in master'
  git branch feature
  echo 'line for feature' >> code
  git add .
  git commit -m 'Code in feature'
}
create_task x
t(){
  echo "git rev-list master..feature | grep -Fxq `git rev-parse master`" >> test
}
create_test t
#-----------------
DESC='Случайно сделал несколько коммитов в мастер, а надо было в feature. Перенести в feature.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git push -u origin master
  git branch feature
  seq 4 | xargs -I{} bash -c "echo 'line {} for feature' >> code; git add .; git commit -m 'Fix {}'"
}
create_task x
t(){
  echo "git rev-list master..feature | grep -Fxq `git rev-parse master`" >> test
}
create_test t
#-----------------
DESC='Начал делать задачу Б прямо из ветки А, забыл переключиться в master.
Сделать так, чтобы ветка по задаче Б была из ветки master'

x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git checkout -b feature-a
  echo 'module_a.call()' >> code
  git commit -am 'Feature A call'
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> module_a; git add .; git commit -m 'For feature A {}'"
  git checkout -b feature-b
  echo 'module_b.call()' >> code
  git commit -am 'Feature B call'
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> module_b; git add .; git commit -m 'For feature B {}'"
}
create_task x
#-----------------
DESC='Случайно сделал merge и push. Надо отменить merge.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code'
  git branch feature
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Fix in master {}'"
  git push -u origin master
  git chekcout feature
  seq 4 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'For feature {}'"
  git checkout master
  git merge --no-ff feature
  git push -u origin master
}
#-----------------
DESC='Не могу сделать pull, файлы в локальном репозитории.'
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?







