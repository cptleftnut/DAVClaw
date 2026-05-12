# DAVClaw Android Dashboard

A mobile application for DAVClaw that provides a WebView-based dashboard to interact with the local OpenClaw gateway running on Android. This app enables offline LLM inference directly on your phone without requiring internet connectivity.

## Features

- **WebView Dashboard**: Interact with the OpenClaw gateway through a web-based interface
- **Offline-First**: 100% local LLM inference using llama.cpp or MLC LLM
- **Gateway Monitoring**: Real-time connection status and system resource monitoring
- **Settings Management**: Configure gateway URL, model selection, and offline preferences
- **Cross-Platform**: Built with React Native and Expo for iOS and Android

## Quick Start

### Prerequisites

- Android device with 6GB+ RAM (8GB+ recommended)
- Termux installed from F-Droid (not Play Store)
- Node.js 22+ and pnpm

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/cptleftnut/DAVClaw.git
   cd DAVClaw
   ```

2. **Install dependencies**:
   ```bash
   pnpm install
   ```

3. **Start the development server**:
   ```bash
   pnpm dev
   ```

4. **Open in Expo Go**:
   - Scan the QR code with Expo Go on your Android device
   - Or run: `pnpm android`

### Building the APK

#### Using GitHub Actions (Recommended)

The repository includes a GitHub Actions workflow that automatically builds the APK on every push to `main`:

1. Push your changes to the `main` branch
2. Navigate to the **Actions** tab on GitHub
3. Select the **Build APK** workflow
4. The APK will be available in the workflow artifacts after the build completes
5. Releases are automatically created with the APK attached

#### Building Locally

To build the APK on your machine:

```bash
# Option 1: Using Expo Application Services (EAS)
eas build --platform android --local

# Option 2: Using the local build script
./scripts/build-apk-local.sh
```

## Project Structure

```
DAVClawApp/
├── app/                      # Expo Router app directory
│   ├── _layout.tsx          # Root layout with providers
│   └── (tabs)/
│       ├── _layout.tsx      # Tab navigation
│       └── index.tsx        # Home screen (WebView dashboard)
├── components/              # Reusable React Native components
├── hooks/                   # Custom React hooks
├── lib/                     # Utility functions and helpers
├── assets/                  # App icons and images
├── .github/workflows/       # GitHub Actions workflows
│   └── build-apk.yml       # APK build workflow
├── eas.json                 # EAS build configuration
├── app.config.ts            # Expo app configuration
├── tailwind.config.js       # Tailwind CSS configuration
└── package.json             # Project dependencies
```

## Configuration

### App Settings (app.config.ts)

Update the app name and branding in `app.config.ts`:

```typescript
const env = {
  appName: "DAVClaw",
  appSlug: "davclaw",
  logoUrl: "", // S3 URL of custom logo
};
```

### Gateway Connection

The app connects to the OpenClaw gateway at `http://127.0.0.1:18789` by default. To customize:

1. Open the Settings screen in the app
2. Enter a custom gateway URL
3. Tap "Save" to persist the setting

## Development

### Adding New Screens

1. Create a new file in `app/(tabs)/` or `app/`
2. Use the `ScreenContainer` component for proper SafeArea handling
3. Add navigation in `app/(tabs)/_layout.tsx`

### Styling

This project uses **NativeWind** (Tailwind CSS for React Native). Use Tailwind classes directly:

```tsx
<View className="flex-1 items-center justify-center p-4">
  <Text className="text-2xl font-bold text-foreground">Hello</Text>
</View>
```

### Theme Colors

Edit `theme.config.js` to customize colors:

```javascript
const themeColors = {
  primary: { light: '#0a7ea4', dark: '#0a7ea4' },
  background: { light: '#ffffff', dark: '#151718' },
  // ... more colors
};
```

## Testing

Run the test suite:

```bash
pnpm test
```

## Deployment

### GitHub Actions Workflow

The `.github/workflows/build-apk.yml` workflow:

1. Checks out the code
2. Installs dependencies
3. Sets up Java and Android SDK
4. Builds the APK using EAS
5. Uploads the APK to workflow artifacts
6. Creates a GitHub release with the APK attached

### Manual APK Installation

To install the APK on your device:

```bash
adb install -r app.apk
```

## Troubleshooting

### Gateway Connection Issues

If the app cannot connect to the gateway:

1. Verify the gateway is running in Termux:
   ```bash
   proot-distro login ubuntu
   openclaw gateway start
   ```

2. Check the gateway URL in the app settings
3. Ensure localhost:18789 is accessible from the WebView

### Build Failures

If the APK build fails:

1. Ensure Android SDK is installed: `$ANDROID_HOME` is set
2. Check Java version: `java -version` (should be 17+)
3. Clear build cache: `rm -rf android/build`
4. Reinstall dependencies: `pnpm install --frozen-lockfile`

### WebView Not Loading

If the WebView dashboard doesn't load:

1. Check the browser console for errors
2. Verify the gateway is running and accessible
3. Try refreshing the WebView manually
4. Check network connectivity

## Documentation

- [DAVClaw Blueprint](../README.md) — Full architecture and setup guide
- [Expo Documentation](https://docs.expo.dev/) — React Native and Expo guides
- [NativeWind Documentation](https://www.nativewind.dev/) — Tailwind CSS for React Native

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -am 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Submit a pull request

## License

This project is part of the DAVClaw project. See the main repository for license information.

## Support

For issues, questions, or suggestions:

1. Check the [DAVClaw Blueprint](../README.md) for setup instructions
2. Review existing GitHub issues
3. Create a new issue with detailed information

## Roadmap

- [ ] Native Flutter app with embedded Node.js runtime
- [ ] MLC LLM Android SDK integration
- [ ] Push notifications for inference completion
- [ ] Model management UI (download, delete, switch)
- [ ] Performance monitoring dashboard
- [ ] Voice input support
- [ ] Offline chat history storage
