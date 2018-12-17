start: build
	docker run -it git-lesson

build:
	docker build -t git-lesson .

clean:
	-docker images -f "dangling=true" -q | xargs docker rmi -f
	-docker images git-lesson -f "before=git-lesson:latest" -q | xargs docker rmi -f