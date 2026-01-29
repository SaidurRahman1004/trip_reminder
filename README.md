#  TripReminder - Smart Travel Alarm App

TripReminder is a modern Flutter-based travel assistant designed to help users plan their journeys and never miss a trip. It features a robust alarm system integrated with local storage to provide timely reminders for your scheduled travels.

## ✨ Features
- **Effortless Trip Planning:** Quickly add destinations with specific dates and times.
- **Persistent Storage:** Powered by **SQLite (sqflite)** to keep your trip data safe even after the app is closed.
- **Smart Alarm System:** Accurate notifications with custom alarm sounds at the exact time of your journey.
- **Interactive Management:**
    - Toggle alarms on/off directly from the home screen.
    - Edit existing trips to update schedules.
    - Delete trips with a single swipe or click.
- **Deep Linking:** Tap on a notification to go directly to the **Trip Details** screen.
- **Modern UI:** Built with **Material 3**, featuring a clean Teal & Amber theme for a travel-friendly experience.

## 🛠 Technology Stack
- **Framework:** [Flutter](https://flutter.dev)
- **Database:** [sqflite](https://pub.dev/packages/sqflite) (Local SQL Database)
- **Notifications:** [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- **Timezone Handling:** [timezone](https://pub.dev/packages/timezone)
- **UI & Design:** Google Fonts (Poppins), Material Design 3

## 📂 Folder Structure
- `lib/models/`: Data models for Trip objects.
- `lib/services/`: Database helpers and Notification service logic.
- `lib/screens/`:
    - `homeScreen/`: Main listing and Add/Edit dialogs.
    - `details/`: Deep-linked landing screen from notifications.
- `lib/widgets/`: Reusable custom components (Buttons, TextFields, Cards).

## 🚀 Roadmap (Future Updates)
- [ ] **Riverpod State Management:** Currently using `setState`. The project will be migrated to **Riverpod** for better state handling and performance optimization.
- [ ] **Google Maps Integration:** View trip destinations and get directions directly within the app.
- [ ] **Cloud Sync:** Firebase integration to sync trips across multiple devices.

## ⚙️ How to Setup
1. **Clone the repository:**
   