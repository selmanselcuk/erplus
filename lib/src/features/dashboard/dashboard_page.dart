import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Dashboard',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                int columns = 2;
                if (width >= 1200) {
                  columns = 4;
                } else if (width >= 800) {
                  columns = 3;
                }

                return GridView.count(
                  crossAxisCount: columns,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.5,
                  children: [
                    _buildDashboardCard(
                      'Toplam Satış',
                      '₺1,234,567',
                      Icons.trending_up_rounded,
                      const Color(0xFF10B981),
                      const Color(0xFFD1FAE5),
                    ),
                    _buildDashboardCard(
                      'Müşteriler',
                      '1,234',
                      Icons.people_alt_rounded,
                      const Color(0xFF3B82F6),
                      const Color(0xFFDBEAFE),
                    ),
                    _buildDashboardCard(
                      'Siparişler',
                      '567',
                      Icons.shopping_bag_rounded,
                      const Color(0xFFF59E0B),
                      const Color(0xFFFEF3C7),
                    ),
                    _buildDashboardCard(
                      'Ürünler',
                      '890',
                      Icons.inventory_2_rounded,
                      const Color(0xFF8B5CF6),
                      const Color(0xFFEDE9FE),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    String title,
    String value,
    IconData icon,
    Color iconColor,
    Color bgColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 26, color: iconColor),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
