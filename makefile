lesson:
	docker build -t lesson . && docker run -it lesson /bin/bash

clean:
	docker rmi -f $(docker images -f "dangling=true" -q)
	docker rmi -f $(docker images lesson -f "before=lesson:latest" -q)