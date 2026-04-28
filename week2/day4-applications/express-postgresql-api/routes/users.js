// routes/users.js
const express = require('express');
const { body, validationResult } = require('express-validator');
const pool = require('../config/db');
const router = express.Router();

// Validation Middleware
const validate = (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    next();
};

// GET all users
router.get('/', async (req, res, next) => {
    try {
        const result = await pool.query('SELECT id, username, email, full_name, created_at FROM users');
        res.json(result.rows);
    } catch (err) {
        next(err);
    }
});

// GET user by ID
router.get('/:id', async (req, res, next) => {
    try {
        const result = await pool.query('SELECT id, username, email, full_name, created_at FROM users WHERE id = $1', [req.params.id]);
        if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
        res.json(result.rows[0]);
    } catch (err) {
        next(err);
    }
});

// POST new user
router.post('/', 
    [
        body('username').isString().isLength({ min: 3 }),
        body('email').isEmail(),
        body('full_name').isString()
    ], 
    validate, 
    async (req, res, next) => {
        const { username, email, full_name } = req.body;
        try {
            const result = await pool.query(
                'INSERT INTO users (username, email, full_name) VALUES ($1, $2, $3) RETURNING *',
                [username, email, full_name]
            );
            res.status(201).json(result.rows[0]);
        } catch (err) {
            next(err);
        }
});

// PUT update user
router.put('/:id', 
    [
        body('username').optional().isString().isLength({ min: 3 }),
        body('email').optional().isEmail(),
        body('full_name').optional().isString()
    ], 
    validate, 
    async (req, res, next) => {
        const { username, email, full_name } = req.body;
        try {
            // COALESCE means: "If the user didn't provide a new value, just keep the old one"
            const result = await pool.query(
                'UPDATE users SET username = COALESCE($1, username), email = COALESCE($2, email), full_name = COALESCE($3, full_name), updated_at = CURRENT_TIMESTAMP WHERE id = $4 RETURNING *',
                [username, email, full_name, req.params.id]
            );
            if (result.rows.length === 0) return res.status(404).json({ error: 'User not found' });
            res.json(result.rows[0]);
        } catch (err) {
            next(err);
        }
});
// DELETE user
router.delete('/:id', async (req, res, next) => {
    try {
        const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING id', [req.params.id]);
        if (result.rowCount === 0) return res.status(404).json({ error: 'User not found' });
        res.json({ message: 'User deleted successfully' });
    } catch (err) {
        next(err);
    }
});

module.exports = router;