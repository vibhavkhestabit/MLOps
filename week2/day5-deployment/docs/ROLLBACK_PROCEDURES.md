# Emergency Rollback Procedures
**Author:** Vibhav Khaneja

## Overview
In the event of a critical failure post-deployment (e.g., failed health checks, database migration errors, or severe performance degradation), the `rollback.sh` script provides an automated recovery path.

## Executing a Rollback
1. Trigger the emergency script:
   ```
   ./scripts/rollback.sh
   ```

2. Select the affected stack (1, 2, or 3).
3. The script will dynamically scan the deployment directory for available timestamped backups (e.g., stack1-backup-20260501-120000).
4. Select the desired stable state by entering the corresponding number.

## Automated Recovery Actions
1. Once a backup is selected, the script performs the following:
2. Halt: Gracefully stops all PM2 and Systemd services for the affected stack.
3. Restore: Copies the stable file state from the backup directory into the active /var/www/ directory.
4. Migrate Down: Executes framework-specific database rollback commands (e.g., npm run migrate:rollback or php artisan migrate:rollback).
5. Restart: Brings the application layers back online and verifies status.
