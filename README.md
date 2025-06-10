# Atloud

A feature-rich timer and alarm clock application built with Flutter.

## Features

- **Timer**: Set custom countdown timers with precise control
- **Clock**: Use the app as an alarm clock
- **Background Operation**: Keep your timers running even when the app is in the background
- **Multiple Alarm Sounds**: Choose from various alarm sounds like fanfare, brass, ukulele, and more
- **Volume Control**: Easily adjust the alarm volume directly from the app
- **Vibration**: Haptic feedback when alarms are triggered
- **Text-to-Speech**: Voice announcements for timer events
- **Screen Wake Lock**: Prevents the device from sleeping during active timers

## Getting Started

### Prerequisites

- Flutter SDK (version ^3.7.0)
- Dart SDK

### Installation

1. Clone the repository:
```bash
git clone https://github.com/tomaszbazan/atloud.git
```

2. Navigate to the project directory:
```bash
cd atloud
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Tech Stack

- **Flutter**: UI framework
- **flutter_foreground_task**: For background task management
- **audioplayers**: For sound playback
- **vibration**: For haptic feedback
- **flutter_tts**: For text-to-speech functionality
- **flutter_secure_storage**: For secure data storage
- **volume_controller**: For device volume management
- **wakelock_plus**: For keeping the screen awake

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- Icons and design elements from various open-source projects
- Sound effects from various free sound libraries
