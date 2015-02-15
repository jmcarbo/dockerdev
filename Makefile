run:
	docker run --rm -ti -v /Users/joanmarc/.ssh:/home/swuser/ssh -v /var/run/docker.sock:/var/run/docker.sock -p 5901:5901 -v /Users/joanmarc/code/dockerdev:/home/swuser/data -h myhost dockerdev:latest /sbin/my_init -- /bin/bash
build:
	docker build -t dockerdev .
