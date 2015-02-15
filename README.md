Run firefox.


```shell
docker run -d --name firefox -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix kennethkl/firefox
```

Subsequent Run:

```shell
docker start firefox
```