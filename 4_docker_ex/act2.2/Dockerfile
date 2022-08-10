FROM nginx:latest
WORKDIR /app

RUN apt update 

RUN apt install git -y

RUN git clone https://github.com/BuckyMaler/global.git
#RUN ls -l

RUN cp -r ./global/* /usr/share/nginx/html/