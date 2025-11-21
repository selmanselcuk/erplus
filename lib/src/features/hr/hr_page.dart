import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class HrPage extends StatefulWidget {
  const HrPage({super.key});

  @override
  State<HrPage> createState() => _HrPageState();
}

class _HrPageState extends State<HrPage> with PageLoadingMixin {
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
                colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
              ),
            ),
            child: const Icon(
              Icons.people_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'İnsan Kaynakları Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Personel, bordro, performans ve eğitim yönetimi.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE7F3),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF831843),
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
      id: 'personel',
      title: 'Personel Yönetimi',
      subtitle: 'Personel kartları, özlük işleri ve işe giriş/çıkış',
      icon: Icons.badge_outlined,
      color: const Color(0xFFEC4899),
    ),
    _L2Section(
      id: 'organizasyon',
      title: 'Organizasyon Yönetimi',
      subtitle: 'Departman, pozisyon ve organizasyon yapısı',
      icon: Icons.account_tree_outlined,
      color: const Color(0xFFDB2777),
    ),
    _L2Section(
      id: 'devam',
      title: 'Devam/Puantaj',
      subtitle: 'Günlük devam, mesai ve izin takibi',
      icon: Icons.access_time_outlined,
      color: const Color(0xFFC026D3),
    ),
    _L2Section(
      id: 'bordro',
      title: 'Bordro',
      subtitle: 'Maaş hesaplama, SGK ve vergi işlemleri',
      icon: Icons.payments_outlined,
      color: const Color(0xFF7C3AED),
    ),
    _L2Section(
      id: 'performans',
      title: 'Performans',
      subtitle: 'Hedef belirleme, değerlendirme ve geri bildirim',
      icon: Icons.star_outline,
      color: const Color(0xFF0891B2),
    ),
    _L2Section(
      id: 'egitim',
      title: 'Eğitim',
      subtitle: 'Eğitim planlama, katılım ve sertifika takibi',
      icon: Icons.school_outlined,
      color: const Color(0xFF059669),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Personel Yönetimi L3
    const _Feature(
      id: 'personel_kart',
      sectionId: 'personel',
      title: 'Personel Kartı',
      description: 'Personel temel bilgileri, iletişim ve özlük dosyası',
      group: 'Personel',
      icon: Icons.person_outline,
      color: Color(0xFFEC4899),
    ),
    const _Feature(
      id: 'ise_giris',
      sectionId: 'personel',
      title: 'İşe Giriş İşlemleri',
      description: 'Yeni personel kayıt ve oryantasyon süreci',
      group: 'Personel',
      icon: Icons.login_outlined,
      color: Color(0xFFEC4899),
    ),
    const _Feature(
      id: 'isten_cikis',
      sectionId: 'personel',
      title: 'İşten Çıkış İşlemleri',
      description: 'İşten ayrılma süreci ve kıdem tazminatı',
      group: 'Personel',
      icon: Icons.logout_outlined,
      color: Color(0xFFEC4899),
    ),
    const _Feature(
      id: 'ozluk',
      sectionId: 'personel',
      title: 'Özlük İşleri',
      description: 'Terfi, transfer, disiplin ve ödül işlemleri',
      group: 'Personel',
      icon: Icons.folder_shared_outlined,
      color: Color(0xFFEC4899),
    ),

    // Organizasyon Yönetimi L3
    const _Feature(
      id: 'departman',
      sectionId: 'organizasyon',
      title: 'Departman Yönetimi',
      description: 'Departman tanımlama ve hiyerarşi oluşturma',
      group: 'Organizasyon',
      icon: Icons.business_outlined,
      color: Color(0xFFDB2777),
    ),
    const _Feature(
      id: 'pozisyon',
      sectionId: 'organizasyon',
      title: 'Pozisyon Tanımları',
      description: 'İş tanımları ve görev sorumlulukları',
      group: 'Organizasyon',
      icon: Icons.work_outline,
      color: Color(0xFFDB2777),
    ),
    const _Feature(
      id: 'org_sema',
      sectionId: 'organizasyon',
      title: 'Organizasyon Şeması',
      description: 'Şirket organizasyon şeması ve raporlama çizgisi',
      group: 'Organizasyon',
      icon: Icons.hub_outlined,
      color: Color(0xFFDB2777),
    ),

    // Devam/Puantaj L3
    const _Feature(
      id: 'gunluk_devam',
      sectionId: 'devam',
      title: 'Günlük Devam',
      description: 'Giriş/çıkış kayıtları ve pdks entegrasyonu',
      group: 'Devam',
      icon: Icons.today_outlined,
      color: Color(0xFFC026D3),
    ),
    const _Feature(
      id: 'mesai',
      sectionId: 'devam',
      title: 'Mesai Yönetimi',
      description: 'Fazla mesai ve vardiya planlaması',
      group: 'Devam',
      icon: Icons.schedule_outlined,
      color: Color(0xFFC026D3),
    ),
    const _Feature(
      id: 'izin',
      sectionId: 'devam',
      title: 'İzin Yönetimi',
      description: 'Yıllık izin, mazeret ve rapor takibi',
      group: 'Devam',
      icon: Icons.event_available_outlined,
      color: Color(0xFFC026D3),
    ),
    const _Feature(
      id: 'puantaj',
      sectionId: 'devam',
      title: 'Puantaj Raporu',
      description: 'Aylık çalışma saati ve eksik gün hesaplama',
      group: 'Devam',
      icon: Icons.assessment_outlined,
      color: Color(0xFFC026D3),
    ),

    // Bordro L3
    const _Feature(
      id: 'maas_hesap',
      sectionId: 'bordro',
      title: 'Maaş Hesaplama',
      description: 'Aylık maaş ve ücret hesaplamaları',
      group: 'Bordro',
      icon: Icons.calculate_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'sgk',
      sectionId: 'bordro',
      title: 'SGK İşlemleri',
      description: 'SGK bildirge ve prim hesaplamaları',
      group: 'Bordro',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'vergi',
      sectionId: 'bordro',
      title: 'Vergi ve Kesintiler',
      description: 'Gelir vergisi, damga vergisi ve diğer kesintiler',
      group: 'Bordro',
      icon: Icons.receipt_long_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'bordro_rapor',
      sectionId: 'bordro',
      title: 'Bordro Raporları',
      description: 'Aylık bordro ve maliyet raporları',
      group: 'Bordro',
      icon: Icons.bar_chart_outlined,
      color: Color(0xFF7C3AED),
    ),

    // Performans L3
    const _Feature(
      id: 'hedef_belirleme',
      sectionId: 'performans',
      title: 'Hedef Belirleme',
      description: 'Bireysel ve departman hedeflerini tanımla',
      group: 'Performans',
      icon: Icons.flag_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'performans_degerlendirme',
      sectionId: 'performans',
      title: 'Performans Değerlendirme',
      description: 'Dönemsel performans değerlendirme formları',
      group: 'Performans',
      icon: Icons.rate_review_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'geri_bildirim',
      sectionId: 'performans',
      title: 'Geri Bildirim',
      description: '360 derece geri bildirim ve iyileştirme planı',
      group: 'Performans',
      icon: Icons.feedback_outlined,
      color: Color(0xFF0891B2),
    ),

    // Eğitim L3
    const _Feature(
      id: 'egitim_plan',
      sectionId: 'egitim',
      title: 'Eğitim Planlama',
      description: 'Yıllık eğitim planı ve ihtiyaç analizi',
      group: 'Eğitim',
      icon: Icons.event_note_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'egitim_katilim',
      sectionId: 'egitim',
      title: 'Eğitim Katılımı',
      description: 'Eğitim kayıt ve katılımcı takibi',
      group: 'Eğitim',
      icon: Icons.how_to_reg_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'sertifika',
      sectionId: 'egitim',
      title: 'Sertifika Yönetimi',
      description: 'Sertifika ve yetkinlik takibi',
      group: 'Eğitim',
      icon: Icons.card_membership_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'egitim_rapor',
      sectionId: 'egitim',
      title: 'Eğitim Raporları',
      description: 'Eğitim etkinlik ve maliyet raporları',
      group: 'Eğitim',
      icon: Icons.analytics_outlined,
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
