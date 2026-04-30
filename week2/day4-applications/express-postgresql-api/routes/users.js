const express = require('express');
const router = express.Router();
const User = require('../models/User'); // Import the Mongoose model
// const pool = require('../config/db'); // We don't need Postgres anymore!

// GET: List all users
router.get('/', async (req, res, next) => {
    try {
        const users = await User.find().select('-__v'); // Exclude MongoDB internal versioning field
        res.json(users);
    } catch (err) {
        next(err);
    }
});

// GET: Get user by ID
router.get('/:id', async (req, res, next) => {
    try {
        const user = await User.findById(req.params.id).select('-__v');
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.json(user);
    } catch (err) {
        // If the ID isn't a valid MongoDB ObjectId format, handle it gracefully
        if (err.kind === 'ObjectId') {
             return res.status(404).json({ error: 'User not found' });
        }
        next(err);
    }
});

// POST: Create a new user
router.post('/', async (req, res, next) => {
    try {
        const { username, email, full_name } = req.body;
        
        // Mongoose handles the validation and creation
        const newUser = new User({ username, email, full_name });
        const savedUser = await newUser.save();
        
        res.status(201).json(savedUser);
    } catch (err) {
        // Handle MongoDB Duplicate Key Error (e.g., username/email already exists)
        if (err.code === 11000) {
            return res.status(400).json({ error: 'Username or email already exists' });
        }
        next(err);
    }
});

// PUT: Update an existing user
router.put('/:id', async (req, res, next) => {
    try {
        const { full_name } = req.body; // Only allowing full_name updates for this example
        
        const updatedUser = await User.findByIdAndUpdate(
            req.params.id, 
            { full_name }, 
            { new: true, runValidators: true } // Return the updated document and run schema validation
        ).select('-__v');

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json(updatedUser);
    } catch (err) {
         if (err.kind === 'ObjectId') {
             return res.status(404).json({ error: 'User not found' });
        }
        next(err);
    }
});

// DELETE: Delete a user
router.delete('/:id', async (req, res, next) => {
    try {
        const deletedUser = await User.findByIdAndDelete(req.params.id);
        
        if (!deletedUser) {
            return res.status(404).json({ error: 'User not found' });
        }
        
        res.json({ message: 'User successfully deleted', deletedUser });
    } catch (err) {
         if (err.kind === 'ObjectId') {
             return res.status(404).json({ error: 'User not found' });
        }
        next(err);
    }
});

module.exports = router;