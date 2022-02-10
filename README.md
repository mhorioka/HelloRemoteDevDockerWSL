A Sample project to test remote development feature of IntelliJ IDEA on Docker + WSL2 environment

# How to use

## 1. Build docker image

docker build -t remote-dev .

## 2. Run the docker image

docker run -i -t --rm --name my-remote-dev -p 5993:5993 -p 8080:8080 remote-dev /bin/bash

## 3. In the container, start remote server 

ide/bin/remote-dev-server.sh run project --listenOn 0.0.0.0 --port 5993

## 4. Find and copy a link for connection

You can find a following link in standard output


Join link: tcp://0.0.0.0:5993...


## 5. Connect to the remote server from JetBrains Gateway using the link