const express = require('express');
const os = require('os');

const app = express();

const PORT = 3000;
const VERSION = process.env.VERSION || 'unknown';

app.get('/', (req, res) => {
  res.json({
    message: 'Blue-Green Deployment Demo',
    version: VERSION,
    hostname: os.hostname(),
    timestamp: new Date().toISOString()
  });
});

app.get('/health', (req, res) => {
  res.send('OK');
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});