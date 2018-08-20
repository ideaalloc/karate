# karate
Karate Docker Image

### Use it

```sh
$ docker pull atpio/atlasp-karate:1.0.0
```

You should have created a features folder with feature files in it, after that you can run as:

```sh
$ docker run -it --rm -e ENV --name atlasp-karate-running atlasp-karate karate
```

### Build

```sh
$ export ENV=dev
```

```sh
$ docker build -t atlasp-karate .
$ docker run -it --rm -e ENV --name atlasp-karate-running atlasp-karate
```
