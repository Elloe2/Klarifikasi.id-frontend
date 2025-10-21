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



## 📁 Project Structure

### **🎯 Frontend Architecture (Flutter)**

```
Klarifikasi.id Frontend/
├── 📱 lib/                                    # Main application code
│   ├── 🎯 app/                               # Application structure & navigation
│   │   ├── app.dart                          # Main app widget dengan providers
│   │   └── home_shell.dart                  # Bottom navigation shell
│   ├── 📊 models/                           # Data models & serialization
│   │   ├── user.dart                        # User model dengan factory methods
│   │   ├── search_result.dart               # Search result model
│   │   ├── gemini_analysis.dart             # Gemini AI analysis model
│   │   └── search_history_entry.dart        # History entry model
│   ├── 📱 pages/                            # UI Pages & screens
│   │   ├── search_page.dart                 # Main search interface dengan Gemini AI
│   │   ├── login_page.dart                  # User authentication
│   │   ├── register_page.dart               # User registration
│   │   └── settings_page.dart               # Profile management
│   ├── 🔄 providers/                        # State management
│   │   └── auth_provider.dart               # Authentication state provider
│   ├── 🌐 services/                         # API services & HTTP clients
│   │   ├── auth_service.dart                # Authentication API calls
│   │   └── search_api.dart                  # Search & Gemini AI API calls
│   ├── 🎨 theme/                            # App theming & styling
│   │   └── app_theme.dart                   # Dark theme dengan gradients
│   ├── 🧩 widgets/                          # Reusable UI components
│   │   ├── gemini_chatbot.dart              # Gemini AI chatbot widget
│   │   ├── gemini_logo.dart                 # Custom Gemini logo widget
│   │   ├── loading_widgets.dart             # Loading animations
│   │   ├── error_banner.dart                # Error handling UI
│   │   └── loading_button.dart              # Loading state button
│   ├── 🚀 splash/                           # Splash screen & initialization
│   │   └── splash_gate.dart                 # Authentication gate
│   ├── ⚙️ config.dart                       # API configuration & constants
│   └── 🎬 main.dart                         # Application entry point
├── 📦 pubspec.yaml                          # Dependencies & metadata (v2.0.0)
├── 🎨 assets/                               # Static assets
│   ├── images/                             # App images & logos
│   │   └── logo/                           # Klarifikasi.id logos
│   └── fonts/                              # Custom fonts (SpotifyMix)
├── 🧪 test/                                # Unit & widget tests
├── 📱 android/                             # Android-specific configuration
├── 🌐 web/                                 # Web-specific configuration
│   ├── index.html                          # Main HTML file
│   ├── manifest.json                       # PWA manifest
│   └── favicon.png                         # Custom favicon
└── 📋 README.md                            # Frontend documentation
```

### **🔗 API Integration Architecture**

```
Frontend ↔ Backend Communication Flow:
├── 🔐 Authentication Layer
│   ├── Token Management                     # Laravel Sanctum tokens
│   ├── Secure Storage                       # Flutter Secure Storage
│   ├── Auto-refresh                         # Token renewal mechanism
│   └── Session Persistence                 # Cross-app sessions
├── 🔍 Search & AI Layer
│   ├── Real-time Search                     # Google CSE integration
│   ├── Gemini AI Analysis                   # AI-powered fact-checking
│   ├── Response Parsing                      # JSON data processing
│   └── Error Handling                       # Comprehensive error management
├── 📊 Data Flow
│   ├── Request Validation                   # Input sanitization
│   ├── Response Caching                     # Performance optimization
│   ├── State Management                     # Provider pattern
│   └── UI Updates                          # Reactive UI updates
└── 🛡️ Security Layer
    ├── HTTPS Communication                  # Encrypted data transmission
    ├── CORS Configuration                   # Cross-origin security
    ├── Rate Limiting                        # API protection
    └── Input Validation                     # XSS & injection prevention
```

### **🎨 UI/UX Architecture**

```
User Interface Layers:
├── 🎯 Presentation Layer
│   ├── Material 3 Design                   # Modern Material Design
│   ├── Dark Theme                          # Spotify-inspired dark theme
│   ├── Custom Branding                     # Klarifikasi.id visual identity
│   └── Responsive Design                   # Multi-device compatibility
├── 🧩 Component Layer
│   ├── Reusable Widgets                    # Modular UI components
│   ├── Custom Animations                   # Smooth loading states
│   ├── Error Handling UI                   # User-friendly error messages
│   └── Loading States                      # Visual feedback systems
├── 📱 Navigation Layer
│   ├── Bottom Navigation                    # Main app navigation
│   ├── Route Management                     # Page routing system
│   ├── Deep Linking                         # URL-based navigation
│   └── State Persistence                   # Navigation state preservation
└── 🎨 Theming Layer
    ├── Color Schemes                        # Consistent color palette
    ├── Typography                           # SpotifyMix font family
    ├── Spacing System                       # Consistent spacing
    └── Icon System                          # Custom iconography
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


---

<div align="center">

**⭐ Star this repository if you find it helpful!**

[![GitHub stars](https://img.shields.io/github/stars/Elloe2/Klarifikasi.id-frontend.svg?style=social&label=Star)](https://github.com/Elloe2/Klarifikasi.id-frontend)
[![GitHub forks](https://img.shields.io/github/forks/Elloe2/Klarifikasi.id-frontend.svg?style=social&label=Fork)](https://github.com/Elloe2/Klarifikasi.id-frontend/fork)

**Made with ❤️ for the Indonesian fact-checking community**

</div>
