# Base Stage: Install dependencies
FROM node:18.17.1 AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

# Production Stage: Final lightweight image
FROM node:18.17.1-alpine3.17
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY --from=base /usr/src/app .
COPY server.js ./ 

EXPOSE 8080
ENTRYPOINT ["node", "./server.js"]
