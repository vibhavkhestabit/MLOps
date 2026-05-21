const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.send("Node Security Scan App");
});

app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy"
  });
});

const PORT = 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
