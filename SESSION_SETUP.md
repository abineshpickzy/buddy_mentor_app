# Session Content Setup Instructions

## Required Packages Added
The following packages have been added to pubspec.yaml:

```yaml
# Session content page dependencies
webview_flutter: ^4.4.2    # For Cloudflare video player
path_provider: ^2.1.1      # For file downloads
open_filex: ^4.3.4         # For opening downloaded files
```

## Setup Steps

1. **Install packages:**
   ```bash
   flutter pub get
   ```

2. **Platform-specific setup:**

### Android Setup
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```

### iOS Setup
Add to `ios/Runner/Info.plist`:
```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

## Features Implemented

✅ **Session Circle Navigation**: Click any session → Navigate to content page
✅ **Video Player**: Cloudflare Stream integration via WebView
✅ **File Downloads**: PDF, DOCX, images with progress indicators
✅ **Tab Navigation**: Switch between sessions within content page
✅ **Progress Tracking**: Visual progress indicators
✅ **Cross-Platform**: Works on both Android and iOS

## API Integration

- **Endpoint**: `prgm/{programId}/{sessionId}/ast`
- **Response**: Videos, documents, images with metadata
- **Download**: Direct file download with progress tracking

## Usage Flow

1. Timeline → Module click → First chapter sessions
2. Session circle → Session click → Content page
3. Content page → Video + downloadables + description
4. Tab navigation between sessions
5. Mark as complete functionality

All components are integrated with your existing program overview data structure.