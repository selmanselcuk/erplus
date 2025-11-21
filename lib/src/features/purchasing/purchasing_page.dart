import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class PurchasingPage extends StatefulWidget {
  const PurchasingPage({super.key});

  @override
  State<PurchasingPage> createState() => _PurchasingPageState();
}

class _PurchasingPageState extends State<PurchasingPage> with PageLoadingMixin {
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
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
            ),
            child: const Icon(
              Icons.shopping_basket_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Satın Alma Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Tedarik süreçlerinizi ve satın alma operasyonlarınızı yönetin.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF78350F),
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
      id: 'talepler',
      title: 'Satın Alma Talepleri',
      subtitle: 'Talep oluşturma, onaylama ve takip süreçleri',
      icon: Icons.request_quote_outlined,
      color: const Color(0xFFF59E0B),
    ),
    _L2Section(
      id: 'teklif',
      title: 'Teklif/Pazarlık',
      subtitle: 'Tedarikçi tekliflerini toplama ve karşılaştırma',
      icon: Icons.compare_arrows_outlined,
      color: const Color(0xFFD97706),
    ),
    _L2Section(
      id: 'siparis',
      title: 'Satın Alma Siparişleri',
      subtitle: 'Satın alma siparişi oluşturma ve takibi',
      icon: Icons.shopping_cart_outlined,
      color: const Color(0xFFEA580C),
    ),
    _L2Section(
      id: 'kabul',
      title: 'Mal Kabul',
      subtitle: 'Gelen malların muayene ve kabul işlemleri',
      icon: Icons.assignment_turned_in_outlined,
      color: const Color(0xFFDC2626),
    ),
    _L2Section(
      id: 'fatura',
      title: 'Alış Faturaları',
      subtitle: 'Alış faturası kayıt ve muhasebe entegrasyonu',
      icon: Icons.receipt_long_outlined,
      color: const Color(0xFF7C3AED),
    ),
    _L2Section(
      id: 'analitik',
      title: 'Analitik',
      subtitle: 'Tedarikçi performansı ve maliyet analizleri',
      icon: Icons.analytics_outlined,
      color: const Color(0xFF059669),
    ),
  ];

  final List<_Feature> _allFeatures = [
    // Satın Alma Talepleri L3
    const _Feature(
      id: 'talep_kart',
      sectionId: 'talepler',
      title: 'Talep Kartı',
      description: 'Departman veya proje bazlı satın alma talebi oluştur',
      group: 'Talep',
      icon: Icons.note_add_outlined,
      color: Color(0xFFF97316),
    ),
    const _Feature(
      id: 'talep_onay',
      sectionId: 'talepler',
      title: 'Talep Onay Süreci',
      description: 'Hiyerarşik onay akışı ve yetkilendirme',
      group: 'Talep',
      icon: Icons.check_circle_outline,
      color: Color(0xFFEA580C),
    ),
    const _Feature(
      id: 'talep_takip',
      sectionId: 'talepler',
      title: 'Talep Takibi',
      description: 'Açık taleplerin durumunu ve ilerlemesini izle',
      group: 'Talep',
      icon: Icons.track_changes_outlined,
      color: Color(0xFFF97316),
    ),

    // Teklif/Pazarlık L3
    const _Feature(
      id: 'teklif_toplama',
      sectionId: 'teklif',
      title: 'Teklif Toplama',
      description: 'Tedarikçilere teklif talebi gönder',
      group: 'Teklif',
      icon: Icons.send_outlined,
      color: Color(0xFFEA580C),
    ),
    const _Feature(
      id: 'teklif_karsilastir',
      sectionId: 'teklif',
      title: 'Teklif Karşılaştırma',
      description: 'Fiyat, teslimat süresi ve koşulları karşılaştır',
      group: 'Teklif',
      icon: Icons.compare_outlined,
      color: Color(0xFFF97316),
    ),
    const _Feature(
      id: 'pazarlik',
      sectionId: 'teklif',
      title: 'Pazarlık Yönetimi',
      description: 'Tedarikçilerle pazarlık sürecini yönet',
      group: 'Teklif',
      icon: Icons.handshake_outlined,
      color: Color(0xFFD97706),
    ),

    // Satın Alma Siparişleri L3
    const _Feature(
      id: 'satin_alma_siparis',
      sectionId: 'siparis',
      title: 'Satın Alma Siparişi',
      description: 'Tedarikçiye gönderilecek sipariş oluştur',
      group: 'Sipariş',
      icon: Icons.shopping_bag_outlined,
      color: Color(0xFFFB923C),
    ),
    const _Feature(
      id: 'siparis_revize',
      sectionId: 'siparis',
      title: 'Sipariş Revizyonu',
      description: 'Sipariş değişikliklerini yönet ve kaydet',
      group: 'Sipariş',
      icon: Icons.edit_note_outlined,
      color: Color(0xFFF97316),
    ),
    const _Feature(
      id: 'siparis_takip',
      sectionId: 'siparis',
      title: 'Sipariş Takibi',
      description: 'Tedarikçi siparişlerini takip et',
      group: 'Sipariş',
      icon: Icons.local_shipping_outlined,
      color: Color(0xFFEA580C),
    ),

    // Mal Kabul L3
    const _Feature(
      id: 'mal_giris',
      sectionId: 'kabul',
      title: 'Mal Giriş Belgesi',
      description: 'Depoya giren malları kaydet',
      group: 'Kabul',
      icon: Icons.inventory_outlined,
      color: Color(0xFFF59E0B),
    ),
    const _Feature(
      id: 'kalite_kontrol',
      sectionId: 'kabul',
      title: 'Kalite Kontrol',
      description: 'Gelen malların kalite muayenesini yap',
      group: 'Kabul',
      icon: Icons.verified_outlined,
      color: Color(0xFFD97706),
    ),
    const _Feature(
      id: 'iade_ret',
      sectionId: 'kabul',
      title: 'İade/Red İşlemleri',
      description: 'Kusurlu malların iadesini yönet',
      group: 'Kabul',
      icon: Icons.undo_outlined,
      color: Color(0xFFF59E0B),
    ),

    // Alış Faturaları L3
    const _Feature(
      id: 'alis_fatura',
      sectionId: 'fatura',
      title: 'Alış Faturası Kayıt',
      description: 'Tedarikçi faturalarını sisteme kaydet',
      group: 'Fatura',
      icon: Icons.receipt_outlined,
      color: Color(0xFFB45309),
    ),
    const _Feature(
      id: 'fatura_eslestir',
      sectionId: 'fatura',
      title: 'Fatura Eşleştirme',
      description: 'Faturaları sipariş ve mal kabulle eşleştir',
      group: 'Fatura',
      icon: Icons.link_outlined,
      color: Color(0xFF92400E),
    ),
    const _Feature(
      id: 'odenecek',
      sectionId: 'fatura',
      title: 'Ödenecek Takibi',
      description: 'Tedarikçi borçlarını ve ödeme planlarını yönet',
      group: 'Fatura',
      icon: Icons.schedule_outlined,
      color: Color(0xFFB45309),
    ),

    // Analitik L3
    const _Feature(
      id: 'tedarikci_performans',
      sectionId: 'analitik',
      title: 'Tedarikçi Performansı',
      description: 'Tedarikçilerin teslimat ve kalite performansı',
      group: 'Analitik',
      icon: Icons.business_outlined,
      color: Color(0xFF10B981),
    ),
    const _Feature(
      id: 'maliyet_analiz',
      sectionId: 'analitik',
      title: 'Maliyet Analizi',
      description: 'Satın alma maliyetlerinin detaylı analizi',
      group: 'Analitik',
      icon: Icons.attach_money_outlined,
      color: Color(0xFF059669),
    ),
    const _Feature(
      id: 'siparis_rapor',
      sectionId: 'analitik',
      title: 'Sipariş Raporları',
      description: 'Dönemsel satın alma sipariş istatistikleri',
      group: 'Analitik',
      icon: Icons.bar_chart_outlined,
      color: Color(0xFF047857),
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
