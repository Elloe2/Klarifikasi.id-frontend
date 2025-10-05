#!/bin/bash

# === TESTING SCRIPT UNTUK HTTP REQUESTS ===
# Script ini untuk testing apakah HTTP requests berhasil setelah perbaikan

echo "🔍 Testing HTTP Requests untuk Klarifikasi.id"
echo "=============================================="

# Test 1: Laravel Backend Health Check
echo ""
echo "📡 Test 1: Backend Health Check"
echo "curl -X GET http://localhost:8000/up"
curl -X GET http://localhost:8000/up -w "\nStatus Code: %{http_code}\nTotal Time: %{time_total}s\n"

# Test 2: API Search Endpoint
echo ""
echo "🔍 Test 2: API Search Endpoint"
echo "curl -X POST http://localhost:8000/api/search -H 'Content-Type: application/json' -d '{\"query\":\"test\",\"limit\":5}'"
curl -X POST http://localhost:8000/api/search \
  -H "Content-Type: application/json" \
  -d '{"query":"test","limit":5}' \
  -w "\nStatus Code: %{http_code}\nTotal Time: %{time_total}s\n"

# Test 3: API History Endpoint
echo ""
echo "📚 Test 3: API History Endpoint"
echo "curl -X GET http://localhost:8000/api/history"
curl -X GET http://localhost:8000/api/history \
  -w "\nStatus Code: %{http_code}\nTotal Time: %{time_total}s\n"

echo ""
echo "✅ Testing selesai!"
echo ""
echo "💡 Tips untuk troubleshooting:"
echo "1. Pastikan Laravel backend running: php artisan serve"
echo "2. Check Laravel logs: tail -f storage/logs/laravel.log"
echo "3. Verify CORS configuration di config/cors.php"
echo "4. Check network tab di browser DevTools untuk Flutter web"
