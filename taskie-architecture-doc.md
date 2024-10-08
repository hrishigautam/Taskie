# Taskie App Architecture Document

## Overview
Taskie is a Swift-based iOS application for managing tasks. It allows users to create, track, and complete tasks with deadlines, providing a simple and efficient task management solution.

## Key Components

### 1. TaskieApp (TaskieApp.swift)
- The main entry point of the application
- Sets up the app structure and initializes the main view (ContentView)

### 2. ContentView (ContentView.swift)
- The main view of the application
- Displays pending and current tasks
- Provides navigation to add new tasks and view task history
- Uses TaskSection and TaskRowView for rendering task lists

### 3. TaskieManager (TaskieManager.swift)
- Core logic for managing tasks
- Handles task creation, updating, and completion
- Manages task lists (today's tasks, pending tasks, completed tasks)
- Implements data persistence and timer-based updates

### 4. Task Model
- Represents individual tasks with properties like title, deadline, and completion status
- Provides methods for updating remaining time and completion status

### 5. HistoryView (HistoryView.swift)
- Displays a list of completed tasks

### 6. AddTaskView (AddTaskView.swift)
- Provides a form for adding new tasks with title and deadline

### 7. Persistence
- Handles saving and loading tasks (implementation details not provided in the given files)

## Data Flow
1. User interactions in ContentView and AddTaskView trigger actions in TaskieManager
2. TaskieManager updates task lists and persists changes
3. Views observe TaskieManager and update UI accordingly

## Key Features
- Real-time task updates using Combine framework
- Automatic categorization of tasks (today's tasks vs. pending tasks)
- Task completion tracking
- Task history with cleanup mechanism (keeps last 20 completed tasks)

## Architecture Pattern
The app follows a simplified MVVM (Model-View-ViewModel) pattern:
- Model: Task
- View: ContentView, HistoryView, AddTaskView
- ViewModel: TaskieManager (acts as a ViewModel for the entire app)

## Potential Improvements
1. Implement more robust error handling
2. Add unit tests for TaskieManager and Task model
3. Implement local notifications for upcoming task deadlines
4. Add task editing functionality
5. Implement data sync with a backend service for multi-device support
