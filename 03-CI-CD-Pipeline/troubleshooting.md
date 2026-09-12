# CI/CD Troubleshooting Record

## Issue 1: Workflow Not Appearing in GitHub Actions

### Problem

The GitHub Actions workflow was created, but no workflow run appeared in the Actions tab.

### Investigation

The workflow file location was checked.

The initial location was:
website/.github/workflows/test.yml
at the repository root.

### Resolution

The workflow was moved to the correct directory:
.github/workflows/test.yml

### Result

After pushing the changes, GitHub Actions detected the workflow and successfully executed the pipeline.

---

## Issue 2: Git Authentication

### Problem

Git push failed because GitHub no longer accepts account passwords for Git operations.

### Resolution

Configured SSH authentication using an Ed25519 key.

The repository remote was changed from HTTPS to SSH.

### Result

The Ubuntu environment successfully authenticated with GitHub and pushed changes.
