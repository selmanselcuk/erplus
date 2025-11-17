# ERPlus Git Setup Script
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "ERPlus Git Kurulum Başlatılıyor..." -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Git yüklü mü kontrol et
$gitInstalled = $null -ne (Get-Command git -ErrorAction SilentlyContinue)

if (-not $gitInstalled) {
    Write-Host "HATA: Git yüklü değil!" -ForegroundColor Red
    Write-Host "Lütfen önce Git'i yükleyin: https://git-scm.com/download/win" -ForegroundColor Yellow
    Read-Host "Devam etmek için Enter'a basın"
    exit
}

Write-Host "✓ Git yüklü" -ForegroundColor Green
Write-Host ""

# .gitignore oluştur
Write-Host "📝 .gitignore dosyası oluşturuluyor..." -ForegroundColor Yellow

$gitignoreContent = @"
# Flutter/Dart
.dart_tool/
.flutter-plugins
.flutter-plugins-dependencies
.packages
.pub-cache/
.pub/
build/
flutter_*.log
*.iml
*.ipr
*.iws
.idea/

# Android
**/android/**/gradle-wrapper.jar
**/android/.gradle
**/android/captures/
**/android/gradlew
**/android/gradlew.bat
**/android/local.properties
**/android/**/GeneratedPluginRegistrant.java

# iOS/macOS
**/ios/**/*.mode1v3
**/ios/**/*.mode2v3
**/ios/**/*.moved-aside
**/ios/**/*.pbxuser
**/ios/**/*.perspectivev3
**/ios/**/DerivedData/
**/ios/**/Pods/
**/ios/**/.symlinks/
**/ios/**/xcuserdata
**/ios/Flutter/ephemeral
**/macos/Flutter/ephemeral/

# Windows/Linux
**/windows/flutter/ephemeral/
**/linux/flutter/ephemeral/

# Web
**/web/packages/
**/web/.dart_tool/

# Coverage
coverage/
"@

Set-Content -Path ".gitignore" -Value $gitignoreContent
Write-Host "✓ .gitignore oluşturuldu" -ForegroundColor Green
Write-Host ""

# Git init
Write-Host "🔧 Git repository başlatılıyor..." -ForegroundColor Yellow
git init
Write-Host "✓ Git repository başlatıldı" -ForegroundColor Green
Write-Host ""

# Dosyaları ekle
Write-Host "📦 Dosyalar ekleniyor..." -ForegroundColor Yellow
git add .
Write-Host "✓ Dosyalar eklendi" -ForegroundColor Green
Write-Host ""

# İlk commit
Write-Host "💾 İlk commit yapılıyor..." -ForegroundColor Yellow
git commit -m "Initial commit: Premium customer card form with Apple-style design"
Write-Host "✓ Commit tamamlandı" -ForegroundColor Green
Write-Host ""

# GitHub bilgileri iste
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "GitHub Bilgileri" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "GitHub'da yeni bir repository oluşturun:" -ForegroundColor Yellow
Write-Host "1. https://github.com adresine gidin" -ForegroundColor White
Write-Host "2. 'New repository' butonuna tıklayın" -ForegroundColor White
Write-Host "3. Repository adı: erplus (veya istediğiniz bir isim)" -ForegroundColor White
Write-Host "4. Private seçin" -ForegroundColor White
Write-Host "5. 'Create repository' tıklayın" -ForegroundColor White
Write-Host "6. Açılan sayfadan repository URL'sini kopyalayın" -ForegroundColor White
Write-Host ""

$repoUrl = Read-Host "GitHub repository URL'sini girin (örn: https://github.com/kullanici/erplus.git)"

if ([string]::IsNullOrWhiteSpace($repoUrl)) {
    Write-Host "HATA: URL boş olamaz!" -ForegroundColor Red
    Read-Host "Devam etmek için Enter'a basın"
    exit
}

# Remote ekle
Write-Host ""
Write-Host "🔗 GitHub bağlantısı ekleniyor..." -ForegroundColor Yellow
git remote add origin $repoUrl
git branch -M main
Write-Host "✓ Bağlantı eklendi" -ForegroundColor Green
Write-Host ""

# Push yap
Write-Host "🚀 Kod GitHub'a yükleniyor..." -ForegroundColor Yellow
Write-Host "GitHub kullanıcı adı ve şifrenizi girin:" -ForegroundColor Cyan
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "==================================" -ForegroundColor Green
    Write-Host "✓✓✓ BAŞARILI! ✓✓✓" -ForegroundColor Green
    Write-Host "==================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Projeniz GitHub'a yüklendi!" -ForegroundColor Green
    Write-Host "Artık evden şu komutla erişebilirsiniz:" -ForegroundColor Yellow
    Write-Host "git clone $repoUrl" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "HATA: Push başarısız!" -ForegroundColor Red
    Write-Host "GitHub kullanıcı adı/şifrenizi kontrol edin" -ForegroundColor Yellow
    Write-Host "veya GitHub'da Personal Access Token oluşturun:" -ForegroundColor Yellow
    Write-Host "https://github.com/settings/tokens" -ForegroundColor White
}

Write-Host ""
Read-Host "Kapatmak için Enter'a basın"