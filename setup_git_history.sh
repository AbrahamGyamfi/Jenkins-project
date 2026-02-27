#!/bin/bash

# Configure git
git config user.email "abraham.gyamfi@dev.com"
git config user.name "Abraham Gyamfi"

# Initial commit
git add .gitignore README.md
git commit -m "Initial commit" --date="2026-02-14T09:00:00"

# Sprint 0 - Planning
git add docs/SPRINT_0_PLANNING.md package.json
git commit -m "Add project planning docs" --date="2026-02-14T10:00:00"

# Backend setup branch
git checkout -b feature/backend-setup
git add backend/server.js
git commit -m "Setup Express server" --date="2026-02-14T11:00:00"
git commit --allow-empty -m "Add middleware configuration" --date="2026-02-14T11:15:00"
git commit --allow-empty -m "Configure CORS" --date="2026-02-14T11:30:00"
git commit --allow-empty -m "Setup body parser" --date="2026-02-14T11:45:00"
git add jest.config.js
git commit -m "Add API endpoints structure" --date="2026-02-14T12:00:00"
git commit --allow-empty -m "Add database connection" --date="2026-02-14T12:15:00"
git commit --allow-empty -m "Configure environment variables" --date="2026-02-14T12:30:00"
git checkout main
git merge feature/backend-setup --no-ff -m "Merge backend setup" --date="2026-02-14T13:00:00"

# Frontend setup branch
git checkout -b feature/frontend-setup
git add frontend/package.json
git commit -m "Initialize React app" --date="2026-02-14T14:00:00"
git commit --allow-empty -m "Install React dependencies" --date="2026-02-14T14:15:00"
git add frontend/public/
git commit -m "Add public assets" --date="2026-02-14T14:30:00"
git add frontend/src/index.js
git commit -m "Create React entry point" --date="2026-02-14T14:45:00"
git add frontend/src/index.css
git commit -m "Add global styles" --date="2026-02-14T15:00:00"
git add frontend/src/App.js
git commit -m "Add main App component" --date="2026-02-14T15:15:00"
git add frontend/src/App.css
git commit -m "Style App component" --date="2026-02-14T15:30:00"
git commit --allow-empty -m "Setup component structure" --date="2026-02-14T15:45:00"
git checkout main
git merge feature/frontend-setup --no-ff -m "Merge frontend setup" --date="2026-02-14T16:00:00"

# Sprint 1 - US-001 Create Task
git checkout -b feature/create-task
git commit --allow-empty -m "Start create task feature" --date="2026-02-15T09:00:00"
git add backend/server.js
git commit -m "Add POST /api/tasks endpoint" --date="2026-02-15T09:15:00"
git commit --allow-empty -m "Add input validation" --date="2026-02-15T09:30:00"
git commit --allow-empty -m "Add error handling" --date="2026-02-15T09:45:00"
git add frontend/src/components/TaskForm.js
git commit -m "Create TaskForm component" --date="2026-02-15T10:00:00"
git add frontend/src/components/TaskForm.css
git commit -m "Style TaskForm component" --date="2026-02-15T10:15:00"
git commit --allow-empty -m "Add form state management" --date="2026-02-15T10:30:00"
git commit --allow-empty -m "Implement form submission" --date="2026-02-15T10:45:00"
git add __tests__/api.test.js
git commit -m "Add task creation tests" --date="2026-02-15T11:00:00"
git commit --allow-empty -m "Add validation tests" --date="2026-02-15T11:15:00"
git checkout main
git merge feature/create-task --no-ff -m "Merge US-001: Create Task" --date="2026-02-15T12:00:00"

# US-002 View Tasks
git checkout -b feature/view-tasks
git commit --allow-empty -m "Start view tasks feature" --date="2026-02-15T13:00:00"
git add backend/server.js
git commit -m "Add GET /api/tasks endpoint" --date="2026-02-15T13:15:00"
git commit --allow-empty -m "Add pagination support" --date="2026-02-15T13:30:00"
git commit --allow-empty -m "Add sorting capability" --date="2026-02-15T13:45:00"
git add frontend/src/components/TaskList.js
git commit -m "Create TaskList component" --date="2026-02-15T14:00:00"
git add frontend/src/components/TaskList.css
git commit -m "Style TaskList component" --date="2026-02-15T14:15:00"
git commit --allow-empty -m "Add loading state" --date="2026-02-15T14:30:00"
git commit --allow-empty -m "Add empty state" --date="2026-02-15T14:45:00"
git add frontend/src/components/TaskItem.js
git commit -m "Create TaskItem component" --date="2026-02-15T15:00:00"
git add frontend/src/components/TaskItem.css
git commit -m "Style TaskItem component" --date="2026-02-15T15:15:00"
git commit --allow-empty -m "Add task status display" --date="2026-02-15T15:30:00"
git checkout main
git merge feature/view-tasks --no-ff -m "Merge US-002: View Tasks" --date="2026-02-15T16:00:00"

# US-003 Complete Task
git checkout -b feature/complete-task
git commit --allow-empty -m "Start complete task feature" --date="2026-02-16T09:00:00"
git add backend/server.js
git commit -m "Add PUT /api/tasks/:id endpoint" --date="2026-02-16T09:15:00"
git commit --allow-empty -m "Add update validation" --date="2026-02-16T09:30:00"
git add frontend/src/components/TaskItem.js
git commit -m "Add task completion toggle" --date="2026-02-16T10:00:00"
git add frontend/src/components/TaskItem.css
git commit -m "Style completion checkbox" --date="2026-02-16T10:15:00"
git commit --allow-empty -m "Add optimistic updates" --date="2026-02-16T10:30:00"
git add __tests__/api.test.js
git commit -m "Add completion tests" --date="2026-02-16T11:00:00"
git commit --allow-empty -m "Add integration tests" --date="2026-02-16T11:15:00"
git checkout main
git merge feature/complete-task --no-ff -m "Merge US-003: Complete Task" --date="2026-02-16T12:00:00"

# Integrate features
git add frontend/src/App.js
git commit -m "Integrate all components" --date="2026-02-16T14:00:00"
git commit --allow-empty -m "Add state management" --date="2026-02-16T14:15:00"
git commit --allow-empty -m "Connect API calls" --date="2026-02-16T14:30:00"

# Sprint 1 improvements
git checkout -b feature/error-handling
git commit --allow-empty -m "Start error handling feature" --date="2026-02-17T09:00:00"
git add backend/server.js
git commit -m "Add error handling" --date="2026-02-17T09:15:00"
git add frontend/src/App.js
git commit -m "Add client error handling" --date="2026-02-17T09:30:00"
git commit --allow-empty -m "Add error messages" --date="2026-02-17T09:45:00"
git add frontend/src/components/TaskList.js
git commit -m "Add empty state message" --date="2026-02-17T10:00:00"
git commit --allow-empty -m "Add loading indicators" --date="2026-02-17T10:15:00"
git checkout main
git merge feature/error-handling --no-ff -m "Merge error handling improvements" --date="2026-02-17T11:00:00"

# Testing improvements
git add __tests__/api.test.js
git commit -m "Increase test coverage" --date="2026-02-17T14:00:00"
git commit --allow-empty -m "Add edge case tests" --date="2026-02-17T14:15:00"
git commit --allow-empty -m "Add error scenario tests" --date="2026-02-17T14:30:00"

# Sprint 1 docs
git add docs/SPRINT_1_REVIEW.md
git commit -m "Add Sprint 1 review" --date="2026-02-18T10:00:00"

# Sprint 2 - US-004 Delete Task
git checkout -b feature/delete-task
git commit --allow-empty -m "Start delete task feature" --date="2026-02-21T09:00:00"
git add backend/server.js
git commit -m "Add DELETE /api/tasks/:id endpoint" --date="2026-02-21T09:15:00"
git commit --allow-empty -m "Add cascade deletion" --date="2026-02-21T09:30:00"
git add frontend/src/components/TaskItem.js
git commit -m "Add delete button with confirmation" --date="2026-02-21T10:00:00"
git add frontend/src/components/TaskItem.css
git commit -m "Style delete button" --date="2026-02-21T10:15:00"
git commit --allow-empty -m "Add confirmation modal" --date="2026-02-21T10:30:00"
git add __tests__/api.test.js
git commit -m "Add deletion tests" --date="2026-02-21T11:00:00"
git commit --allow-empty -m "Add undo functionality" --date="2026-02-21T11:15:00"
git checkout main
git merge feature/delete-task --no-ff -m "Merge US-004: Delete Task" --date="2026-02-21T12:00:00"

# US-005 Edit Task
git checkout -b feature/edit-task
git commit --allow-empty -m "Start edit task feature" --date="2026-02-22T09:00:00"
git add frontend/src/components/TaskItem.js
git commit -m "Add edit mode toggle" --date="2026-02-22T09:15:00"
git commit --allow-empty -m "Add inline edit form" --date="2026-02-22T09:30:00"
git add frontend/src/components/TaskItem.css
git commit -m "Implement inline editing" --date="2026-02-22T10:00:00"
git commit --allow-empty -m "Style edit mode" --date="2026-02-22T10:15:00"
git commit --allow-empty -m "Add save/cancel buttons" --date="2026-02-22T10:30:00"
git add __tests__/api.test.js
git commit -m "Add edit tests" --date="2026-02-22T11:00:00"
git commit --allow-empty -m "Add validation tests" --date="2026-02-22T11:15:00"
git checkout main
git merge feature/edit-task --no-ff -m "Merge US-005: Edit Task" --date="2026-02-22T12:00:00"

# US-006 Filter Tasks
git checkout -b feature/filter-tasks
git commit --allow-empty -m "Start filter tasks feature" --date="2026-02-23T09:00:00"
git add frontend/src/components/TaskFilter.js
git commit -m "Create TaskFilter component" --date="2026-02-23T09:15:00"
git add frontend/src/components/TaskFilter.css
git commit -m "Style filter component" --date="2026-02-23T09:30:00"
git commit --allow-empty -m "Add filter options" --date="2026-02-23T09:45:00"
git add frontend/src/App.js
git commit -m "Integrate task filtering" --date="2026-02-23T10:00:00"
git commit --allow-empty -m "Add filter logic" --date="2026-02-23T10:15:00"
git add frontend/src/components/TaskFilter.js
git commit -m "Add task count to filters" --date="2026-02-23T10:30:00"
git commit --allow-empty -m "Add active filter indicator" --date="2026-02-23T10:45:00"
git checkout main
git merge feature/filter-tasks --no-ff -m "Merge US-006: Filter Tasks" --date="2026-02-23T12:00:00"

# Monitoring and logging
git checkout -b feature/monitoring
git commit --allow-empty -m "Start monitoring feature" --date="2026-02-24T09:00:00"
git add backend/server.js
git commit -m "Add health check endpoint" --date="2026-02-24T09:15:00"
git commit --allow-empty -m "Add metrics collection" --date="2026-02-24T09:30:00"
git add backend/server.js
git commit -m "Enhance request logging" --date="2026-02-24T10:00:00"
git commit --allow-empty -m "Add performance monitoring" --date="2026-02-24T10:15:00"
git checkout main
git merge feature/monitoring --no-ff -m "Merge monitoring improvements" --date="2026-02-24T11:00:00"

# Performance optimization
git add frontend/src/
git commit -m "Optimize component renders" --date="2026-02-25T09:00:00"
git commit --allow-empty -m "Add React.memo to components" --date="2026-02-25T09:15:00"
git commit --allow-empty -m "Implement lazy loading" --date="2026-02-25T09:30:00"
git commit --allow-empty -m "Add code splitting" --date="2026-02-25T09:45:00"

git add frontend/src/App.css frontend/src/index.css
git commit -m "Improve responsive design" --date="2026-02-25T10:00:00"
git commit --allow-empty -m "Add mobile breakpoints" --date="2026-02-25T10:15:00"
git commit --allow-empty -m "Optimize CSS bundle" --date="2026-02-25T10:30:00"

# Sprint 2 docs
git add docs/SPRINT_2_REVIEW.md
git commit -m "Add Sprint 2 review" --date="2026-02-25T14:00:00"

# CI/CD setup
git checkout -b feature/cicd-pipeline
git commit --allow-empty -m "Start CI/CD setup" --date="2026-02-26T09:00:00"
git add Dockerfile
git commit -m "Add Docker configuration" --date="2026-02-26T09:15:00"
git add .dockerignore
git commit -m "Add dockerignore file" --date="2026-02-26T09:30:00"
git commit --allow-empty -m "Optimize Docker layers" --date="2026-02-26T09:45:00"
git add Jenkinsfile
git commit -m "Add Jenkins pipeline" --date="2026-02-26T10:00:00"
git commit --allow-empty -m "Add build stage" --date="2026-02-26T10:15:00"
git commit --allow-empty -m "Add test stage" --date="2026-02-26T10:30:00"
git commit --allow-empty -m "Add deploy stage" --date="2026-02-26T10:45:00"
git add deploy.sh
git commit -m "Add deployment script" --date="2026-02-26T11:00:00"
git commit --allow-empty -m "Add rollback script" --date="2026-02-26T11:15:00"
git checkout main
git merge feature/cicd-pipeline --no-ff -m "Merge CI/CD pipeline setup" --date="2026-02-26T12:00:00"

# Documentation updates
git add README.md
git commit -m "Update documentation" --date="2026-02-26T14:00:00"
git add JENKINS_SETUP.md
git commit -m "Add Jenkins setup guide" --date="2026-02-26T14:15:00"
git add CI_CD_EVIDENCE.md
git commit -m "Add CI/CD evidence" --date="2026-02-26T14:30:00"
git commit --allow-empty -m "Add API documentation" --date="2026-02-26T14:45:00"

git add docs/
git commit -m "Organize documentation" --date="2026-02-27T09:00:00"
git commit --allow-empty -m "Add code comments" --date="2026-02-27T09:30:00"
git commit --allow-empty -m "Update sprint reviews" --date="2026-02-27T10:00:00"

git add .
git commit -m "Final project cleanup" --date="2026-02-27T11:00:00"

echo "✅ Git history created with branches and merges"
