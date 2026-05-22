const express = require('express');

const app = express();

const PORT = process.env.PORT || 3000;
const ENVIRONMENT = process.env.NODE_ENV || 'development';
const APP_VERSION = process.env.APP_VERSION || '1.0.0';

app.get('/', (req, res) => {
  res.json({
    message: 'Multi Environment Deployment',
    environment: ENVIRONMENT,
    version: APP_VERSION,
    hostname: require('os').hostname(),
    timestamp: new Date()
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});