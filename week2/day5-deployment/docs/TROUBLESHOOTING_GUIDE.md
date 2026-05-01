# Common Issues & Troubleshooting
**Author:** Vibhav Khaneja

### 1. PM2 Instances Failing to Start (Status: Errored)
**Symptom:** Running `pm2 start` results in instances instantly crashing or not appearing.
**Root Cause:** PM2 is likely executing in the wrong working directory, causing it to miss the `ecosystem.config.js` or `package.json` file.
**Solution:** Always use absolute paths in deployment scripts (e.g., `pm2 start /home/user/.../ecosystem.config.js`). Use `pm2 logs` to view exact crash outputs.

### 2. Nginx Returns "502 Bad Gateway"
**Symptom:** Nginx successfully loads the site, but backend API requests fail.
**Root Cause:** The upstream servers defined in Nginx (`proxy_pass`) are down, or the port numbers mismatch.
**Solution:** 
1. Check process status: `pm2 list` or `systemctl status fastapi-app-8003`.
2. Check Nginx error logs: `tail -f /var/log/nginx/error.log`.

### 3. Nginx Fails to Reload
**Symptom:** `systemctl reload nginx` fails.
**Root Cause:** Syntax error in a configuration file, or missing SSL certificates.
**Solution:** ALWAYS run `sudo nginx -t` before reloading. If a certificate is missing, generate a self-signed one using `openssl`.

### 4. Database Connection Limits Exceeded
**Symptom:** Load tests drop connections, or application logs show "Too many connections."
**Root Cause:** Application connection pools are overwhelming the database's `max_connections` setting.
**Solution:** Optimize the connection pool size in the application code, or implement Redis caching to absorb read queries.