# DAVClaw Dashboard — Mobile App Design

## Overview

DAVClaw is a mobile application that provides a WebView-based dashboard to interact with the local OpenClaw gateway running on Android. The app enables users to communicate with a locally-running LLM (via llama.cpp or MLC LLM) without requiring internet connectivity.

## Screen List

1. **Home Screen** — WebView dashboard pointing to `http://localhost:18789`
2. **Settings Screen** — Configure gateway connection, model selection, and offline preferences
3. **Status Screen** — Display gateway health, model status, and system resources

## Primary Content and Functionality

### Home Screen
- **WebView Component**: Renders the OpenClaw gateway dashboard at `http://localhost:18789`
- **Fallback UI**: If gateway is unreachable, display a connection status card with troubleshooting steps
- **Refresh Button**: Manual refresh of WebView content
- **Functionality**: Full interaction with the OpenClaw dashboard (chat, model selection, settings)

### Settings Screen
- **Gateway URL Input**: Customize the gateway endpoint (default: `http://127.0.0.1:18789`)
- **Connection Status**: Real-time indicator showing if gateway is reachable
- **Model Selection**: Display available models from the gateway
- **Offline Mode Toggle**: Enable/disable offline-only mode
- **Storage**: Display available disk space for models

### Status Screen
- **Gateway Health**: Ping status and response time
- **Model Status**: Currently loaded model and inference speed
- **System Resources**: RAM usage, CPU load, temperature
- **Logs**: Recent gateway logs and error messages

## Key User Flows

### Flow 1: Launch and Connect
1. User opens the app
2. App checks if gateway is running at `http://localhost:18789`
3. If reachable: Load WebView dashboard
4. If unreachable: Show connection error with troubleshooting steps

### Flow 2: Chat with Local LLM
1. User navigates to Home Screen
2. WebView loads the OpenClaw dashboard
3. User types a message in the chat interface
4. Message is sent to the local llama.cpp server
5. Response is streamed back and displayed in the WebView

### Flow 3: Configure Gateway
1. User navigates to Settings Screen
2. User enters custom gateway URL (if needed)
3. User selects a model from available options
4. Settings are saved to AsyncStorage
5. App reconnects to the gateway with new settings

## Color Choices

| Element | Color | Hex |
|---------|-------|-----|
| Primary Accent | Deep Blue | `#0a7ea4` |
| Background | White (Light) / Dark Gray (Dark) | `#ffffff` / `#151718` |
| Surface | Light Gray (Light) / Dark Surface (Dark) | `#f5f5f5` / `#1e2022` |
| Text Primary | Dark Gray (Light) / Light Gray (Dark) | `#11181C` / `#ECEDEE` |
| Text Secondary | Medium Gray | `#687076` / `#9BA1A6` |
| Success | Green | `#22C55E` |
| Error | Red | `#EF4444` |
| Border | Light Border | `#E5E7EB` / `#334155` |

## Technical Considerations

- **WebView Integration**: Use `react-native-webview` to embed the OpenClaw dashboard
- **Local Network Access**: Ensure the app can access `localhost:18789` on Android
- **Offline First**: Cache gateway responses and provide offline fallback UI
- **Connection Monitoring**: Periodically ping the gateway to detect connection loss
- **Error Handling**: Display user-friendly error messages for connection failures
