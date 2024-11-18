FROM node:17.9.0 AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm build

FROM node:17.9.0-alpine3.15 
WORKDIR /usr/src/app
COPY --from=build /usr/src/app .  # Copy from "base" stage
RUN npm install --only=production

EXPOSE 8080
ENTRYPOINT ["node", "/usr/src/app/server.js"]
