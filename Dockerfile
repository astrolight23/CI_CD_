# Stage 1: Build frontend
FROM node:18 as frontend-builder

WORKDIR /app/frontend

COPY ./frontend/package*.json ./
RUN npm install

COPY ./frontend ./

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build


# Stage 2: Set up backend and serve frontend
FROM node:18

WORKDIR /app

# Install backend dependencies
COPY ./backend/package*.json ./
RUN npm install

# Copy backend source code
COPY ./backend ./

# Copy frontend build to backend's "build" directory
COPY --from=frontend-builder /app/frontend/build ./build

# Expose the port used by the backend server
EXPOSE 4000

# Run the server
CMD ["node", "index.js"]
