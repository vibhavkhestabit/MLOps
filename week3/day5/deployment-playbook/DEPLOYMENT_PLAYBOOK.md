# Production Deployment Playbook

---

# Pre-Deployment Checklist

- [ ] All containers healthy
- [ ] Backup completed
- [ ] Docker images built successfully
- [ ] Security scans passed
- [ ] Monitoring stack operational
- [ ] Environment variables verified
- [ ] Team notified

---

# Deployment Steps

## 1. Backup Current Environment

```bash
./backup-docker-system.sh
```

---

## 2. Build Images

```bash
docker compose build
```

---

## 3. Deploy Application

```bash
docker compose up -d
```

---

## 4. Verify Containers

```bash
docker ps
```

---

## 5. Verify Logs

```bash
docker compose logs --tail=50
```

---

## 6. Verify Health Endpoints

```bash
curl http://localhost:3000/health
```

---

# Post-Deployment Verification

- [ ] Containers running
- [ ] Health checks passing
- [ ] No critical logs
- [ ] Prometheus targets UP
- [ ] Grafana dashboards active
- [ ] Application accessible

---

# Rollback Procedure

## Stop current deployment

```bash
docker compose down
```

---

## Restore backup

```bash
./restore-volume.sh <backup-file> <volume-name>
```

---

## Start previous deployment

```bash
docker compose up -d
```

---

# Emergency Commands

## View logs

```bash
docker logs <container>
```

## Restart container

```bash
docker restart <container>
```

## View resource usage

```bash
docker stats
```

## Cleanup unused resources

```bash
docker system prune -f
```
