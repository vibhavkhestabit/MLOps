const express = require('express');

const app = express();

app.get('/', (req, res) => {
  res.send(`
    <h1>Docker Bind Mount Demo</h1>
    <p>Hot reload working</p>
  `);
});

app.listen(3000, () => {
  console.log('Server running on port 3000');
});