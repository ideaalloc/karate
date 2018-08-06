FROM maven:3-jdk-8-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY pom.xml /tmp/pom.xml

COPY . /usr/src/app

RUN mvn -B -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml prepare-package -DskipTests

RUN ["chmod", "+x", "/usr/src/app/maven_runner.sh"]

CMD ["/usr/src/app/maven_runner.sh"]
