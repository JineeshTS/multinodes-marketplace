const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
const path = require('path');
const dotenv = require('dotenv');
const http = require('http');
const { Server } = require('socket.io');

// NOTE: In a larger app, routes would be in a separate /routes folder.
// For simplicity for a first-timer, we are keeping them here.
// All other best practices from the review are applied.

// Load environment variables
dotenv.config();

// Create Express app
const app = express();
const server = http.createServer(app);
const io = new new Server(server, { /* ... socket.io config ... */ });
const dbPool = require('./config/db'); // We'd move db config to its own file

// Middleware
app.use(helmet());
app.use(compression());
app.use(cors());
app.use(express.json());

// --- All your API routes would go here ---
// Example: app.use('/api/auth', require('./routes/auth.routes'));

app.get('/api/health', (req, res) => {
  res.json({ success: true, status: 'healthy' });
});


// --- Frontend & Admin Panel Serving ---
// Serve the main frontend
app.use(express.static(path.join(__dirname, '../../frontend/build')));
// Serve the admin panel
app.use('/admin', express.static(path.join(__dirname, '../../admin-panel/build')));


// Handle SPA (Single Page Application) routing by sending index.html
// This must come AFTER your API routes but BEFORE the final error handler.
app.get('/admin/*', (req, res) => {
    res.sendFile(path.join(__dirname, '../../admin-panel/build/index.html'));
});
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../../frontend/build/index.html'));
});

// --- Server Startup ---
const PORT = process.env.PORT || 3001;
server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});