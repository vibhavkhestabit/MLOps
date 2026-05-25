const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
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

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    service: "product-service"
  });
});

app.get("/", (req, res) => {
  res.json({
    message: "Product Service Running"
  });
});

const PORT = process.env.PORT || 8002;

app.get("/products", (req, res) => {
  res.json([
    {
      id: 1,
      name: "Laptop",
      price: 75000
    },
    {
      id: 2,
      name: "Phone",
      price: 25000
    }
  ]);
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Product Service running on port ${PORT}`);
});