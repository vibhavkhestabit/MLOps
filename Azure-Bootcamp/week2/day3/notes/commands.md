# Week 2 Day 3 — Commands Reference

## Verify Repository Root

```bash
git rev-parse --show-toplevel
```

---

## View Existing Remotes

```bash
git remote -v
```

---

## Add Azure DevOps Remote

```bash
git remote add azure https://vibhav-azure-bootcamp@dev.azure.com/vibhav-azure-bootcamp/azure-bootcamp/_git/azure-bootcamp
```

---

## Verify Both Remotes

```bash
git remote -v
```

Expected:

```text
origin  -> GitHub
azure   -> Azure DevOps
```

---

## Fetch Azure Branches

```bash
git fetch azure
```

---

## View Branches

```bash
git branch -a
```

---

## View Commit History

```bash
git log --oneline --graph --decorate --all --max-count=10
```

---

## Check Status

```bash
git status
```

---

## Stage Files

```bash
git add Azure-Bootcamp/week2/day3
```

---

## Commit Changes

```bash
git commit -m "Week 2 Day 3 Azure DevOps sample application"
```

---

## Push To GitHub

```bash
git push origin main
```

---

## Push To Azure DevOps

```bash
git push azure main
```

---

## Initial Force Push

Used only once to replace Azure Repo starter README history.

```bash
git push azure main --force
```

---

## Azure Pipeline YAML

```yaml
trigger:
- main

pool:
  vmImage: ubuntu-latest

steps:

- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.11'
  displayName: 'Use Python 3.11'

- script: |
    python -m pip install --upgrade pip
    pip install -r Azure-Bootcamp/week2/day3/app/requirements.txt
  displayName: 'Install Dependencies'

- script: |
    cd Azure-Bootcamp/week2/day3/app
    pytest -v
  displayName: 'Run Unit Tests'
```

---

## Useful Azure DevOps Navigation

### Create Project

```text
Azure DevOps
→ New Project
```

### Create Repository

```text
Repos
→ Initialize Repository
```

### Create Pipeline

```text
Pipelines
→ Create Pipeline
```

### View Logs

```text
Pipeline Run
→ Job
→ Logs
```

### Parallel Jobs

```text
Organization Settings
→ Parallel Jobs
```

### Delete Project

```text
Project Settings
→ Overview
→ Delete Project
```

### Delete Organization

```text
Organization Settings
→ Overview
→ Delete Organization
```
