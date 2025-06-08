module.exports = {
  apps: [{
    name: 'multinodes-marketplace',
    script: './backend/server.js', // Correct path to server.js
    instances: "max", // Let PM2 decide the best number of instances
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'production',
      PORT: 3001
    },
    // Log files will be managed by PM2 in its own directory
    // This is simpler than managing a /logs folder ourselves.
    max_memory_restart: '512M',
    watch: false,
    autorestart: true,
  }]
};