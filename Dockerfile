FROM node:17.9.0 AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .  # Copy all application files to /usr/src/app

FROM base as builder
WORKDIR /usr/src/app
RUN npm run build

FROM node:17.9.0-alpine3.15
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /usr/src/app/dist ./

EXPOSE 8080
ENTRYPOINT ["node", "/server.js"]
