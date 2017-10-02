lesson:
	docker build -t lesson . && docker run -it lesson /bin/bash

clean:
	-docker images -f "dangling=true" -q | xargs docker rmi -f
	-docker images lesson -f "before=lesson:latest" -q | xargs docker rmi -f