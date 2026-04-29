# Process Management & Operations Guide

This system uses a hybrid process management strategy. JavaScript applications are daemonized using **PM2**, while Python and PHP applications utilize Linux **Systemd**.

## PM2 Operations (JavaScript Apps)
The PM2 configuration is centralized in `ecosystem.config.js`.

* **Start the Fleet**: `pm2 start ecosystem.config.js`
* **Check Status**: `pm2 status`
* **View Aggregated Logs**: `pm2 logs`
* **Monitor CPU/RAM in Real-Time**: `pm2 monit`
* **Save State for Server Reboots**: `pm2 save`
* **Stop All PM2 Apps**: `pm2 stop all`

## Systemd Operations (Python/PHP Apps)
Systemd services are registered in `/etc/systemd/system/`.

* **Start Services**:
  * `sudo systemctl start fastapi`
  * `sudo systemctl start laravel-app`
* **Stop Services**:
  * `sudo systemctl stop fastapi`
  * `sudo systemctl stop laravel-app`
* **Check Status**:
  * `sudo systemctl status fastapi`
* **View Live Logs**:
  * `sudo journalctl -u fastapi -f`
* **Reload Configs (After Editing .service files)**:
  * `sudo systemctl daemon-reload`

![ss](../screenshots/ss29.png)
![ss](../screenshots/ss30.png)
![ss](../screenshots/ss31.png)
![ss](../screenshots/ss32.png)
![ss](../screenshots/ss33.png)
