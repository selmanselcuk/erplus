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
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    // Sadece UI'ı güncelle, karakter sayısını göster
    setState(() {
      // Text temizlendiğinde sonuçları da temizle
      if (_searchController.text.isEmpty) {
        _isSearching = false;
        _searchResults = [];
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
      width: 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFFBFBFB),
            const Color(0xFFF5F7FA),
          ],
        ),
        border: Border(
          right: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0066FF).withOpacity(0.03),
            blurRadius: 32,
            offset: const Offset(8, 0),
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
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    _buildContactBlock(),
                    const SizedBox(height: 20),
                    _buildFinancialBlock(),
                    const SizedBox(height: 20),
                    _buildTagsBlock(),
                    const SizedBox(height: 20),
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
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Compact header with avatar and name
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Minimal avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF667EEA).withOpacity(0.9),
                        const Color(0xFF764BA2).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'ABC',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ABC Ticaret A.Ş.',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'C-0001',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                                letterSpacing: -0.1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.business_rounded,
                            size: 13,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            'Kurumsal',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.grey.shade100,
          ),
          // Badges and score in horizontal layout
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Badges
                _buildCompactBadge(
                  'VIP',
                  Icons.workspace_premium_rounded,
                  const Color(0xFFFBBF24),
                  const Color(0xFFFEF3C7),
                ),
                const SizedBox(width: 6),
                _buildCompactBadge(
                  'A+',
                  Icons.verified_rounded,
                  const Color(0xFF10B981),
                  const Color(0xFFD1FAE5),
                ),
                const Spacer(),
                // Score
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981).withOpacity(0.1),
                        const Color(0xFF059669).withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SKOR',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                '95',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF059669),
                                  letterSpacing: -0.5,
                                  height: 1,
                                ),
                              ),
                              Text(
                                '/100',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade600,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.trending_up_rounded,
                              color: Colors.white,
                              size: 11,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              '+5',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactBadge(
      String text, IconData icon, Color primaryColor, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: primaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 10),
          child: Text(
            'HIZLI İŞLEMLER',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        // Grid layout for actions
        Row(
          children: [
            Expanded(
              child: _buildMinimalActionCard(
                'Sipariş',
                Icons.add_shopping_cart_rounded,
                const Color(0xFF3B82F6),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMinimalActionCard(
                'Fatura',
                Icons.receipt_long_rounded,
                const Color(0xFF8B5CF6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildMinimalActionCard(
                'Tahsilat',
                Icons.account_balance_wallet_rounded,
                const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildMinimalActionCard(
                'Teklif',
                Icons.description_rounded,
                const Color(0xFFF59E0B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMinimalActionCard(String label, IconData icon, Color color) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  letterSpacing: -0.2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 12),
            child: Text(
              'İLETİŞİM',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          _buildCompactContactRow(
            Icons.person_rounded,
            'Ahmet Yılmaz',
            'Satın Alma Müdürü',
            const Color(0xFF3B82F6),
          ),
          const SizedBox(height: 8),
          _buildCompactContactRow(
            Icons.phone_rounded,
            '+90 216 555 12 34',
            'Dahili: 1234',
            const Color(0xFF10B981),
          ),
          const SizedBox(height: 8),
          _buildCompactContactRow(
            Icons.email_rounded,
            'info@abcticaret.com',
            null,
            const Color(0xFFF59E0B),
          ),
          const SizedBox(height: 8),
          _buildCompactContactRow(
            Icons.location_on_rounded,
            'Kadıköy, İstanbul',
            'Türkiye',
            const Color(0xFFEC4899),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactContactRow(
    IconData icon,
    String value,
    String? subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade900,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 12),
            child: Text(
              'FİNANSAL DURUM',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          _buildCompactFinancialMetric(
            'Toplam Ciro',
            _formatCurrency(2450000),
            Icons.trending_up_rounded,
            const Color(0xFF10B981),
            '+12.5%',
          ),
          const SizedBox(height: 10),
          _buildCompactFinancialMetric(
            'Açık Alacak',
            _formatCurrency(125000),
            Icons.receipt_long_rounded,
            const Color(0xFFF59E0B),
            null,
          ),
          const SizedBox(height: 10),
          _buildCompactFinancialMetric(
            'Sipariş Adedi',
            '234',
            Icons.shopping_cart_rounded,
            const Color(0xFF3B82F6),
            null,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.1),
                  const Color(0xFF10B981).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF10B981).withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.shield_rounded,
                      size: 18, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Risk Skoru',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            '8.5',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF10B981),
                              letterSpacing: -1,
                              height: 1,
                            ),
                          ),
                          Text(
                            '/10',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade600,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF10B981), Color(0xFF059669)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Text(
                    'Düşük Risk',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactFinancialMetric(
    String label,
    String value,
    IconData icon,
    Color color,
    String? badge,
  ) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade900,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTagsBlock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 2, bottom: 10),
            child: Text(
              'ETİKETLER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _SimpleTagChip('Aylık Sipariş', const Color(0xFF3B82F6)),
              _SimpleTagChip('Referans', const Color(0xFF10B981)),
              _SimpleTagChip('Uzun Vadeli', const Color(0xFF8B5CF6)),
              _SimpleTagChip('Yüksek Ciro', const Color(0xFFF59E0B)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdate() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 12,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 6),
          Text(
            'Son güncelleme: 15 Kas 2025, 14:30',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ],
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
          // Customer search
          SizedBox(
            width: 360,
            child: _buildCustomerSearchField(),
          ),
          const SizedBox(width: 20),
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

  Widget _buildCustomerSearchField() {
    return Stack(
      children: [
        TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          onSubmitted: (value) {
            // Enter tuşuna basıldığında
            if (value.length >= 3) {
              _performSearch(value);
            }
          },
          decoration: InputDecoration(
            isDense: true,
            hintText: 'Cari kod veya ünvan ile ara (Enter veya 🔍)',
            hintStyle: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
            prefixIcon: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Search icon'a tıklandığında
                  if (_searchController.text.length >= 3) {
                    _performSearch(_searchController.text);
                  }
                },
                child: Icon(Icons.search_rounded,
                    size: 20, color: Colors.grey.shade600),
              ),
            ),
            suffixIcon: _searchController.text.isNotEmpty
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Karakter sayısı göstergesi
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _searchController.text.length >= 3
                              ? const Color(0xFF10B981).withOpacity(0.1)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${_searchController.text.length}/3',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _searchController.text.length >= 3
                                ? const Color(0xFF10B981)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.clear_rounded,
                            size: 18, color: Colors.grey.shade600),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _isSearching = false;
                            _searchResults = [];
                          });
                        },
                      ),
                    ],
                  )
                : null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
          ),
        ),
        if (_isSearching && _searchResults.isNotEmpty)
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: _buildSearchResults(),
          ),
        // Arama yapılırken loading overlay
        if (_isSearching && _searchResults.isEmpty)
          Positioned(
            top: 48,
            left: 0,
            right: 0,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF6366F1)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Aranıyor...',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _performSearch(String query) {
    if (query.length < 3) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = [];
    });

    // Simulated delay for API call
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      final results = [
        {'code': 'C-0001', 'name': 'ABC Ticaret A.Ş.', 'city': 'İstanbul'},
        {'code': 'C-0002', 'name': 'XYZ Lojistik Ltd.', 'city': 'Ankara'},
        {'code': 'C-0003', 'name': 'ABC Yapı A.Ş.', 'city': 'İzmir'},
        {'code': 'C-0125', 'name': 'DEF İnşaat Ltd.', 'city': 'Bursa'},
        {'code': 'C-0210', 'name': 'GHI Tekstil A.Ş.', 'city': 'Denizli'},
        {'code': 'C-0505', 'name': 'JKL Otomotiv Ltd.', 'city': 'Kocaeli'},
      ]
          .where((customer) =>
              customer['code']!.toLowerCase().contains(query.toLowerCase()) ||
              customer['name']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = results;
        _isSearching = results.isEmpty ? false : true;
      });

      // Show modal if results found
      if (results.isNotEmpty) {
        _showSearchResultsDialog();
      }
    });
  }

  void _showSearchResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(0),
        alignment: Alignment.topCenter,
        child: Container(
          margin: const EdgeInsets.only(top: 120, left: 24, right: 24),
          constraints: const BoxConstraints(maxWidth: 500, maxHeight: 400),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withOpacity(0.05),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        size: 18, color: const Color(0xFF6366F1)),
                    const SizedBox(width: 8),
                    Text(
                      '${_searchResults.length} müşteri bulundu',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 20, color: Colors.grey.shade600),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Results
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final customer = _searchResults[index];
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _searchController.text = customer['name']!;
                          setState(() {
                            _isSearching = false;
                            _searchResults = [];
                          });
                          _searchFocusNode.unfocus();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF667EEA).withOpacity(0.9),
                                      const Color(0xFF764BA2).withOpacity(0.9),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    customer['name']!
                                        .substring(0, 2)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customer['name']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF111827),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF6366F1)
                                                .withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            customer['code']!,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF6366F1),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(Icons.location_on_rounded,
                                            size: 13,
                                            color: Colors.grey.shade500),
                                        const SizedBox(width: 3),
                                        Text(
                                          customer['city']!,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded,
                                  size: 16, color: Colors.grey.shade400),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(12),
      shadowColor: Colors.black.withOpacity(0.1),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: const Color(0xFF10B981)),
                  const SizedBox(width: 6),
                  Text(
                    '${_searchResults.length} sonuç bulundu',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.keyboard_return_rounded,
                            size: 12, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          'Seç',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Results
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final customer = _searchResults[index];
                  return _buildSearchResultItem(
                    code: customer['code']!,
                    name: customer['name']!,
                    city: customer['city']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultItem({
    required String code,
    required String name,
    required String city,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Navigate to selected customer
          _searchController.text = name;
          setState(() {
            _isSearching = false;
            _searchResults = [];
          });
          _searchFocusNode.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF667EEA).withOpacity(0.9),
                      const Color(0xFF764BA2).withOpacity(0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 2).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            code,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.location_on_rounded,
                            size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Text(
                          city,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 1),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF6366F1),
              width: 2,
            ),
          ),
        ),
        labelColor: const Color(0xFF6366F1),
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade500,
        ),
        tabs: const [
          _TabItem(icon: Icons.dashboard_rounded, text: 'Genel Bakış'),
          _TabItem(icon: Icons.account_balance_wallet_rounded, text: 'Finans'),
          _TabItem(icon: Icons.description_rounded, text: 'Belgeler'),
          _TabItem(icon: Icons.timeline_rounded, text: 'Aktivite'),
          _TabItem(icon: Icons.shield_rounded, text: 'Risk Profili'),
        ],
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
    final bool isPositive = change.startsWith('+');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                decoration: BoxDecoration(
                  color: isPositive
                      ? const Color(0xFF10B981).withOpacity(0.1)
                      : const Color(0xFFF59E0B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 12,
                      color: isPositive
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isPositive
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade900,
              letterSpacing: -0.5,
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
      Color iconColor = const Color(0xFF3B82F6)}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(icon, size: 16, color: Colors.grey.shade500),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade100, thickness: 1),
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
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class _SimpleTagChip extends StatelessWidget {
  final String label;
  final Color color;

  const _SimpleTagChip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
          letterSpacing: -0.1,
        ),
      ),
    );
  }
}
