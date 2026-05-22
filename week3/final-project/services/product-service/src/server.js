const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");

const app = express();

app.use(cors());
app.use(helmet());
app.use(morgan("dev"));
app.use(express.json());

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

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Product Service running on port ${PORT}`);
});