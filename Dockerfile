# syntax=docker/dockerfile:1
# Instead of creating our own base image,
# we’ll use the official Go image that already has all the tools and packages to compile
# and run a Go application.
# When we have used that FROM command, we told Docker to include in our image all the functionality
# from the golang:1.16-alpine image. All of our consequent commands would build on top of that “base” image.
FROM golang:1.19-alpine

#To make things easier when running the rest of our commands, let’s create a directory inside the image
#that we are building. This also instructs Docker to use this directory as the default destination
#for all subsequent commands.
WORKDIR /app

#But before we can run go mod download inside our image, we need to get our go.mod and go.sum
#files copied into it. We use the COPY command to do this. Copy dependencies
COPY go.mod ./


#Now that we have the module files inside the Docker image that we are building,
#we can use the RUN command to execute the command go mod download there as well.
#This works exactly the same as if we were running go locally on our machine, but
#this time these Go modules will be installed into a directory inside the image.
RUN go mod download

#At this point, we have an image that is based on Go environment version 1.16
#(or a later minor version, since we had specified 1.16 as our tag in the FROM command)
#and we have installed our dependencies.

#The next thing we need to do is to copy our source code into the image.
#We’ll use the COPY command just like we did with our module files before.
#This COPY command uses a wildcard to copy all files with .go extension located
#in the current directory on the host (the directory where the Dockerfile is located)
#into the current directory inside the image.
COPY *.go ./

#Now, we would like to compile our application. To that end, we use the familiar RUN command.
#This should be familiar. The result of that command will be a static application binary named
#docker-gs-ping and located in the root of the filesystem of the image that we are building.
#We could have put the binary into any other place we desire inside that image, the root directory
#has no special meaning in this regard. It’s just convenient to use it to keep the file paths
#short for improved readability.
RUN go build -o docker-gs-ping

#tell Docker what command to execute when our image is used to start a container.
CMD [ "./docker-gs-ping" ]
