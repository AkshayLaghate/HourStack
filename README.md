
# 🚀 HourStack

**HourStack** is an open-source Freelancer Productivity App built with Flutter + GetX + Firebase.

It combines:

- ⏱ Multi-project time tracking
- 📋 Kanban-based task management (per project)
- 💰 Revenue analytics
- 📅 Calendar-based work insights
- 📊 Dashboard analytics
- 📤 Timesheet export (CSV / Excel / PDF)
- 🌗 Light & Dark mode
- 📱 Fully responsive (Mobile + Web)

---

## ✨ Why HourStack?

Freelancers often use:
- One tool for time tracking
- Another tool for task management
- A spreadsheet for revenue tracking

HourStack combines everything into **one clean, developer-focused system**.

---

# 🏗 Tech Stack

### Frontend
- Flutter (latest stable, null-safe)
- GetX (state management, routing, dependency injection)

### Backend
- Firebase Authentication
- Cloud Firestore

### Packages Used
- fl_chart (analytics charts)
- table_calendar
- flutter_heatmap_calendar
- syncfusion_flutter_xlsio
- pdf + printing
- intl
- uuid

---

# 📂 Project Structure

```
/app
  /modules
    /auth
    /dashboard
    /projects
    /project_details
    /kanban
    /tasks
    /timer
    /calendar
    /reports
  /data
    /models
    /repositories
  /services
  /routes
  /theme
```

---

# 🔥 Core Features

## ⏱ Time Tracking
- Manual start/stop timer
- Project-level tracking
- Task-level tracking
- Daily rounding to nearest hour
- Prevent overlapping sessions

## 📋 Kanban Board (Per Project)
- Backlog
- In Progress
- Review
- Done
- Drag & Drop (Web)
- Horizontal scroll (Mobile)

## 💰 Revenue Tracking
- Hourly rate per project
- Daily revenue calculation
- Monthly revenue analytics

## 📊 Dashboard
- Today’s hours & revenue
- Monthly totals
- 7-day productivity chart
- Project time distribution
- GitHub-style heatmap

## 📅 Calendar View
- Monthly overview
- Daily revenue & hours breakdown

## 📤 Reports
Export monthly timesheets as:
- CSV
- Excel
- PDF

---

# 🚀 Getting Started

## 1️⃣ Clone Repository

```
git clone https://github.com/yourusername/hourstack.git
cd hourstack
```

## 2️⃣ Install Dependencies

```
flutter pub get
```

## 3️⃣ Setup Firebase

- Create Firebase project
- Enable Email/Password authentication
- Create Firestore database
- Add `google-services.json` (Android)
- Add `GoogleService-Info.plist` (iOS)
- Configure Firebase for Web

## 4️⃣ Run App

```
flutter run
```

For web:

```
flutter run -d chrome
```

---

# 🔐 Firestore Structure

## Users

```
users/{userId}
```

## Projects

```
users/{userId}/projects/{projectId}
```

## Tasks

```
users/{userId}/projects/{projectId}/tasks/{taskId}
```

## Sessions

```
users/{userId}/sessions/{sessionId}
```

---

# 📌 Roadmap

- [ ] Idle detection
- [ ] Invoice generation
- [ ] Stripe integration
- [ ] Client portal
- [ ] Team collaboration
- [ ] Weekly email reports
- [ ] SaaS deployment version

---

# 🤝 Contributing

Contributions are welcome!

1. Fork the repo
2. Create a feature branch
3. Commit changes
4. Open a Pull Request

Please follow clean architecture principles and keep code modular.

---

# 📄 License

MIT License.

You are free to use, modify, and distribute this project.

---

# 💡 Author

Built by **Akshay Laghate**  
Freelance Mobile & Software Developer  

If you like this project, consider starring ⭐ the repo.

---

# 🌍 Vision

HourStack aims to become the open-source productivity app for freelancers.

Time + Tasks + Revenue — in one clean system.
