import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Customer360Page extends StatefulWidget {
  final String? customerId;

  const Customer360Page({super.key, this.customerId});

  @override
  State<Customer360Page> createState() => _Customer360PageState();
}

class _Customer360PageState extends State<Customer360Page>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _currencyFormatter = NumberFormat('#,##0.00', 'tr_TR');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatCurrency(num value) {
    return '${_currencyFormatter.format(value)} ₺';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Row(
          children: [
            _buildLeftPanel(),
            Expanded(child: _buildRightPanel()),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // SOL PANEL – MÜŞTERİ KARTI
  // ───────────────────────────────────────────────────

  Widget _buildLeftPanel() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(3, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLeftHeader(),
          Expanded(
            child: ScrollConfiguration(
              behavior: const _NoGlowScrollBehavior(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildContactBlock(),
                    const SizedBox(height: 24),
                    _buildFinancialBlock(),
                    const SizedBox(height: 24),
                    _buildTagsBlock(),
                    const SizedBox(height: 24),
                    _buildLastUpdate(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.32),
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'ABC',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.6,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'ABC Ticaret A.Ş.',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kurumsal Müşteri • C-0001',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.82),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: [
              _buildPillBadge('VIP', Icons.star_rounded,
                  const Color(0xFFFFC857), Colors.black.withOpacity(0.85)),
              _buildPillBadge('Stratejik', Icons.flag_rounded,
                  Colors.white.withOpacity(0.16), Colors.white),
              _buildPillBadge('A+ Skor', Icons.verified_rounded,
                  Colors.white.withOpacity(0.16), Colors.white),
            ],
          ),
          const SizedBox(height: 18),
          _buildScoreChip(),
        ],
      ),
    );
  }

  Widget _buildPillBadge(
      String text, IconData icon, Color bg, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.white.withOpacity(0.18),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 13),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: foreground,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '95',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: -1.2,
            ),
          ),
          Text(
            '/100',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withOpacity(0.38),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              children: [
                Icon(Icons.trending_up_rounded, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  '+5',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Hızlı İşlemler'),
        _buildQuickActionButton(
          label: 'Yeni Sipariş',
          icon: Icons.add_shopping_cart_rounded,
          color: const Color(0xFF2563EB),
        ),
        _buildQuickActionButton(
          label: 'Fatura Kes',
          icon: Icons.receipt_long_rounded,
          color: const Color(0xFF22C55E),
        ),
        _buildQuickActionButton(
          label: 'Tahsilat Kaydı',
          icon: Icons.payments_rounded,
          color: const Color(0xFFF59E0B),
        ),
        _buildQuickActionButton(
          label: 'Teklif Oluştur',
          icon: Icons.note_add_rounded,
          color: const Color(0xFF0EA5E9),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: color.withOpacity(0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('İletişim'),
        _buildContactRow(Icons.person_outline_rounded, 'Yetkili',
            'Ahmet Yılmaz • Satın Alma'),
        _buildContactRow(Icons.phone_rounded, 'Telefon', '+90 216 555 12 34'),
        _buildContactRow(Icons.email_rounded, 'E-posta', 'info@abcticaret.com'),
        _buildContactRow(
            Icons.location_on_rounded, 'Adres', 'İstanbul, Kadıköy • TR'),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Finansal Durum'),
        _buildFinancialRowLeft(
            'Kredi Limiti', _formatCurrency(500000), const Color(0xFF2563EB)),
        _buildFinancialRowLeft(
            'Kullanılan', _formatCurrency(125000), const Color(0xFFF97316)),
        _buildFinancialRowLeft(
            'Kullanılabilir', _formatCurrency(375000), const Color(0xFF22C55E)),
        const SizedBox(height: 10),
        _buildFinancialRowLeft(
            'Risk Skoru', '8.5 / 10', const Color(0xFF22C55E)),
      ],
    );
  }

  Widget _buildFinancialRowLeft(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.16), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Etiketler'),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: const [
            _TagChip('Aylık Sipariş'),
            _TagChip('Referans Müşteri'),
            _TagChip('Uzun Vadeli'),
            _TagChip('Yüksek Ciro'),
          ],
        ),
      ],
    );
  }

  Widget _buildLastUpdate() {
    return Center(
      child: Text(
        'Son güncelleme:\n15 Kas 2025, 14:30',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 9,
          color: Colors.grey.shade400,
          height: 1.4,
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // SAĞ PANEL – ÜST BAR + TABBAR + İÇERİK
  // ───────────────────────────────────────────────────

  Widget _buildRightPanel() {
    return Column(
      children: [
        _buildTopBar(),
        _buildTabs(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildFinanceTab(),
              _buildDocumentsTab(),
              _buildActivityTab(),
              _buildRiskTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // breadcrumb
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Müşteri ve Cari  •  Müşteri 360°',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'ABC Ticaret A.Ş.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: Color(0xFF111827),
                ),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: 220,
            child: TextField(
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Bu müşteri içinde ara...',
                prefixIcon: const Icon(Icons.search_rounded, size: 18),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          _buildTopBarButton(
            icon: Icons.share_rounded,
            label: 'Paylaş',
          ),
          const SizedBox(width: 8),
          _buildTopBarButton(
            icon: Icons.print_rounded,
            label: 'Yazdır',
          ),
          const SizedBox(width: 8),
          _buildTopBarButton(
            icon: Icons.star_border_rounded,
            label: 'Favori',
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarButton({required IconData icon, required String label}) {
    return Material(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(999),
        ),
        child: TabBar(
          controller: _tabController,
          isScrollable: false,
          labelPadding: EdgeInsets.zero,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          labelColor: const Color(0xFF2563EB),
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            _TabItem(icon: Icons.dashboard_rounded, text: 'Genel Bakış'),
            _TabItem(
                icon: Icons.account_balance_wallet_rounded, text: 'Finans'),
            _TabItem(icon: Icons.description_rounded, text: 'Belgeler'),
            _TabItem(icon: Icons.timeline_rounded, text: 'Aktivite'),
            _TabItem(icon: Icons.shield_rounded, text: 'Risk Profili'),
          ],
        ),
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // TAB 1 – GENEL BAKIŞ
  // ───────────────────────────────────────────────────

  Widget _buildOverviewTab() {
    return ScrollConfiguration(
      behavior: const _NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildOverviewStatsRow(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildOverviewActivityCard()),
                const SizedBox(width: 20),
                Expanded(child: _buildOverviewNotesCard()),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildOverviewOrdersCard()),
                const SizedBox(width: 20),
                Expanded(child: _buildOverviewCreditCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _bigStatCard(
            title: 'Toplam Ciro',
            value: _formatCurrency(2450000),
            change: '+12.5%',
            color: const Color(0xFF2563EB),
            icon: Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _bigStatCard(
            title: 'Açık Alacak',
            value: _formatCurrency(125000),
            change: '-5.2%',
            color: const Color(0xFF22C55E),
            icon: Icons.account_balance_wallet_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _bigStatCard(
            title: 'Sipariş Adedi',
            value: '234',
            change: '+18%',
            color: const Color(0xFFF97316),
            icon: Icons.shopping_bag_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _bigStatCard(
            title: 'Belge Sayısı',
            value: '1.247',
            change: '+3%',
            color: const Color(0xFF0EA5E9),
            icon: Icons.description_rounded,
          ),
        ),
      ],
    );
  }

  Widget _bigStatCard({
    required String title,
    required String value,
    required String change,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  change,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF15803D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardShell(
      {required String title,
      required IconData icon,
      required Widget child,
      Color iconColor = const Color(0xFF2563EB)}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewActivityCard() {
    return _cardShell(
      title: 'Son Aktiviteler',
      icon: Icons.timeline_rounded,
      child: Column(
        children: List.generate(4, (i) => _activityRowSmall(i)),
      ),
    );
  }

  Widget _activityRowSmall(int index) {
    final data = [
      (
        'Yeni sipariş oluşturuldu',
        'SIP-2025${100 + index}',
        Icons.shopping_bag_rounded,
        const Color(0xFF2563EB)
      ),
      (
        'Ödeme alındı',
        _formatCurrency(45000 + index * 1500),
        Icons.payments_rounded,
        const Color(0xFF22C55E)
      ),
      (
        'Fatura kesildi',
        'FAT-2025${300 + index}',
        Icons.receipt_long_rounded,
        const Color(0xFFF97316)
      ),
      (
        'Not eklendi',
        '“Yeni ürün talebi var”',
        Icons.note_alt_rounded,
        const Color(0xFF0EA5E9)
      ),
    ];
    final item = data[index % data.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: item.$4.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.$3, size: 16, color: item.$4),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${index + 1}s önce',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewNotesCard() {
    return _cardShell(
      title: 'Özel Notlar',
      icon: Icons.lightbulb_rounded,
      iconColor: const Color(0xFFF59E0B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            '• Stratejik müşteri, her ay düzenli sipariş.\n'
            '• Ödeme performansı çok iyi, vade uyumu yüksek.\n'
            '• Referans müşteri olarak kullanılabilir.\n'
            '• Yeni ürün gruplarına ilgi gösteriyor.',
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewOrdersCard() {
    return _cardShell(
      title: 'Son Siparişler',
      icon: Icons.shopping_cart_checkout_rounded,
      iconColor: const Color(0xFF2563EB),
      child: Column(
        children: List.generate(3, (i) => _orderRow(i)),
      ),
    );
  }

  Widget _orderRow(int index) {
    final statusList = ['Tamamlandı', 'Hazırlanıyor', 'Beklemede'];
    final status = statusList[index % statusList.length];

    Color statusColor;
    switch (status) {
      case 'Tamamlandı':
        statusColor = const Color(0xFF22C55E);
        break;
      case 'Hazırlanıyor':
        statusColor = const Color(0xFF2563EB);
        break;
      default:
        statusColor = const Color(0xFFF97316);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 18,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIP-2025${1200 + index}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${15 - index}.11.2025',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatCurrency(45000 + index * 8000),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCreditCard() {
    return _cardShell(
      title: 'Limit & Vade Özeti',
      icon: Icons.account_balance_rounded,
      iconColor: const Color(0xFF22C55E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _miniRow('Kredi Limiti', _formatCurrency(500000)),
          _miniRow('Kullanılan', _formatCurrency(125000)),
          _miniRow('Kalan Limit', _formatCurrency(375000)),
          const SizedBox(height: 8),
          _miniRow('Ortalama Vade', '45 gün'),
          _miniRow('Ödeme Performansı', 'A+'),
        ],
      ),
    );
  }

  Widget _miniRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // TAB 2 – FİNANS & HAREKETLER
  // ───────────────────────────────────────────────────

  Widget _buildFinanceTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Belge, tutar veya açıklama ara...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 18),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _pillButton(
                icon: Icons.filter_list_rounded,
                label: 'Filtreler',
                color: const Color(0xFF2563EB),
              ),
              const SizedBox(width: 8),
              _pillButton(
                icon: Icons.download_rounded,
                label: 'Dışa Aktar',
                color: Colors.grey.shade800,
              ),
            ],
          ),
        ),
        Expanded(
          child: ScrollConfiguration(
            behavior: const _NoGlowScrollBehavior(),
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: 20,
              itemBuilder: (context, index) => _financeRow(index),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pillButton(
      {required IconData icon, required String label, required Color color}) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _financeRow(int index) {
    final types = ['Fatura', 'Ödeme', 'İrsaliye', 'Dekont'];
    final type = types[index % types.length];
    final isIncome = type == 'Ödeme' || type == 'Dekont';

    final color = isIncome ? const Color(0xFF22C55E) : const Color(0xFFF97316);

    final amount = 25000 + index * 1300;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type • 2025${1000 + index}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${15 - (index % 15)} Kasım 2025 • 14:${(20 + index) % 60}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncome ? '+' : '-'}${_formatCurrency(amount)}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isIncome ? 'Tahsilat' : 'Borç',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // TAB 3 – BELGELER
  // ───────────────────────────────────────────────────

  Widget _buildDocumentsTab() {
    return ScrollConfiguration(
      behavior: const _NoGlowScrollBehavior(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_rounded,
                    size: 20, color: Color(0xFF2563EB)),
                const SizedBox(width: 8),
                const Text(
                  'Müşteri ile ilişkili tüm belgeler',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                _pillButton(
                  icon: Icons.cloud_upload_rounded,
                  label: 'Belge Yükle',
                  color: const Color(0xFF2563EB),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: 12,
              itemBuilder: (context, index) => _documentRow(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentRow(int index) {
    final types = ['Fatura PDF', 'Sözleşme', 'Teklif', 'İrsaliye', 'Dekont'];
    final type = types[index % types.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.insert_drive_file_rounded,
                size: 22, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type • DOC-${202500 + index}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Boyut: ${(index + 1) * 0.4 + 0.8} MB • ${10 + index % 10}.11.2025',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.visibility_rounded, size: 20),
            color: Colors.grey.shade700,
            tooltip: 'Önizle',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded, size: 20),
            color: const Color(0xFF2563EB),
            tooltip: 'İndir',
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // TAB 4 – AKTİVİTE & NOTLAR
  // ───────────────────────────────────────────────────

  Widget _buildActivityTab() {
    return Row(
      children: [
        // Aktivite timeline
        Expanded(
          flex: 3,
          child: ScrollConfiguration(
            behavior: const _NoGlowScrollBehavior(),
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: 25,
              itemBuilder: (context, index) => _activityCard(index),
            ),
          ),
        ),
        // Notlar
        Container(
          width: 320,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border(
              left: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.note_alt_rounded,
                        size: 18, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    const Text(
                      'Notlar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 22),
                      color: const Color(0xFF2563EB),
                      tooltip: 'Yeni Not',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                  behavior: const _NoGlowScrollBehavior(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: 6,
                    itemBuilder: (context, index) => _noteItem(index),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityCard(int index) {
    final items = [
      (
        'Müşteri kartı güncellendi',
        'Selman Selçuk',
        Icons.edit_rounded,
        const Color(0xFF2563EB)
      ),
      (
        'Yeni sipariş oluşturuldu',
        'Sistem',
        Icons.shopping_cart_rounded,
        const Color(0xFF22C55E)
      ),
      (
        'Ödeme alındı',
        'Finans Departmanı',
        Icons.payments_rounded,
        const Color(0xFF22C55E)
      ),
      (
        'Fatura gönderildi',
        'Sistem',
        Icons.send_rounded,
        const Color(0xFFF97316)
      ),
      (
        'Not eklendi',
        'Ahmet Yılmaz',
        Icons.note_alt_rounded,
        const Color(0xFF0EA5E9)
      ),
      (
        'İrsaliye oluşturuldu',
        'Depo',
        Icons.local_shipping_rounded,
        const Color(0xFF0EA5E9)
      ),
    ];
    final item = items[index % items.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: item.$4.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.$3, size: 18, color: item.$4),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$1,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.$2} • ${index + 1} saat önce',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: Color(0xFF2563EB),
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Selman Selçuk',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
              ),
              const Spacer(),
              Text(
                '${index + 1} gün önce',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Müşteri ile telefon görüşmesi yapıldı. Yeni kampanya hakkında bilgilendirildi, olumlu geri dönüş aldı.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────
  // TAB 5 – RİSK PROFİLİ
  // ───────────────────────────────────────────────────

  Widget _buildRiskTab() {
    return ScrollConfiguration(
      behavior: const _NoGlowScrollBehavior(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _riskScoreCard(),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _riskFactorsCard()),
                const SizedBox(width: 20),
                Expanded(child: _paymentHistoryCard()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _riskScoreCard() {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Risk Değerlendirmesi',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                '8.5',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -3,
                  height: 0.9,
                ),
              ),
              SizedBox(width: 4),
              Text(
                '/10',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Text(
              'DÜŞÜK RİSK • GÜVENİLİR MÜŞTERİ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _riskFactorsCard() {
    return _cardShell(
      title: 'Risk Faktörleri',
      icon: Icons.shield_rounded,
      child: Column(
        children: [
          _riskFactorRow('Ödeme Performansı', 95),
          _riskFactorRow('Limit Kullanım Oranı', 25),
          _riskFactorRow('İşlem Sıklığı', 88),
          _riskFactorRow('Vade Uyumu', 92),
        ],
      ),
    );
  }

  Widget _riskFactorRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              Text(
                '$value%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF22C55E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF22C55E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentHistoryCard() {
    final months = ['Kasım', 'Ekim', 'Eylül', 'Ağustos', 'Temmuz', 'Haziran'];

    return _cardShell(
      title: 'Ödeme Geçmişi',
      icon: Icons.history_rounded,
      iconColor: const Color(0xFF22C55E),
      child: Column(
        children: [
          for (int i = 0; i < months.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    i < 5 ? Icons.check_circle_rounded : Icons.warning_rounded,
                    size: 18,
                    color: i < 5
                        ? const Color(0xFF22C55E)
                        : const Color(0xFFF97316),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      months[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Text(
                    i < 5 ? 'Zamanında' : 'Gecikmiş',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: i < 5
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFF97316),
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

// ─────────────────────────────────────────────────────
// YARDIMCI WIDGET & SCROLL BEHAVIOR
// ─────────────────────────────────────────────────────

class _NoGlowScrollBehavior extends ScrollBehavior {
  const _NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TabItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE5F0FF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1D4ED8),
        ),
      ),
    );
  }
}
