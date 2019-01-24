start: build
	docker run -it git-lesson

build:
	docker build -t git-lesson .

clean:
	-docker ps -aq -f status=exited | xargs docker rm
	-docker images git-lesson -f dangling=true -q | xargs docker rmi
	-docker images git-lesson -f before=git-lesson:latest -q | xargs docker rmi

clean-all:
	-docker ps -aq -f status=exited | xargs docker rm
	-docker images -f dangling=true -q | xargs docker rmi
