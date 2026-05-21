# Docker Security Baseline Checklist

---

# Dockerfile Security Checklist

- [ ] Uses minimal base image
- [ ] Uses fixed image tags (not latest)
- [ ] Uses multi-stage builds
- [ ] Runs as non-root user
- [ ] No hardcoded secrets
- [ ] Minimal layers used
- [ ] Uses COPY instead of ADD
- [ ] Implements HEALTHCHECK
- [ ] Only required ports exposed
- [ ] Proper file ownership configured
- [ ] Uses .dockerignore
- [ ] Removes unnecessary packages

---

# Container Runtime Security Checklist

- [ ] Runs with read-only filesystem
- [ ] Drops unnecessary capabilities
- [ ] Uses no-new-privileges
- [ ] Uses AppArmor/SELinux profile
- [ ] Resource limits configured
- [ ] PID limits configured
- [ ] Uses tmpfs for temp storage
- [ ] Runs on internal network where possible
- [ ] Logging configured
- [ ] Secrets externalized

---

# Vulnerability Management Checklist

- [ ] Images scanned with Trivy
- [ ] No CRITICAL vulnerabilities
- [ ] HIGH vulnerabilities reviewed
- [ ] Reports archived
- [ ] Automated scans configured
- [ ] Regular rescanning scheduled
- [ ] Dependency updates automated
- [ ] Base images updated regularly

---

# Supply Chain Security Checklist

- [ ] Docker Content Trust enabled
- [ ] Images signed before deployment
- [ ] Trusted registries only
- [ ] SBOM generation configured
- [ ] Build provenance tracked

---

# Kubernetes Readiness Checklist

- [ ] Non-root containers
- [ ] Security contexts configured
- [ ] Network policies planned
- [ ] Resource requests/limits set
- [ ] Liveness/readiness probes configured
- [ ] Secrets managed securely

---
