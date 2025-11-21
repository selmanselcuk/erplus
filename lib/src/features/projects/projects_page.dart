import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with PageLoadingMixin {
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
                colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              ),
            ),
            child: const Icon(
              Icons.work_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Proje & Sözleşme Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Proje planlama, görev yönetimi ve sözleşme takibi.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3E8FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF581C87),
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
      id: 'kartlar',
      title: 'Proje Kartları',
      subtitle: 'Proje tanımlama, ekip oluşturma ve hedef belirleme',
      icon: Icons.folder_outlined,
      color: const Color(0xFF8B5CF6),
    ),
    _L2Section(
      id: 'gorev',
      title: 'Görev & İş Paketleri',
      subtitle: 'Görev atama, ilerleme takibi ve Gantt grafiği',
      icon: Icons.assignment_outlined,
      color: const Color(0xFF7C3AED),
    ),
    _L2Section(
      id: 'kaynak',
      title: 'Kaynak Planlama',
      subtitle: 'İnsan kaynağı, ekipman ve malzeme planlaması',
      icon: Icons.people_alt_outlined,
      color: const Color(0xFF6D28D9),
    ),
    _L2Section(
      id: 'harcama',
      title: 'Harcamalar',
      subtitle: 'Proje bütçesi ve masraf takibi',
      icon: Icons.request_quote_outlined,
      color: const Color(0xFFEF4444),
    ),
    _L2Section(
      id: 'sozlesme',
      title: 'Sözleşmeler',
      subtitle: 'Müşteri ve tedarikçi sözleşmelerini yönet',
      icon: Icons.description_outlined,
      color: const Color(0xFF0891B2),
    ),
    _L2Section(
      id: 'analitik',
      title: 'Proje Analitiği',
      subtitle: 'Proje performansı ve kârlılık raporları',
      icon: Icons.analytics_outlined,
      color: const Color(0xFF059669),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Proje Kartları L3
    const _Feature(
      id: 'proje_tanimlama',
      sectionId: 'kartlar',
      title: 'Proje Tanımlama',
      description: 'Yeni proje oluştur ve temel bilgileri kaydet',
      group: 'Proje Kartı',
      icon: Icons.add_circle_outline,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'proje_ekip',
      sectionId: 'kartlar',
      title: 'Proje Ekibi',
      description: 'Proje ekibini oluştur ve rol atamalarını yap',
      group: 'Proje Kartı',
      icon: Icons.groups_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'proje_milestone',
      sectionId: 'kartlar',
      title: 'Kilometre Taşları',
      description: 'Proje hedeflerini ve kilometre taşlarını tanımla',
      group: 'Proje Kartı',
      icon: Icons.flag_outlined,
      color: Color(0xFF6D28D9),
    ),

    // Görev & İş Paketleri L3
    const _Feature(
      id: 'gorev_atama',
      sectionId: 'gorev',
      title: 'Görev Atama',
      description: 'Ekip üyelerine görev ata ve öncelik belirle',
      group: 'Görev',
      icon: Icons.task_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'gorev_takip',
      sectionId: 'gorev',
      title: 'Görev Takibi',
      description: 'Görevlerin ilerleme durumunu takip et',
      group: 'Görev',
      icon: Icons.track_changes_outlined,
      color: Color(0xFF6D28D9),
    ),
    const _Feature(
      id: 'gantt',
      sectionId: 'gorev',
      title: 'Gantt Grafiği',
      description: 'Proje takvimi ve görev bağımlılıklarını görüntüle',
      group: 'Görev',
      icon: Icons.calendar_view_month_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'is_paketi',
      sectionId: 'gorev',
      title: 'İş Paketleri',
      description: 'Görevleri iş paketlerine grupla',
      group: 'Görev',
      icon: Icons.widgets_outlined,
      color: Color(0xFF7C3AED),
    ),

    // Kaynak Planlama L3
    const _Feature(
      id: 'kaynak_ihtiyac',
      sectionId: 'kaynak',
      title: 'Kaynak İhtiyaç Planlama',
      description: 'Projenin kaynak ihtiyacını planla',
      group: 'Kaynak',
      icon: Icons.pending_actions_outlined,
      color: Color(0xFF6D28D9),
    ),
    const _Feature(
      id: 'kaynak_atama',
      sectionId: 'kaynak',
      title: 'Kaynak Atama',
      description: 'İnsan ve ekipman kaynaklarını ata',
      group: 'Kaynak',
      icon: Icons.assignment_ind_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'kaynak_kullanim',
      sectionId: 'kaynak',
      title: 'Kaynak Kullanım Analizi',
      description: 'Kaynakların verimlilik ve kullanım analizi',
      group: 'Kaynak',
      icon: Icons.leaderboard_outlined,
      color: Color(0xFF8B5CF6),
    ),

    // Harcamalar L3
    const _Feature(
      id: 'butce_tanimlama',
      sectionId: 'harcama',
      title: 'Proje Bütçesi',
      description: 'Proje bütçesini tanımla ve kalemlere ayır',
      group: 'Harcama',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFEF4444),
    ),
    const _Feature(
      id: 'masraf_kayit',
      sectionId: 'harcama',
      title: 'Masraf Kayıtları',
      description: 'Proje harcamalarını kaydet ve kategorize et',
      group: 'Harcama',
      icon: Icons.receipt_long_outlined,
      color: Color(0xFFDC2626),
    ),
    const _Feature(
      id: 'butce_takip',
      sectionId: 'harcama',
      title: 'Bütçe Takibi',
      description: 'Bütçe gerçekleşme oranlarını takip et',
      group: 'Harcama',
      icon: Icons.trending_up_outlined,
      color: Color(0xFFB91C1C),
    ),

    // Sözleşmeler L3
    const _Feature(
      id: 'sozlesme_kart',
      sectionId: 'sozlesme',
      title: 'Sözleşme Kartı',
      description: 'Müşteri ve tedarikçi sözleşmelerini kaydet',
      group: 'Sözleşme',
      icon: Icons.description_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'sozlesme_vade',
      sectionId: 'sozlesme',
      title: 'Vade ve Ödeme Planı',
      description: 'Sözleşme vadeleri ve ödeme planlarını yönet',
      group: 'Sözleşme',
      icon: Icons.schedule_outlined,
      color: Color(0xFF0E7490),
    ),
    const _Feature(
      id: 'sozlesme_revize',
      sectionId: 'sozlesme',
      title: 'Sözleşme Revizyonu',
      description: 'Sözleşme değişikliklerini ve eklerini yönet',
      group: 'Sözleşme',
      icon: Icons.update_outlined,
      color: Color(0xFF06B6D4),
    ),

    // Proje Analitiği L3
    const _Feature(
      id: 'proje_performans',
      sectionId: 'analitik',
      title: 'Proje Performansı',
      description: 'Proje ilerleme ve performans metrikleri',
      group: 'Analitik',
      icon: Icons.assessment_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'proje_karlilik',
      sectionId: 'analitik',
      title: 'Proje Kârlılık Analizi',
      description: 'Proje gelir, gider ve kârlılık raporları',
      group: 'Analitik',
      icon: Icons.attach_money_outlined,
      color: Color(0xFF10B981),
    ),
    const _Feature(
      id: 'proje_risk',
      sectionId: 'analitik',
      title: 'Risk Analizi',
      description: 'Proje risklerini tanımla ve yönet',
      group: 'Analitik',
      icon: Icons.warning_amber_outlined,
      color: Color(0xFFF59E0B),
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
