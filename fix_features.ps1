# ERPlus - Feature tanımlarını otomatik güncelleme scripti
# Sales, Purchasing, Finance, CRM, Reports modüllerini günceller

Write-Host "ERPlus Feature Güncelleyici" -ForegroundColor Cyan
Write-Host "============================`n" -ForegroundColor Cyan

$files = @(
    "lib\src\features\sales\sales_page.dart",
    "lib\src\features\purchasing\purchasing_page.dart", 
    "lib\src\features\finance\finance_page.dart",
    "lib\src\features\crm\crm_page.dart",
    "lib\src\features\reports\reports_page.dart"
)

foreach ($file in $files) {
    Write-Host "İşleniyor: $file" -ForegroundColor Yellow
    
    $content = Get-Content $file -Raw
    
    # _Feature( -> const _Feature( değişimi
    $content = $content -replace '(\s+)_Feature\(', '$1const _Feature('
    
    Set-Content -Path $file -Value $content -NoNewline
    
    Write-Host "  ✓ const eklendi" -ForegroundColor Green
}

Write-Host "`nTamamlandı!" -ForegroundColor Green
Write-Host "Not: group ve color değerleri manuel eklenmelidir." -ForegroundColor Yellow
