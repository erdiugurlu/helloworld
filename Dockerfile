FROM erdiugurlu/golang-alpine-git:1.13.6 AS builder
LABEL MAINTAINER=ugurluerdi@gmail.com
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group
RUN apk add --update --no-cache ca-certificates
# Set the working directory outside $GOPATH to enable the support for modules.
#WORKDIR /src
WORKDIR /go/src/helloworld

ENV GO111MODULE=on
COPY ./go.mod ./go.sum ./
RUN go mod download

COPY helloworld.go .
 
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app .


FROM scratch AS final
# Import the user and group files from the first stage.
COPY --from=builder /user/group /user/passwd /etc/
WORKDIR /opt/
COPY --from=builder /go/src/helloworld/app .
USER nobody:nobody
CMD ["./app"]
EXPOSE 11130