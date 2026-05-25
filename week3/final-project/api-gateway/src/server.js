const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const rateLimit = require("express-rate-limit");
const { createProxyMiddleware } = require("http-proxy-middleware");
const promBundle = require("express-prom-bundle");

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());

const metricsMiddleware = promBundle({
  includeMethod: true,
  includePath: true
});

app.use(metricsMiddleware);

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100
});

app.use(limiter);

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "api-gateway"
  });
});

app.get("/", (req, res) => {
  res.json({
    message: "API Gateway Running"
  });
});

/* USER SERVICE */
app.use(
  "/api/users",
  createProxyMiddleware({
    target: "http://user-service:8001",
    changeOrigin: true,
    pathRewrite: {
      "^/api/users": ""
    }
  })
);

/* PRODUCT SERVICE */
app.use(
  "/api/products",
  createProxyMiddleware({
    target: "http://product-service:8002",
    changeOrigin: true,
    pathRewrite: {
      "^/api/products": ""
    }
  })
);

/* ORDER SERVICE */
app.use(
  "/api/orders",
  createProxyMiddleware({
    target: "http://order-service:8003",
    changeOrigin: true,
    pathRewrite: {
      "^/api/orders": ""
    }
  })
);

const PORT = process.env.PORT || 5000;

app.listen(PORT, () => {
  console.log(`Gateway running on port ${PORT}`);
});