// server.js
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const logger = require('./middleware/logger');
const userRoutes = require('./routes/users');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('combined', { stream: { write: message => logger.info(message.trim()) } }));

// --- DATABASE CONNECTION & HEALTH CHECK LOGIC ---
let pool; // Declare pool outside so it doesn't break if Postgres is skipped

if (process.env.MONGO_URI) {
    // === DAY 5: MongoDB Replica Set Connection ===
    const mongoose = require('mongoose');
    console.log("Attempting to connect to MongoDB Replica Set...");
    
    mongoose.connect(process.env.MONGO_URI)
        .then(() => {
            console.log('Successfully connected to MongoDB Cluster');
            logger.info('Successfully connected to MongoDB Cluster');
        })
        .catch(err => {
            console.error('MongoDB connection error:', err);
            logger.error('MongoDB connection error', err);
        });

    // MongoDB Health Check
    app.get('/api/health', (req, res) => {
        const dbState = mongoose.connection.readyState;
        
        if (dbState === 1) {
            res.status(200).json({
                status: 'healthy',
                timestamp: new Date().toISOString(),
                uptime: process.uptime(),
                database: { status: 'connected', type: 'mongodb' },
                environment: process.env.NODE_ENV,
                version: '1.0.0'
            });
        } else {
            logger.error('MongoDB health check failed, state: ' + dbState);
            res.status(503).json({
                status: 'degraded',
                database: 'disconnected',
                type: 'mongodb'
            });
        }
    });

} else {
    // === DAY 4: Original PostgreSQL Connection ===
    pool = require('./config/db');
    
    // PostgreSQL Health Check
    app.get('/api/health', async (req, res) => {
        try {
            await pool.query('SELECT 1');
            res.status(200).json({
                status: 'healthy',
                timestamp: new Date().toISOString(),
                uptime: process.uptime(),
                database: {
                    status: 'connected',
                    type: 'postgresql',
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
            logger.error('PostgreSQL health check failed', err);
            res.status(503).json({
                status: 'degraded',
                database: 'disconnected',
                error: err.message
            });
        }
    });
}
// ----------------------------------------------

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