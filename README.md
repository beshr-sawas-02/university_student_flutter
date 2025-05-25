# University Student Application

A Flutter mobile application for university students to manage their courses, view grades, and vote for preferred courses.

## Features

1. **Authentication**
    - Student login
    - Profile management

2. **Courses**
    - View available courses
    - View course details
    - See prerequisites

3. **Marks/Grades**
    - View marks for each course
    - Calculate semester GPA
    - Calculate cumulative GPA

4. **Voting**
    - Vote for preferred courses (4-6 courses)
    - View voting history
    - Update votes

## Technology Stack

- **Frontend**: Flutter
- **State Management**: GetX
- **API Calls**: Dio
- **Local Storage**: GetStorage

## Color Scheme

- Primary: #D4C9BE (Light beige)
- Secondary: #123458 (Dark blue)
- Accent: #030303 (Black)

## Installation

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android Emulator / iOS Simulator

### Steps

1. Clone the repository:
```bash
git clone https://github.com/yourusername/university_student_app.git
```

2. Navigate to the project directory:
```bash
cd university_student_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Update the API base URL:
   In `lib/app/utils/constants.dart`, update the `baseUrl` to point to your backend server.

5. Run the app:
```bash
flutter run
```

## API Integration

The app connects to a NestJS backend with the following modules:
- Authentication
- Students
- Courses
- Marks
- Votes

Make sure your backend is running and accessible before using the app.

## Project Structure

```
lib/
├── app/
│   ├── bindings/
│   │   ├── auth_binding.dart
│   │   ├── course_binding.dart
│   │   ├── mark_binding.dart
│   │   └── vote_binding.dart
│   ├── data/
│   │   ├── models/
│   │   ├── providers/
│   │   └── repositories/
│   ├── modules/
│   │   ├── auth/
│   │   ├── courses/
│   │   ├── dashboard/
│   │   ├── marks/
│   │   └── votes/
│   ├── routes/
│   └── utils/
└── main.dart
```

## Screenshots

[Add screenshots here]

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request