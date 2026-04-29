module.exports = {
  apps: [
    {
      name: 'express-api',
      script: 'server.js',          
      cwd: './express-postgresql-api',      
      instances: 1,
      exec_mode: 'fork', // We will use fork for now to keep it simple, cluster can be used for heavier loads
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
      },
      error_file: './logs/express-api-error.log',
      out_file: './logs/express-api-out.log',
      time: true // Adds timestamps to your logs
    },
    {
      name: 'nextjs-app',
      script: 'npm',
      args: 'run dev -- -p 3001',
      cwd: './next-frontend',
      instances: 1,
      exec_mode: 'fork',
      env: {
        NODE_ENV: 'production',
        PORT: 3001,
      },
      error_file: './logs/nextjs-error.log',
      out_file: './logs/nextjs-out.log',
      time: true
    }
  ]
};
