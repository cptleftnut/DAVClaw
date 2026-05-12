# GitHub Actions Workflow Setup Guide

The DAVClaw project includes a GitHub Actions workflow for automated APK building. Due to GitHub's workflow permissions requirements, the workflow file needs to be added manually through GitHub's web interface or with proper permissions.

## Option 1: Add Workflow via GitHub Web Interface (Recommended)

1. Go to your repository: https://github.com/cptleftnut/DAVClaw
2. Click on the **Actions** tab
3. Click **"New workflow"** or **"Set up a workflow yourself"**
4. Create a new file named `build-apk.yml` in `.github/workflows/`
5. Copy the content from the workflow file below
6. Click **"Commit changes"**

## Option 2: Add Workflow via Git CLI (Requires Workflow Permissions)

If you have GitHub CLI configured with proper permissions:

```bash
# Clone the repository
git clone https://github.com/cptleftnut/DAVClaw.git
cd DAVClaw

# Create the workflow directory
mkdir -p .github/workflows

# Create the workflow file (see content below)
cat > .github/workflows/build-apk.yml << 'EOF'
[PASTE WORKFLOW CONTENT HERE]
EOF

# Commit and push
git add .github/workflows/build-apk.yml
git commit -m "Add GitHub Actions APK build workflow"
git push origin main
```

## Workflow File Content

Save this as `.github/workflows/build-apk.yml`:

```yaml
name: Build APK

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    timeout-minutes: 60

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "22"
          cache: "pnpm"

      - name: Setup pnpm
        uses: pnpm/action-setup@v2
        with:
          version: 9.12.0

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: "temurin"
          java-version: "17"

      - name: Setup Android SDK
        uses: android-actions/setup-android@v3

      - name: Accept Android licenses
        run: |
          yes | $ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager --licenses || true

      - name: Setup Expo
        run: pnpm add -g eas-cli

      - name: Build APK
        run: |
          eas build --platform android --local --output ./app.apk
        env:
          EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}

      - name: Upload APK to artifacts
        if: success()
        uses: actions/upload-artifact@v4
        with:
          name: davclaw-app
          path: app.apk
          retention-days: 30

      - name: Create Release
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          tag_name: v${{ github.run_number }}
          release_name: DAVClaw APK Release ${{ github.run_number }}
          draft: false
          prerelease: false

      - name: Upload APK to Release
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        uses: actions/upload-release-asset@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          upload_url: ${{ steps.create_release.outputs.upload_url }}
          asset_path: ./app.apk
          asset_name: davclaw-app-${{ github.run_number }}.apk
          asset_content_type: application/vnd.android.package-archive
```

## Setting Up Secrets

The workflow requires the `EXPO_TOKEN` secret for building with EAS:

1. Go to your repository settings: https://github.com/cptleftnut/DAVClaw/settings/secrets/actions
2. Click **"New repository secret"**
3. Name: `EXPO_TOKEN`
4. Value: Your Expo authentication token (get it from https://expo.dev/settings/tokens)
5. Click **"Add secret"**

## Verifying the Workflow

After adding the workflow file:

1. Go to the **Actions** tab
2. You should see "Build APK" in the workflow list
3. Make a commit to trigger the workflow
4. Check the workflow run for build status

## Troubleshooting

- **Workflow not appearing**: Ensure the file is in `.github/workflows/build-apk.yml`
- **Build failures**: Check the workflow run logs for detailed error messages
- **Permission errors**: Ensure your GitHub account has proper permissions for the repository
- **EXPO_TOKEN issues**: Verify the token is valid and hasn't expired

## Manual APK Building

If the workflow is not available, you can build the APK locally:

```bash
# Using the local build script
./scripts/build-apk-local.sh

# Or using EAS directly
eas build --platform android --local
```

For more information, see the main [README.md](README.md).
