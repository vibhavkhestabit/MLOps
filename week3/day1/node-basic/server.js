const express = require("express");

const app = express();

const PORT = 3000;

app.get("/", (req, res) => {
  res.send("Hello from Dockerized Node.js App, Week 3 day 1 Exercise");
});

app.get("/health", (req, res) => {
  res.json({
    status: "OK",
    uptime: process.uptime(),
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
