// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const pool = require('./config/db');
const logger = require('./middleware/logger');
const userRoutes = require('./routes/users');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));

// Health Check Endpoint
app.get('/api/health', async (req, res) => {
    try {
        await pool.query('SELECT 1');
        res.status(200).json({
            status: 'healthy',
            timestamp: new Date().toISOString(),
            uptime: process.uptime(),
            database: {
                status: 'connected',
                pool: {
                    total: pool.totalCount,
                    idle: pool.idleCount,
                    active: pool.totalCount - pool.idleCount
                }
            },
            environment: process.env.NODE_ENV,
            version: '1.0.0'
        });
    } catch (err) {
        logger.error('Health check failed', err);
        res.status(503).json({
            status: 'degraded',
            database: 'disconnected',
            error: err.message
        });
    }
});

// Routes
app.use('/api/users', userRoutes);

// Global Error Handler
app.use((err, req, res, next) => {
    logger.error(`${err.status || 500} - ${err.message} - ${req.originalUrl} - ${req.method} - ${req.ip}`);
    res.status(err.status || 500).json({
        error: process.env.NODE_ENV === 'development' ? err.message : 'Internal Server Error'
    });
});

app.listen(PORT, () => {
    logger.info(`Express API running on http://localhost:${PORT}`);
    console.log(`🚀 Server is running on http://localhost:${PORT}`);
});