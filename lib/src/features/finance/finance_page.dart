import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> with PageLoadingMixin {
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
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
            ),
            child: const Icon(
              Icons.account_balance_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Finans & Nakit Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Kasa, banka, çek/senet ve nakit akışı yönetimi.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF312E81),
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
      id: 'kasa',
      title: 'Kasa İşlemleri',
      subtitle: 'Nakit giriş/çıkış, virman ve devir işlemleri',
      icon: Icons.payments_outlined,
      color: const Color(0xFF6366F1),
    ),
    _L2Section(
      id: 'banka',
      title: 'Banka İşlemleri',
      subtitle: 'Banka hesapları, EFT/havale ve mutabakat',
      icon: Icons.account_balance_wallet_outlined,
      color: const Color(0xFF4F46E5),
    ),
    _L2Section(
      id: 'ceksenet',
      title: 'Çek/Senet',
      subtitle: 'Alınan ve verilen çek/senet takibi',
      icon: Icons.description_outlined,
      color: const Color(0xFF7C3AED),
    ),
    _L2Section(
      id: 'odeme',
      title: 'Ödeme/Tahsilat Planları',
      subtitle: 'Vadeli ödeme ve tahsilat planlaması',
      icon: Icons.schedule_outlined,
      color: const Color(0xFF0891B2),
    ),
    _L2Section(
      id: 'nakit',
      title: 'Nakit Akışı',
      subtitle: 'Günlük, haftalık ve aylık nakit akış takibi',
      icon: Icons.trending_up_outlined,
      color: const Color(0xFF059669),
    ),
    _L2Section(
      id: 'analitik',
      title: 'Finans Analitiği',
      subtitle: 'Finansal raporlar ve bütçe takibi',
      icon: Icons.analytics_outlined,
      color: const Color(0xFFF59E0B),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Kasa İşlemleri L3
    const _Feature(
      id: 'kasa_giris',
      sectionId: 'kasa',
      title: 'Kasa Giriş',
      description: 'Kasaya nakit giriş işlemi kaydet',
      group: 'Kasa',
      icon: Icons.add_circle_outline,
      color: Color(0xFF10B981),
    ),
    const _Feature(
      id: 'kasa_cikis',
      sectionId: 'kasa',
      title: 'Kasa Çıkış',
      description: 'Kasadan nakit çıkış işlemi kaydet',
      group: 'Kasa',
      icon: Icons.remove_circle_outline,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'kasa_virman',
      sectionId: 'kasa',
      title: 'Kasa Virmanı',
      description: 'Kasalar arası para transferi',
      group: 'Kasa',
      icon: Icons.swap_horiz_outlined,
      color: Color(0xFF047857),
    ),
    const _Feature(
      id: 'kasa_sayim',
      sectionId: 'kasa',
      title: 'Kasa Sayımı',
      description: 'Fiziksel kasa sayımı ve mutabakat',
      group: 'Kasa',
      icon: Icons.calculate_outlined,
      color: Color(0xFF10B981),
    ),

    // Banka İşlemleri L3
    const _Feature(
      id: 'banka_hesap',
      sectionId: 'banka',
      title: 'Banka Hesapları',
      description: 'Banka hesap kartları ve bakiye takibi',
      group: 'Banka',
      icon: Icons.account_balance_outlined,
      color: Color(0xFF0891B2),
    ),
    const _Feature(
      id: 'eft_havale',
      sectionId: 'banka',
      title: 'EFT/Havale İşlemleri',
      description: 'Para transferi ve havale kayıtları',
      group: 'Banka',
      icon: Icons.send_outlined,
      color: Color(0xFF0E7490),
    ),
    const _Feature(
      id: 'banka_mutabakat',
      sectionId: 'banka',
      title: 'Banka Mutabakatı',
      description: 'Banka ekstre mutabakat ve fark analizi',
      group: 'Banka',
      icon: Icons.fact_check_outlined,
      color: Color(0xFF06B6D4),
    ),
    const _Feature(
      id: 'pos_tahsilat',
      sectionId: 'banka',
      title: 'POS Tahsilatları',
      description: 'Kredi kartı ve POS cihazı tahsilatları',
      group: 'Banka',
      icon: Icons.credit_card_outlined,
      color: Color(0xFF0891B2),
    ),

    // Çek/Senet L3
    const _Feature(
      id: 'alinan_cek',
      sectionId: 'ceksenet',
      title: 'Alınan Çek/Senet',
      description: 'Müşterilerden alınan çek ve senetler',
      group: 'Çek-Senet',
      icon: Icons.call_received_outlined,
      color: Color(0xFF7C3AED),
    ),
    const _Feature(
      id: 'verilen_cek',
      sectionId: 'ceksenet',
      title: 'Verilen Çek/Senet',
      description: 'Tedarikçilere verilen çek ve senetler',
      group: 'Çek-Senet',
      icon: Icons.call_made_outlined,
      color: Color(0xFF6D28D9),
    ),
    const _Feature(
      id: 'cek_tahsil',
      sectionId: 'ceksenet',
      title: 'Çek Tahsil/Ödeme',
      description: 'Çek ve senet vade takibi ve tahsilat',
      group: 'Çek-Senet',
      icon: Icons.payment_outlined,
      color: Color(0xFF8B5CF6),
    ),
    const _Feature(
      id: 'cirolu_cek',
      sectionId: 'ceksenet',
      title: 'Çek Cirosu',
      description: 'Alınan çeklerin ciro işlemleri',
      group: 'Çek-Senet',
      icon: Icons.autorenew_outlined,
      color: Color(0xFF7C3AED),
    ),

    // Ödeme/Tahsilat Planları L3
    const _Feature(
      id: 'odeme_plan',
      sectionId: 'odeme',
      title: 'Ödeme Planı',
      description: 'Tedarikçilere yapılacak ödemelerin planlaması',
      group: 'Ödeme',
      icon: Icons.event_outlined,
      color: Color(0xFF6366F1),
    ),
    const _Feature(
      id: 'tahsilat_plan',
      sectionId: 'odeme',
      title: 'Tahsilat Planı',
      description: 'Müşterilerden yapılacak tahsilatların planlaması',
      group: 'Ödeme',
      icon: Icons.event_available_outlined,
      color: Color(0xFF4F46E5),
    ),
    const _Feature(
      id: 'vade_uyari',
      sectionId: 'odeme',
      title: 'Vade Uyarıları',
      description: 'Yaklaşan vade tarihlerinde otomatik uyarı',
      group: 'Ödeme',
      icon: Icons.notifications_outlined,
      color: Color(0xFF6366F1),
    ),

    // Nakit Akışı L3
    const _Feature(
      id: 'nakit_rapor',
      sectionId: 'nakit',
      title: 'Nakit Akış Raporu',
      description: 'Günlük, haftalık ve aylık nakit akış raporları',
      group: 'Nakit',
      icon: Icons.assessment_outlined,
      color: Color(0xFFEF4444),
    ),
    const _Feature(
      id: 'nakit_tahmin',
      sectionId: 'nakit',
      title: 'Nakit Tahmini',
      description: 'Gelecek dönem nakit akış tahminleri',
      group: 'Nakit',
      icon: Icons.insights_outlined,
      color: Color(0xFFDC2626),
    ),
    const _Feature(
      id: 'nakit_pozisyon',
      sectionId: 'nakit',
      title: 'Nakit Pozisyonu',
      description: 'Anlık toplam nakit pozisyon görüntüleme',
      group: 'Nakit',
      icon: Icons.account_balance_wallet_outlined,
      color: Color(0xFFB91C1C),
    ),

    // Finans Analitiği L3
    const _Feature(
      id: 'gelir_gider',
      sectionId: 'analitik',
      title: 'Gelir/Gider Analizi',
      description: 'Dönemsel gelir ve gider karşılaştırmaları',
      group: 'Analitik',
      icon: Icons.bar_chart_outlined,
      color: Color(0xFFF59E0B),
    ),
    const _Feature(
      id: 'butce_takip',
      sectionId: 'analitik',
      title: 'Bütçe Takibi',
      description: 'Bütçe hedefleri ve gerçekleşme oranları',
      group: 'Analitik',
      icon: Icons.track_changes_outlined,
      color: Color(0xFFD97706),
    ),
    const _Feature(
      id: 'kar_zarar',
      sectionId: 'analitik',
      title: 'Kâr/Zarar Analizi',
      description: 'Departman ve proje bazlı kârlılık analizleri',
      group: 'Analitik',
      icon: Icons.analytics_outlined,
      color: Color(0xFFB45309),
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
