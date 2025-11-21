import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        // KPI Cards (Üst Metrikler)
        _buildKPICards(context),
        const SizedBox(height: 24),

        // Grafikler Satırı (Gelir + Gider)
        _buildChartsRow(context),
        const SizedBox(height: 24),

        // Alt Bölüm: Son İşlemler, Bekleyen Ödemeler, Stok Durumu
        _buildBottomSection(context),
      ],
    );
  }

  Widget _buildKPICards(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 4;
        if (width < 1200) {
          columns = 2;
        } else if (width < 800) {
          columns = 1;
        }

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: columns,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
          children: [
            _buildKPICard(
              'Toplam Cari Bakiye',
              '₺2.458.750',
              '+12.5%',
              true,
              Icons.account_balance_wallet_rounded,
              const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF6366F1)]),
            ),
            _buildKPICard(
              'Gunluk Satis',
              '₺185.240',
              '+8.3%',
              true,
              Icons.trending_up_rounded,
              const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF3B82F6)]),
            ),
            _buildKPICard(
              'Stok Degeri',
              '₺1.875.300',
              '-2.1%',
              false,
              Icons.inventory_2_rounded,
              const LinearGradient(
                  colors: [Color(0xFFEC4899), Color(0xFFF97316)]),
            ),
            _buildKPICard(
              'Bekleyen Siparisler',
              '47',
              '+5',
              true,
              Icons.pending_actions_rounded,
              const LinearGradient(
                  colors: [Color(0xFFF59E0B), Color(0xFFEF4444)]),
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(
    String title,
    String value,
    String change,
    bool isPositive,
    IconData icon,
    LinearGradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    isPositive
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 14,
                    color: isPositive
                        ? const Color(0xFF10B981)
                        : const Color(0xFFEF4444),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    change,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPositive
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'bu ay',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartsRow(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildRevenueChart()),
              const SizedBox(width: 16),
              Expanded(flex: 2, child: _buildExpenseChart()),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRevenueChart(),
              const SizedBox(height: 16),
              _buildExpenseChart(),
            ],
          );
        }
      },
    );
  }

  Widget _buildBottomSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1400) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildRecentTransactions()),
              const SizedBox(width: 16),
              Expanded(child: _buildPendingPayments()),
              const SizedBox(width: 16),
              Expanded(child: _buildStockAlerts()),
            ],
          );
        } else if (constraints.maxWidth >= 900) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRecentTransactions()),
                  const SizedBox(width: 16),
                  Expanded(child: _buildPendingPayments()),
                ],
              ),
              const SizedBox(height: 16),
              _buildStockAlerts(),
            ],
          );
        } else {
          return Column(
            children: [
              _buildRecentTransactions(),
              const SizedBox(height: 16),
              _buildPendingPayments(),
              const SizedBox(height: 16),
              _buildStockAlerts(),
            ],
          );
        }
      },
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gelir Analizi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Son 6 ay',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: Color(0xFF64748B)),
                    SizedBox(width: 6),
                    Text(
                      '2025',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Basit bar chart simulation
          SizedBox(
            height: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar('Haz', 0.6),
                _buildBar('Tem', 0.8),
                _buildBar('Agu', 0.7),
                _buildBar('Eyl', 0.9),
                _buildBar('Eki', 0.85),
                _buildBar('Kas', 0.95),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double height) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Container(
                height: 180 * height,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gider Dagilimi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Bu ay',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          // Donut chart simulation
          SizedBox(
            height: 200,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 30,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor:
                          const AlwaysStoppedAnimation(Color(0xFFEF4444)),
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '₺425K',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Toplam',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildExpenseItem('Personel', '₺185K', 0.44, const Color(0xFFEF4444)),
          _buildExpenseItem(
              'Operasyon', '₺120K', 0.28, const Color(0xFFF59E0B)),
          _buildExpenseItem('Pazarlama', '₺78K', 0.18, const Color(0xFF6366F1)),
          _buildExpenseItem('Diger', '₺42K', 0.10, const Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
      String label, String amount, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${(percent * 100).toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Son Islemler',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Tumunu Gor',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTransactionItem(
            'ABC Ltd.',
            'Satis Faturasi #SF-2401',
            '₺45.800',
            true,
            '10:45',
          ),
          _buildTransactionItem(
            'XYZ A.S.',
            'Alis Faturasi #AF-5621',
            '₺28.500',
            false,
            '09:30',
          ),
          _buildTransactionItem(
            'DEF Tek.',
            'Tahsilat #TH-8842',
            '₺18.200',
            true,
            'Dun',
          ),
          _buildTransactionItem(
            'GHI San.',
            'Odeme #OD-3347',
            '₺32.100',
            false,
            'Dun',
          ),
          _buildTransactionItem(
            'JKL Ltd.',
            'Satis Faturasi #SF-2398',
            '₺67.900',
            true,
            '2 gun once',
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    String company,
    String description,
    String amount,
    bool isIncome,
    String time,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isIncome
                  ? const Color(0xFF10B981).withOpacity(0.1)
                  : const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color:
                  isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isIncome
                      ? const Color(0xFF10B981)
                      : const Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingPayments() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bekleyen Odemeler',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          _buildPaymentItem(
            'MNO Ltd.',
            '₺42.500',
            'Bugun',
            const Color(0xFFEF4444),
            true,
          ),
          _buildPaymentItem(
            'PQR A.S.',
            '₺18.200',
            'Yarin',
            const Color(0xFFF59E0B),
            true,
          ),
          _buildPaymentItem(
            'STU Tek.',
            '₺35.800',
            '3 gun',
            const Color(0xFF10B981),
            false,
          ),
          _buildPaymentItem(
            'VWX San.',
            '₺25.400',
            '5 gun',
            const Color(0xFF10B981),
            false,
          ),
          _buildPaymentItem(
            'YZA Ltd.',
            '₺52.100',
            '1 hafta',
            const Color(0xFF64748B),
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(
    String company,
    String amount,
    String dueDate,
    Color color,
    bool isUrgent,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Vade: $dueDate',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              if (isUrgent)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ACIL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStockAlerts() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Stok Uyarilari',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          _buildStockItem(
            'Urun-A',
            'Kategori-1',
            12,
            50,
            const Color(0xFFEF4444),
          ),
          _buildStockItem(
            'Urun-B',
            'Kategori-2',
            28,
            100,
            const Color(0xFFF59E0B),
          ),
          _buildStockItem(
            'Urun-C',
            'Kategori-1',
            45,
            200,
            const Color(0xFFF59E0B),
          ),
          _buildStockItem(
            'Urun-D',
            'Kategori-3',
            8,
            30,
            const Color(0xFFEF4444),
          ),
          _buildStockItem(
            'Urun-E',
            'Kategori-2',
            65,
            150,
            const Color(0xFF10B981),
          ),
        ],
      ),
    );
  }

  Widget _buildStockItem(
    String product,
    String category,
    int current,
    int min,
    Color color,
  ) {
    final percent = current / min;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      category,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$current / $min',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent > 1 ? 1 : percent,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }
}
