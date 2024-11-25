FROM node:17.9.0 AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .  # Copy all application files to /usr/src/app

FROM node:17.9.0-alpine3.15 AS builder
WORKDIR /usr/src/app
COPY --from=base /usr/src/app .  # Copy everything from "base" stage's /usr/src/app
RUN npm install --only=production

EXPOSE 8080
ENTRYPOINT ["node", "/usr/src/app/server.js"]
