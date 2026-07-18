# Sensi Ultralock

Premium Gaming Optimizer for iOS.

## Features

- **Game Optimizer** - Sensitivity Booster, Screen Booster, 120Hz Screen, Feather Aim, Headshot Fix
- **Pro Features** - AimLock Assist Pro, Auto Trigger Pro, Recoil Control Pro, Crosshair Overlay
- **VIP Elite** - AimLock Ultra, Anchor Aim, Crosshair Premium
- **System Dashboard** - Real-time device information
- **Member Profile** - Account management and subscription details

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.10+

## Installation

### XcodeGen (Recommended)

1. Install XcodeGen:
```bash
brew install xcodegen
```

2. Generate Xcode project:
```bash
xcodegen generate
```

3. Open `SensiUltralock.xcodeproj` in Xcode and build.

### Manual Setup

1. Open Xcode
2. Create a new iOS App project
3. Set minimum deployment target to iOS 16.0
4. Copy all source files from `SensiUltralock/` into the project
5. Build and run

## Architecture

- **MVVM** - Model-View-ViewModel architecture
- **SwiftUI** - Fully SwiftUI-based UI
- **Combine** - Reactive state management

## Project Structure

```
SensiUltralock/
├── App/
├── Views/
│   ├── Login/
│   ├── Home/
│   ├── Optimizer/
│   ├── System/
│   └── Member/
├── Components/
├── Theme/
├── Models/
├── Services/
├── ViewModels/
├── Extensions/
├── Managers/
├── Assets.xcassets/
└── Resources/
```

## License

Proprietary. All rights reserved.
