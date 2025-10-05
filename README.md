# Klarifikasi.id

Aplikasi web fact-checking yang dibangun dengan Flutter frontend dan Laravel backend untuk membantu pengguna memverifikasi kebenaran informasi dan klaim.

## 🚀 Fitur Utama

- **Fact-checking Search**: Pencarian informasi dengan integrasi Google Custom Search
- **Search History**: Riwayat pencarian dengan pagination
- **User Authentication**: Sistem login/register dengan token-based authentication
- **Responsive UI**: Design yang responsive untuk desktop dan mobile
- **Rate Limiting**: Pembatasan pencarian untuk mencegah spam
- **Indonesian Language**: Interface dalam bahasa Indonesia

## 🛠️ Tech Stack

### Frontend (Flutter)
- **Framework**: Flutter 3.9.2
- **State Management**: Provider
- **HTTP Client**: HTTP package dengan retry logic
- **Storage**: Flutter Secure Storage untuk token management
- **UI**: Material 3 dengan custom theming

### Backend (Laravel)
- **Framework**: Laravel 12.0
- **PHP Version**: PHP 8.2+
- **Authentication**: Laravel Sanctum
- **Database**: MySQL
- **Search API**: Google Custom Search Engine

## 📋 Prerequisites

- **Flutter SDK** (3.9.2+)
- **PHP** (8.2+)
- **Composer**
- **MySQL**
- **Google Custom Search API Key**

## 🚀 Installation

### 1. Clone Repository
```bash
git clone https://github.com/your-username/klarifikasi.id.git
cd klarifikasi.id
```

### 2. Backend Setup
```bash
cd Klarifikasi.id-backend

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate app key
php artisan key:generate

# Configure database in .env
# DB_CONNECTION=mysql
# DB_DATABASE=klarifikasi_id
# etc.

# Run migrations
php artisan migrate

# Start development server
php artisan serve --host=0.0.0.0 --port=8000
```

### 3. Frontend Setup
```bash
cd ../Klarifikasi.id\ Frontend

# Install dependencies
flutter pub get

# Run web version
flutter run -d chrome
```

## 🔑 Environment Variables

### Backend (.env)
```env
# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=klarifikasi_id
DB_USERNAME=root
DB_PASSWORD=

# Google Custom Search
GOOGLE_CSE_KEY=your_api_key
GOOGLE_CSE_CX=your_cx_id

# App
APP_NAME=Klarifikasi.id
APP_ENV=local
APP_KEY=your_app_key
APP_DEBUG=true
APP_URL=http://localhost:8000
```

### Frontend (lib/config.dart)
```dart
// Update API base URL for production
String get apiBaseUrl {
  if (kDebugMode) {
    return 'http://localhost:8000';
  }
  return 'https://your-production-domain.com';
}
```

## 🔐 Authentication

1. **Register**: `POST /api/auth/register`
2. **Login**: `POST /api/auth/login`
3. **Profile**: `GET /api/auth/profile` (protected)
4. **Update Profile**: `POST /api/auth/profile` (protected)
5. **Logout**: `POST /api/auth/logout` (protected)

## 🔍 API Endpoints

### Search
- `POST /api/search` - Perform search (protected, rate limited)
- `GET /api/history` - Get search history (protected)
- `DELETE /api/history` - Clear history (protected)

### Authentication
- `POST /api/auth/register` - User registration
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile (protected)
- `POST /api/auth/profile` - Update profile (protected)
- `POST /api/auth/logout` - User logout (protected)

## 🌐 Deployment

### Backend (Laravel)
```bash
# Production deployment
composer install --optimize-autoloader --no-dev
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Frontend (Flutter)
```bash
# Build for web
flutter build web --release

# Deploy to web server
# Upload build/web contents to web server
```

## 📊 Database Schema

### Users Table
- User authentication and profile data

### Search Histories Table
- Search queries and metadata
- Top results and thumbnails

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Authors

- **Your Name** - *Initial work*

## 🙏 Acknowledgments

- Google Custom Search API
- Laravel Framework
- Flutter Framework
- Indonesian fact-checking community
