import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with PageLoadingMixin {
  _PageMode _mode = _PageMode.hub;
  _L2Section? _activeSection;

  /// L2 → L3 geçiş
  Future<void> _navigateToSection(_L2Section section) async {
    await navigateWithLoading(() async {
      _mode = _PageMode.section;
      _activeSection = section;
    });
  }

  /// L3 → L2 geri dönüş
  Future<void> _navigateBackToHub() async {
    await navigateWithLoading(() async {
      _mode = _PageMode.hub;
      _activeSection = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isHub = _mode == _PageMode.hub;

    return PageLoadingOverlay(
      isLoading: isPageLoading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: isHub
                  ? _buildL2Hub(_sections)
                  : _buildL3SectionView(
                      section: _activeSection!,
                      features: _allFeatures
                          .where((f) => f.sectionId == _activeSection!.id)
                          .toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // === ÜST BAŞLIK KARTI =====================================================
  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCCFFFFFF), Color(0xB0F9FAFB)],
        ),
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFF64748B), Color(0xFF334155)],
              ),
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Ayarlar & Sistem Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Sistem ayarları, parametreler ve bildirimler.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // === L2 HUB GÖRÜNÜMÜ ======================================================
  Widget _buildL2Hub(List<_L2Section> sections) {
    return Padding(
      key: const ValueKey('hub_view'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          int columns = 1;
          if (width >= 1500) {
            columns = 4;
          } else if (width >= 1150) {
            columns = 3;
          } else if (width >= 800) {
            columns = 2;
          }

          return GridView.count(
            crossAxisCount: columns,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.8,
            children: [
              for (final s in sections)
                _L2Card(section: s, onTap: () => _navigateToSection(s)),
            ],
          );
        },
      ),
    );
  }

  // === L3 GÖRÜNÜMÜ (SEÇİLİ L2 İÇİN) ========================================
  Widget _buildL3SectionView({
    required _L2Section section,
    required List<_Feature> features,
  }) {
    return Padding(
      key: ValueKey('section_${section.id}'),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Üstte geri butonu + L2 başlığı
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: _navigateBackToHub,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        size: 16,
                        color: Color(0xFF374151),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'L2 merkeze dön',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                section.icon,
                size: 18,
                color: section.color.withOpacity(0.9),
              ),
              const SizedBox(width: 6),
              Text(
                section.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• L3 menüler',
                style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            section.subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: _buildL3Grid(section, features),
          ),
        ],
      ),
    );
  }

  Widget _buildL3Grid(_L2Section section, List<_Feature> features) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns = 1;
        if (width >= 1500) {
          columns = 4;
        } else if (width >= 1150) {
          columns = 3;
        } else if (width >= 800) {
          columns = 2;
        }

        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3.6,
          children: [
            for (final feat in features)
              _L3Card(
                feature: feat,
                onTap: () {
                  // TODO: L3 özellik tıklandığında ne olacak
                },
              ),
          ],
        );
      },
    );
  }

  // === DATA MODELS ==========================================================

  final List<_L2Section> _sections = [
    _L2Section(
      id: 'organizasyon',
      title: 'Organizasyon',
      subtitle: 'Şirket bilgileri, şubeler ve lokasyonlar',
      icon: Icons.business_outlined,
      color: const Color(0xFF64748B),
    ),
    _L2Section(
      id: 'genel',
      title: 'Genel Ayarlar',
      subtitle: 'Dil, para birimi, saat dilimi ve varsayılanlar',
      icon: Icons.tune_outlined,
      color: const Color(0xFF475569),
    ),
    _L2Section(
      id: 'parametre',
      title: 'Parametreler',
      subtitle: 'Modül bazlı parametreler ve iş kuralları',
      icon: Icons.settings_applications_outlined,
      color: const Color(0xFF334155),
    ),
    _L2Section(
      id: 'bildirim',
      title: 'Bildirimler',
      subtitle: 'E-posta, SMS ve uygulama içi bildirim ayarları',
      icon: Icons.notifications_outlined,
      color: const Color(0xFF0891B2),
    ),
    _L2Section(
      id: 'tema',
      title: 'Tema & Görünüm',
      subtitle: 'Renk teması, logo ve arayüz özelleştirmeleri',
      icon: Icons.palette_outlined,
      color: const Color(0xFF8B5CF6),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Organizasyon L3
    const _Feature(
      id: 'sirket_bilgi',
      sectionId: 'organizasyon',
      title: 'Şirket Bilgileri',
      description: 'Şirket adı, vergi numarası ve resmi bilgiler',
      group: 'Organizasyon',
      icon: Icons.corporate_fare_outlined,
      color: Color(0xFF64748B),
    ),
    const _Feature(
      id: 'sube_lokasyon',
      sectionId: 'organizasyon',
      title: 'Şube & Lokasyonlar',
      description: 'Şube, depo ve satış noktası tanımları',
      group: 'Organizasyon',
      icon: Icons.location_on_outlined,
      color: Color(0xFF64748B),
    ),
    const _Feature(
      id: 'calisma_takvimi',
      sectionId: 'organizasyon',
      title: 'Çalışma Takvimi',
      description: 'Resmi tatiller, hafta içi/hafta sonu ayarları',
      group: 'Organizasyon',
      icon: Icons.calendar_month_outlined,
      color: Color(0xFF64748B),
    ),
    const _Feature(
      id: 'logo_dokuman',
      sectionId: 'organizasyon',
      title: 'Logo & Döküman Başlığı',
      description: 'Şirket logosu, fatura başlığı ve fiş tasarımları',
      group: 'Organizasyon',
      icon: Icons.image_outlined,
      color: Color(0xFF64748B),
    ),

    // Genel Ayarlar L3
    const _Feature(
      id: 'dil_bolge',
      sectionId: 'genel',
      title: 'Dil & Bölge',
      description: 'Arayüz dili ve bölgesel format ayarları',
      group: 'Genel',
      icon: Icons.language_outlined,
      color: Color(0xFF475569),
    ),
    const _Feature(
      id: 'para_birimi',
      sectionId: 'genel',
      title: 'Para Birimi',
      description: 'Varsayılan para birimi ve kur ayarları',
      group: 'Genel',
      icon: Icons.attach_money_outlined,
      color: Color(0xFF475569),
    ),
    const _Feature(
      id: 'saat_dilimi',
      sectionId: 'genel',
      title: 'Saat Dilimi',
      description: 'Sistem saat dilimi ve tarih formatları',
      group: 'Genel',
      icon: Icons.schedule_outlined,
      color: Color(0xFF475569),
    ),
    const _Feature(
      id: 'varsayilan',
      sectionId: 'genel',
      title: 'Varsayılan Değerler',
      description: 'Form ve belge varsayılan ayarları',
      group: 'Genel',
      icon: Icons.backup_outlined,
      color: Color(0xFF475569),
    ),

    // Parametreler L3
    const _Feature(
      id: 'satis_parametre',
      sectionId: 'parametre',
      title: 'Satış Parametreleri',
      description: 'Teklif, sipariş ve fatura iş kuralları',
      group: 'Parametre',
      icon: Icons.point_of_sale_outlined,
      color: Color(0xFF334155),
    ),
    const _Feature(
      id: 'stok_parametre',
      sectionId: 'parametre',
      title: 'Stok Parametreleri',
      description: 'Stok takip yöntemi ve değerleme kriterleri',
      group: 'Parametre',
      icon: Icons.inventory_2_outlined,
      color: Color(0xFF334155),
    ),
    const _Feature(
      id: 'finans_parametre',
      sectionId: 'parametre',
      title: 'Finans Parametreleri',
      description: 'Kasa, banka ve ödeme yöntem ayarları',
      group: 'Parametre',
      icon: Icons.account_balance_outlined,
      color: Color(0xFF334155),
    ),
    const _Feature(
      id: 'uretim_parametre',
      sectionId: 'parametre',
      title: 'Üretim Parametreleri',
      description: 'Reçete, iş emri ve fire oranı ayarları',
      group: 'Parametre',
      icon: Icons.precision_manufacturing_outlined,
      color: Color(0xFF334155),
    ),
    const _Feature(
      id: 'personel_parametre',
      sectionId: 'parametre',
      title: 'Personel Parametreleri',
      description: 'Devam, izin ve bordro hesaplama kuralları',
      group: 'Parametre',
      icon: Icons.badge_outlined,
      color: Color(0xFF334155),
    ),

    // Bildirimler L3
    const _Feature(
      id: 'eposta_ayar',
      sectionId: 'bildirim',
      title: 'E-posta Ayarları',
      description: 'SMTP ayarları ve e-posta şablonları',
      group: 'Bildirim',
      icon: Icons.email_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'sms_ayar',
      sectionId: 'bildirim',
      title: 'SMS Ayarları',
      description: 'SMS entegrasyonu ve şablon yönetimi',
      group: 'Bildirim',
      icon: Icons.sms_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'push_bildirim',
      sectionId: 'bildirim',
      title: 'Push Bildirimleri',
      description: 'Mobil ve web push bildirimleri',
      group: 'Bildirim',
      icon: Icons.notifications_active_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'bildirim_kural',
      sectionId: 'bildirim',
      title: 'Bildirim Kuralları',
      description: 'Otomatik bildirim tetikleme koşulları',
      group: 'Bildirim',
      icon: Icons.rule_outlined,
      color: Color(0xFF0891B2),
    ),

    // Tema & Görünüm L3
    const _Feature(
      id: 'renk_tema',
      sectionId: 'tema',
      title: 'Renk Teması',
      description: 'Aydınlık/karanlık tema ve renk şeması',
      group: 'Tema',
      icon: Icons.color_lens_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'font_boyut',
      sectionId: 'tema',
      title: 'Yazı Tipi & Boyut',
      description: 'Arayüz yazı tipi ve boyut ayarları',
      group: 'Tema',
      icon: Icons.text_fields_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'menu_layout',
      sectionId: 'tema',
      title: 'Menü Düzeni',
      description: 'Yan menü, üst menü veya kompakt görünüm',
      group: 'Tema',
      icon: Icons.view_sidebar_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'kisisellestirme',
      sectionId: 'tema',
      title: 'Kişiselleştirme',
      description: 'Widget düzeni ve gösterge ayarları',
      group: 'Tema',
      icon: Icons.dashboard_customize_outlined,
      color: Color(0xFF8B5CF6),
    ),
  ];
}

// === L2 SECTION MODEL =====================================================
class _L2Section {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  _L2Section({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

// === L2 CARD WIDGET =======================================================
class _L2Card extends StatefulWidget {
  final _L2Section section;
  final VoidCallback onTap;

  const _L2Card({required this.section, required this.onTap});

  @override
  State<_L2Card> createState() => _L2CardState();
}

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
              color:
                  _hover ? s.color.withOpacity(0.35) : const Color(0xFFE5E7EB),
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

// === FEATURE MODEL ========================================================
class _Feature {
  final String id;
  final String sectionId;
  final String title;
  final String description;
  final String group;
  final IconData icon;
  final Color color;

  const _Feature({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.group,
    required this.icon,
    required this.color,
  });
}

// === L3 CARD WIDGET =======================================================
class _L3Card extends StatefulWidget {
  final _Feature feature;
  final VoidCallback onTap;

  const _L3Card({required this.feature, required this.onTap});

  @override
  State<_L3Card> createState() => _L3CardState();
}

class _L3CardState extends State<_L3Card> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
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
              color:
                  _hover ? f.color.withOpacity(0.35) : const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              if (_hover)
                BoxShadow(
                  color: f.color.withOpacity(0.20),
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
                    color: f.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(f.icon, size: 20, color: f.color),
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: f.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    f.group,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: f.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
