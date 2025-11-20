# 🌟 Klarifikasi.id v2.0.0

[![Flutter](https://img.shields.io/badge/Flutter-3.35.3-blue.svg)](https://flutter.dev)
[![Laravel](https://img.shields.io/badge/Laravel-12.32.5-red.svg)](https://laravel.com)
[![PHP](https://img.shields.io/badge/PHP-8.2+-purple.svg)](https://php.net)
[![MySQL](https://img.shields.io/badge/MySQL-8.0+-orange.svg)](https://mysql.com)
[![Gemini AI](https://img.shields.io/badge/Gemini-AI%20Powered-green.svg)](https://ai.google.dev)
[![Version](https://img.shields.io/badge/Version-2.0.0-green.svg)](https://github.com/Elloe2/Klarifikasi.id)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **Aplikasi fact-checking modern dengan AI Gemini** yang dibangun dengan Flutter frontend dan Laravel backend untuk membantu pengguna memverifikasi kebenaran informasi dan klaim secara real-time menggunakan teknologi AI terdepan.

<p align="center">
  <img src="https://via.placeholder.com/800x400/1a1a2e/ffffff?text=Klarifikasi.id+Dashboard" alt="Klarifikasi.id Screenshot" width="800"/>
</p>

## 📝 Ringkasan Singkat

- **Apa ini?** Aplikasi fact-checking berbasis web & Android untuk menganalisis klaim dengan bantuan Google Gemini AI dan Google Custom Search.
- **Tech stack utama:** Flutter 3.35.3 (frontend), Laravel 12.32.5 + MySQL (backend), Google Gemini 2.0-flash, Google CSE.
- **Backend produksi:** `https://klarifikasiid-backend-production.up.railway.app` (Railway + MySQL).
- **Frontend produksi:**
  - Cloudhebat: `https://www.klarifikasi.rj22d.my.id/`
  - GitHub Pages: `https://elloe2.github.io/Klarifikasi.id/`

**Cara jalanin frontend lokal (web):**

1. Pastikan file `.env` di folder frontend berisi:
   - `API_BASE_URL=https://klarifikasiid-backend-production.up.railway.app`
2. Jalankan perintah berikut:

   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome --web-port 8000
   ```

**Build untuk produksi (web):**

```bash
flutter build web --release
```

Output akan tersimpan di `build/web` dan bisa di-copy ke hosting (misalnya `Klarifikasi.id Deployment` untuk GitHub Pages / Cloudhebat).

---

## ✨ Fitur Unggulan

### 🤖 **AI-Powered Fact-Checking**
- **Gemini AI Integration**: Google Gemini AI untuk analisis klaim cerdas
- **Real-time Search**: Pencarian informasi dengan Google Custom Search Engine
- **Smart Analysis**: AI memberikan penjelasan dan sumber terpercaya
- **Collapsible UI**: Gemini chatbot dengan ExpansionTile untuk UX yang lebih baik

### 🔍 **Advanced Search System**
- **Google CSE**: Integrasi dengan Google Custom Search Engine
- **Rich Results**: Preview hasil pencarian dengan thumbnail dan snippet
- **Rate Limiting**: Pembatasan pencarian untuk mencegah spam
- **Custom Logos**: Logo Klarifikasi.id untuk branding yang konsisten

### 👤 **User Management System**
- **Secure Authentication**: Token-based auth dengan Laravel Sanctum
- **Profile Management**: Update profil dengan data pendidikan dan institusi
- **Password Security**: Password hashing dengan bcrypt
- **Session Management**: Automatic token refresh dan cleanup

### 🎨 **Modern UI/UX**
- **Spotify-Inspired Design**: Dark theme dengan SpotifyMix font family
- **Responsive Design**: Optimized untuk desktop, tablet, dan mobile
- **Custom Branding**: Logo Klarifikasi.id untuk favicon dan PWA icons
- **Loading Animations**: Smooth loading states dengan custom animations
- **Error Handling**: Comprehensive error dialogs dan feedback

### 📱 **Multi-Platform Support**
- **Flutter Web**: Aplikasi web modern dengan performa tinggi
- **Android App**: Native Android application dengan APK build
- **PWA Ready**: Progressive Web App dengan service worker
- **Cross-Platform**: Satu codebase untuk semua platform

### 🚀 **Production Ready**
- **MySQL Database**: Robust relational database dengan migrations
- **SSL Support**: HTTPS-ready dengan security headers
- **Automated Deployment**: GitHub Pages dengan PowerShell script
- **Error Monitoring**: Comprehensive logging dan error tracking
- **Scalable Architecture**: Clean code structure untuk easy maintenance

## 📋 Changelog

### **v2.0.0** - Major Update (Current)
- ✨ **Gemini AI Integration**: Added Google Gemini AI for intelligent fact-checking
- 🎨 **Custom Gemini Logo**: Authentic Google Gemini branding with diamond shape
- 🔄 **Collapsible UI**: Gemini chatbot now uses ExpansionTile for better UX
- 🗑️ **Simplified Analysis**: Removed HOAX/FAKTA system, focus on explanations
- 🎯 **Enhanced UX**: Better loading states and error handling
- 🚀 **Performance**: Optimized API calls and response handling

### **v1.0.0** - Initial Release
- 🎉 **Core Features**: Search, authentication, and basic fact-checking
- 🔐 **Security**: Laravel Sanctum authentication
- 📱 **Responsive**: Mobile-first design with Flutter
- 🎨 **Modern UI**: Spotify-inspired dark theme

## 🌐 Production URLs

- **Frontend (Cloudhebat)**: https://www.klarifikasi.rj22d.my.id/
- **Frontend (GitHub Pages)**: https://elloe2.github.io/Klarifikasi.id/
- **Backend (Railway)**: https://klarifikasiid-backend-production.up.railway.app/
- **GitHub Repository**: https://github.com/Elloe2/Klarifikasi.id

## 🏗️ Arsitektur Aplikasi

### **📐 System Architecture Overview**

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                    🌐 USER LAYER                                │
├─────────────────────────────────────────────────────────────────────────────────┤
│  📱 Flutter Web App          │  📱 Flutter Android App    │  🌐 PWA Browser     │
│  • Chrome/Safari/Firefox     │  • Native Android APK     │  • Service Worker   │
│  • Responsive Design         │  • Offline Capability     │  • Push Notifications│
│  • PWA Features              │  • Material Design        │  • App-like Experience│
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                🎨 PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🎯 Flutter Frontend (Multi-Platform)                                           │
│  ├── 📱 Pages Layer                                                             │
│  │   ├── search_page.dart          # Main search interface with Gemini AI     │
│  │   ├── login_page.dart           # User authentication                       │
│  │   ├── register_page.dart        # User registration                         │
│  │   └── settings_page.dart        # Profile management                       │
│  ├── 🧩 Widgets Layer                                                          │
│  │   ├── gemini_chatbot.dart       # AI analysis display widget               │
│  │   ├── gemini_logo.dart          # Custom Gemini logo widget                │
│  │   ├── loading_widgets.dart      # Loading animations                       │
│  │   └── error_banner.dart         # Error handling UI                        │
│  ├── 🔄 State Management                                                       │
│  │   └── auth_provider.dart        # Authentication state provider            │
│  └── 🌐 Services Layer                                                         │
│      ├── auth_service.dart         # Authentication API calls                 │
│      └── search_api.dart           # Search & Gemini AI API calls             │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                🔗 API GATEWAY LAYER                            │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🌐 HTTP/REST API Communication                                                 │
│  ├── 🔐 Authentication Headers     # Bearer Token (Laravel Sanctum)           │
│  ├── 📡 Request/Response Format    # JSON with proper error handling           │
│  ├── ⚡ Rate Limiting              # 10 requests/minute protection             │
│  ├── 🌍 CORS Configuration         # Multi-origin support                      │
│  └── 🔒 SSL/TLS Encryption         # HTTPS security                            │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                ⚙️ BUSINESS LOGIC LAYER                          │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🚀 Laravel Backend (API-First Architecture)                                    │
│  ├── 🎯 Controllers Layer                                                       │
│  │   ├── AuthController.php        # User authentication & profile management  │
│  │   └── SearchController.php      # Fact-checking & Gemini AI integration     │
│  ├── 🔧 Services Layer                                                         │
│  │   ├── GoogleSearchService.php   # Google Custom Search Engine integration   │
│  │   └── GeminiService.php         # Google Gemini AI integration              │
│  ├── 📊 Models Layer                                                            │
│  │   └── User.php                  # User model with Sanctum tokens           │
│  ├── 🛡️ Middleware Layer                                                       │
│  │   ├── auth:sanctum              # Token-based authentication               │
│  │   ├── throttle                 # Rate limiting protection                  │
│  │   └── cors                     # Cross-origin resource sharing            │
│  └── 🛣️ Routes Layer                                                           │
│      └── api.php                   # RESTful API endpoints                    │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                🤖 AI SERVICES LAYER                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🧠 Google Gemini AI Service                                                    │
│  ├── 🔍 Model: gemini-2.0-flash    # Latest Gemini model for analysis         │
│  ├── 📝 Prompt Engineering         # Structured prompts for fact-checking     │
│  ├── 🔄 Response Parsing           # JSON extraction & error handling          │
│  ├── ⚡ Safety Settings            # Content filtering & safety measures       │
│  └── 🎯 Analysis Output            # Explanation & sources (no verdict)        │
│                                                                                 │
│  🔍 Google Custom Search Engine                                                 │
│  ├── 🌐 Search API                # Real-time web search                       │
│  ├── 📊 Result Processing         # Thumbnail & snippet extraction             │
│  ├── 🎯 Query Optimization        # Search term refinement                     │
│  └── 📈 Rate Limiting             # API quota management                       │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                💾 DATA PERSISTENCE LAYER                        │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🗄️ MySQL Database (Railway)                                                   │
│  ├── 👤 Users Table                                                             │
│  │   ├── id (Primary Key)          # Unique user identifier                    │
│  │   ├── name, email, password      # Basic user information                    │
│  │   ├── birth_date                # Optional demographic data                 │
│  │   ├── education_level           # User education background                 │
│  │   └── institution               # School/university information             │
│  ├── 🔐 Personal Access Tokens Table                                           │
│  │   ├── tokenable_type, tokenable_id  # Polymorphic relationship to users     │
│  │   ├── name, token               # Token identification & value              │
│  │   ├── abilities                # Token permissions                          │
│  │   └── last_used_at, expires_at  # Token lifecycle management               │
│  ├── 📊 Sessions Table                                                         │
│  │   ├── id (Primary Key)          # Session identifier                        │
│  │   ├── user_id                   # Associated user (nullable)                │
│  │   ├── ip_address, user_agent    # Security tracking                         │
│  │   └── payload, last_activity    # Session data & activity tracking          │
│  └── 🔒 Security Features                                                      │
│      ├── SSL Encryption            # Secure data transmission                  │
│      ├── Password Hashing          # bcrypt encryption                          │
│      └── Token Expiration          # Automatic security cleanup                │
└─────────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                                🚀 DEPLOYMENT LAYER                             │
├─────────────────────────────────────────────────────────────────────────────────┤
│  🌐 Production Infrastructure                                                   │
│  ├── 📱 Frontend Deployment                                                     │
│  │   ├── GitHub Pages            # Automated deployment via PowerShell          │
│  │   ├── Cloudhebat Hosting      # Static hosting with SPA routing             │
│  │   └── PWA Configuration       # Service worker & manifest                  │
│  ├── ⚙️ Backend Deployment                                                      │
│  │   ├── Railway                # Managed Laravel hosting                      │
│  │   ├── Auto-scaling           # Automatic resource management                │
│  │   └── SSL Certificates       # Automatic HTTPS configuration               │
│  ├── 🗄️ Database Hosting                                                       │
│  │   ├── Railway MySQL          # Managed MySQL database                       │
│  │   ├── Automated Backups       # Data protection & recovery                 │
│  │   └── Connection Pooling      # Optimized database connections             │
│  └── 🔧 DevOps & Monitoring                                                    │
│      ├── Health Check Endpoints   # System monitoring                          │
│      ├── Error Logging           # Comprehensive error tracking               │
│      └── Performance Metrics     # Application performance monitoring          │
└─────────────────────────────────────────────────────────────────────────────────┘
```

### **🔄 Data Flow Architecture**

```
1. 📱 USER INTERACTION
   User enters search query → Flutter UI captures input

2. 🔐 AUTHENTICATION CHECK
   Check for valid token → Optional authentication for enhanced features

3. 📡 API REQUEST
   Flutter → HTTP POST → Laravel Backend (/api/search)

4. 🛡️ MIDDLEWARE PROCESSING
   Rate limiting → CORS → Authentication (optional)

5. 🎯 CONTROLLER LOGIC
   SearchController → Validate input → Call services

6. 🔍 PARALLEL PROCESSING
   ├── GoogleSearchService → Google CSE API → Web search results
   └── GeminiService → Gemini AI API → Claim analysis

7. 📊 DATA AGGREGATION
   Combine search results + AI analysis → Structured response

8. 📱 RESPONSE DELIVERY
   JSON response → Flutter UI → Display results + AI analysis

9. 💾 OPTIONAL PERSISTENCE
   Save search history (if authenticated) → Database storage
```

## 📁 Project Structure

### **🎯 Frontend Structure (Flutter)**

```
Klarifikasi.id Frontend/
├── 📱 lib/                                    # Main application code
│   ├── 🎯 app/                               # Application structure
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
├── 📦 pubspec.yaml                          # Dependencies & metadata
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

### **⚙️ Backend Structure (Laravel)**

```
Klarifikasi.id-backend/
├── 🎯 app/                                 # Application core
│   ├── 🎮 Http/Controllers/                # API controllers
│   │   ├── AuthController.php              # User authentication & profile
│   │   ├── SearchController.php            # Fact-checking & Gemini AI
│   │   └── Controller.php                  # Base controller
│   ├── 📊 Models/                          # Eloquent models
│   │   └── User.php                        # User model dengan Sanctum
│   ├── 🔧 Services/                        # Business logic services
│   │   ├── GoogleSearchService.php         # Google CSE integration
│   │   └── GeminiService.php              # Gemini AI integration
│   ├── 🛡️ Providers/                      # Service providers
│   │   └── AppServiceProvider.php          # Service container bindings
│   └── 🚀 Console/                        # Artisan commands
├── 🌐 api/                                 # Serverless API endpoints
│   ├── index.php                           # Root API router
│   ├── auth.php                            # Authentication endpoints
│   ├── search.php                          # Search endpoints
│   ├── _init.php                           # Serverless initialization
│   └── _env.php                            # Environment configuration
├── ⚙️ config/                             # Configuration files
│   ├── app.php                             # Application configuration
│   ├── auth.php                            # Authentication config
│   ├── database.php                        # Database configuration
│   ├── services.php                        # Third-party services
│   └── cors.php                            # CORS configuration
├── 🗄️ database/                           # Database management
│   ├── migrations/                         # Database migrations
│   │   ├── create_users_table.php          # Users table
│   │   ├── create_personal_access_tokens_table.php  # Sanctum tokens
│   │   └── create_cache_table.php          # Cache table
│   ├── factories/                          # Model factories
│   │   └── UserFactory.php                 # User factory
│   └── seeders/                            # Database seeders
│       ├── DatabaseSeeder.php              # Main seeder
│       └── UserSeeder.php                  # User seeder
├── 🛣️ routes/                             # Route definitions
│   ├── api.php                             # API routes
│   ├── web.php                             # Web routes
│   └── console.php                         # Console routes
├── 🚀 bootstrap/                           # Application bootstrap
│   ├── app.php                             # Application bootstrap
│   ├── serverless.php                      # Serverless bootstrap
│   └── providers.php                       # Service providers
├── 📦 composer.json                        # PHP dependencies
├── 📋 README.md                            # Backend documentation
└── 🔧 artisan                              # Laravel command line tool
```

### **🌐 Deployment Structure**

```
Klarifikasi.id Deployment/                 # Production build output
├── 📄 index.html                           # Main application file
├── 📄 main.dart.js                         # Compiled Flutter JavaScript
├── 📄 flutter.js                           # Flutter engine
├── 📄 flutter_service_worker.js            # PWA service worker
├── 📄 manifest.json                        # PWA manifest
├── 📄 favicon.png                          # Custom favicon
├── 📄 version.json                          # Version tracking
├── 📁 assets/                               # Optimized assets
│   ├── images/                             # Compressed images
│   ├── fonts/                              # Tree-shaken fonts
│   └── icons/                              # PWA icons
└── 📋 README.md                            # Deployment documentation
```

### **🔗 Integration Points**

```
Frontend ↔ Backend Communication:
├── 🔐 Authentication Flow
│   ├── POST /api/auth/register             # User registration
│   ├── POST /api/auth/login                # User login
│   ├── GET /api/auth/profile               # Get user profile
│   └── POST /api/auth/logout               # User logout
├── 🔍 Search Flow
│   ├── POST /api/search                    # Fact-checking search
│   ├── GET /api/search/{query}             # Search by URL parameter
│   └── GET /api/health                     # Health check
└── 🤖 AI Integration
    ├── Gemini AI Analysis                  # Real-time claim analysis
    ├── Google CSE Results                  # Web search results
    └── Combined Response                   # Structured JSON response
```

## 🛠️ Tech Stack

### **Frontend (Flutter)**
- **Framework**: Flutter 3.35.3 🚀
- **State Management**: Provider Pattern 📱
- **HTTP Client**: http package dengan timeout & retry (custom) 🔄
- **Storage**: Flutter Secure Storage 🔐
- **UI Framework**: Material 3 dengan Spotify-inspired theming 🎨
- **Custom Fonts**: SpotifyMix font family 🎵
- **AI Integration**: Gemini AI chatbot widget 🤖

### **Backend (Laravel)**
- **Framework**: Laravel 12.32.5 ⚡
- **Authentication**: Laravel Sanctum 🛡️
- **Database**: MySQL 8.0+ 🗄️
- **Search Engine**: Google Custom Search Engine 🔍
- **AI Service**: Google Gemini AI integration 🤖
- **Caching**: Redis/Memcached 📋

### **Development Tools**
- **Version Control**: Git & GitHub
- **Code Quality**: PHPStan, ESLint
- **Testing**: PHPUnit, Flutter Test
- **Deployment**: Docker, CI/CD Ready

## 📋 Prerequisites

Sebelum memulai, pastikan Anda memiliki:

- **Flutter SDK** (3.9.2+) - [Download](https://flutter.dev/docs/get-started/install)
- **PHP** (8.2+) - [Download](https://php.net/downloads.php)
- **Composer** - [Download](https://getcomposer.org/download/)
- **MySQL** (8.0+) - [Download](https://dev.mysql.com/downloads/mysql/)
- **Google Custom Search API Key** - [Get Key](https://console.cloud.google.com/)



## 🔗 API Endpoints

### **Authentication Routes**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | User registration | ❌ |
| POST | `/api/auth/login` | User login | ❌ |
| GET | `/api/auth/profile` | Get user profile | ✅ |
| POST | `/api/auth/profile` | Update profile | ✅ |
| POST | `/api/auth/logout` | User logout | ✅ |

### **Search Routes**
| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/search` | Perform fact-checking search with Gemini AI | ❌ |
| GET | `/api/health` | Health check endpoint | ❌ |
| GET | `/api/test-google-cse` | Test Google CSE connection | ❌ |



## 📊 Database Schema

### **Users Table**
```sql
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    birth_date DATE NULL,
    education_level ENUM('sd', 'smp', 'sma', 'kuliah') NULL,
    institution VARCHAR(255) NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### **Personal Access Tokens Table**
```sql
CREATE TABLE personal_access_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tokenable_type VARCHAR(255) NOT NULL,
    tokenable_id BIGINT NOT NULL,
    name VARCHAR(255) NOT NULL,
    token VARCHAR(64) UNIQUE NOT NULL,
    abilities TEXT NULL,
    last_used_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### **Sessions Table**
```sql
CREATE TABLE sessions (
    id VARCHAR(255) PRIMARY KEY,
    user_id BIGINT NULL,
    ip_address VARCHAR(45) NULL,
    user_agent TEXT NULL,
    payload LONGTEXT NOT NULL,
    last_activity INT NOT NULL
);
```

## 🚀 Deployment Status

### **✅ Production Ready**
- **Frontend**: ✅ Deployed di GitHub Pages dan Cloudhebat
- **Backend**: ✅ Running di Railway dengan MySQL
- **AI Integration**: ✅ Gemini AI fully integrated
- **Custom Branding**: ✅ Logo Klarifikasi.id applied
- **Automated Deployment**: ✅ PowerShell script ready

### **🌐 Live URLs**
- **GitHub Pages**: https://elloe2.github.io/Klarifikasi.id/
- **Cloudhebat**: https://www.klarifikasi.rj22d.my.id/
- **Backend API**: https://klarifikasiid-backend-production.up.railway.app/

### **📊 Build Information**
```
Frontend Build: Flutter 3.35.3
Backend Version: Laravel 12.32.5
Database: MySQL 8.0+ (Railway)
AI Service: Google Gemini 2.0-flash
Deployment: Automated via PowerShell
```

## 🎯 Key Features v2.0.0

### **🤖 Gemini AI Integration**
- **Smart Analysis**: AI menganalisis klaim dan memberikan penjelasan
- **Custom Logo**: Google Gemini logo dengan diamond shape
- **Collapsible UI**: ExpansionTile untuk UX yang lebih baik
- **Simplified Output**: Fokus pada penjelasan dan sumber

### **🎨 Enhanced UI/UX**
- **Spotify-Inspired Design**: Dark theme dengan SpotifyMix font
- **Custom Branding**: Logo Klarifikasi.id untuk semua platform
- **Responsive Design**: Mobile-first dengan desktop optimization
- **Loading States**: Smooth animations dan error handling

### **🔧 Technical Improvements**
- **Automated Deployment**: PowerShell script untuk GitHub Pages
- **Custom HTTP Client**: Retry logic dan timeout handling
- **PWA Support**: Service worker untuk offline capability
- **Performance**: Optimized build dengan tree-shaking


## 📝 License

Distributed under the **MIT License**. See [`LICENSE`](LICENSE) for more information.

## 👥 Authors & Contributors

- **Elloe** - *Project Creator & Maintainer*
- **Community Contributors** - *All contributors welcome!*

## 🙏 Acknowledgments

- **Google Gemini AI** - AI-powered fact-checking capabilities
- **Google Custom Search API** - Untuk search functionality
- **Laravel Community** - Excellent documentation dan packages
- **Flutter Team** - Amazing cross-platform framework
- **Indonesian Fact-Checking Community** - Inspiration dan support
- **Open Source Contributors** - Tools dan libraries yang digunakan
- **Spotify Design System** - UI/UX inspiration dan font family


---

<div align="center">

**⭐ Star this repository if you find it helpful!**

[![GitHub stars](https://img.shields.io/github/stars/Elloe2/Klarifikasi.id.svg?style=social&label=Star)](https://github.com/Elloe2/Klarifikasi.id)
[![GitHub forks](https://img.shields.io/github/forks/Elloe2/Klarifikasi.id.svg?style=social&label=Fork)](https://github.com/Elloe2/Klarifikasi.id/fork)

**Made with ❤️ for the Indonesian fact-checking community**

</div>
