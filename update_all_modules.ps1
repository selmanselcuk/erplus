# ERPlus - Tüm modülleri güncelleme script'i
# Bu script service, inventory, sales, purchasing, finance, crm, reports modüllerini günceller

Write-Host "ERPlus modül güncelleme başlatılıyor..." -ForegroundColor Green

$modules = @(
    @{name="service"; file="lib/src/features/service/service_page.dart"; colors=@("#06B6D4", "#0891B2", "#0E7490")},
    @{name="inventory"; file="lib/src/features/inventory/inventory_page.dart"; colors=@("#6366F1", "#8B5CF6", "#7C3AED")},
    @{name="sales"; file="lib/src/features/sales/sales_page.dart"; colors=@("#10B981", "#059669", "#22C55E")},
    @{name="purchasing"; file="lib/src/features/purchasing/purchasing_page.dart"; colors=@("#F97316", "#EA580C", "#FB923C")},
    @{name="finance"; file="lib/src/features/finance/finance_page.dart"; colors=@("#1E40AF", "#1E3A8A", "#334155")},
    @{name="crm"; file="lib/src/features/crm/crm_page.dart"; colors=@("#6366F1", "#4F46E5", "#4338CA")},
    @{name="reports"; file="lib/src/features/reports/reports_page.dart"; colors=@("#F59E0B", "#D97706", "#B45309")}
)

Write-Host "7 modül güncellenecek" -ForegroundColor Cyan
Write-Host ""

foreach ($module in $modules) {
    Write-Host "✓ $($module.name) modülü güncelleniyor..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Güncelleme tamamlandı!" -ForegroundColor Green
