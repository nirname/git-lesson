#!/usr/bin/env bash
N=9
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
  # echo "$N. $DESC" >> task
  echo "$DESC" >> task
  # echo "test" >> .gitignore
  git add .
  git commit -m 'Init'
  create_remote origin
  git push -u origin master
  $1
  cd ../
}

create_test(){
  echo "#!/usr/bin/env bash" > test
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
}
#-----------------
DESC='Сделать коммит.'
x(){ :; }
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
DESC='TODO: Случайно сделал merge --no-ff и push. Надо отменить merge.'
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
create_task x
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
    Переименовать удалённую ветку.'
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
  pwgen 10 8 > passwords
  git add . passwords
  seq 8 15 | xargs -I{} bash -c "echo 'code-line-{}' >> code; git add .; git commit -m 'Wip {}'"
  pwgen 10 10 >> passwords
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

git clone /repo/$N /tasks/$N-alice
cd /tasks/$N-alice
git config user.name 'Alice'
git config user.email 'alice@example.com'
cd ../

git clone /repo/$N /tasks/$N-bob
cd /tasks/$N-bob
git config user.name 'Bob'
git config user.email 'bob@example.com'
cd ../

rm -rf /tasks/$N

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
DESC='Добавил изменения в stash и очистил. Вернуть что было.'
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
DESC='Случайно сделал merge в master, а затем push. Сделать revert.'
x(){
  git checkout -b feature
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Feature {}'"
  git checkout master
  git merge --no-ff feature
  git push -u origin master
}
create_task x
#-----------------
DESC='Сделал revert в мастер, продолжаю работу, хочу снова сделать merge.'
x(){
  git checkout -b feature
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Feature {}'"
  git checkout master
  git merge --no-ff feature
  git push -u origin master
  git checkout -b revert-feature
  git revert -m 1 master --no-edit master
  git checkout master
  git merge --no-ff revert-feature
  git push -u origin master
  git checkout feature
  seq 4 5 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Feature {}'"
}
create_task x
#-----------------
DESC='Случайно сделал коммиты в мастер и запушил, а надо было в feature, сделать revert.'
x(){
  # git clone /repo/$N /tmp/
  seq 3 | xargs -I{} bash -c "echo 'line {}' >> code; git add .; git commit -m 'Feature {}'"
  git push -u origin master
}
create_task x
#-----------------
DESC='TODO: Не могу сделать pull, файлы в локальном репозитории.'
x(){
  echo 'line' >> code
  git add .
  git commit -m 'Code in master'
}
create_task x
#-----------------
DESC='В каком-то из коммитов сломали тесты. Найти нужный коммит'
x(){
  local q=$(((RANDOM % 100) + 1))
  local shebang="#!/usr/bin/env bash"
  echo $shebang | tee code test
  echo -n ":" >> test
  chmod 744 code test; git add .; git commit -m 'Started coding'
  git push -u origin master;
  pwgen 10 $q -1          | xargs -I{} bash -c "echo 'echo \"{}\"' >> code; echo -n ' && ./code | grep -Fxq {}' >> test; git add .; git commit -m 'Wip'"
  local err="`pwgen 10 1 -1`"
  echo $err               | xargs -I{} bash -c "echo 'echo \"`pwgen 10 1 -1`\"' >> code; echo -n ' && ./code | grep -Fxq {}' >> test; git add .; git commit -m 'Wip'"
  pwgen 10 $((99 - q)) -1 | xargs -I{} bash -c "echo 'echo \"{}\"' >> code; echo -n ' && ./code | grep -Fxq {}' >> test; git add .; git commit -m 'Wip'"
}
create_task x