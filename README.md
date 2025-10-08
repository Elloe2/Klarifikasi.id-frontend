# 🌟 Klarifikasi.id (Flutter Frontend)

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-blue.svg)](https://dart.dev)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Android-green.svg)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Aplikasi Fact-Checking Modern** untuk memverifikasi kebenaran informasi melalui pencarian di portal berita terpercaya menggunakan Google Custom Search Engine dengan backend Laravel.

<p align="center">
  <img src="https://via.placeholder.com/800x400/1a1a2e/ffffff?text=Klarifikasi.id+Flutter+App" alt="Klarifikasi.id Screenshot" width="800"/>
</p>

## ✨ Fitur Unggulan

### 🔍 **Smart Fact-Checking**
- **Real-time Search**: Pencarian informasi dengan Google Custom Search Engine
- **Trusted Sources**: Integrasi dengan portal berita kredibel Indonesia
- **Search History**: Riwayat pencarian dengan pagination dan metadata
- **Rate Limiting**: Pembatasan pencarian untuk mencegah spam

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

### 📱 **Multi-Platform**
- **Flutter Web**: Aplikasi web modern dengan performa tinggi
- **Android App**: Native Android application dengan APK build
- **Cross-Platform**: Satu codebase untuk semua platform
- **Progressive Web App**: PWA-ready dengan service worker

## 🏗️ Arsitektur Aplikasi

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Flutter       │    │     Laravel      │    │     MySQL       │
│   Frontend      │◄──►│     Backend      │◄──►│    Database     │
│                 │    │                  │    │                 │
│ • Web & Android │    │ • REST API       │    │ • Users         │
│ • Provider      │    │ • Sanctum Token  │    │ • Search History│
│ • Secure Storage│    │ • Google CSE     │    │ • Access Tokens │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🛠️ Tech Stack

### **Frontend (Flutter)**
- **Framework**: Flutter 3.35.3 🚀
- **Language**: Dart 3.9.2 ⚡
- **State Management**: Provider Pattern 📱
- **HTTP Client**: Dio dengan retry logic 🔄
- **Storage**: Flutter Secure Storage 🔐
- **UI Framework**: Material 3 dengan custom theming 🎨

### **Backend Integration**
- **API Communication**: RESTful API dengan Laravel backend
- **Authentication**: Token-based dengan Laravel Sanctum
- **Search Engine**: Google Custom Search Engine integration
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

## 🚀 Quick Start

### **1. Clone Repository**

```bash
# Clone frontend repository
git clone https://github.com/Elloe2/Klarifikasi.id-frontend.git
cd Klarifikasi.id-frontend

# Pastikan backend Laravel sudah tersedia
# di folder ../Klarifikasi.id-backend/
```

### **2. Install Dependencies**

```bash
# Install Flutter dependencies
flutter pub get

# Upgrade jika diperlukan
flutter pub upgrade
```

### **3. Konfigurasi Backend**

Pastikan backend Laravel sudah running:

```bash
# Di terminal terpisah, jalankan backend
cd ../Klarifikasi.id-backend
php artisan serve --host=0.0.0.0 --port=8000
```

### **4. Run Flutter Application**

#### **Development Mode**

```bash
# Jalankan di Web (Chrome)
flutter run -d chrome --web-port 3000

# Jalankan di Android Emulator
flutter run -d emulator-5554

# Jalankan di Android Device (USB Debugging)
flutter run -d <device-id>
```

#### **Build untuk Production**

```bash
# Build untuk Web
flutter build web --release

# Build untuk Android APK
flutter build apk --release

# Build untuk Android App Bundle (Play Store)
flutter build appbundle --release
```

## 🔧 Configuration

### **API Configuration** (`lib/config.dart`)

```dart
String get apiBaseUrl {
  if (kDebugMode) {
    // Development: Connect ke Laravel backend lokal
    return 'http://localhost:8000';
  }
  // Production: Ganti dengan domain production
  return 'https://api.klarifikasi.id';
}
```

### **Environment Variables**

Backend Laravel harus dikonfigurasi dengan benar:

```env
# Google Custom Search API
GOOGLE_CSE_KEY=your_api_key_here
GOOGLE_CSE_CX=your_cx_id_here

# Database MySQL
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_DATABASE=klarifikasi_id
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
    └── loading_widgets.dart # Loading indicators
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
| POST | `/api/search` | Perform fact-checking search | ✅ |
| GET | `/api/history` | Get search history | ✅ |
| DELETE | `/api/history` | Clear search history | ✅ |

## 📱 Screenshots

<div align="center">

### **Search Interface**
<img src="https://via.placeholder.com/400x600/1a1a2e/ffffff?text=Search+Page" alt="Search Page" width="300"/>

### **Results Display**
<img src="https://via.placeholder.com/400x600/16213e/ffffff?text=Results" alt="Results" width="300"/>

### **Profile Settings**
<img src="https://via.placeholder.com/400x600/0f3460/ffffff?text=Settings" alt="Settings" width="300"/>

</div>

## 🌐 Deployment

### **Web Deployment**

**Netlify/Vercel (Recommended):**
```bash
# Build Flutter web
flutter build web --release

# Deploy folder build/web/ ke Netlify
# Configure SPA redirect rules untuk deep links
```

**Traditional Hosting:**
```bash
# Upload build/web/ contents
# Configure server untuk SPA routing
# Enable HTTPS dan compression
```

### **Android Deployment**

**Google Play Store:**
```bash
# Build APK untuk testing
flutter build apk --release

# Build App Bundle untuk production
flutter build appbundle --release

# Sign APK dengan keystore
# Upload ke Google Play Console
```

**Firebase App Distribution:**
```bash
# Build dan distribute untuk internal testing
flutter build apk --release
firebase appdistribution:distribute build/app/outputs/apk/release/app-release.apk \
  --app <your-firebase-app-id> \
  --groups "testers"
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
- **Laravel Community** - Excellent documentation dan packages
- **Flutter Team** - Amazing cross-platform framework
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
