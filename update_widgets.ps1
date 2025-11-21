# Widget update script - L2Card ve L3Card'ı yeni hover pattern'e dönüştürür

$replacements = @(
  @{
    file = 'd:\erplus\lib\src\features\projects\projects_page.dart'
    color = '0xFF8B5CF6'
  },
  @{
    file = 'd:\erplus\lib\src\features\hr\hr_page.dart'
    color = '0xFFEC4899'
  },
  @{
    file = 'd:\erplus\lib\src\features\service\service_page.dart'
    color = '0xFF06B6D4'
  },
  @{
    file = 'd:\erplus\lib\src\features\crm\crm_page.dart'
    color = '0xFFF43F5E'
  },
  @{
    file = 'd:\erplus\lib\src\features\reports\reports_page.dart'
    color = '0xFF14B8A6'
  },
  @{
    file = 'd:\erplus\lib\src\features\integration\integration_page.dart'
    color = '0xFF8B5CF6'
  },
  @{
    file = 'd:\erplus\lib\src\features\compliance\compliance_page.dart'
    color = '0xFF64748B'
  },
  @{
    file = 'd:\erplus\lib\src\features\settings\settings_page.dart'
    color = '0xFF64748B'
  }
)

$l2CardTemplate = @'
class _L2CardState extends State<_L2Card> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.section;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _hover ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hover ? s.color.withOpacity(0.35) : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: s.color.withOpacity(0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 9),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: widget.onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: s.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(s.icon, size: 22, color: s.color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        s.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: Colors.grey.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
'@

foreach ($replacement in $replacements) {
  $file = $replacement.file
  $color = $replacement.color
  
  if (!(Test-Path $file)) {
    Write-Host "❌ Dosya bulunamadı: $file" -ForegroundColor Red
    continue
  }
  
  $content = Get-Content $file -Raw -Encoding UTF8
  
  # L2Card güncelle - eski pattern'i bul ve değiştir
  $l2Pattern = '(?s)class _L2CardState extends State<_L2Card> with SingleTickerProviderStateMixin \{.*?^}'
  if ($content -match $l2Pattern) {
    $content = $content -replace $l2Pattern, $l2CardTemplate
    Write-Host "✓ L2Card güncellendi: $(Split-Path $file -Leaf)" -ForegroundColor Green
  } else {
    Write-Host "⚠ L2Card pattern bulunamadı: $(Split-Path $file -Leaf)" -ForegroundColor Yellow
  }
  
  # L3Card güncelle - renk kodunu kullanarak
  $l3Template = @"
class _L3CardState extends State<_L3Card> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final f = widget.feature;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _hover ? 1.02 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover ? const Color($color).withOpacity(0.28) : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: const Color($color).withOpacity(0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 7),
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color($color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.icon, size: 18, color: const Color($color)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        f.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 16,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
"@
  
  $l3Pattern = '(?s)class _L3CardState extends State<_L3Card> with SingleTickerProviderStateMixin \{.*?^}'
  if ($content -match $l3Pattern) {
    $content = $content -replace $l3Pattern, $l3Template
    Write-Host "✓ L3Card güncellendi: $(Split-Path $file -Leaf)" -ForegroundColor Green
  } else {
    Write-Host "⚠ L3Card pattern bulunamadı: $(Split-Path $file -Leaf)" -ForegroundColor Yellow
  }
  
  Set-Content $file $content -Encoding UTF8 -NoNewline
}

Write-Host "`n✅ Tüm widget güncellemeleri tamamlandı!" -ForegroundColor Cyan
