---
name: expo-build-validation
description: Validate Expo app builds before submission, checking configuration, dependencies, assets, and platform-specific requirements. Use before building for app stores.
allowed-tools: fs_read fs_write execute_bash
metadata:
  author: kiro-cli
  version: "1.0"
  category: mobile
  compatibility: Requires Expo CLI, Node.js, valid Expo project
---

# Expo Build Validation

## Instructions

### 1. Project structure validation

**Check essential files:**
```bash
# Verify core Expo files exist
ls -la app.json app.config.js package.json
ls -la assets/icon.png assets/splash.png assets/adaptive-icon.png
```

**Validate app.json/app.config.js:**
```javascript
// Validation script for app configuration
const fs = require('fs');
const path = require('path');

function validateAppConfig() {
  let config;
  
  // Try app.config.js first, then app.json
  if (fs.existsSync('app.config.js')) {
    config = require('./app.config.js');
  } else if (fs.existsSync('app.json')) {
    config = JSON.parse(fs.readFileSync('app.json', 'utf8'));
  } else {
    throw new Error('No app.json or app.config.js found');
  }

  const { expo } = config;
  const errors = [];
  const warnings = [];

  // Required fields
  if (!expo.name) errors.push('Missing expo.name');
  if (!expo.slug) errors.push('Missing expo.slug');
  if (!expo.version) errors.push('Missing expo.version');
  if (!expo.platforms) errors.push('Missing expo.platforms');

  // iOS specific validation
  if (expo.platforms?.includes('ios')) {
    if (!expo.ios?.bundleIdentifier) {
      errors.push('Missing ios.bundleIdentifier for iOS build');
    }
    if (!expo.ios?.buildNumber) {
      warnings.push('Missing ios.buildNumber - will use version');
    }
  }

  // Android specific validation
  if (expo.platforms?.includes('android')) {
    if (!expo.android?.package) {
      errors.push('Missing android.package for Android build');
    }
    if (!expo.android?.versionCode) {
      warnings.push('Missing android.versionCode - will auto-increment');
    }
  }

  // Asset validation
  if (!expo.icon) errors.push('Missing app icon');
  if (!expo.splash?.image) warnings.push('Missing splash screen');

  console.log('=== EXPO CONFIG VALIDATION ===');
  if (errors.length > 0) {
    console.error('❌ ERRORS:');
    errors.forEach(err => console.error(`  - ${err}`));
  }
  if (warnings.length > 0) {
    console.warn('⚠️  WARNINGS:');
    warnings.forEach(warn => console.warn(`  - ${warn}`));
  }
  if (errors.length === 0 && warnings.length === 0) {
    console.log('✅ Configuration valid');
  }

  return { errors, warnings };
}

validateAppConfig();
```

### 2. Dependencies and compatibility check

**Check for incompatible packages:**
```bash
# Check for common incompatible packages
npx expo install --check

# Validate Expo SDK compatibility
npx expo doctor

# Check for deprecated packages
npm audit --audit-level moderate
```

**Custom dependency validator:**
```javascript
// Check package.json for common issues
const packageJson = require('./package.json');

function validateDependencies() {
  const issues = [];
  const { dependencies, devDependencies } = packageJson;
  
  // Check for React Native version compatibility
  const rnVersion = dependencies['react-native'];
  if (rnVersion && !rnVersion.includes('0.72') && !rnVersion.includes('0.73')) {
    issues.push('React Native version may be incompatible with current Expo SDK');
  }

  // Check for problematic packages
  const problematicPackages = [
    'react-native-vector-icons', // Use @expo/vector-icons instead
    'react-native-maps', // Use expo-location instead
    'react-native-camera', // Use expo-camera instead
  ];

  problematicPackages.forEach(pkg => {
    if (dependencies[pkg] || devDependencies[pkg]) {
      issues.push(`Consider replacing ${pkg} with Expo equivalent`);
    }
  });

  console.log('=== DEPENDENCY VALIDATION ===');
  if (issues.length > 0) {
    issues.forEach(issue => console.warn(`⚠️  ${issue}`));
  } else {
    console.log('✅ Dependencies look good');
  }

  return issues;
}

validateDependencies();
```

### 3. Asset validation

**Check required assets:**
```bash
# Validate app icons
file assets/icon.png
identify assets/icon.png  # Check dimensions (should be 1024x1024)

# Validate splash screen
file assets/splash.png
identify assets/splash.png

# Check adaptive icon (Android)
file assets/adaptive-icon.png
identify assets/adaptive-icon.png  # Should be 1024x1024
```

**Asset validation script:**
```javascript
const fs = require('fs');
const { execSync } = require('child_process');

function validateAssets() {
  const requiredAssets = [
    { path: 'assets/icon.png', size: '1024x1024', required: true },
    { path: 'assets/splash.png', required: true },
    { path: 'assets/adaptive-icon.png', size: '1024x1024', required: false },
  ];

  console.log('=== ASSET VALIDATION ===');
  
  requiredAssets.forEach(asset => {
    if (!fs.existsSync(asset.path)) {
      if (asset.required) {
        console.error(`❌ Missing required asset: ${asset.path}`);
      } else {
        console.warn(`⚠️  Missing optional asset: ${asset.path}`);
      }
      return;
    }

    try {
      const dimensions = execSync(`identify -format "%wx%h" ${asset.path}`, { encoding: 'utf8' }).trim();
      
      if (asset.size && dimensions !== asset.size) {
        console.warn(`⚠️  ${asset.path} is ${dimensions}, should be ${asset.size}`);
      } else {
        console.log(`✅ ${asset.path} (${dimensions})`);
      }
    } catch (error) {
      console.error(`❌ Error checking ${asset.path}: ${error.message}`);
    }
  });
}

validateAssets();
```

### 4. Build environment validation

**Check Expo CLI and environment:**
```bash
# Check Expo CLI version
expo --version

# Check if logged in
expo whoami

# Validate EAS CLI (for EAS Build)
eas --version
eas whoami

# Check Node.js version
node --version
npm --version
```

**Environment validation script:**
```bash
#!/bin/bash

echo "=== EXPO BUILD ENVIRONMENT VALIDATION ==="

# Check Node.js version (should be 16+ for Expo SDK 49+)
NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 16 ]; then
  echo "❌ Node.js version $NODE_VERSION is too old. Requires 16+"
  exit 1
else
  echo "✅ Node.js version: $(node --version)"
fi

# Check Expo CLI
if ! command -v expo &> /dev/null; then
  echo "❌ Expo CLI not installed. Run: npm install -g @expo/cli"
  exit 1
else
  echo "✅ Expo CLI: $(expo --version)"
fi

# Check if logged in to Expo
if ! expo whoami &> /dev/null; then
  echo "⚠️  Not logged in to Expo. Run: expo login"
else
  echo "✅ Logged in as: $(expo whoami)"
fi

# Check EAS CLI for EAS Build
if command -v eas &> /dev/null; then
  echo "✅ EAS CLI: $(eas --version)"
  if ! eas whoami &> /dev/null; then
    echo "⚠️  Not logged in to EAS. Run: eas login"
  else
    echo "✅ EAS logged in as: $(eas whoami)"
  fi
else
  echo "⚠️  EAS CLI not installed. For EAS Build, run: npm install -g eas-cli"
fi

echo "✅ Environment validation complete"
```

### 5. Platform-specific validation

**iOS validation:**
```bash
# Check iOS bundle identifier format
grep -o '"bundleIdentifier":\s*"[^"]*"' app.json

# Validate iOS version requirements
grep -o '"minimumOsVersion":\s*"[^"]*"' app.json
```

**Android validation:**
```bash
# Check Android package name format
grep -o '"package":\s*"[^"]*"' app.json

# Validate Android API levels
grep -o '"compileSdkVersion":\s*[0-9]*' app.json
grep -o '"targetSdkVersion":\s*[0-9]*' app.json
```

### 6. Pre-build validation script

**Complete validation runner:**
```javascript
// validate-build.js
const { execSync } = require('child_process');
const fs = require('fs');

async function runValidation() {
  console.log('🔍 Starting Expo build validation...\n');
  
  const checks = [
    { name: 'Project Structure', fn: validateProjectStructure },
    { name: 'App Configuration', fn: validateAppConfig },
    { name: 'Dependencies', fn: validateDependencies },
    { name: 'Assets', fn: validateAssets },
    { name: 'Environment', fn: validateEnvironment },
  ];

  let hasErrors = false;

  for (const check of checks) {
    try {
      console.log(`\n=== ${check.name.toUpperCase()} ===`);
      const result = await check.fn();
      if (result && result.errors && result.errors.length > 0) {
        hasErrors = true;
      }
    } catch (error) {
      console.error(`❌ ${check.name} failed: ${error.message}`);
      hasErrors = true;
    }
  }

  console.log('\n=== VALIDATION SUMMARY ===');
  if (hasErrors) {
    console.error('❌ Build validation failed. Fix errors before building.');
    process.exit(1);
  } else {
    console.log('✅ All validations passed. Ready to build!');
  }
}

function validateProjectStructure() {
  const requiredFiles = ['package.json', 'app.json'];
  const missingFiles = requiredFiles.filter(file => !fs.existsSync(file));
  
  if (missingFiles.length > 0) {
    throw new Error(`Missing files: ${missingFiles.join(', ')}`);
  }
  
  console.log('✅ Project structure valid');
  return { errors: [] };
}

function validateEnvironment() {
  try {
    execSync('expo --version', { stdio: 'pipe' });
    console.log('✅ Expo CLI available');
  } catch {
    throw new Error('Expo CLI not installed');
  }
  
  return { errors: [] };
}

// Add other validation functions here...

runValidation().catch(console.error);
```

## Examples

### Quick validation check
```bash
# Run all validations
node validate-build.js

# Check specific aspects
expo doctor
npx expo install --check
```

### Pre-build checklist
```bash
# 1. Validate configuration
node -e "console.log(JSON.stringify(require('./app.json'), null, 2))"

# 2. Check dependencies
npm audit --audit-level moderate

# 3. Validate assets
ls -la assets/

# 4. Test build locally
expo export

# 5. Run validation script
node validate-build.js
```

## Troubleshooting

- **Missing app.json**: Create from template or run `expo init`
- **Invalid bundle identifier**: Use reverse domain format (com.company.app)
- **Asset dimension errors**: Resize images to required dimensions
- **Dependency conflicts**: Run `npx expo install --fix`
- **Environment issues**: Update Node.js, Expo CLI, or EAS CLI
- **Build fails after validation**: Check platform-specific requirements
