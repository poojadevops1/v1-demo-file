FROM node:17.9.0 AS base
WORKDIR /usr/src/app
COPY package*.json ./
COPY . .  # Ensure correct permissions on all files
RUN npm install

FROM node:17.9.0-alpine3.15 AS builder
WORKDIR /usr/src/app
COPY --from=base /usr/src/app .  # Copy from "base" stage
RUN npm install --only=production

EXPOSE 8080
ENTRYPOINT ["node", "/usr/src/app/server.js"]
