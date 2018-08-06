# karate
Karate Docker Image

### Run Regression Test

```sh
$ docker build -t atlasp-karate .
$ docker run -it --rm --name atlasp-karate-running atlasp-karate
```

### Create Maven Configutation

```sh
$ mvn archetype:generate \
-DarchetypeGroupId=com.intuit.karate \
-DarchetypeArtifactId=karate-archetype \
-DarchetypeVersion=0.8.0 \
-DgroupId=io.atlasp \
-DartifactId=karate
```
