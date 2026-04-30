module.exports = {
  apps: [
    // --- BACKEND: Node.js Express API (3 Instances) ---
    {
      name: 'nodejs-api-3000',
      script: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/express-postgresql-api/server.js',
      env: {
        PORT: 3000,
        NODE_ENV: 'production',
        MONGO_URI: 'mongodb://127.0.0.1:27017,127.0.0.1:27018,127.0.0.1:27019/appdb?replicaSet=rs0'
      }
    },
    {
      name: 'nodejs-api-3003',
      script: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/express-postgresql-api/server.js',
      env: {
        PORT: 3003,
        NODE_ENV: 'production',
        MONGO_URI: 'mongodb://127.0.0.1:27017,127.0.0.1:27018,127.0.0.1:27019/appdb?replicaSet=rs0'
      }
    },
    {
      name: 'nodejs-api-3004',
      script: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/express-postgresql-api/server.js',
      env: {
        PORT: 3004,
        NODE_ENV: 'production',
        MONGO_URI: 'mongodb://127.0.0.1:27017,127.0.0.1:27018,127.0.0.1:27019/appdb?replicaSet=rs0'
      }
    },

    // --- FRONTEND: Next.js SSR App (2 Instances) ---
    {
      name: 'nextjs-app-3001',
      script: 'npm',
      args: 'run start -- -p 3001',
      cwd: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/next-frontend',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'nextjs-app-3002',
      script: 'npm',
      args: 'run start -- -p 3002',
      cwd: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/next-frontend',
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};