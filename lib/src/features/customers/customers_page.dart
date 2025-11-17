import 'package:flutter/material.dart';
import '../../widgets/page_loading_overlay.dart';

// Müşteri Kartı içeriğini embed etmek için
import 'customer_card_page.dart';

/// Sayfa modu: L2 hub mı gösteriliyor, yoksa seçili L2'nin L3 menüleri mi?
enum _PageMode { hub, section }

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key, this.onOpenCustomerCard});

  // L3 "Müşteri Kartı"na tıklanınca çağrılacak callback
  final VoidCallback? onOpenCustomerCard;

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> with PageLoadingMixin {
  _PageMode _mode = _PageMode.hub;
  _L2Section? _activeSection;

  /// Müşteri Yönetimi > Müşteri Kartı seçildiğinde
  /// L3 grid yerine TabBar + CustomerCardView gösterilsin mi?
  bool _showCustomerCardTabs = false;

  /// L2 → L3 geçiş
  Future<void> _navigateToSection(_L2Section section) async {
    await navigateWithLoading(() async {
      _mode = _PageMode.section;
      _activeSection = section;
      _showCustomerCardTabs = false; // her L2'ye girince önce L3 grid’i göster
    });
  }

  /// L3 → L2 geri dönüş
  Future<void> _navigateBackToHub() async {
    await navigateWithLoading(() async {
      _mode = _PageMode.hub;
      _activeSection = null;
      _showCustomerCardTabs = false; // L2 hub’a dönünce tab görünümünü kapat
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
                colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
              ),
            ),
            child: const Icon(
              Icons.account_tree_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Cari Hesap Yönetimi',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Müşteri ve tedarikçi tüm cari hesap fonksiyonlarına tek merkezden erişin.',
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
              Text(
                _showCustomerCardTabs && section.id == 'musteri'
                    ? '• Müşteri Kartı'
                    : '• L3 menüler',
                style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            section.subtitle,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 14),

          // Burada iki mod var:
          // 1) Normal: L3 grid (tüm feature kartları)
          // 2) Eğer Müşteri Yönetimi > Müşteri Kartı seçildiyse: TabBar + CustomerCardView
          Expanded(
            child: _showCustomerCardTabs && section.id == 'musteri'
                ? _buildCustomerCardTabs()
                : _buildL3Grid(section, features),
          ),
        ],
      ),
    );
  }

  /// Normal L3 grid görünümü (tüm feature kartlarını listeler).
  /// Müşteri Yönetimi > Müşteri Kartı için özel davranış içerir.
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
                  // 🔹 Eğer L2 = Müşteri Yönetimi ve L3 = "Müşteri Kartı" ise:
                  if (section.id == 'musteri' && f.id == 'musteri-kart') {
                    if (widget.onOpenCustomerCard != null) {
                      widget.onOpenCustomerCard!(); // Shell'de yeni sekme aç
                    }
                    return;
                  }

                  // Diğer tüm L3 feature'lar için şimdilik placeholder mesaj
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

  /// Müşteri Yönetimi > Müşteri Kartı seçildiğinde gösterilen TabControl alanı.
  /// 1. sekme: Genel Bilgiler (CustomerCardView)
  /// Diğer sekmeler şimdilik placeholder – ileride gerçek ekranlarla doldurulur.
  Widget _buildCustomerCardTabs() {
    return DefaultTabController(
      length: 3, // Genel, Adresler, Finans (örnek)
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF1D4ED8),
            unselectedLabelColor: Color(0xFF6B7280),
            indicatorColor: Color(0xFF1D4ED8),
            tabs: [
              Tab(text: 'Genel Bilgiler'),
              Tab(text: 'Adresler'),
              Tab(text: 'Finans'),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                // 1) GENEL BİLGİLER – Müşteri Kartı formu
                CustomerCardPage(
                  onClose: () {
                    setState(() {
                      _showCustomerCardTabs = false;
                    });
                  },
                ),

                // 2) ADRESLER – şimdilik placeholder
                Center(
                  child: Text(
                    'Adresler sekmesi (ileride detaylandırılacak).',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                // 3) FİNANS – şimdilik placeholder
                Center(
                  child: Text(
                    'Finans sekmesi (ileride detaylandırılacak).',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//// ==================== MODELLER & VERİLER ==================================

class _L2Section {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _L2Section({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class _Feature {
  final String id;
  final String
  sectionId; // hangi L2'ye ait (musteri, tedarikci, crm, finans...)
  final String title;
  final String description;
  final String group; // etiket (Müşteri, Tedarikçi, CRM, Finans, ...)
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

/// L2 listesi (Eksen’deki alt modüller)
const List<_L2Section> _sections = [
  _L2Section(
    id: 'musteri',
    title: 'Müşteri Yönetimi',
    subtitle: 'Müşteri kartı, adresler, CRM ve cari hareketler.',
    icon: Icons.person_rounded,
    color: Color(0xFF2563EB),
  ),
  _L2Section(
    id: 'tedarikci',
    title: 'Tedarikçi Yönetimi (SRM)',
    subtitle: 'Tedarikçi kartı, performans ve sözleşmeler.',
    icon: Icons.store_rounded,
    color: Color(0xFFF97316),
  ),
  _L2Section(
    id: 'crm',
    title: 'CRM & İletişim',
    subtitle: 'Fırsatlar, teklifler, ziyaretler ve kampanyalar.',
    icon: Icons.support_agent_rounded,
    color: Color(0xFF6366F1),
  ),
  _L2Section(
    id: 'finans',
    title: 'Finans & Risk (Cari)',
    subtitle: 'Risk, limit, ekstre ve tahsilat yönetimi.',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF4B5563),
  ),
  _L2Section(
    id: 'islemler',
    title: 'İşlemler',
    subtitle: 'Teklif, sipariş, irsaliye ve fatura süreçleri.',
    icon: Icons.sync_alt_rounded,
    color: Color(0xFF22C55E),
  ),
  _L2Section(
    id: 'baglanti',
    title: 'Proje & Sözleşme Bağlantı',
    subtitle: 'Proje ve sözleşme atamaları, performans.',
    icon: Icons.assignment_turned_in_rounded,
    color: Color(0xFF111827),
  ),
  _L2Section(
    id: 'portal',
    title: 'Portal (Dış Kullanıcı)',
    subtitle: 'Müşteri ve tedarikçi portalları, online formlar.',
    icon: Icons.badge_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _L2Section(
    id: 'analitik',
    title: 'Analitik & Raporlama',
    subtitle: 'Kârlılık, performans ve dashboard analizleri.',
    icon: Icons.insights_rounded,
    color: Color(0xFFF59E0B),
  ),
  _L2Section(
    id: 'ayarlar',
    title: 'Ayarlar & Sözlükler',
    subtitle: 'Cari tipleri, bölgeler, fiyat listeleri, akışlar.',
    icon: Icons.tune_rounded,
    color: Color(0xFF6B7280),
  ),
];

/// Tüm L3 menüleri – (Eksen SetL3 yapısının Flutter karşılığı)
const List<_Feature> _allFeatures = [
  // ---- MÜŞTERİ (L2: musteri) ----------------------------------------------
  _Feature(
    id: 'musteri-360',
    sectionId: 'musteri',
    title: 'Müşteri 360°',
    description: 'Müşteri kartı, hareketler, risk, bütünleşik görünüm.',
    group: 'Müşteri',
    icon: Icons.person_pin_circle_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'musteri-kart',
    sectionId: 'musteri',
    title: 'Müşteri Kartı',
    description: 'Cari müşteri kartı oluşturma ve güncelleme.',
    group: 'Müşteri',
    icon: Icons.badge_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'musteri-liste',
    sectionId: 'musteri',
    title: 'Müşteri Listesi',
    description: 'Tüm müşterileri tablo halinde görüntüleyin.',
    group: 'Müşteri',
    icon: Icons.people_alt_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'kisi-izin',
    sectionId: 'musteri',
    title: 'Kişiler & KVKK İzinleri',
    description: 'Kişi kartları ve KVKK/onay durumları.',
    group: 'Müşteri',
    icon: Icons.verified_user_rounded,
    color: Color(0xFF16A34A),
  ),
  _Feature(
    id: 'adresler',
    sectionId: 'musteri',
    title: 'Adresler',
    description: 'Teslimat ve fatura adreslerinin yönetimi.',
    group: 'Müşteri',
    icon: Icons.location_on_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'odeme-teslim',
    sectionId: 'musteri',
    title: 'Ödeme & Teslim Şartları',
    description: 'Müşteri bazlı ödeme ve teslim koşulları.',
    group: 'Müşteri',
    icon: Icons.local_shipping_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'fiyat-iskonto',
    sectionId: 'musteri',
    title: 'Fiyat / İskonto Profili',
    description: 'Fiyat listesi ve iskonto yapılarının tanımı.',
    group: 'Müşteri',
    icon: Icons.request_quote_rounded,
    color: Color(0xFFF59E0B),
  ),
  _Feature(
    id: 'ilgili-projeler',
    sectionId: 'musteri',
    title: 'İlişkili Projeler',
    description: 'Müşterinin ilişkilendirildiği projeler.',
    group: 'Müşteri',
    icon: Icons.engineering_rounded,
    color: Color(0xFF111827),
  ),
  _Feature(
    id: 'ilgili-sozlesmeler',
    sectionId: 'musteri',
    title: 'İlişkili Sözleşmeler',
    description: 'Sözleşme bağlantıları ve durumları.',
    group: 'Müşteri',
    icon: Icons.description_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'musteri-dokuman',
    sectionId: 'musteri',
    title: 'Dokümanlar',
    description: 'Sözleşme, teklif ve diğer müşteri dokümanları.',
    group: 'Müşteri',
    icon: Icons.folder_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'crm-aktiviteler',
    sectionId: 'musteri',
    title: 'CRM Not & Aktiviteler',
    description: 'Görüşme notları, aktiviteler ve takipler.',
    group: 'Müşteri',
    icon: Icons.event_note_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'musteri-ekstre',
    sectionId: 'musteri',
    title: 'Cari Ekstresi',
    description: 'Müşteri cari ekstresi ve hareket özeti.',
    group: 'Müşteri',
    icon: Icons.receipt_long_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'musteri-hareket',
    sectionId: 'musteri',
    title: 'Cari Hareketler',
    description: 'Cari hareket listesi ve detayları.',
    group: 'Müşteri',
    icon: Icons.cached_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'musteri-portal-erisimi',
    sectionId: 'musteri',
    title: 'Portal Erişimi (Müşteri)',
    description: 'Müşteri portal kullanıcıları ve yetkileri.',
    group: 'Müşteri',
    icon: Icons.manage_accounts_rounded,
    color: Color(0xFFF97316),
  ),

  // ---- TEDARİKÇİ (L2: tedarikci) ------------------------------------------
  _Feature(
    id: 'tedarikci-360',
    sectionId: 'tedarikci',
    title: 'Tedarikçi 360°',
    description: 'Tedarikçi kartı, performans ve risk görünümü.',
    group: 'Tedarikçi',
    icon: Icons.storefront_rounded,
    color: Color(0xFFF59E0B),
  ),
  _Feature(
    id: 'tedarikci-kart',
    sectionId: 'tedarikci',
    title: 'Tedarikçi Kartı',
    description: 'Cari tedarikçi kartı oluşturma ve güncelleme.',
    group: 'Tedarikçi',
    icon: Icons.badge_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'tedarikci-liste',
    sectionId: 'tedarikci',
    title: 'Tedarikçi Listesi',
    description: 'Tüm tedarikçilerin tablo görünümü.',
    group: 'Tedarikçi',
    icon: Icons.store_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 'banka-odeme',
    sectionId: 'tedarikci',
    title: 'Banka & Ödeme Şartları',
    description: 'Tedarikçi banka ve ödeme koşulları.',
    group: 'Tedarikçi',
    icon: Icons.credit_score_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'sertifikalar',
    sectionId: 'tedarikci',
    title: 'Sertifikalar',
    description: 'Kalite ve uygunluk sertifikaları.',
    group: 'Tedarikçi',
    icon: Icons.workspace_premium_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'fiyat-anlasma',
    sectionId: 'tedarikci',
    title: 'Fiyat Anlaşmaları / SLA',
    description: 'Tedarikçi fiyat anlaşmaları ve SLA yapıları.',
    group: 'Tedarikçi',
    icon: Icons.handshake_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'degerlendirme',
    sectionId: 'tedarikci',
    title: 'Performans & Değerlendirme',
    description: 'Tedarikçi performans skorları ve izleme.',
    group: 'Tedarikçi',
    icon: Icons.leaderboard_rounded,
    color: Color(0xFFE11D48),
  ),
  _Feature(
    id: 'liste-yonetimi',
    sectionId: 'tedarikci',
    title: 'Kara/Beyaz Liste Yönetimi',
    description: 'Riskli veya tercih edilen tedarikçi listeleri.',
    group: 'Tedarikçi',
    icon: Icons.block_rounded,
    color: Color(0xFFDC2626),
  ),
  _Feature(
    id: 'tedarikci-dokuman',
    sectionId: 'tedarikci',
    title: 'Dokümanlar',
    description: 'Sözleşme ve diğer tedarikçi dokümanları.',
    group: 'Tedarikçi',
    icon: Icons.folder_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'tedarikci-aktiviteler',
    sectionId: 'tedarikci',
    title: 'Notlar & Aktiviteler',
    description: 'Tedarikçi görüşme notları ve aksiyonlar.',
    group: 'Tedarikçi',
    icon: Icons.event_note_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'b2b-entegrasyon',
    sectionId: 'tedarikci',
    title: 'B2B / EDI Entegrasyonları',
    description: 'Tedarikçi entegrasyon ve veri alışverişi.',
    group: 'Tedarikçi',
    icon: Icons.hub_rounded,
    color: Color(0xFF0EA5E9),
  ),

  // ---- CRM (L2: crm) -------------------------------------------------------
  _Feature(
    id: 'pipeline',
    sectionId: 'crm',
    title: 'Fırsatlar / Pipeline',
    description: 'Satış fırsatları ve pipeline yönetimi.',
    group: 'CRM',
    icon: Icons.timeline_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'crm-teklifler',
    sectionId: 'crm',
    title: 'Teklifler (CRM)',
    description: 'CRM tarafındaki tüm teklifler.',
    group: 'CRM',
    icon: Icons.request_quote_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'gorev-ziyaret',
    sectionId: 'crm',
    title: 'Görevler & Ziyaret Planı',
    description: 'Saha ziyaretleri ve görev planlaması.',
    group: 'CRM',
    icon: Icons.today_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'sikayet-talep',
    sectionId: 'crm',
    title: 'Şikayet / Talep Kayıt',
    description: 'Müşteri şikayet ve taleplerinin kaydı.',
    group: 'CRM',
    icon: Icons.report_gmailerrorred_rounded,
    color: Color(0xFFDC2626),
  ),
  _Feature(
    id: 'kampanya',
    sectionId: 'crm',
    title: 'Kampanya Yönetimi',
    description: 'CRM kampanya tanımları ve takibi.',
    group: 'CRM',
    icon: Icons.campaign_rounded,
    color: Color(0xFFF59E0B),
  ),
  _Feature(
    id: 'toplu-iletisim',
    sectionId: 'crm',
    title: 'Toplu E-posta / SMS / WhatsApp',
    description: 'Toplu iletişim gönderimleri ve şablonlar.',
    group: 'CRM',
    icon: Icons.send_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'cagri-kayit',
    sectionId: 'crm',
    title: 'Çağrı Kayıtları',
    description: 'Gelen/giden çağrı kayıtları.',
    group: 'CRM',
    icon: Icons.call_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'takvim',
    sectionId: 'crm',
    title: 'Randevu Takvimi',
    description: 'Toplantı ve randevu planlaması.',
    group: 'CRM',
    icon: Icons.event_rounded,
    color: Color(0xFF6366F1),
  ),

  // ---- FİNANS (L2: finans) -------------------------------------------------
  _Feature(
    id: 'risk-limit',
    sectionId: 'finans',
    title: 'Risk & Limit Yönetimi',
    description: 'Müşteri ve tedarikçi risk limit politikaları.',
    group: 'Finans',
    icon: Icons.shield_rounded,
    color: Color(0xFFDC2626),
  ),
  _Feature(
    id: 'vade-politikalari',
    sectionId: 'finans',
    title: 'Vade / İskonto Politikaları',
    description: 'Cari bazlı vade ve iskonto kuralları.',
    group: 'Finans',
    icon: Icons.percent_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 'finans-ekstre',
    sectionId: 'finans',
    title: 'Cari Ekstresi',
    description: 'Tüm carilerin finansal ekstreleri.',
    group: 'Finans',
    icon: Icons.receipt_long_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'acik-bakiye',
    sectionId: 'finans',
    title: 'Açık Bakiyeler / Yaşlandırma',
    description: 'Vadesi geçen bakiyeler ve aging raporu.',
    group: 'Finans',
    icon: Icons.schedule_rounded,
    color: Color(0xFF111827),
  ),
  _Feature(
    id: 'tahsilat-plani',
    sectionId: 'finans',
    title: 'Tahsilat Planı',
    description: 'Planlanan tahsilatlar ve takibi.',
    group: 'Finans',
    icon: Icons.payments_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'ba-bs',
    sectionId: 'finans',
    title: 'BA / BS Mutabakat',
    description: 'BA-BS mutabakat süreçleri.',
    group: 'Finans',
    icon: Icons.fact_check_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'ebelge-onay',
    sectionId: 'finans',
    title: 'E-Belge Onayları (e-Fatura/İrs.)',
    description: 'E-fatura / e-irsaliye onay süreçleri.',
    group: 'Finans',
    icon: Icons.assignment_turned_in_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'teminat',
    sectionId: 'finans',
    title: 'Teminat / Kefalet',
    description: 'Teminat, kefalet ve benzeri güvenceler.',
    group: 'Finans',
    icon: Icons.assured_workload_rounded,
    color: Color(0xFF4B5563),
  ),

  // ---- İŞLEMLER (L2: islemler) --------------------------------------------
  _Feature(
    id: 'teklif-olustur',
    sectionId: 'islemler',
    title: 'Teklif Oluştur (İç)',
    description: 'İç satış tekliflerinin oluşturulması.',
    group: 'İşlemler',
    icon: Icons.request_quote_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'teklif-link',
    sectionId: 'islemler',
    title: 'Online Teklif Linki Oluştur',
    description: 'Müşteriye online teklif linki gönderimi.',
    group: 'İşlemler',
    icon: Icons.link_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'teklif-topla',
    sectionId: 'islemler',
    title: 'Online Teklif Topla',
    description: 'Gelen online tekliflerin toplanması.',
    group: 'İşlemler',
    icon: Icons.mark_email_unread_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'satis-siparis',
    sectionId: 'islemler',
    title: 'Satış Siparişi',
    description: 'Satış siparişi oluşturma ve yönetimi.',
    group: 'İşlemler',
    icon: Icons.shopping_cart_checkout_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'rfq-olustur',
    sectionId: 'islemler',
    title: 'RFQ / Teklif İstemi (Tedarikçi)',
    description: 'Tedarikçiden fiyat teklifi isteme.',
    group: 'İşlemler',
    icon: Icons.live_help_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 'satinalma-siparis',
    sectionId: 'islemler',
    title: 'Satınalma Siparişi',
    description: 'Satınalma siparişlerinin yönetimi.',
    group: 'İşlemler',
    icon: Icons.assignment_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'irsaliye',
    sectionId: 'islemler',
    title: 'Sevk İrsaliyesi',
    description: 'Sevk irsaliyesi oluşturma ve takibi.',
    group: 'İşlemler',
    icon: Icons.local_shipping_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'fatura',
    sectionId: 'islemler',
    title: 'Fatura İşlemleri',
    description: 'Fatura kesimi ve yönetimi.',
    group: 'İşlemler',
    icon: Icons.receipt_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'iade-iptal',
    sectionId: 'islemler',
    title: 'İade / İptal',
    description: 'İade ve iptal süreçleri.',
    group: 'İşlemler',
    icon: Icons.undo_rounded,
    color: Color(0xFFDC2626),
  ),
  _Feature(
    id: 'toplu-pdf-mail',
    sectionId: 'islemler',
    title: 'Toplu PDF E-posta Gönderimi',
    description: 'Toplu PDF fatura / ekstre mail gönderimi.',
    group: 'İşlemler',
    icon: Icons.email_rounded,
    color: Color(0xFF111827),
  ),
  _Feature(
    id: 'hizli-mesaj',
    sectionId: 'islemler',
    title: 'Hızlı WhatsApp / SMS / E-posta',
    description: 'Cari karttan hızlı mesaj gönderimleri.',
    group: 'İşlemler',
    icon: Icons.send_rounded,
    color: Color(0xFF22C55E),
  ),

  // ---- BAĞLANTI (L2: baglanti) --------------------------------------------
  _Feature(
    id: 'projeler',
    sectionId: 'baglanti',
    title: 'Proje Atamaları',
    description: 'Cari hesapların projelere atanması.',
    group: 'Bağlantı',
    icon: Icons.engineering_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'sozlesmeler',
    sectionId: 'baglanti',
    title: 'Sözleşme Atamaları',
    description: 'Cari – sözleşme ilişkilerinin takibi.',
    group: 'Bağlantı',
    icon: Icons.description_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'performans',
    sectionId: 'baglanti',
    title: 'Proje / Sözleşme Performansı',
    description: 'Proje ve sözleşme bazlı performans analizi.',
    group: 'Bağlantı',
    icon: Icons.query_stats_rounded,
    color: Color(0xFF22C55E),
  ),

  // ---- PORTAL (L2: portal) -------------------------------------------------
  _Feature(
    id: 'musteri-portal',
    sectionId: 'portal',
    title: 'Müşteri Portalı',
    description: 'Müşteri portalı ve yetkileri.',
    group: 'Portal',
    icon: Icons.web_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'm-portal-ekstre',
    sectionId: 'portal',
    title: '— Ekstre / Fatura Görüntüle',
    description: 'Müşteri portalında ekstre & fatura görüntüleme.',
    group: 'Portal',
    icon: Icons.receipt_long_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'm-portal-siparis',
    sectionId: 'portal',
    title: '— Sipariş Takibi',
    description: 'Online sipariş durumu ve takibi.',
    group: 'Portal',
    icon: Icons.local_mall_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'm-portal-teklif',
    sectionId: 'portal',
    title: '— Açık Teklifler / Onay',
    description: 'Açık tekliflerin online onay süreçleri.',
    group: 'Portal',
    icon: Icons.rule_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'tedarikci-portal',
    sectionId: 'portal',
    title: 'Tedarikçi Portalı',
    description: 'Tedarikçi portalı ve işlemleri.',
    group: 'Portal',
    icon: Icons.language_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 't-portal-rfq',
    sectionId: 'portal',
    title: '— RFQ Cevapla / Fiyat Güncelle',
    description: 'Tedarikçi RFQ cevaplama ve fiyat güncelleme.',
    group: 'Portal',
    icon: Icons.edit_note_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 't-portal-siparis',
    sectionId: 'portal',
    title: '— Sipariş Durumu / Onay',
    description: 'Tedarikçi portalında sipariş durumu & onay.',
    group: 'Portal',
    icon: Icons.inventory_2_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 't-portal-belge',
    sectionId: 'portal',
    title: '— İrsaliye/Fatura Yükleme',
    description: 'İrsaliye / fatura doküman yükleme.',
    group: 'Portal',
    icon: Icons.upload_file_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'online-teklif',
    sectionId: 'portal',
    title: 'Online Teklif Formu Oluşturucu',
    description: 'Dış kullanıcılara açık teklif formu oluşturma.',
    group: 'Portal',
    icon: Icons.link_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'portal-guvenlik',
    sectionId: 'portal',
    title: 'Portal Güvenlik & Roller',
    description: 'Portal rol ve güvenlik tanımları.',
    group: 'Portal',
    icon: Icons.admin_panel_settings_rounded,
    color: Color(0xFF111827),
  ),

  // ---- ANALİTİK (L2: analitik) --------------------------------------------
  _Feature(
    id: 'musteri-karlilik',
    sectionId: 'analitik',
    title: 'Müşteri Kârlılık Analizi',
    description: 'Cari bazlı kârlılık raporları.',
    group: 'Analitik',
    icon: Icons.attach_money_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'tedarikci-perf',
    sectionId: 'analitik',
    title: 'Tedarikçi Performans Analizi',
    description: 'Tedarikçi performans skor ve raporları.',
    group: 'Analitik',
    icon: Icons.query_stats_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 'donusum-orani',
    sectionId: 'analitik',
    title: 'Teklif→Sipariş Dönüşüm Oranı',
    description: 'Tekliften siparişe dönüşüm oranı.',
    group: 'Analitik',
    icon: Icons.trending_up_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'tahsilat-aging',
    sectionId: 'analitik',
    title: 'Tahsilat Yaşlandırma (Aging)',
    description: 'Tahsilat gecikme ve aging analizleri.',
    group: 'Analitik',
    icon: Icons.schedule_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'dashboard-analitik',
    sectionId: 'analitik',
    title: 'Panolar / BI Entegrasyonları',
    description: 'BI panoları ve dış rapor entegrasyonları.',
    group: 'Analitik',
    icon: Icons.dashboard_customize_rounded,
    color: Color(0xFF6366F1),
  ),

  // ---- AYARLAR (L2: ayarlar) ----------------------------------------------
  _Feature(
    id: 'cari-tip-etiket',
    sectionId: 'ayarlar',
    title: 'Cari Tipleri & Etiketler',
    description: 'Cari sınıflandırma ve etiket yönetimi.',
    group: 'Ayarlar',
    icon: Icons.label_rounded,
    color: Color(0xFF3B82F6),
  ),
  _Feature(
    id: 'bolge-saha',
    sectionId: 'ayarlar',
    title: 'Bölge / Saha Tanımları',
    description: 'Bölge, saha ve sorumlu tanımları.',
    group: 'Ayarlar',
    icon: Icons.place_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Feature(
    id: 'fiyat-listeleri',
    sectionId: 'ayarlar',
    title: 'Fiyat Listeleri',
    description: 'Cari tipine göre fiyat listeleri.',
    group: 'Ayarlar',
    icon: Icons.price_change_rounded,
    color: Color(0xFF22C55E),
  ),
  _Feature(
    id: 'iskonto-matrisi',
    sectionId: 'ayarlar',
    title: 'İskonto Matrisleri',
    description: 'Detaylı iskonto matris yapıları.',
    group: 'Ayarlar',
    icon: Icons.grid_on_rounded,
    color: Color(0xFF6366F1),
  ),
  _Feature(
    id: 'kvkk-sablon',
    sectionId: 'ayarlar',
    title: 'KVKK & Sözleşme Şablonları',
    description: 'Metin şablonları ve sözleşme içerikleri.',
    group: 'Ayarlar',
    icon: Icons.description_rounded,
    color: Color(0xFF4B5563),
  ),
  _Feature(
    id: 'iletisim-entegr',
    sectionId: 'ayarlar',
    title: 'E-posta/SMS/WhatsApp Entegrasyonu',
    description: 'Mail, SMS ve WhatsApp altyapı entegrasyonları.',
    group: 'Ayarlar',
    icon: Icons.settings_phone_rounded,
    color: Color(0xFFF97316),
  ),
  _Feature(
    id: 'onay-akislari',
    sectionId: 'ayarlar',
    title: 'Onay Akışları',
    description: 'Cari modülüne özel onay akışı tanımları.',
    group: 'Ayarlar',
    icon: Icons.rule_rounded,
    color: Color(0xFF3B82F6),
  ),
];

//// ==================== KART WIDGET’LARI ====================================

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
              color: _hover
                  ? s.color.withOpacity(0.35)
                  : const Color(0xFFE5E7EB),
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
              color: _hover
                  ? f.color.withOpacity(0.35)
                  : const Color(0xFFE5E7EB),
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
