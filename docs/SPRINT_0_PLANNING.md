# Sprint 0: Planning & Setup

## 1. Product Vision

**TaskFlow** is a lightweight, intuitive task management web application that helps individuals organize, prioritize, and track their daily tasks efficiently, enabling them to stay focused and productive with a clean, distraction-free interface.

## 2. Product Backlog

### User Stories with Acceptance Criteria

#### US-001: Create Task (Priority: High, Story Points: 5)
**As a** user  
**I want to** create a new task with a title and description  
**So that** I can track my work items

**Acceptance Criteria:**
- User can enter a task title (required, max 100 characters)
- User can enter a task description (optional, max 500 characters)
- Task is saved and appears in the task list immediately
- User receives confirmation that task was created
- Form validation prevents empty titles

---

#### US-002: View Task List (Priority: High, Story Points: 3)
**As a** user  
**I want to** view all my tasks in a list  
**So that** I can see what needs to be done

**Acceptance Criteria:**
- All tasks are displayed in a list format
- Each task shows title, description, and status
- Tasks are sorted by creation date (newest first)
- Empty state message shown when no tasks exist
- List updates in real-time when tasks are added/removed

---

#### US-003: Mark Task as Complete (Priority: High, Story Points: 3)
**As a** user  
**I want to** mark tasks as complete or incomplete  
**So that** I can track my progress

**Acceptance Criteria:**
- User can toggle task status with a single click
- Completed tasks have visual distinction (strikethrough, different color)
- Status changes are persisted immediately
- UI updates instantly without page reload
- User can toggle status back to incomplete

---

#### US-004: Delete Task (Priority: Medium, Story Points: 2)
**As a** user  
**I want to** delete tasks I no longer need  
**So that** I can keep my task list clean and relevant

**Acceptance Criteria:**
- User can delete any task from the list
- Confirmation dialog appears before deletion
- Task is removed from list immediately after confirmation
- Deletion cannot be undone (for v1)
- User receives feedback that task was deleted

---

#### US-005: Edit Task (Priority: Medium, Story Points: 5)
**As a** user  
**I want to** edit existing task details  
**So that** I can update information as requirements change

**Acceptance Criteria:**
- User can edit task title and description
- Edit form is pre-populated with current values
- Changes are saved immediately
- User can cancel editing without saving
- Form validation same as create task

---

#### US-006: Filter Tasks by Status (Priority: Low, Story Points: 3)
**As a** user  
**I want to** filter tasks by completion status  
**So that** I can focus on pending work or review completed items

**Acceptance Criteria:**
- Filter options: All, Active, Completed
- Filter persists during session
- Task count shows number of tasks in each category
- Filter updates instantly when tasks change status
- Default filter is "All"

---

#### US-007: Task Priority Levels (Priority: Low, Story Points: 5)
**As a** user  
**I want to** assign priority levels to tasks  
**So that** I can focus on the most important work first

**Acceptance Criteria:**
- Three priority levels: High, Medium, Low
- Visual indicators for each priority (color coding)
- Tasks can be sorted by priority
- Default priority is Medium
- Priority can be changed after task creation

---

## 3. Definition of Done (DoD)

A user story is considered "Done" when ALL of the following criteria are met:

1. **Code Complete**: All code is written, reviewed, and merged to main branch
2. **Tests Passing**: All unit tests pass with minimum 80% code coverage for new code
3. **CI Pipeline Green**: All automated checks pass in CI/CD pipeline
4. **Functional**: Feature works as described in acceptance criteria
5. **Code Quality**: Code follows project standards (linting, formatting)
6. **Documentation**: Code is properly commented and README is updated if needed
7. **Peer Reviewed**: Code has been reviewed by at least one peer (simulated for individual work)
8. **No Known Bugs**: No critical or high-priority bugs remain

## 4. Sprint 1 Plan

### Sprint Goal
Establish the foundation of TaskFlow by implementing core task management features (create, view, and complete tasks) with a working CI/CD pipeline and test infrastructure.

### Selected User Stories for Sprint 1
1. **US-001: Create Task** (5 points) - HIGH priority
2. **US-002: View Task List** (3 points) - HIGH priority
3. **US-003: Mark Task as Complete** (3 points) - HIGH priority

**Total Story Points: 11**

### Sprint 1 Capacity
- Duration: 1 week
- Available hours: 20 hours
- Expected velocity: 10-12 story points

### Technical Setup Tasks
- Initialize project structure (React + Node.js)
- Set up Git repository with proper .gitignore
- Configure ESLint and Prettier
- Set up Jenkins CI/CD pipeline
- Implement Jest for testing
- Create basic project documentation

### Success Criteria for Sprint 1
- Users can create, view, and mark tasks as complete
- Application has responsive UI
- All tests pass in CI pipeline
- Code coverage > 80% for new features
- Sprint Review document completed
- Sprint Retrospective conducted

---

## 5. Backlog Prioritization

### Must Have (Sprint 1)
- US-001: Create Task
- US-002: View Task List
- US-003: Mark Task as Complete

### Should Have (Sprint 2)
- US-004: Delete Task
- US-005: Edit Task
- US-006: Filter Tasks by Status

### Could Have (Future Sprints)
- US-007: Task Priority Levels

---

## 6. Risk Assessment

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Technical complexity higher than estimated | High | Medium | Break down stories further, reduce scope if needed |
| CI/CD setup takes longer than expected | Medium | Medium | Start with simple pipeline, iterate |
| Testing infrastructure delays feature work | Medium | Low | Set up tests incrementally with each feature |
| Scope creep during implementation | Medium | Medium | Strictly follow Sprint Plan, defer new ideas to backlog |

---

## 7. Technology Stack

### Frontend
- **Framework**: React 18 with TypeScript
- **Styling**: CSS Modules / Tailwind CSS
- **State Management**: React Hooks (useState, useEffect)

### Backend
- **Runtime**: Node.js with Express
- **Database**: JSON file storage (for prototype) or SQLite
- **API**: RESTful API

### DevOps
- **Version Control**: Git + GitHub
- **CI/CD**: Jenkins
- **Testing**: Jest + React Testing Library
- **Code Quality**: ESLint, Prettier

---

**Sprint 0 Completed**: February 14, 2026  
**Sprint 1 Start Date**: February 14, 2026  
**Sprint 1 End Date**: February 20, 2026
