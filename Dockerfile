FROM ubuntu as builder
COPY lib /lib
COPY haarcascades .
EXPOSE 8080
RUN apt update -y
RUN apt install -y software-properties-common
#RUN apt install -y gnupg
#RUN  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys KEYID
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EB9B1D8886F44E2A
#RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
#RUN apt install -y gnupg > /dev/null
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 0xEB9B1D8886F44E2A
#RUN wget https://download.docker.com/linux/ubuntu/gpg
#RUN apt-key add gpg 
#RUN apt-add-repository -y ppa:openjdk-r/ppa
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt update -y
RUN apt install -y maven
RUN apt install -y git
RUN apt install -y openjdk-8-jdk 
RUN apt install -y libpng16-16 
RUN apt install -y libjasper1 
RUN apt install -y libdc1394-22  
RUN git clone https://github.com/barais/TPDockerSampleApp 
WORKDIR /TPDockerSampleApp/
RUN mvn install:install-file -Dfile=/lib/opencv-3410.jar -DgroupId=org.opencv  -DartifactId=opencv -Dversion=3.4.10 -Dpackaging=jar 
RUN mvn package 
# CMD java -Djava.library.path=/lib/ubuntuupperthan18/ -jar target/fatjar-0.0.1-SNAPSHOT.jar

FROM ubuntu as run
RUN apt update -y
RUN apt install -y software-properties-common
RUN add-apt-repository "deb http://security.ubuntu.com/ubuntu xenial-security main"
RUN apt install -y openjdk-8-jre
RUN apt install -y libpng16-16 
RUN apt install -y libjasper1 
RUN apt install -y libdc1394-22  
WORKDIR /app/
COPY --from=builder /TPDockerSampleApp/lib/ubuntuupperthan18/ /app/lib
COPY --from=builder /TPDockerSampleApp/haarcascades /app/haarcascades
COPY --from=builder /TPDockerSampleApp/target/fatjar-0.0.1-SNAPSHOT.jar /app/app.jar
CMD java -Djava.library.path=/app/lib/ -jar /app/app.jar
