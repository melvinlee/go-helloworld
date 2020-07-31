FROM golang:alpine
WORKDIR /go/src/github.com/melvinlee/app/
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build .

FROM scratch
COPY --from=0 /go/src/github.com/melvinlee/app/app .
ENTRYPOINT ["/app"]