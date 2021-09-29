# walk_with_god

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prerequisite & install (MacOS)

MacOS Prerequisite: homebrew
Recommend install VS Code Studio, Android Studio and XCode

### Install Dart SDK

Here is an example to install Dart SDK version 2.13 for MacOS.
See https://dart.dev/get-dart for details.

```
brew tap dart-lang/dart
brew install dart@2.13
echo 'export PATH="$PATH:/opt/homebrew/home/dart@2.13/bin"' >> ~/.zshrc
```

### Install Flutter SDK

Here is an example to install Flutter SDK version 2.5.0 for MacOS. (Change haley to your username)
See https://flutter.dev/docs/get-started/install/macos for details.

```
curl https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_2.5.0-stable.zip --output ./flutter_windows_2.5.0-stable.zip
sudo unzip ./flutter_windows_2.5.0-stable.zip -d /Users/haley/Programs
echo 'export PATH="$PATH:/Users/haley/Programs/flutter/bin"' >> ~/.zshrc
sudo chown -R haley flutter
rm ./flutter_windows_2.5.0-stable.zip
```

### Tell if the environment is ready
```
flutter doctor -v
```

### Install Android SDK Command-line Tools in Android Studio
Preferences > Appearance & Behavior > System Settings > Android SDK > SDK Tools > Android SDK Command-line Tools (latest)

### Accept Android license
```
flutter doctor --android-licenses
```

### Create a Android Emulator in Android Studio
Tools > AVD Manager
for example, I am using Pixel 4 & API Level 31

### Install packages
```
flutter pub get
```

## For app release

run: flutter build appbundle --build-number
