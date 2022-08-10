FROM node:16.3-alpine

WORKDIR /app

COPY ./simple-nodejs-weather-app . 

RUN yarn install --production

CMD ["node","server.js"]