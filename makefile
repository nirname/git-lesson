start: build
	docker run -it nirname/git-lesson

build:
	docker build -t nirname/git-lesson .

push:
	docker push nirname/git-lesson

clean:
	-docker ps -aq -f status=exited | xargs docker rm
	-docker images nirname/git-lesson -f dangling=true -q | xargs docker rmi
	-docker images nirname/git-lesson -f before=nirname/git-lesson:latest -q | xargs docker rmi

clean-all:
	-docker ps -aq -f status=exited | xargs docker rm
	-docker images -f dangling=true -q | xargs docker rmi
