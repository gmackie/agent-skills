---
name: expo-build-submit
description: Build and submit Expo apps to App Store and Google Play using EAS Build and EAS Submit. Handles certificates, provisioning, and store uploads.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: mobile
  compatibility: Requires EAS CLI, Expo account, Apple Developer/Google Play accounts
---

# Expo Build and Submit

## Instructions

### 1. Set up EAS Build configuration

**Initialize EAS configuration:**
```bash
# Install EAS CLI
npm install -g eas-cli

# Login to EAS
eas login

# Initialize EAS configuration
eas build:configure
```

**Configure eas.json:**
```json
{
  "cli": {
    "version": ">= 5.4.0"
  },
  "build": {
    "development": {
      "developmentClient": true,
      "distribution": "internal"
    },
    "preview": {
      "distribution": "internal",
      "ios": {
        "simulator": true
      }
    },
    "production": {
      "ios": {
        "autoIncrement": "buildNumber"
      },
      "android": {
        "autoIncrement": "versionCode"
      }
    }
  },
  "submit": {
    "production": {
      "ios": {
        "appleId": "your-apple-id@example.com",
        "ascAppId": "1234567890",
        "appleTeamId": "ABCD123456"
      },
      "android": {
        "serviceAccountKeyPath": "./google-service-account.json",
        "track": "production"
      }
    }
  }
}
```

### 2. iOS build and submission setup

**Configure iOS credentials:**
```bash
# Set up iOS credentials (certificates, provisioning profiles)
eas credentials

# Or configure manually in eas.json
```

**iOS-specific eas.json configuration:**
```json
{
  "build": {
    "production": {
      "ios": {
        "buildConfiguration": "Release",
        "scheme": "YourAppName",
        "autoIncrement": "buildNumber",
        "bundleIdentifier": "com.yourcompany.yourapp",
        "enterpriseProvisioning": "universal"
      }
    }
  }
}
```

**Build for iOS:**
```bash
# Build for iOS App Store
eas build --platform ios --profile production

# Build for TestFlight (internal testing)
eas build --platform ios --profile preview

# Check build status
eas build:list
```

**Submit to App Store:**
```bash
# Submit latest build to App Store Connect
eas submit --platform ios --profile production

# Submit specific build
eas submit --platform ios --id YOUR_BUILD_ID

# Submit with custom options
eas submit --platform ios --apple-id your-apple-id@example.com --asc-app-id 1234567890
```

### 3. Android build and submission setup

**Configure Android credentials:**
```bash
# Generate Android keystore
eas credentials

# Or provide existing keystore
```

**Android-specific eas.json configuration:**
```json
{
  "build": {
    "production": {
      "android": {
        "buildType": "apk",
        "gradleCommand": ":app:assembleRelease",
        "autoIncrement": "versionCode"
      }
    }
  }
}
```

**Build for Android:**
```bash
# Build APK for Google Play
eas build --platform android --profile production

# Build AAB (recommended for Play Store)
eas build --platform android --profile production

# Build for internal testing
eas build --platform android --profile preview
```

**Submit to Google Play:**
```bash
# Set up Google Play service account
# Download service account JSON from Google Play Console

# Submit to Google Play
eas submit --platform android --profile production

# Submit to specific track
eas submit --platform android --track internal
eas submit --platform android --track alpha
eas submit --platform android --track beta
eas submit --platform android --track production
```

### 4. Automated build and submit workflow

**Build script for both platforms:**
```bash
#!/bin/bash

# build-and-submit.sh
set -e

echo "🚀 Starting Expo build and submit process..."

# Validate build before starting
if command -v node validate-build.js &> /dev/null; then
  echo "🔍 Running build validation..."
  node validate-build.js
fi

# Build for both platforms
echo "📱 Building iOS..."
eas build --platform ios --profile production --non-interactive

echo "🤖 Building Android..."
eas build --platform android --profile production --non-interactive

# Wait for builds to complete
echo "⏳ Waiting for builds to complete..."
eas build:list --status=in-progress --json | jq -r '.[].id' | while read build_id; do
  echo "Waiting for build $build_id..."
  while [ "$(eas build:view $build_id --json | jq -r '.status')" = "in-progress" ]; do
    sleep 30
  done
done

# Submit builds
echo "📤 Submitting to app stores..."

# Submit iOS
echo "🍎 Submitting to App Store..."
eas submit --platform ios --latest --non-interactive

# Submit Android
echo "🤖 Submitting to Google Play..."
eas submit --platform android --latest --non-interactive

echo "✅ Build and submit process complete!"
```

### 5. Environment-specific builds

**Development build:**
```bash
# Build development client
eas build --profile development --platform ios
eas build --profile development --platform android

# Install on device
eas build:run --profile development --platform ios
```

**Preview/staging build:**
```bash
# Build for internal testing
eas build --profile preview --platform all

# Share build with team
eas build:list --json | jq -r '.[0].artifacts.buildUrl'
```

**Production build with version bump:**
```bash
# Update version in app.json first
npm version patch  # or minor, major

# Build with updated version
eas build --profile production --platform all --auto-submit
```

### 6. Advanced build configuration

**Custom build hooks:**
```json
{
  "build": {
    "production": {
      "env": {
        "ENVIRONMENT": "production"
      },
      "prebuildCommand": "npm run prebuild:production",
      "postInstallCommand": "npm run postinstall:production"
    }
  }
}
```

**Build with custom environment variables:**
```bash
# Set environment variables for build
eas build --profile production --platform ios \
  --clear-cache \
  --message "Release v1.2.3 - Bug fixes and improvements"
```

**Monitor build progress:**
```javascript
// monitor-build.js
const { execSync } = require('child_process');

function monitorBuilds() {
  console.log('📊 Monitoring EAS builds...');
  
  setInterval(() => {
    try {
      const builds = JSON.parse(execSync('eas build:list --status=in-progress --json', { encoding: 'utf8' }));
      
      if (builds.length === 0) {
        console.log('✅ No builds in progress');
        return;
      }
      
      builds.forEach(build => {
        console.log(`🔄 Build ${build.id} (${build.platform}): ${build.status}`);
        console.log(`   Started: ${new Date(build.createdAt).toLocaleString()}`);
        console.log(`   Profile: ${build.buildProfile}`);
      });
    } catch (error) {
      console.error('Error checking builds:', error.message);
    }
  }, 30000); // Check every 30 seconds
}

monitorBuilds();
```

### 7. Troubleshooting and debugging

**Build debugging:**
```bash
# View build logs
eas build:view BUILD_ID

# Clear build cache
eas build --clear-cache

# View build artifacts
eas build:list --json | jq -r '.[0].artifacts'
```

**Submission debugging:**
```bash
# Check submission status
eas submit:list

# View submission details
eas submit:view SUBMISSION_ID

# Retry failed submission
eas submit --id BUILD_ID --platform ios
```

**Common build fixes:**
```bash
# Fix dependency issues
npm install
npx expo install --fix

# Clear all caches
npm start -- --clear
eas build --clear-cache
rm -rf node_modules package-lock.json
npm install

# Update Expo SDK
npx expo upgrade
```

## Examples

### Complete build and submit workflow
```bash
# 1. Validate project
node validate-build.js

# 2. Update version
npm version patch

# 3. Build for both platforms
eas build --profile production --platform all

# 4. Submit to stores
eas submit --platform all --latest

# 5. Monitor progress
node monitor-build.js
```

### Quick development build
```bash
# Build and install development client
eas build --profile development --platform ios
eas build:run --profile development --platform ios
```

### Automated CI/CD pipeline
```yaml
# .github/workflows/build-submit.yml
name: Build and Submit
on:
  push:
    tags: ['v*']

jobs:
  build-submit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: 18
      
      - name: Setup EAS
        uses: expo/expo-github-action@v8
        with:
          eas-version: latest
          token: ${{ secrets.EXPO_TOKEN }}
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build and Submit
        run: |
          eas build --platform all --profile production --non-interactive
          eas submit --platform all --latest --non-interactive
```

## Troubleshooting

- **Build fails with dependency errors**: Run `npx expo install --fix`
- **iOS certificate issues**: Use `eas credentials` to manage certificates
- **Android keystore problems**: Generate new keystore with `eas credentials`
- **Submission rejected**: Check app store guidelines and requirements
- **Build timeout**: Optimize build by reducing dependencies or using cache
- **Version conflicts**: Ensure version numbers are incremented properly
- **Store metadata missing**: Complete app store listings before submission
