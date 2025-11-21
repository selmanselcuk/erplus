import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

enum _PageMode { hub, section }

class InventoryPage extends StatefulWidget {
  final Function(String) onOpenSubModule;
  const InventoryPage({super.key, required this.onOpenSubModule});
  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> with PageLoadingMixin {
  _PageMode _mode = _PageMode.hub;
  _L2Section? _activeSection;

  Future<void> _navigateToSection(_L2Section section) async {
    await navigateWithLoading(() async {
      _mode = _PageMode.section;
      _activeSection = section;
    });
  }

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
                          .toList()),
            ),
          ),
        ],
      ),
    );
  }

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
                colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              ),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Stok & Ürün Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Ürün ve envanter yönetimi tüm WMS, Barkod, Kalite, Maliyet & Analitik fonksiyonlarına tek merkezden erişin.',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'L2 & L3 menü haritası',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF1D4ED8),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

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
          Expanded(child: _buildL3Grid(section, features)),
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
            for (final f in features)
              _FeatureCard(
                feature: f,
                onTap: () {
                  widget.onOpenSubModule(f.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('"${f.title}" ekranı ileride eklenecek.'),
                      duration: const Duration(milliseconds: 1600),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

class _L2Section {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _L2Section(this.id, this.title, this.subtitle, this.icon, this.color);
}

class _Feature {
  final String id;
  final String sectionId;
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color color;
  const _Feature(
      {required this.id,
      required this.sectionId,
      required this.title,
      this.subtitle,
      required this.icon,
      required this.color});
}

final _sections = <_L2Section>[
  const _L2Section(
      'urun',
      'Ürün Yönetimi',
      'Ürün kartları, kategori, nitelik, varyant',
      Icons.inventory_2_rounded,
      Color(0xFF0066FF)),
  const _L2Section(
      'varyant',
      'Varyant & Barkod',
      'Varyant matrisi, çoklu barkod, GS1 AI',
      Icons.view_module_rounded,
      Color(0xFF8B5CF6)),
  const _L2Section(
      'depo',
      'Depo & Lokasyon (WMS)',
      'Depo tanımları, lokasyon ağacı',
      Icons.warehouse_rounded,
      Color(0xFF10B981)),
  const _L2Section(
      'hareket',
      'Envanter Hareketleri',
      'Giriş/çıkış, transfer, lot/seri',
      Icons.sync_alt_rounded,
      Color(0xFF059669)),
  const _L2Section('sayim', 'Sayım & Uyum', 'Cycle count, kör sayım, mobil',
      Icons.rule_folder_rounded, Color(0xFFF59E0B)),
  const _L2Section('kalite', 'Kalite & Uygunluk', 'IQC, IPQC, OQC, NCR',
      Icons.verified_rounded, Color(0xFFEF4444)),
  const _L2Section('planlama', 'Tedarik & Planlama', 'Emniyet stoku, MRP, EOQ',
      Icons.event_repeat_rounded, Color(0xFF1F2937)),
  const _L2Section(
      'maliyet',
      'Maliyet & Fiyat',
      'Maliyet yöntemleri, BOM, fiyat',
      Icons.price_change_rounded,
      Color(0xFF0066FF)),
  const _L2Section('analitik', 'Analitik & Raporlama',
      'Devir hızı, ABC/XYZ, KPI', Icons.insights_rounded, Color(0xFF8B5CF6)),
  const _L2Section('entegr', 'Entegrasyonlar', 'Pazar yerleri, EDI, GS1',
      Icons.hub_rounded, Color(0xFF10B981)),
  const _L2Section(
      'hizmet',
      'Hizmet Yönetimi',
      'Hizmet kartları, fiyat, analiz',
      Icons.design_services_rounded,
      Color(0xFF059669)),
  const _L2Section('ayarlar', 'Ayarlar & Sözlükler', 'Ölçü birimleri, lot/seri',
      Icons.tune_rounded, Color(0xFF1F2937)),
];

final _allFeatures = <_Feature>[
  const _Feature(
      id: 'urun-kart',
      sectionId: 'urun',
      title: 'Ürün Kartları',
      subtitle: 'Temel ürün bilgileri',
      icon: Icons.inventory_2_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'kategori',
      sectionId: 'urun',
      title: 'Kategori & Hiyerarşi',
      subtitle: 'Ürün sınıflandırma',
      icon: Icons.category_rounded,
      color: Color(0xFF8B5CF6)),
  const _Feature(
      id: 'nitelik',
      sectionId: 'urun',
      title: 'Nitelik / Özellik Setleri',
      subtitle: 'Ürün özellikleri',
      icon: Icons.tune_rounded,
      color: Color(0xFF10B981)),
  const _Feature(
      id: 'media',
      sectionId: 'urun',
      title: 'Görseller & Dokümanlar',
      subtitle: 'Ürün medya yönetimi',
      icon: Icons.folder_rounded,
      color: Color(0xFFF59E0B)),
  const _Feature(
      id: 'matrix',
      sectionId: 'varyant',
      title: 'Varyant Matrisi',
      subtitle: 'Çoklu varyant yönetimi',
      icon: Icons.grid_on_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'barkodlar',
      sectionId: 'varyant',
      title: 'Çoklu Barkod',
      subtitle: 'Birden fazla barkod',
      icon: Icons.qr_code_rounded,
      color: Color(0xFF10B981)),
  const _Feature(
      id: 'depolar',
      sectionId: 'depo',
      title: 'Depo Tanımları',
      subtitle: 'Depo kayıtları',
      icon: Icons.warehouse_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'lokasyon',
      sectionId: 'depo',
      title: 'Lokasyon Ağacı',
      subtitle: 'Raf ve konum',
      icon: Icons.account_tree_rounded,
      color: Color(0xFF8B5CF6)),
  const _Feature(
      id: 'ir-cr',
      sectionId: 'hareket',
      title: 'Giriş/Çıkış Fişleri',
      subtitle: 'Stok hareketleri',
      icon: Icons.swap_vert_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'lot-serial',
      sectionId: 'hareket',
      title: 'Lot & Seri zleme',
      subtitle: 'Takip numaraları',
      icon: Icons.numbers_rounded,
      color: Color(0xFF059669)),
  const _Feature(
      id: 'plan',
      sectionId: 'sayim',
      title: 'Sayım Planı',
      subtitle: 'Periyodik sayımlar',
      icon: Icons.rule_folder_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'iqc',
      sectionId: 'kalite',
      title: 'Giriş Kalite (IQC)',
      subtitle: 'Gelen mal kontrolü',
      icon: Icons.rule_rounded,
      color: Color(0xFF059669)),
  const _Feature(
      id: 'minmax',
      sectionId: 'planlama',
      title: 'Emniyet Stoku',
      subtitle: 'Min-Max seviyeleri',
      icon: Icons.safety_check_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'yontem',
      sectionId: 'maliyet',
      title: 'Maliyet Yöntemleri',
      subtitle: 'FIFO, LIFO, Ortalama',
      icon: Icons.calculate_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'devir-hizi',
      sectionId: 'analitik',
      title: 'Stok Devir Hızı',
      subtitle: 'Dönüş oranları',
      icon: Icons.donut_large_rounded,
      color: Color(0xFF0066FF)),
  const _Feature(
      id: 'pazar',
      sectionId: 'entegr',
      title: 'Pazar Yerleri',
      subtitle: 'Online satış kanalları',
      icon: Icons.public_rounded,
      color: Color(0xFF10B981)),
  const _Feature(
      id: 'hizmet-kart',
      sectionId: 'hizmet',
      title: 'Hizmet Kartları',
      subtitle: 'Hizmet tanımları',
      icon: Icons.design_services_rounded,
      color: Color(0xFF059669)),
  const _Feature(
      id: 'obd',
      sectionId: 'ayarlar',
      title: 'Ölçü Birimleri',
      subtitle: 'Birim tanımları',
      icon: Icons.straighten_rounded,
      color: Color(0xFF0066FF)),
];

//// ==================== KART WIDGET'LARI ====================================

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

class _FeatureCard extends StatefulWidget {
  final _Feature feature;
  final VoidCallback onTap;

  const _FeatureCard({required this.feature, required this.onTap});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
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
                      if (f.subtitle != null)
                        Text(
                          f.subtitle!,
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
                    'Stok',
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
