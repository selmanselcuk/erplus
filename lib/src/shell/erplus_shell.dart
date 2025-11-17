import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/customers/customers_page.dart';
import '../features/customers/customer_card_page.dart';

class ERPlusShell extends StatefulWidget {
  const ERPlusShell({super.key});

  @override
  State<ERPlusShell> createState() => _ERPlusShellState();
}

/// Workspace’teki her sekme
class _WorkspaceTabItem {
  final String id; // 'module_0', 'module_1', 'customer_card' vs.
  final IconData icon;
  final String label;
  final WidgetBuilder builder;

  const _WorkspaceTabItem({
    required this.id,
    required this.icon,
    required this.label,
    required this.builder,
  });
}

class _ERPlusShellState extends State<ERPlusShell> {
  /// Soldaki menüde hangi item seçili (sadece highlight için)
  int _selectedMenuIndex = -1; // -1 = hiçbir şey seçili değil

  /// Açık sekmeler listesi (tarayıcı sekmesi gibi)
  final List<_WorkspaceTabItem> _tabs = [];

  /// Şu anda aktif olan sekme id’si (null = boş hoş geldiniz ekranı)
  String? _activeTabId;

  static const _menuItems = <_MenuItem>[
    _MenuItem(Icons.space_dashboard_rounded, 'Dashboard'),
    _MenuItem(Icons.groups_rounded, 'Cari Hesap Yönetimi'),
    _MenuItem(Icons.inventory_2_rounded, 'Ürün Yönetimi'),
    _MenuItem(Icons.trending_up_rounded, 'Satış Yönetimi'),
    _MenuItem(Icons.shopping_bag_rounded, 'Satın Alma Yönetimi'),
    _MenuItem(Icons.account_balance_wallet_rounded, 'Finans Yönetimi'),
    _MenuItem(Icons.timeline_rounded, 'Proje Yönetimi'),
    _MenuItem(Icons.badge_rounded, 'İK Yönetimi'),
    _MenuItem(Icons.build_circle_rounded, 'Servis Yönetimi'),
    _MenuItem(Icons.hub_rounded, 'CRM Yönetimi'),
    _MenuItem(Icons.insights_rounded, 'Raporlama Yönetimi'),
    _MenuItem(Icons.device_hub_rounded, 'Entegrasyon Yönetimi'),
    _MenuItem(Icons.verified_user_rounded, 'Uyumluluk Yönetimi'),
    _MenuItem(Icons.tune_rounded, 'Ayarlar Yönetimi'),
  ];

  // ---------------------------------------------------------------------------
  //  SEKME OLUŞTUR
  // ---------------------------------------------------------------------------

  _WorkspaceTabItem _buildModuleTab(int menuIndex) {
    final menu = _menuItems[menuIndex];

    WidgetBuilder builder;
    switch (menuIndex) {
      case 0:
        builder = (ctx) => const DashboardPage();
        break;
      case 1:
        builder = (ctx) =>
            CustomersPage(onOpenCustomerCard: _openCustomerCardTab);
        break;
      default:
        builder = (ctx) => _PlaceholderPage(title: menu.label);
        break;
    }

    return _WorkspaceTabItem(
      id: 'module_$menuIndex',
      icon: menu.icon,
      label: menu.label,
      builder: builder,
    );
  }

  // ---------------------------------------------------------------------------
  //  SEKME AÇ / AKTİF ET
  // ---------------------------------------------------------------------------

  void _openModuleFromSidebar(int menuIndex) {
    final id = 'module_$menuIndex';

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      // Bu modül için sekme yoksa yeni sekme ekle
      _tabs.add(_buildModuleTab(menuIndex));
    }

    setState(() {
      _selectedMenuIndex = menuIndex;
      _activeTabId = id;
    });
  }

  void _openCustomerCardTab() {
    const id = 'customer_card';

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: Icons.person_rounded,
          label: 'Müşteri Kartı',
          builder: (ctx) => CustomerCardPage(onClose: _closeCustomerCardTab),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 1; // Cari modülü
    });
  }

  void _closeCustomerCardTab() => _closeTab('customer_card');

  void _closeTab(String id) {
    final index = _tabs.indexWhere((t) => t.id == id);
    if (index == -1) return;

    setState(() {
      _tabs.removeAt(index);

      if (_activeTabId == id) {
        // Aktif sekme kapandıysa
        if (_tabs.isEmpty) {
          // Hiç sekme kalmadı → hoş geldiniz
          _activeTabId = null;
          _selectedMenuIndex = -1;
        } else {
          // Soldaki sekmeyi aktif yap
          final newIndex = index > 0 ? index - 1 : 0;
          _activeTabId = _tabs[newIndex].id;

          final newId = _activeTabId!;
          if (newId.startsWith('module_')) {
            _selectedMenuIndex = int.parse(newId.substring('module_'.length));
          } else if (newId == 'customer_card') {
            _selectedMenuIndex = 1;
          }
        }
      }
    });
  }

  // ---------------------------------------------------------------------------
  //  BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width >= 900;

    if (!isWide) {
      // 📱 Mobil
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            _activeTabId == null
                ? 'ERPlus'
                : _tabs.firstWhere((t) => t.id == _activeTabId).label,
          ),
        ),
        drawer: Drawer(
          child: SafeArea(child: _buildSidebarContent(isDrawer: true)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: _buildPageWithHeader(theme),
        ),
      );
    }

    // 💻 Desktop / Tablet
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebarPanel(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildPageWithHeader(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Sağ panel + header + tabcontrol + içerik
  Widget _buildPageWithHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Üst header
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Text(
                  _activeTabId == null
                      ? 'Hoş Geldiniz'
                      : _tabs.firstWhere((t) => t.id == _activeTabId!).label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  '• ERPlus',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: Color(0xFF6B7280),
                  ),
                  tooltip: 'Ara',
                ),
              ],
            ),
          ),

          // Workspace tabcontrol (sadece sekme varsa göster)
          if (_tabs.isNotEmpty) _buildWorkspaceTabs(),

          // İçerik
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _activeTabId == null
                  ? _buildWelcomeScreen()
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 260),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: const Offset(0.02, 0),
                          end: Offset.zero,
                        ).animate(animation);

                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          ),
                        );
                      },
                      child: KeyedSubtree(
                        key: ValueKey(_activeTabId),
                        child: _tabs
                            .firstWhere((t) => t.id == _activeTabId)
                            .builder(context),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  HOŞ GELDİNİZ EKRANI
  // ---------------------------------------------------------------------------

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Premium ana icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF007AFF), Color(0xFF5AC8FA)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF007AFF).withOpacity(0.3),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Hoş Geldiniz, Selman',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1F),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Başlamak için soldaki menüden bir modül seçiniz',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF86868B).withOpacity(0.8),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildQuickAccessCard(
                icon: Icons.space_dashboard_rounded,
                label: 'Dashboard',
                color: const Color(0xFF007AFF),
                onTap: () => _openModuleFromSidebar(0),
              ),
              _buildQuickAccessCard(
                icon: Icons.groups_rounded,
                label: 'Cari Hesap',
                color: const Color(0xFF34C759),
                onTap: () => _openModuleFromSidebar(1),
              ),
              _buildQuickAccessCard(
                icon: Icons.inventory_2_rounded,
                label: 'Ürün Yönetimi',
                color: const Color(0xFFFF9500),
                onTap: () => _openModuleFromSidebar(2),
              ),
              _buildQuickAccessCard(
                icon: Icons.trending_up_rounded,
                label: 'Satış',
                color: const Color(0xFFFF3B30),
                onTap: () => _openModuleFromSidebar(3),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            // İçerik alanı ile aynı arkaplan
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  // İkon arkaplanı da içerik alanı ile aynı
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 34, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                  letterSpacing: -0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  WORKSPACE TABCONTROL
  // ---------------------------------------------------------------------------

  Widget _buildWorkspaceTabs() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surface, // İçerik alanıyla aynı renk
        border: Border(
          bottom: BorderSide(
            color: Theme.of(
              context,
            ).dividerColor, // İçerik alanıyla aynı border
            width: 0.5,
          ),
        ),
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final isActive = tab.id == _activeTabId;

          return MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _activeTabId = tab.id;

                  if (tab.id.startsWith('module_')) {
                    _selectedMenuIndex = int.parse(
                      tab.id.substring('module_'.length),
                    );
                  } else if (tab.id == 'customer_card') {
                    _selectedMenuIndex = 1;
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: isActive
                      ? const Color(0xFFF5F5F7) // Aktif sekme açık gri
                      : Colors.transparent,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                  border: isActive
                      ? Border.all(
                          color: Colors.black.withOpacity(0.06),
                          width: 0.5,
                        )
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tab.icon,
                      size: 15,
                      color: isActive
                          ? const Color(0xFF007AFF)
                          : const Color(0xFF8E8E93),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tab.label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF1D1D1F)
                            : const Color(0xFF86868B),
                        letterSpacing: -0.08,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // X butonu
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _closeTab(tab.id),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive
                                ? const Color(0xFFE5E5EA)
                                : Colors.transparent,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.close_rounded,
                              size: 11,
                              color: isActive
                                  ? const Color(0xFF86868B)
                                  : const Color(0xFFAEAEB2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SIDEBAR (Apple Premium Design - Dark Theme)
  // ---------------------------------------------------------------------------

  Widget _buildSidebarPanel() {
    return Container(
      width: 280, // Biraz daha geniş
      padding: const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          // Önceki koyu renk korundu
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black.withOpacity(0.5), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: _buildSidebarContent(),
      ),
    );
  }

  Widget _buildSidebarContent({bool isDrawer = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo - Apple Style Dark
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ERPlus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Kurumsal Yönetim',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // İnce ayırıcı çizgi - Apple style
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),

        // Modüller başlığı
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'MODÜLLER',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Menü listesi
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              final selected = index == _selectedMenuIndex;
              return _buildMenuItem(item, index, selected, isDrawer);
            },
          ),
        ),

        // Alt ayırıcı
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 0.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.0),
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.0),
              ],
            ),
          ),
        ),

        // Alt profil - Apple Style Dark
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF2563EB), Color(0xFF38BDF8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selman',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                        ),
                        Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 16,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Alt bilgi
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '© 2025 ERPlus',
                style: TextStyle(
                  color: Colors.white38,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'v1.0.0 • Flutter UI Shell',
                style: TextStyle(
                  color: Colors.white24,
                  fontSize: 9,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    _MenuItem item,
    int index,
    bool selected,
    bool isDrawer,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            _openModuleFromSidebar(index);
            if (isDrawer) Navigator.of(context).pop();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? Colors.white.withOpacity(0.1) // Apple dark aktif bg
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8), // Apple 8px radius
              border: selected
                  ? Border.all(
                      color: const Color(0xFF38BDF8).withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Row(
              children: [
                // Icon container
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF38BDF8).withOpacity(0.15)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: selected
                        ? const Color(0xFF38BDF8)
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.82),
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      letterSpacing: -0.08,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Seçili ok işareti
                if (selected)
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: Color(0xFF38BDF8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
//  YARDIMCI SINIFLAR
// ---------------------------------------------------------------------------

class _SidebarSeparator extends StatelessWidget {
  const _SidebarSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.0),
            Colors.white.withOpacity(0.55),
            Colors.white.withOpacity(0.0),
          ],
        ),
      ),
    );
  }
}

class _SidebarFooter extends StatelessWidget {
  const _SidebarFooter();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '© 2025 ERPlus',
            style: TextStyle(color: Colors.white38, fontSize: 11),
          ),
          SizedBox(height: 2),
          Text(
            'v1.0.0 • Flutter UI Shell',
            style: TextStyle(color: Colors.white24, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  const _MenuItem(this.icon, this.label);
}

class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$title (yakında)',
        style: const TextStyle(color: Color(0xFF6B7280), fontSize: 18),
      ),
    );
  }
}
