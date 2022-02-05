FROM openjdk:11-jdk-slim
RUN apt-get update && apt-get install -y git curl unzip procps time
ARG USERNAME=intellij
ARG GROUPNAME=intellij
ARG UID=1000
ARG GID=1000
ARG PROJURL=https://github.com/spring-projects/spring-petclinic
ARG PROJDIR=project
ARG IDEURL=https://download.jetbrains.com/idea/ideaIU-2021.3.2.tar.gz
RUN groupadd -g $GID $GROUPNAME && \
   useradd -m -s /bin/bash -u $UID -g $GID $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
RUN git clone $PROJURL $PROJDIR
RUN cd $PROJDIR && ./mvnw -ntp package
RUN curl -fsSL -o ide.tar.gz $IDEURL && \
mkdir ide && \
tar xfz ide.tar.gz --strip-components=1 -C ide && \
rm ide.tar.gz


#Install plugin
RUN time ide/bin/remote-dev-server.sh installPlugins $PROJDIR com.intellij.ja

#RUN time ide/bin/remote-dev-server.sh warm-up $PROJDIR
#ENV REMOTE_DEV_SERVER_JCEF_ENABLED=1
CMD ide/bin/remote-dev-server.sh run $PROJDIR --listenOn 0.0.0.0 --port 5993