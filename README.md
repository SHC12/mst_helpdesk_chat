# Dedi MST Helpdesk Chat Apps

## Overview

A Flutter app built with **Clean Architecture** + 

- **Flutter Version:** 3.32.6
- **Dart SDK:** 3.8.1

- **State Management:** Cubit


## Requirements

- Flutter **3.32.6** (recommended to use FVM for version pinning)
- Dart **3.8.1**

## Quick Start

```bash
# If you use FVM
fvm use 3.32.6
fvm flutter --version

# Install dependencies
fvm flutter pub get

# Generate Build Runners
fvm dart run build_runner build --delete-conflicting-outputs

# Run on a device/emulator
fvm flutter run
```

If you are not using FVM, replace `fvm flutter` with `flutter`.

## Environment Variable

```bash
# Open AI Key
OPENAI_API_KEY = 'sk---your-openai-api-key'


```

## Project Highlights


- **State Management:** `cubit` for reactive UI states; `equatable` for value equality
- **Local Storage:** Hive for cache-first
