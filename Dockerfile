FROM golang:1.15-alpine as build

WORKDIR /app
ADD . .
RUN CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build -mod=vendor -a -ldflags "-s" -installsuffix cgo -o bin/migrate *.go

# pin to 3.11 for image scanning service support
FROM alpine:3.11
RUN apk --no-cache add tzdata ca-certificates bash
COPY --from=build /app/bin/migrate .

ENTRYPOINT  ["/migrate"]
