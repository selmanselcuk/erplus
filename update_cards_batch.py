import re
import os

# Cari stilinde L2Card template
L2_NEW_TEMPLATE = '''class _L2CardState extends State<_L2Card> {
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
}'''

# L3Card template - renk kodu ile parametrik
def get_l3_template(color_code):
    return '''class _L3CardState extends State<_L3Card> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {{
    final f = widget.feature;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _hover ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hover ? const Color(''' + color_code + ''').withOpacity(0.35) : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: const Color(''' + color_code + ''').withOpacity(0.20),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
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
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(''' + color_code + ''').withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.icon, size: 20, color: const Color(''' + color_code + ''')),
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
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        f.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF6B7280),
                          height: 1.22,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.grey.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}'''

# Modül renkleri
MODULE_COLORS = {
    'service': '0xFF06B6D4',
    'crm': '0xFFF43F5E',
    'reports': '0xFF14B8A6',
    'integration': '0xFF8B5CF6',
    'compliance': '0xFF64748B',
    'settings': '0xFF64748B',
    'projects': '0xFF8B5CF6',
}

# İşlenecek dosyalar (HR zaten yapıldı)
files = [
    'lib/src/features/service/service_page.dart',
    'lib/src/features/crm/crm_page.dart',
    'lib/src/features/reports/reports_page.dart',
    'lib/src/features/integration/integration_page.dart',
    'lib/src/features/compliance/compliance_page.dart',
    'lib/src/features/settings/settings_page.dart',
]

# L2Card için regex pattern
l2_pattern = re.compile(
    r'class _L2CardState extends State<_L2Card>.*?^}',
    re.MULTILINE | re.DOTALL
)

# L3Card için regex pattern
l3_pattern = re.compile(
    r'class _L3CardState extends State<_L3Card>.*?^}',
    re.MULTILINE | re.DOTALL
)

for file_path in files:
    try:
        module_name = file_path.split('/')[2]  # service, crm, etc.
        color = MODULE_COLORS.get(module_name, '0xFF64748B')
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # L2 Card değiştir
        content = l2_pattern.sub(L2_NEW_TEMPLATE, content)
        
        # L3 Card değiştir
        l3_template = get_l3_template(color)
        content = l3_pattern.sub(l3_template, content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f'✅ {module_name} güncellendi')
    except Exception as e:
        print(f'❌ {file_path} hatası: {e}')

print('\n✅ Tüm güncellemeler tamamlandı!')
