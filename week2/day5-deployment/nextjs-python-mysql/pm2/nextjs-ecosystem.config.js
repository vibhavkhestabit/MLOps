module.exports = {
  apps: [
    {
      name: 'stack3-nextjs-3005',
      script: 'npm',
      args: 'run start -- -p 3005',
      cwd: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/next-frontend',
      env: {
        NODE_ENV: 'production'
      }
    },
    {
      name: 'stack3-nextjs-3006',
      script: 'npm',
      args: 'run start -- -p 3006',
      cwd: '/home/vibhavkhaneja/MLOps-Training/week2/day4-applications/next-frontend',
      env: {
        NODE_ENV: 'production'
      }
    }
  ]
};