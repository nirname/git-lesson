#!/usr/bin/env bash

N=0
#-----------------
DESC='Задание'
create_remote(){
  mkdir -p /repo
  git init /repo/$N --bare
  git remote add $1 /repo/$N
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
x(){ :; }
create_task x
t(){
  echo "test \$(git rev-list `git rev-parse HEAD`..master | wc -l) == 1" >> test
}
create_test t
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
DESC='Случайно сделал несколько коммитов в мастер, а надо было в feature.
Перенести все fix коммиты в feature.'
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
DESC='TODO: Случайно сделал merge и push. Надо отменить merge.'
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
DESC='Сделал локальный коммит с неправильным описанием, надо поправить.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'wROnG Msg'
}
create_task x
#-----------------
DESC='TODO: Сделал коммит, запушил, надо переименовать'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'wROnG Msg'
  git push -u origin master
}
#-----------------
DESC='Неправильно назвал ветку и поместил в репозиторий.
Переименовать удалённую ветку в task-456.'
x(){
  git checkout -b task-123
  echo 'task 456' >> code
  git add .
  git commit -m 'Task 456'
  git push -u origin task-123
}
create_task x
#-----------------
DESC='Запушили пароли в репозитарий, надо почистить историю.'
x(){
  seq 1 7 | xargs -I{} bash -c "echo 'code-line-{}' >> code; git add .; git commit -m 'Wip {}'"
  echo "Yai8Ahg3
Eo4faika
theewama
Sahthais
lee9Guuj
airooy5A
ieGhio1j
Shie0ahr" > passwords
  git add . passwords
  seq 8 15 | xargs -I{} bash -c "echo 'code-line-{}' >> code; git add .; git commit -m 'Wip {}'"
  echo "mee4ePei
AeQu3aeR
Eiz9zebu
ieyai2Ao
OhboGh1e
awakieM4
No8iepoo
doo2eiVi
atahph3H
ach5jaiG" >> passwords
  seq 16 20 | xargs -I{} bash -c "echo 'code-line-{}' >> code; git add .; git commit -m 'Wip {}'"
  # git rm passwords
  # git add .
  # git cm -m 'Removed passwords'
  git push -u origin master
}
create_task x
#-----------------
DESC='Слить несколько веток в одну одним коммитом.'
x(){
  seq 3 | xargs -I{} bash -c "git checkout master; git checkout -b module-{}; echo 'module_{}' >> module_{}; git add .; git commit -m 'Module {}'"
  git checkout master
}
create_task x
t(){ :; }
#-----------------
DESC='Неправильный автоматический merge'
x(){
  echo '#!/usr/bin/env bash
func5(){ echo 5; }
func2(){ echo 2; }
func1(){ echo 1; }
func4(){ echo 4; }
func3(){ echo 3; }

func3
func1
func4
func2
func5
' >> script
  chmod 744 script
  git add .
  git cm -m 'Script'
  git push -u origin master
}
create_task x
cp -r /tasks/$N /tasks/$N-bob
mv /tasks/$N /tasks/$N-alice
# hello(){ echo 'hello' }
# hello(){ echo 'hell' }
# echo "`git rev-parse master` `git rev-parse module-1` `git rev-parse module-2` `git rev-parse module-3`"
# if [ "valid" = "valid" ]; then echo 't'; fi
# git show -s --pretty=%P <commit>
#-----------------
DESC='Понял, что всё что было сделано локально - ужас. Вернуть до состояния удалённого репозитория'
x(){
  echo 'work' >> code; git add .; git commit -m 'Work'
}
#-----------------
DESC='Случайно сделал reset --hard, спасти что было.'
x(){
  echo 'work' >> code; git add .; git commit -m 'Fix'
  git push -u origin master
  git checkout -b feature
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Wip {}'"
  git reset --hard master
  git checkout master
  git br -D feature
}
create_task x
#-----------------
DESC='Добавил изменения в stash, и очистил, как вернуть что было.'
x(){
  git checkout -b feature
  echo 'work-in-progress' >> code
  git add .
  git stash
  git co master
  echo 'fix' >> code
  git add .
  git commit -m Fix
  git push
  git checkout feature
  # git stash clear
}
create_task x
#-----------------
DESC='Не могу сделать pull, файлы в локальном репозитории.'
x(){
  git che
}
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?