# Ocotillo BDD Feature Repository

This repository contains **Behavior-Driven Development (BDD)** specifications for the _Ocotillo_ data management application.  
It defines user-facing and backend behaviors for field data entry, hydrograph visualization, and data correction workflows, ensuring traceable alignment between business requirements, QA automation, and implementation.

---

## Purpose

The goal of this repository is to:
- Define system behaviors in **business-readable Gherkin** syntax.  
- Provide a single source of truth for test coverage, validation logic, and workflow consistency.  
- Enable collaboration between **hydrogeologists, data managers, QA engineers, and developers**.  
- Support automated testing with tools like [Behave](https://behave.readthedocs.io/en/stable/) or [Cucumber](https://cucumber.io/).

---

## Structure

```
bdd/
 ├── features/
 │   ├── backend/
 │   │   ├── api.feature
 │   │   └── auth.feature
 │   ├── frontend/
 │   │   ├── login.feature
 │   │   └── cart.feature
 │   └── shared/
 │       └── user_management.feature
 ├── README.md
 └── versioning/
     └── (tags or release notes here)
```

| Folder | Purpose |
|---------|----------|
| `backend/` | Feature files for API, data, or service logic. |
| `frontend/` | UI/UX behavior, end-user flows, and interactions. |
| `shared/` | Cross-cutting scenarios affecting both layers (auth, session, etc.). |

---
## Integration with Service Repos

Each service (e.g. `backend` or `frontend`) checks out this repo during CI and runs relevant `.feature` files using its **own step definitions**.

### Example (Backend CI)
```yaml
- name: Checkout BDD repo
  uses: actions/checkout@v4
  with:
    repository: your-org/bdd
    ref: v1.2.0    # ← version pinning (see below)
    path: bdd

- name: Copy backend features
  run: |
    mkdir -p tests/features
    cp -r bdd/features/backend/* tests/features/

- name: Run BDD tests
  env:
    BASE_URL: ${{ secrets.BACKEND_URL }}
  run: |
    behave tests/features --tags=@backend --no-capture
```

---

## Tags and Scope

Use Gherkin tags to scope features to specific systems:

```gherkin
@backend
Feature: API responds to /health
  Scenario: Service is healthy
    Given the backend API is running
    When I send a GET request to "/health"
    Then the response status should be 200
```

Then filter by tags in CI:
```bash
behave --tags=@backend
```

---

## Version Pinning

To ensure consistent test behavior across environments, **always pin** the BDD repo to a specific version or tag in your CI/CD pipelines.

### Recommended Approaches

#### 1. **Use Git Tags**
Create semantic version tags for releases:
```bash
git tag -a v1.2.0 -m "Add user onboarding features"
git push origin v1.2.0
```

Then in your CI workflow:
```yaml
with:
  repository: your-org/bdd
  ref: v1.2.0
```

#### 2. **Use Branch Pinning**
For continuously updated staging environments:
```yaml
with:
  repository: your-org/bdd
  ref: develop
```

#### 3. **Manual Version File**
Optionally maintain a file:
```
versioning/VERSION
```
containing something like:
```
1.2.0
```
so dependent repos can parse and validate versions programmatically.

---

## Update Workflow

1. Product or QA teams update `.feature` files in `bdd`.
2. Create a new tag or release (e.g., `v1.3.0`).
3. Service repos update their `ref:` in CI to point to the new version.
4. Teams verify compatibility locally before merging to `main`.

---

## Benefits

✅ Shared scenarios = single behavioral truth  
✅ Decoupled step logic per service  
✅ Stable CI/CD pipelines via version pinning  
✅ Easier audit trail of behavior changes  