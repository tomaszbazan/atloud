# CLAUDE.md - Atloud Flutter Project Guide

## Build & Test Commands
- Run app: `flutter run`
- Run tests: `flutter test`
- Run single test: `flutter test test/widget_test.dart`
- Analyze code: `flutter analyze`
- Format code: `flutter format lib/ test/`
- Install dependencies: `flutter pub get`
- Update dependencies: `flutter pub upgrade`

## Code Style Guidelines
- Use named parameters with `required` keyword for required parameters
- Follow standard Flutter widget organization: constructor, fields, lifecycle methods, internal methods, build method
- Widget classes at bottom of file, state classes above them
- Keep widget classes immutable (use `const` constructor)
- Prefix private members with underscore
- Use camelCase for variables and lowerCamelCase for methods
- Group imports: Dart/Flutter core > External packages > Project imports
- Store persistent data via UserDataStorage
- Use constants for styling values (colors, fonts)
- Handle async operations with proper Future/async-await patterns
- Follow standard error handling with try/catch blocks where needed
- Don't use comments in code, except very complicated, unclear logic