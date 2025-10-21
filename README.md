# 🌟 Klarifikasi.id v2.0.0 (Flutter Frontend)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev)
[![Laravel](https://img.shields.io/badge/Laravel-12.0-red.svg)](https://laravel.com)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-orange.svg)](https://mysql.com)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI-purple.svg)](https://ai.google.dev)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android-green.svg)](#)
[![Version](https://img.shields.io/badge/Version-2.0.0-brightgreen.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Aplikasi Fact-Checking Modern dengan AI** untuk memverifikasi kebenaran informasi melalui pencarian di portal berita terpercaya menggunakan Google Custom Search Engine dan analisis AI Gemini dengan backend Laravel dan database MySQL.

<p align="center">
  <img src="https://via.placeholder.com/800x400/1a1a2e/ffffff?text=Klarifikasi.id+Flutter+App" alt="Klarifikasi.id Screenshot" width="800"/>
</p>

## ✨ Fitur Unggulan v2.0.0

### 🤖 **AI-Powered Fact-Checking**
- **Gemini AI Integration**: Analisis klaim otomatis dengan Google Gemini AI
- **Real-time Search**: Pencarian informasi dengan Google Custom Search Engine
- **Smart Analysis**: AI memberikan penjelasan dan sumber referensi
- **Collapsible UI**: Interface AI yang tidak mengganggu saat browsing hasil

### 🔍 **Advanced Search System**
- **Trusted Sources**: Integrasi dengan portal berita kredibel Indonesia
- **Rich Results**: Preview hasil pencarian dengan thumbnail dan snippet
- **Rate Limiting**: Pembatasan pencarian untuk mencegah spam
- **Custom Logo**: Logo Klarifikasi.id yang unik di loading screen

### 👤 **User Management**
- **Secure Authentication**: Token-based auth dengan Laravel Sanctum
- **Profile Management**: Update profil dengan data pendidikan dan institusi
- **Session Management**: Automatic token refresh dan cleanup
- **Cross-Platform**: Single codebase untuk Web dan Android

### 🎨 **Modern UI/UX**
- **Dark Theme**: Elegant dark theme dengan gradient backgrounds
- **Responsive Design**: Optimized untuk desktop, tablet, dan mobile
- **Loading Animations**: Smooth loading states dengan custom animations
- **Error Handling**: Comprehensive error dialogs dan feedback

### 📱 **Multi-Platform Support**
- **Flutter Web**: Aplikasi web modern dengan performa tinggi
- **Android App**: Native Android application dengan APK build
- **Cross-Platform**: Satu codebase untuk semua platform
- **Progressive Web App**: PWA-ready dengan service worker

### 🚀 **Production Ready**
- **Laravel Cloud Backend**: Production-ready dengan SSL encryption
- **MySQL Database**: Robust database dengan Laravel Cloud MySQL
- **Custom Favicon**: Logo Klarifikasi.id sebagai web favicon
- **Version Control**: Git submodules untuk organized development

## 🌐 Production URLs

- **Frontend (Cloudhebat)**: https://www.klarifikasi.rj22d.my.id/
- **Frontend (GitHub Pages)**: https://elloe2.github.io/Klarifikasi.id/
- **Backend (Laravel Cloud)**: https://klarifikasiid-backend-main-ki47jp.laravel.cloud/
- **GitHub Repository**: https://github.com/Elloe2/Klarifikasi.id

## 🏗️ Arsitektur Aplikasi v2.0.0

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter       │    │     Laravel      │    │     MySQL       │
│   Frontend      │◄──►│     Backend      │◄──►│    Database     │
│   (Multi-Platform)   │   (Laravel Cloud) │   (Laravel Cloud) │
│                 │    │                  │    │                 │
│ • Web & Android │    │ • REST API       │    │ • Users         │
│ • Gemini AI UI  │    │ • Gemini AI      │    │ • Access Tokens │
│ • Custom Logo   │    │ • Google CSE     │    │ • SSL Encrypted │
│ • PWA Ready     │    │ • SSL/HTTPS      │    │ • Production    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🛠️ Tech Stack

### **Frontend (Flutter)**
- **Framework**: Flutter 3.35.3 🚀
- **Language**: Dart 3.9.2 ⚡
- **State Management**: Provider Pattern 📱
- **HTTP Client**: http package dengan timeout & retry (custom) 🔄
- **Storage**: Flutter Secure Storage 🔐
- **UI Framework**: Material 3 dengan custom theming 🎨

### **Backend Integration**
- **API Communication**: RESTful API dengan Laravel backend
- **Authentication**: Token-based dengan Laravel Sanctum
- **Search Engine**: Google Custom Search Engine integration
- **AI Integration**: Google Gemini AI untuk analisis klaim
- **Error Handling**: Comprehensive error management

### **Development Tools**
- **IDE Support**: Visual Studio Code, Android Studio
- **Version Control**: Git & GitHub
- **Code Quality**: Dart Analysis, Linting
- **Testing**: Flutter Test Framework
- **Deployment**: Multi-platform deployment ready

## 📋 Prerequisites

Sebelum memulai, pastikan Anda memiliki:

- **Flutter SDK** (3.35.3+) - [Download](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (3.9.2+) - [Included with Flutter](https://dart.dev/get-dart)
- **Android Studio** (untuk Android development) - [Download](https://developer.android.com/studio)
- **Google Chrome** (untuk Web development) - [Download](https://www.google.com/chrome/)
- **Backend Laravel** (sudah tersedia di `../Klarifikasi.id-backend/`)
- **Google Gemini AI API Key** - [Get Key](https://ai.google.dev/)

## 🚀 Quick Start

### **1. Clone Repository**

```bash
# Clone frontend repository
git clone https://github.com/Elloe2/Klarifikasi.id-frontend.git
cd Klarifikasi.id-frontend

# Clone backend repository (terminal terpisah)
git clone https://github.com/Elloe2/Klarifikasi.id-backend.git
cd ../Klarifikasi.id-backend
```

### **2. Install Dependencies**

#### **Backend Setup**
```bash
# Install PHP dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Configure database (Laravel Cloud MySQL)
# Edit .env dengan kredensial Laravel Cloud MySQL
nano .env

# Run database migrations
php artisan migrate

# Start Laravel server
php artisan serve --host=0.0.0.0 --port=8000
```

#### **Frontend Setup**
```bash
# Kembali ke folder frontend
cd ../Klarifikasi.id-frontend

# Install Flutter dependencies
flutter pub get

# Upgrade jika diperlukan
flutter pub upgrade
```

### **3. Run Flutter Application**

#### **Development Mode**

```bash
# Jalankan di Web (Chrome) - Development
flutter run -d chrome --web-port 3001

# Jalankan di Android Emulator
flutter run -d emulator-5554

# Jalankan di Android Device (USB Debugging)
flutter run -d <device-id>
```

#### **Production Build**

```bash
# Build untuk Web Production (Cloudhebat)
flutter build web --release \
  --dart-define=API_BASE_URL=https://klarifikasiid-backend-main-ki47jp.laravel.cloud \
  --dart-define=FORCE_PRODUCTION=true

# Build untuk Android APK
flutter build apk --release

# Build untuk Android App Bundle (Play Store)
flutter build appbundle --release
```

## 🌐 Deployment Guide

### **🎯 OPSI TERBAIK: 100% GRATIS - LARAVEL CLOUD + NETLIFY + NEON**

#### **💎 Opsi 1: Laravel Cloud + Netlify (COMPLETELY FREE)**

##### **Backend Deployment (Laravel Cloud - FREE)**

1. **Laravel Cloud Setup**:
   - Kunjungi [Laravel Cloud](https://cloud.laravel.com)
   - Connect dengan GitHub account
   - Pilih repository `Klarifikasi.id-backend`

2. **Auto Deploy Laravel Cloud**:
   ```bash
   # Laravel Cloud akan automatically:
   # - Detect Laravel framework
   # - Setup production environment
   # - Configure SSL certificate
   # - Deploy dengan zero configuration
   ```

3. **Environment Variables untuk Laravel Cloud**:
   ```env
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://klarifikasiid-backend-main-ki47jp.laravel.cloud

   # Database PostgreSQL (Neon)
   DB_CONNECTION=pgsql
   DB_HOST=ep-summer-poetry-a1j9yrq5-pooler.ap-southeast-1.aws.neon.tech
   DB_PORT=5432
   DB_DATABASE=neondb
   DB_USERNAME=neondb_owner
   DB_PASSWORD=npg_v8cdn2ZBUFXx
   DB_SSLMODE=require

   # Google Custom Search API
   GOOGLE_CSE_KEY=AIzaSyAFOdoaMwgurnjfnhGKn5GFy6_m2HKiGtA
   GOOGLE_CSE_CX=6242f5825dedb4b59
   GOOGLE_CSE_VERIFY_SSL=false
   ```

##### **Database Setup (Neon PostgreSQL - FREE)**

1. **Sign up** ke [Neon](https://neon.tech) - **100% Gratis**
2. **Create New Project**:
   - Pilih region: Asia Southeast (Singapore)
   - Database name: `neondb`
   - Usernamea: `neondb_owner`

3. **Get Connection String**:
   ```
   postgresql://neondb_owner:npg_v8cdn2ZBUFXx@ep-summer-poetry-a1j9yrq5-pooler.ap-southeast-1.aws.neon.tech/neondb?channel_binding=require&sslmode=require
   ```

4. **Update Laravel .env**:
   ```bash
   # Copy connection string ke .env
   DB_URL=postgresql://neondb_owner:npg_v8cdn2ZBUFXx@ep-summer-poetry-a1j9yrq5-pooler.ap-southeast-1.aws.neon.tech/neondb?channel_binding=require&sslmode=require
   ```

##### **Frontend Deployment (Cloudhebat - Production)**

1. **Build Web Assets** (menyematkan API URL produksi):
   ```bash
   flutter build web --release \
     --dart-define=API_BASE_URL=https://klarifikasiid-backend-main-ki47jp.laravel.cloud \
     --dart-define=FORCE_PRODUCTION=true
   ```

2. **Deploy ke Cloudhebat**:
   - Upload isi folder `build/web/`
   - Aktifkan SPA routing (semua route → `index.html`)
   - Jika versi lama masih muncul, lakukan hard refresh/clear site data (service worker)

##### **Frontend Deployment (Netlify - FREE)**

1. **Build Web Assets** (Sudah completed):
   ```bash
   flutter build web --release ✅ DONE
   ```

2. **Deploy ke Netlify**:
   - Sign up ke [Netlify](https://netlify.com) - **FREE**
   - Drag & drop folder `build/web/` ke Netlify
   - Atau connect GitHub repository untuk auto-deploy

3. **Configure Netlify**:
   - **Build command**: `echo "Flutter app ready"`
   - **Publish directory**: `build/web`
   - **Redirect rules** untuk SPA:
     ```
     /*    /index.html   200
     ```

4. **Update API Configuration**:
   ```dart
   // lib/config.dart
   String get apiBaseUrl {
     if (kDebugMode) {
       return 'http://localhost:8000';
     }
     return 'https://your-app-name.onrender.com'; // Render backend URL
   }
   ```

#### **📱 Android Deployment (Firebase - FREE)**

1. **Setup Firebase App Distribution**:
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools

   # Login dan setup project
   firebase login
   firebase init appdistribution
   ```

2. **Build dan Distribute APK**:
   ```bash
   # Build APK (sudah completed)
   flutter build apk --release ✅ DONE

   # Distribute untuk testing
   firebase appdistribution:distribute build/app/outputs/apk/release/app-release.apk \
     --app your-firebase-app-id \
     --groups "beta-testers" \
     --release-notes "Initial release - Fact-checking app for Indonesia"
   ```

3. **Share dengan Users**:
   - Firebase akan generate download links
   - Users bisa install APK langsung
   - Perfect untuk beta testing tanpa Play Store

#### **🌐 Domain Gratis**

1. **Opsi Domain Free**:
   - **Freenom**: Domain .tk, .ml, .ga, .cf (100% gratis)
   - **Railway**: Subdomain gratis (your-app.railway.app)
   - **Netlify**: Subdomain gratis (your-app.netlify.app)

2. **Setup Custom Domain**:
   ```bash
   # Contoh dengan Freenom domain
   # Update DNS records untuk point ke Render dan Netlify
   # Configure SSL gratis di Netlify
   ```

#### **🎉 COMPLETE FREE STACK**

**Final URLs:**
- **Backend API**: `https://your-app.onrender.com`
- **Frontend Web**: `https://your-app.netlify.app`
- **Android App**: Firebase distribution links
- **Database**: PostgreSQL gratis di Render
- **Domain**: `https://klarifikasi.tk` (dari Freenom)

**Total Cost**: **$0 - Completely Free! 🎊**

### **Opsi 2: Indonesian Hosting (Niagahoster)**

#### **Backend Deployment**

1. **Setup Hosting:**
   - Beli hosting PHP di Niagahoster
   - Setup database MySQL di cPanel

2. **Upload Backend:**
   ```bash
   # Upload semua file Laravel ke public_html
   # Configure .env dengan kredensial database
   ```

3. **Environment Configuration:**
   ```env
   APP_ENV=production
   APP_DEBUG=false
   APP_URL=https://klarifikasi.id

   DB_CONNECTION=mysql
   DB_HOST=localhost
   DB_DATABASE=nama_database_anda
   DB_USERNAME=username_db
   DB_PASSWORD=password_db
   ```

#### **Frontend Deployment**

1. **Build Web:**
   ```bash
   flutter build web --release
   ```

2. **Upload ke Subdomain:**
   - Upload folder `build/web/` ke subdomain
   - Configure web server untuk SPA routing

### **Opsi 3: Google Cloud + Firebase (Production)**

#### **Backend (Cloud Run)**

1. **Setup Google Cloud Project**
2. **Deploy Laravel ke Cloud Run:**
   ```bash
   gcloud run deploy --source .
   ```

#### **Frontend (Firebase Hosting)**

1. **Install Firebase CLI:**
   ```bash
   npm install -g firebase-tools
   ```

2. **Deploy Web App:**
   ```bash
   firebase init hosting
   firebase deploy
   ```

#### **Android (Google Play Store)**

1. **Build APK:**
   ```bash
   flutter build apk --release
   ```

2. **Setup Google Play:**
   - Create app di Google Play Console
   - Upload APK dan configure store listing

## 🔧 Configuration

### **API Configuration** (`lib/config.dart`)

```dart
String get apiBaseUrl {
  if (kDebugMode) {
    // Development: Connect ke Laravel backend lokal
    return 'http://localhost:8000';
  }
  // Production: Laravel Cloud backend URL
  return 'https://klarifikasiid-backend-main-ki47jp.laravel.cloud';
}
```

### **Environment Variables**

Backend Laravel harus dikonfigurasi dengan benar:

```env
# Google Custom Search API
GOOGLE_CSE_KEY=your_api_key_here
GOOGLE_CSE_CX=your_cx_id_here

# Gemini AI API
GEMINI_API_KEY=your_gemini_api_key_here

# Database MySQL (Laravel Cloud)
DB_CONNECTION=mysql
DB_HOST=db-a01ccb22-a895-4e6c-83e0-715019c9f1b7.ap-southeast-1.public.db.laravel.cloud
DB_DATABASE=main
DB_USERNAME=vtx2ltv8hbmwy7ag
DB_PASSWORD=aFHjKbQYJP1QTV1RyqNl
```

## 📁 Project Structure

```
lib/
├── config.dart              # API configuration & constants
├── main.dart                # Application entry point
├── app/                     # App structure & navigation
│   ├── app.dart            # Main app widget dengan providers
│   └── home_shell.dart     # Bottom navigation shell
├── models/                  # Data models
│   ├── user.dart           # User model dengan factory
│   ├── search_result.dart  # Search result model
│   ├── gemini_analysis.dart # Gemini AI analysis model
│   └── search_history_entry.dart # History entry model
├── pages/                   # UI Pages
│   ├── search_page.dart    # Main search interface
│   ├── history_page.dart   # Search history dengan pagination
│   ├── login_page.dart     # User login dengan validation
│   ├── register_page.dart  # User registration lengkap
│   └── settings_page.dart  # Profile management
├── providers/               # State Management
│   └── auth_provider.dart  # Authentication state provider
├── services/                # API Services
│   ├── auth_service.dart   # Authentication API calls
│   └── search_api.dart     # Search & history API calls
├── splash/                  # Splash Screen
│   └── splash_gate.dart    # Authentication gate
├── theme/                   # App Theme
│   └── app_theme.dart      # Dark theme dengan gradients
└── widgets/                 # Reusable Widgets
    ├── error_banner.dart   # Error display widget
    ├── loading_button.dart # Loading state button
    ├── loading_widgets.dart # Loading indicators
    ├── gemini_chatbot.dart # Gemini AI chatbot widget
    └── gemini_logo.dart    # Custom Gemini logo widget
```

## 🔗 API Integration

### **Authentication Endpoints**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | User registration | ❌ |
| POST | `/api/auth/login` | User login | ❌ |
| GET | `/api/auth/profile` | Get user profile | ✅ |
| POST | `/api/auth/profile` | Update profile | ✅ |
| POST | `/api/auth/logout` | User logout | ✅ |

### **Search Endpoints**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/search` | Perform fact-checking search with Gemini AI | ❌ |
| GET | `/api/search/{query}` | Search by URL parameter | ❌ |
| GET | `/api/health` | Health check endpoint | ❌ |
| GET | `/api/test-google-cse` | Test Google CSE connection | ❌ |

## 🆕 Changelog v2.0.0

### **🤖 AI Integration**
- ✅ **Google Gemini AI**: Integrasi analisis klaim otomatis
- ✅ **Smart Analysis**: AI memberikan penjelasan dan sumber referensi
- ✅ **Collapsible UI**: Interface AI yang tidak mengganggu browsing
- ✅ **Custom Gemini Logo**: Logo Google Gemini yang authentic

### **🎨 UI/UX Improvements**
- ✅ **Custom Loading Logo**: Logo Klarifikasi.id di loading screen
- ✅ **Enhanced Search UI**: Interface pencarian yang lebih modern
- ✅ **PWA Icons**: Custom favicon dan PWA icons
- ✅ **Responsive Design**: Optimized untuk semua device

### **🔧 Technical Updates**
- ✅ **Database Migration**: PostgreSQL → MySQL Laravel Cloud
- ✅ **API Enhancement**: Search endpoint dengan Gemini analysis
- ✅ **Error Handling**: Improved error management
- ✅ **Performance**: Optimized build dan loading

### **🚀 Deployment Ready**
- ✅ **GitHub Pages**: Automated deployment ready
- ✅ **Laravel Cloud**: Production backend deployed
- ✅ **Version Control**: Git submodules organized
- ✅ **Documentation**: Comprehensive README updates

## 📱 Screenshots

<div align="center">

### **Search Interface with AI**
<img src="https://via.placeholder.com/400x600/1a1a2e/ffffff?text=Search+with+AI" alt="Search with AI" width="300"/>

### **Gemini AI Analysis**
<img src="https://via.placeholder.com/400x600/16213e/ffffff?text=Gemini+Analysis" alt="Gemini Analysis" width="300"/>

### **Custom Loading Screen**
<img src="https://via.placeholder.com/400x600/0f3460/ffffff?text=Loading+Screen" alt="Loading Screen" width="300"/>

</div>

## 🌐 Deployment

### **Web Deployment**

#### **Opsi 1: Netlify (Recommended - FREE)**
```bash
# 1. Build Flutter web untuk production
flutter build web --release

# 2. Deploy ke Netlify:
# - Upload folder build/web/ ke Netlify
# - Configure build settings:
#   Build command: echo "Flutter app ready"
#   Publish directory: build/web
# - Configure redirect rules untuk SPA:
#   /*    /index.html   200
```

#### **Opsi 2: Vercel (FREE)**
```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Deploy
vercel --prod

# 3. Configure environment variables di Vercel dashboard
```

#### **Opsi 3: Indonesian Hosting (Niagahoster/Dewaweb)**
```bash
# 1. Build Flutter web
flutter build web --release

# 2. Upload folder build/web/ ke subdomain
# 3. Configure .htaccess untuk SPA routing:
#   RewriteEngine On
#   RewriteRule ^(.*)$ /index.html [QSA,L]

# 4. Enable HTTPS dan compression
```

### **Android Deployment**

#### **Opsi 1: Google Play Store (Production)**
```bash
# 1. Build APK untuk production
flutter build apk --release

# 2. Build App Bundle (recommended untuk Play Store)
flutter build appbundle --release

# 3. Setup Signing:
# - Generate keystore: keytool -genkey -v -keystore key.jks
# - Configure key.properties dengan keystore credentials
# - Update build.gradle dengan signing config

# 4. Upload ke Google Play Console:
# - Create app listing
# - Upload APK/App Bundle
# - Configure store presence
```

#### **Opsi 2: Firebase App Distribution (Testing)**
```bash
# 1. Install Firebase CLI
npm install -g firebase-tools

# 2. Setup Firebase project
firebase init appdistribution

# 3. Build dan distribute
flutter build apk --release
firebase appdistribution:distribute build/app/outputs/apk/release/app-release.apk \
  --app <your-firebase-app-id> \
  --groups "testers" \
  --release-notes "Initial release"
```

#### **Opsi 3: Direct APK Distribution**
```bash
# Build APK untuk direct distribution
flutter build apk --release

# APK akan tersedia di:
# build/app/outputs/apk/release/app-release.apk

# Share APK untuk testing atau sideload
```

## 📊 Deployment Checklist

### **✅ Pre-Deployment - FULLY COMPLETED**
- [x] **Environment Configuration**: Production URLs dan Laravel Cloud configured
- [x] **API Keys**: Google CSE API keys dengan konfigurasi lengkap
- [x] **Database**: PostgreSQL (Neon) database dengan SSL encryption
- [x] **SSL Certificate**: HTTPS ready dengan Laravel Cloud SSL
- [x] **CORS Configuration**: Multi-origin support untuk production
- [x] **Testing**: All features tested dan berfungsi dengan production backend

### **✅ Web Deployment - PRODUCTION READY**
- [x] **Build Assets**: `flutter build web --release` ✅ **FULLY COMPLETED**
- [x] **Static Hosting**: Ready untuk Netlify dengan optimized assets
- [x] **SPA Routing**: Configuration lengkap untuk single-page application
- [x] **CDN Optimization**: Tree-shaking dan font optimization aktif
- [x] **Environment Variables**: Production API URLs configured
- [x] **Deployment Folder**: `Klarifikasi.id Deployment\` ✅ **UPDATED**

### **✅ Android Deployment - PRODUCTION READY**
- [x] **Build APK**: `flutter build apk --release` ✅ **OPTIMIZED (47.1MB)**
- [x] **Native Performance**: Android-optimized build dengan native code
- [x] **App Signing**: Ready untuk production signing configuration
- [x] **Play Store**: Ready untuk Google Play Store submission
- [x] **Firebase Distribution**: Ready untuk beta testing dan distribution
- [x] **Release Build**: Production-ready APK dengan proguard optimization

### **✅ Backend Deployment - FULLY OPERATIONAL**
- [x] **Laravel Cloud**: ✅ **Deployed dan running di production**
- [x] **Database PostgreSQL**: ✅ **Neon Cloud dengan SSL encryption**
- [x] **Environment Variables**: ✅ **Production environment fully configured**
- [x] **SSL/HTTPS**: ✅ **Laravel Cloud SSL certificate aktif**
- [x] **API Endpoints**: ✅ **All routes tested dan berfungsi**
- [x] **Google CSE Integration**: ✅ **API keys configured dan verified**
- [x] **CORS Policy**: ✅ **Multi-origin support untuk Flutter web**
- [x] **Health Monitoring**: ✅ **Health check endpoints available**
- [x] **Error Tracking**: ✅ **Production-ready logging dan error handling**

## 🎯 Build Status

### **✅ Web Build - PRODUCTION READY**
```
Build Location: Klarifikasi.id Deployment/
Files Generated:
- index.html (main app file)
- main.dart.js (compiled JavaScript - optimized)
- flutter.js (Flutter engine)
- assets/ (images, fonts, icons - tree-shaken)
- manifest.json (PWA configuration)
- flutter_service_worker.js (caching)

Optimizations Applied:
- Font tree-shaking: 99.3% size reduction
- Asset optimization aktif
- JavaScript minification
- PWA service worker enabled

Size: Production optimized
Status: ✅ Ready untuk Netlify deployment
```

### **✅ Android Build - PRODUCTION READY**
```
Build Location: Klarifikasi.id Frontend/build/app/outputs/apk/release/
APK File: app-release.apk (47.1MB)
Features:
- Native Android performance dengan ARM optimization
- Flutter engine embedded untuk offline capability
- All features included (auth, search, history)
- Production security hardening
- ProGuard code obfuscation ready

Status: ✅ Ready untuk Google Play Store atau Firebase Distribution
```

### **✅ Backend Status - FULLY OPERATIONAL**
```
🌐 Laravel Cloud Deployment:
- URL: https://klarifikasiid-backend-main-ki47jp.laravel.cloud
- Status: ✅ Deployed dan running
- SSL: ✅ Laravel Cloud SSL certificate aktif
- Environment: ✅ Production mode

🗄️ Database PostgreSQL (Neon):
- Provider: Neon Cloud (100% Free)
- Connection: ✅ SSL encrypted connection
- Location: Asia Southeast (Singapore)
- Status: ✅ Production ready dengan data persistence

🔍 Google CSE Integration:
- API Key: ✅ Configured dan verified
- Search Engine ID: ✅ Active dan functional
- SSL Verification: ✅ Disabled untuk development
- Rate Limiting: ✅ 10 requests/minute protection

🔐 Authentication & Security:
- Laravel Sanctum: ✅ Token-based authentication
- CORS Policy: ✅ Multi-origin support configured
- Session Management: ✅ Database-driven sessions
- Error Handling: ✅ Production-ready logging

📊 API Endpoints Status:
- POST /api/search: ✅ Active dengan Google CSE
- GET /api/health: ✅ Health check available
- Authentication routes: ✅ All endpoints functional
- History management: ✅ CRUD operations ready

Status: ✅ FULLY PRODUCTION READY
```

## 🧪 Testing

### **Unit Tests**
```bash
# Jalankan semua tests
flutter test

# Jalankan test spesifik
flutter test test/widget_test.dart

# Test dengan coverage
flutter test --coverage
```

### **Integration Tests**
```bash
# Test integrasi dengan backend
flutter test integration_test/

# Test API endpoints
flutter test test/api_test.dart
```

## 🔧 Development

### **Code Quality**
```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Fix linting issues
flutter fix --dry-run
```

### **Build & Run**
```bash
# Clean build cache
flutter clean

# Get dependencies
flutter pub get

# Run di Web
flutter run -d chrome --web-port 3001

# Run di Android
flutter run -d <device-id>
```

## 🤝 Contributing

Kami sangat welcome kontribusi dari komunitas!

### **Cara Kontribusi:**

1. **Fork** repository
2. **Create feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push branch**: `git push origin feature/amazing-feature`
5. **Open Pull Request**

### **Development Guidelines:**

- **Code Style**: Ikuti Effective Dart guidelines
- **Testing**: Tulis tests untuk fitur baru
- **Documentation**: Update README untuk perubahan API
- **Review**: Semua PR perlu review sebelum merge

### **Issue Reporting:**
- Gunakan template issue yang disediakan
- Sertakan steps untuk reproduce bug
- Tambahkan screenshots jika relevan
- Tag dengan label yang sesuai

## 📝 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

## 👥 Authors & Contributors

- **Elloe** - *Project Creator & Maintainer*
- **Community Contributors** - *All contributors welcome!*

## 🙏 Acknowledgments

- **Google Custom Search API** - Untuk search functionality
- **Google Gemini AI** - Untuk analisis klaim otomatis
- **Laravel Community** - Excellent documentation dan packages
- **Flutter Team** - Amazing cross-platform framework
- **Spotify Design System** - Inspiration untuk UI/UX design
- **Indonesian Developer Community** - Support dan inspiration

## 📞 Support & Contact

### **Issues & Bugs**
- GitHub Issues: [Report Bug](https://github.com/Elloe2/Klarifikasi.id-frontend/issues)
- Feature Requests: [Request Feature](https://github.com/Elloe2/Klarifikasi.id-frontend/issues)

### **Documentation**
- **API Documentation**: Lihat backend Laravel untuk API docs
- **Deployment Guide**: See deployment section above
- **Development Guide**: Contributing guidelines above

### **Community**
- **Discussions**: GitHub Discussions untuk Q&A
- **Email**: Contact maintainer untuk partnerships

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

[![GitHub stars](https://img.shields.io/github/stars/Elloe2/Klarifikasi.id-frontend.svg?style=social&label=Star)](https://github.com/Elloe2/Klarifikasi.id-frontend)
[![GitHub forks](https://img.shields.io/github/forks/Elloe2/Klarifikasi.id-frontend.svg?style=social&label=Fork)](https://github.com/Elloe2/Klarifikasi.id-frontend/fork)

**Made with ❤️ for the Indonesian fact-checking community**

</div>
