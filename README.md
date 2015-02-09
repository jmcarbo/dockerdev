# dockerdev
My docker development environment

RUN

```
docker run --rm -ti -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd):/home/swuser/data -p 5901:5901 -h myhost dockerdev
```
vncserver :1 -geometry 1280x800 -depth 24
```
