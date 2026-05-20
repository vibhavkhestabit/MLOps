const express = require('express');
const { Client } = require('pg');

const app = express();

const client = new Client({
  host: 'database',
  user: 'postgres',
  password: 'secret123',
  database: 'postgres',
  port: 5432
});

async function connectDB() {
  try {
    await client.connect();
    console.log('Connected to PostgreSQL');
  } catch (err) {
    console.error('Database connection failed:', err.message);
  }
}

connectDB();

app.get('/', (req, res) => {
  res.json({
    message: 'API is running',
    database: 'connected'
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy'
  });
});

app.listen(3000, () => {
  console.log('API listening on port 3000');
});
