# Build server
FROM python:3.9-slim as server
WORKDIR /app/server
COPY ./server/requirements.txt ./
RUN pip install -r requirements.txt
COPY ./server .
RUN python manage.py db upgrade

# Build client
FROM node:16 as client
WORKDIR /app/client
COPY ./client/package.json ./client/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY ./client ./
RUN yarn build

# Final stage
FROM nginx:alpine as final
WORKDIR /app
COPY --from=server /app/server /app
COPY --from=client /app/client/build /app/client/build

CMD ["nginx", "-g", "daemon off;"]

