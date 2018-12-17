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
DESC='Сделать слияние feature -> master, где в мастере нет коммитов'
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
DESC='Сделать слияние feature -> master, где в мастере есть коммит, посмотреть историю'
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
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?
