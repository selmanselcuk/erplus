import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF5F5F7), Color(0xFFFFFFFF)],
        ),
      ),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 32),
          _buildQuickStats(),
          const SizedBox(height: 32),
          _buildMetricsGrid(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return FadeTransition(
      opacity: _animationController,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF007AFF).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.chart_bar_square_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1D1D1F),
                    letterSpacing: -1.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Hoş geldiniz! İşletme performansınıza göz atın',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF8E8E93),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF007AFF).withOpacity(0.3),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                child: _buildQuickStatItem(
                  'Bugün',
                  '₺45,890',
                  CupertinoIcons.money_dollar_circle_fill,
                  '+12.5%',
                ),
              ),
              Container(
                width: 1,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              Expanded(
                child: _buildQuickStatItem(
                  'Bu Ay',
                  '₺1.2M',
                  CupertinoIcons.calendar_circle_fill,
                  '+8.2%',
                ),
              ),
              Container(
                width: 1,
                color: Colors.white.withOpacity(0.3),
                margin: const EdgeInsets.symmetric(vertical: 8),
              ),
              Expanded(
                child: _buildQuickStatItem(
                  'Bu Yıl',
                  '₺12.5M',
                  CupertinoIcons.chart_bar_circle_fill,
                  '+15.7%',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatItem(
    String label,
    String value,
    IconData icon,
    String change,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.white.withOpacity(0.9)),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF34C759).withOpacity(0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: const Color(0xFF34C759).withOpacity(0.4),
                width: 1,
              ),
            ),
            child: Text(
              change,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF34C759),
                letterSpacing: -0.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 2;
        if (width >= 1200) {
          columns = 4;
        } else if (width >= 800) {
          columns = 3;
        }

        final metrics = [
          _MetricData(
            'Toplam Satış',
            '₺1,234,567',
            CupertinoIcons.chart_bar_alt_fill,
            const Color(0xFF34C759),
            '+12.5%',
            '₺145,890',
          ),
          _MetricData(
            'Müşteriler',
            '1,234',
            CupertinoIcons.person_2_fill,
            const Color(0xFF007AFF),
            '+8.3%',
            '89 yeni',
          ),
          _MetricData(
            'Siparişler',
            '567',
            CupertinoIcons.cart_fill,
            const Color(0xFFFF9500),
            '+15.2%',
            '45 beklemede',
          ),
          _MetricData(
            'Ürünler',
            '890',
            CupertinoIcons.cube_box_fill,
            const Color(0xFF5856D6),
            '+5.1%',
            '23 stokta',
          ),
          _MetricData(
            'Gelir',
            '₺890,450',
            CupertinoIcons.money_dollar_circle_fill,
            const Color(0xFF00C7BE),
            '+18.9%',
            'Bu ay',
          ),
          _MetricData(
            'Gider',
            '₺345,120',
            CupertinoIcons.arrow_down_circle_fill,
            const Color(0xFFFF3B30),
            '-3.2%',
            'Bu ay',
          ),
          _MetricData(
            'Kar',
            '₺545,330',
            CupertinoIcons.graph_circle_fill,
            const Color(0xFF32D74B),
            '+25.6%',
            'Net',
          ),
          _MetricData(
            'Bekleyen',
            '₺125,890',
            CupertinoIcons.clock_fill,
            const Color(0xFFFF9F0A),
            '23 adet',
            'Onay bekliyor',
          ),
        ];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.3,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            return FadeTransition(
              opacity: _animationController,
              child: _buildMetricCard(metrics[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildMetricCard(_MetricData metric) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [metric.color, metric.color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: metric.color.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(metric.icon, size: 28, color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: metric.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: metric.color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  metric.change,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: metric.color,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            metric.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8E8E93),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1D1D1F),
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  CupertinoIcons.info_circle_fill,
                  size: 14,
                  color: Color(0xFF8E8E93),
                ),
                const SizedBox(width: 5),
                Text(
                  metric.subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8E8E93),
                    letterSpacing: -0.1,
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

class _MetricData {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String change;
  final String subtitle;

  _MetricData(
    this.title,
    this.value,
    this.icon,
    this.color,
    this.change,
    this.subtitle,
  );
}
