# === TESTING SCRIPT UNTUK HTTP REQUESTS (Windows PowerShell) ===
# Script ini untuk testing apakah HTTP requests berhasil setelah perbaikan

Write-Host "🔍 Testing HTTP Requests untuk Klarifikasi.id" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Green

# Test 1: Laravel Backend Health Check
Write-Host ""
Write-Host "📡 Test 1: Backend Health Check" -ForegroundColor Yellow
Write-Host "curl -X GET http://localhost:8000/up" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/up" -Method GET -TimeoutSec 10
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Total Time: $($response.Headers.'X-Time-Taken')s" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: API Search Endpoint
Write-Host ""
Write-Host "🔍 Test 2: API Search Endpoint" -ForegroundColor Yellow
Write-Host "curl -X POST http://localhost:8000/api/search -H 'Content-Type: application/json' -d '{\"query\":\"test\",\"limit\":5}'" -ForegroundColor Gray
try {
    $body = '{"query":"test","limit":5}' | ConvertTo-Json
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/search" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 15
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Total Time: $($response.Headers.'X-Time-Taken')s" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: API History Endpoint
Write-Host ""
Write-Host "📚 Test 3: API History Endpoint" -ForegroundColor Yellow
Write-Host "curl -X GET http://localhost:8000/api/history" -ForegroundColor Gray
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8000/api/history" -Method GET -TimeoutSec 10
    Write-Host "Status Code: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Total Time: $($response.Headers.'X-Time-Taken')s" -ForegroundColor Green
} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "✅ Testing selesai!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Tips untuk troubleshooting:" -ForegroundColor Cyan
Write-Host "1. Pastikan Laravel backend running: php artisan serve" -ForegroundColor White
Write-Host "2. Check Laravel logs: Get-Content storage/logs/laravel.log -Tail 10 -Wait" -ForegroundColor White
Write-Host "3. Verify CORS configuration di config/cors.php" -ForegroundColor White
Write-Host "4. Check network tab di browser DevTools untuk Flutter web" -ForegroundColor White
