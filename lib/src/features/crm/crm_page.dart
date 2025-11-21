import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class CrmPage extends StatefulWidget {
  const CrmPage({super.key});

  @override
  State<CrmPage> createState() => _CrmPageState();
}

class _CrmPageState extends State<CrmPage> with PageLoadingMixin {
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
                colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
              ),
            ),
            child: const Icon(
              Icons.sentiment_satisfied_alt_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'CRM & İletişim Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Müşteri ilişkileri, fırsat yönetimi ve kampanyalar.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF881337),
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
      id: 'aday',
      title: 'Aday Yönetimi',
      subtitle: 'Potansiyel müşteri kaydı ve nitelendirme',
      icon: Icons.person_add_outlined,
      color: const Color(0xFFF43F5E),
    ),
    _L2Section(
      id: 'firsat',
      title: 'Fırsat Yönetimi',
      subtitle: 'Satış fırsatları ve satış hunisi takibi',
      icon: Icons.trending_up_outlined,
      color: const Color(0xFFE11D48),
    ),
    _L2Section(
      id: 'aktivite',
      title: 'Aktivite Takibi',
      subtitle: 'Görüşme, arama, e-posta ve hatırlatıcılar',
      icon: Icons.event_note_outlined,
      color: const Color(0xFFBE185D),
    ),
    _L2Section(
      id: 'kampanya',
      title: 'Kampanyalar',
      subtitle: 'Pazarlama kampanyaları ve e-posta otomasyonu',
      icon: Icons.campaign_outlined,
      color: const Color(0xFFF59E0B),
    ),
    _L2Section(
      id: 'memnuniyet',
      title: 'Memnuniyet & Geri Bildirim',
      subtitle: 'Müşteri memnuniyet anketleri ve NPS takibi',
      icon: Icons.stars_outlined,
      color: const Color(0xFF059669),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Aday Yönetimi L3
    const _Feature(
      id: 'aday_kayit',
      sectionId: 'aday',
      title: 'Aday (Lead) Kaydı',
      description: 'Potansiyel müşteri bilgilerini kaydet',
      group: 'Aday',
      icon: Icons.person_add_alt_outlined,
      color: Color(0xFFF43F5E),
    ),
    const _Feature(
      id: 'aday_nitelendirme',
      sectionId: 'aday',
      title: 'Aday Nitelendirme',
      description: 'Lead skorlama ve önceliklendirme',
      group: 'Aday',
      icon: Icons.filter_list_outlined,
      color: Color(0xFFE11D48),
    ),
    const _Feature(
      id: 'aday_musteri',
      sectionId: 'aday',
      title: 'Aday → Müşteri Dönüşümü',
      description: 'Nitelikli adayları müşteri kartına dönüştür',
      group: 'Aday',
      icon: Icons.transform_outlined,
      color: Color(0xFFBE185D),
    ),
    const _Feature(
      id: 'aday_kaynak',
      sectionId: 'aday',
      title: 'Aday Kaynağı Analizi',
      description: 'Web, sosyal medya, referans vb. kaynak analizleri',
      group: 'Aday',
      icon: Icons.source_outlined,
      color: Color(0xFFF43F5E),
    ),

    // Fırsat Yönetimi L3
    const _Feature(
      id: 'firsat_kayit',
      sectionId: 'firsat',
      title: 'Fırsat Kaydı',
      description: 'Yeni satış fırsatı oluştur ve takip et',
      group: 'Fırsat',
      icon: Icons.add_business_outlined,
      color: Color(0xFFE11D48),
    ),
    const _Feature(
      id: 'satis_hunisi',
      sectionId: 'firsat',
      title: 'Satış Hunisi',
      description: 'Fırsat aşamaları ve hunideki ilerlemeler',
      group: 'Fırsat',
      icon: Icons.filter_alt_outlined,
      color: Color(0xFFBE185D),
    ),
    const _Feature(
      id: 'teklif_sunumu',
      sectionId: 'firsat',
      title: 'Teklif Sunumu',
      description: 'Fırsata özel teklif hazırlama ve sunma',
      group: 'Fırsat',
      icon: Icons.description_outlined,
      color: Color(0xFF9F1239),
    ),
    const _Feature(
      id: 'kazanma_kayip',
      sectionId: 'firsat',
      title: 'Kazanma/Kayıp Analizi',
      description: 'Kazanılan ve kaybedilen fırsat sebepleri',
      group: 'Fırsat',
      icon: Icons.analytics_outlined,
      color: Color(0xFFE11D48),
    ),

    // Aktivite Takibi L3
    const _Feature(
      id: 'gorusme',
      sectionId: 'aktivite',
      title: 'Görüşme Kaydı',
      description: 'Yüz yüze ve online görüşme kayıtları',
      group: 'Aktivite',
      icon: Icons.handshake_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'arama',
      sectionId: 'aktivite',
      title: 'Arama Takibi',
      description: 'Telefon görüşmelerini kaydet ve takip et',
      group: 'Aktivite',
      icon: Icons.call_outlined,
      color: Color(0xFF6D28D9),
    ),
    const _Feature(
      id: 'eposta',
      sectionId: 'aktivite',
      title: 'E-posta Entegrasyonu',
      description: 'E-posta otomasyonu ve takibi',
      group: 'Aktivite',
      icon: Icons.email_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'hatirlatici',
      sectionId: 'aktivite',
      title: 'Hatırlatıcılar',
      description: 'Aktivite ve takip hatırlatıcıları oluştur',
      group: 'Aktivite',
      icon: Icons.alarm_outlined,
      color: Color(0xFF7C3AED),
    ),

    // Kampanyalar L3
    const _Feature(
      id: 'kampanya_tasarim',
      sectionId: 'kampanya',
      title: 'Kampanya Tasarımı',
      description: 'Pazarlama kampanyası oluştur ve planla',
      group: 'Kampanya',
      icon: Icons.design_services_outlined,
      color: Color(0xFFF59E0B),
    ),
    const _Feature(
      id: 'hedef_segment',
      sectionId: 'kampanya',
      title: 'Hedef Segmentasyon',
      description: 'Müşteri segmentleri ve hedef kitle tanımlama',
      group: 'Kampanya',
      icon: Icons.groups_outlined,
      color: Color(0xFFD97706),
    ),
    const _Feature(
      id: 'eposta_otomasyon',
      sectionId: 'kampanya',
      title: 'E-posta Otomasyonu',
      description: 'Otomatik e-posta kampanyaları ve tetikleyiciler',
      group: 'Kampanya',
      icon: Icons.autorenew_outlined,
      color: Color(0xFFB45309),
    ),
    const _Feature(
      id: 'kampanya_analiz',
      sectionId: 'kampanya',
      title: 'Kampanya Analizi',
      description: 'Açılma, tıklama ve dönüşüm oranları',
      group: 'Kampanya',
      icon: Icons.bar_chart_outlined,
      color: Color(0xFFF59E0B),
    ),

    // Memnuniyet & Geri Bildirim L3
    const _Feature(
      id: 'anket',
      sectionId: 'memnuniyet',
      title: 'Müşteri Anketi',
      description: 'Memnuniyet anketleri oluştur ve gönder',
      group: 'Memnuniyet',
      icon: Icons.poll_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'nps',
      sectionId: 'memnuniyet',
      title: 'NPS (Net Promoter Score)',
      description: 'Müşteri sadakat skoru ölçümü ve takibi',
      group: 'Memnuniyet',
      icon: Icons.thumb_up_outlined,
      color: Color(0xFF047857),
    ),
    const _Feature(
      id: 'sikayet',
      sectionId: 'memnuniyet',
      title: 'Şikayet Yönetimi',
      description: 'Müşteri şikayetlerini kaydet ve çöz',
      group: 'Memnuniyet',
      icon: Icons.report_problem_outlined,
      color: Color(0xFF10B981),
    ),
    const _Feature(
      id: 'referans',
      sectionId: 'memnuniyet',
      title: 'Referans Programı',
      description: 'Müşteri referans ve tavsiye programları',
      group: 'Memnuniyet',
      icon: Icons.share_outlined,
      color: Color(0xFF059669),
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
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
