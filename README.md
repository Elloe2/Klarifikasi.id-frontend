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
