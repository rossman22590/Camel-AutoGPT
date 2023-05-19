# Stage 1: Server
FROM python:3.9-slim-buster AS server

WORKDIR /app/server

COPY ./server/requirements.txt ./requirements.txt
RUN pip install -r requirements.txt

COPY ./server .

CMD [ "python", "./webserver.py" ]

# Stage 2: Client
FROM node:16 AS client

WORKDIR /app/client

COPY ./client/package.json ./client/yarn.lock ./
RUN yarn install --frozen-lockfile

COPY ./client .

RUN yarn build

EXPOSE 80 5000

CMD ["nginx", "-g", "daemon off;"]
