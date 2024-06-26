# Base image for dependencies
FROM node:18-alpine AS base
WORKDIR /app
COPY package*.json .

# Development stage
FROM base AS dev
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev"]

# Build stage
FROM dev AS build
RUN npm run build

# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY package*.json .
RUN npm ci --only=production
COPY --from=build /app/.next ./.next
EXPOSE 3000
CMD ["npm", "start"]