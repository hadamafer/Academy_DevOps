#esta es la parte de la imagen de contruccion 
FROM golang:1.18.2 as builder 

WORKDIR /src

#cuando hay varios archivos se tiene que poner como destino ./
COPY *.go ./ 

COPY data.txt .

COPY go.mod .

RUN go mod download && go mod verify

#es perverso crear el exe en mi maquina
RUN CGO_ENABLED=0 GOOS=linux go build -v -installsuffix cgo -o api_fer 

#RUN ls -l 

#esta es imagen de ejecucion -> run time

FROM alpine:latest

WORKDIR /app

COPY --from=builder /src/api_fer ./

RUN ls -l api_fer

#esto es una buena practica :)
EXPOSE 8080

CMD ["/app/api_fer"]