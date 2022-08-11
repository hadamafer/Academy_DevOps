
FROM golang:1.18.2 as builder 

WORKDIR /src
COPY *.go ./ 
COPY nros.txt .
COPY go.mod .
RUN go mod download && go mod verify
RUN ls -l
#Crea ejecutable
RUN CGO_ENABLED=0 GOOS=linux go build -v -installsuffix cgo -o api_go 
#---------------------------------------------------------------------------------------------
#esta es imagen de ejecucion -> run time
FROM alpine:latest
WORKDIR /app
COPY --from=builder /src/api_go ./
RUN ls -l
EXPOSE 9090
CMD ["/app/api_go"]