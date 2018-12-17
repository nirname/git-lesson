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
# test $(git cat-file -t 3ea34ff5db454600f582fa93111b0e24e8ea639a) == commit
# echo $?
