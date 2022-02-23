FROM openjdk:11-jdk-slim
RUN apt-get update && apt-get install -y git curl unzip procps time
ARG USERNAME=intellij
ARG GROUPNAME=intellij
ARG UID=1000
ARG GID=1000
ARG PROJDIR=project
#ARG IDEURL=https://download.jetbrains.com/idea/ideaIU-2021.3.2.tar.gz
ARG IDEURL=https://download.jetbrains.com/idea/ideaIU-221.4501.155.tar.gz
#ARG PROJURL=https://github.com/spring-projects/spring-petclinic
ARG PROJURL=https://github.com/mhorioka/HelloSpringBootRemoteDev


#Create non-root user
RUN groupadd -g $GID $GROUPNAME && \
   useradd -m -s /bin/bash -u $UID -g $GID $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

#Clone project code and build (to cache dependencies,etc)
RUN git clone $PROJURL $PROJDIR
RUN cd $PROJDIR && ./mvnw -ntp package

#Download & Install IntelliJ IDEA
RUN curl -fsSL -o ide.tar.gz $IDEURL && \
mkdir ide && \
tar xfz ide.tar.gz --strip-components=1 -C ide && \
rm ide.tar.gz

#Install plugin
RUN time ide/bin/remote-dev-server.sh installPlugins $PROJDIR com.intellij.ja

#Following features are disabled
#RUN time ide/bin/remote-dev-server.sh warm-up $PROJDIR
#ENV REMOTE_DEV_SERVER_JCEF_ENABLED=1

#Default command
CMD ide/bin/remote-dev-server.sh run $PROJDIR --listenOn 0.0.0.0 --port 5993