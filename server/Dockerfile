FROM node

WORKDIR /app

COPY ./server/package.json .

RUN npm install

COPY ./server .

EXPOSE 4000

CMD ["node", "index.js"]
