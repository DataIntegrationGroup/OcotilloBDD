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