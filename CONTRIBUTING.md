# Contributing

Thank you for considering contributing to this project!  
We maintain strict quality and workflow rules enforced by Git hooks and CI to ensure consistency.

---

## 🛠️ First-time setup

After cloning the repository, run:

```bash
make init
```

This will:

- Configure Git to use the repo’s hooks in `.githooks/`
- Make sure the hook scripts are executable  
- From then on, Git will automatically run the checks on `commit` and `push`.

⚠️ You only need to do this once per clone.  

---

## ✅ What the hooks enforce

- **Secrets scanning**  
  Prevents committing common secret patterns (keys, tokens, passwords).  

- **Conventional Commits**  
  Commit messages must follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).  
  Examples:  
  - `feat(api): add rate limiting`  
  - `fix: handle nil pointer in cache`  

- **Branch naming**  
  Branches must match the conventional format:  
  ```
  (feat|feature|fix|docs|style|refactor|perf|test|build|ci|chore|revert)/some-name
  ```

- **Protected branches**  
  Direct pushes to `main` and `dev` are blocked. Open a PR instead.  

- **Go quality gates (pre-push)**  
  Before any push, the following must succeed (run from the repo root):  
  ```bash
  make lint
  make test
  make build
  make cover
  ```
  These Make targets iterate over every Go module listed in `go.work`, so you get full monorepo coverage without calling `go … ./...` manually from each module.

---

## 🔄 Typical workflow

```bash
# Create a feature branch with a valid name
git checkout -b feat/my-cool-feature

# Make changes and stage them
git add .

# Commit with a Conventional Commit message
git commit -m "feat(parser): add array support"

# Push (runs Go checks before sending upstream)
git push origin feat/my-cool-feature
```

If something fails, fix it locally before retrying.
After pushing create a PR targeting `dev`.

---

## 🧪 Continuous Integration

All rules are re-checked in CI. If local hooks were skipped or disabled, CI will still block invalid PRs.  
So it’s always easier to run them locally and get fast feedback.

---

## 🚀 Alternative: Using pre-commit

If you want a cross-platform hook manager instead of `make init`, install [pre-commit](https://pre-commit.com/):

```bash
pip install pre-commit
pre-commit install
pre-commit install --hook-type pre-push --hook-type commit-msg
```

This automates hook installation across systems and keeps hooks updated automatically.  

---

Happy hacking 🚀
