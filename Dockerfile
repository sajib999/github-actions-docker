# ---- Base Build Stage ----
FROM node:18-alpine AS builder

WORKDIR /app

# Install dependencies (include dev deps for build)
COPY package*.json ./
RUN npm ci

# Copy app files
COPY . .

# Build Next.js app
RUN npm run build

# ---- Production Image ----
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public

EXPOSE 3000
CMD ["npm", "start"]
