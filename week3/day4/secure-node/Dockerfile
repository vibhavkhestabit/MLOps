# =========================
# STAGE 1 — Builder
# =========================

FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

# =========================
# STAGE 2 — Production
# =========================

FROM node:20-alpine

# Create non-root user and group
RUN addgroup -S nodegroup && \
    adduser -S nodeuser -G nodegroup

WORKDIR /app

# Copy app from builder stage
COPY --from=builder /app /app

# Set correct ownership
RUN chown -R nodeuser:nodegroup /app

# Switch to non-root user
USER nodeuser

EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
CMD wget --no-verbose --tries=1 --spider \
http://localhost:3000/health || exit 1

CMD ["node", "src/server.js"]
