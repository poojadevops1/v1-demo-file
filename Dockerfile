# Base Stage: Install dependencies
FROM node:18.17.1 AS base
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install

# Build Stage: Compile application
FROM base AS builder
COPY . .  # Copy application source code
RUN npm run build

# Production Stage: Final lightweight image
FROM node:18.17.1-alpine3.17
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install --only=production
COPY --from=builder /usr/src/app/dist ./dist  # Copy built application
COPY server.js ./  # Ensure server.js is included in the final image

EXPOSE 8080
ENTRYPOINT ["node", "./server.js"]
