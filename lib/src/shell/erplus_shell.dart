import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_page.dart';
import '../features/customers/customers_page.dart';
import '../features/customers/customer_card_page.dart';
import '../features/customers/customer_list_page.dart';
import '../features/customers/customer_360_page.dart';
import '../features/inventory/inventory_page.dart';
import '../features/sales/sales_page.dart';
import '../features/purchasing/purchasing_page.dart';
import '../features/finance/finance_page.dart';
import '../features/projects/projects_page.dart';
import '../features/hr/hr_page.dart';
import '../features/service/service_page.dart';
import '../features/crm/crm_page.dart';
import '../features/reports/reports_page.dart';
import '../features/integration/integration_page.dart';
import '../features/compliance/compliance_page.dart';
import '../features/settings/settings_page.dart';

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

  // ---------------------------------------------------------------------------
  //  MODÜL LİSTELERİ (L2/L3)
  // ---------------------------------------------------------------------------

  static const _salesModules = [
    _ModuleCard(
      icon: Icons.description_outlined,
      label: 'Teklif Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 8,
      id: 'teklif',
    ),
    _ModuleCard(
      icon: Icons.shopping_cart_outlined,
      label: 'Sipariş Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 6,
      id: 'siparis',
    ),
    _ModuleCard(
      icon: Icons.local_shipping_outlined,
      label: 'Teslimat Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 5,
      id: 'teslimat',
    ),
    _ModuleCard(
      icon: Icons.receipt_long_outlined,
      label: 'Fatura Yönetimi',
      color: Color(0xFF10B981),
      subCount: 7,
      id: 'fatura',
    ),
    _ModuleCard(
      icon: Icons.settings_suggest_outlined,
      label: 'Operasyon Yönetimi',
      color: Color(0xFFF59E0B),
      subCount: 4,
      id: 'operasyon',
    ),
    _ModuleCard(
      icon: Icons.analytics_outlined,
      label: 'Analitik & Raporlama',
      color: Color(0xFFEC4899),
      subCount: 6,
      id: 'analitik',
    ),
  ];

  static const _purchaseModules = [
    _ModuleCard(
      icon: Icons.request_quote_outlined,
      label: 'Talep Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 5,
      id: 'talep',
    ),
    _ModuleCard(
      icon: Icons.rate_review_outlined,
      label: 'Teklif Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 6,
      id: 'teklif',
    ),
    _ModuleCard(
      icon: Icons.shopping_bag_outlined,
      label: 'Sipariş Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 7,
      id: 'siparis',
    ),
    _ModuleCard(
      icon: Icons.inventory_outlined,
      label: 'Mal Kabul Yönetimi',
      color: Color(0xFF10B981),
      subCount: 4,
      id: 'kabul',
    ),
    _ModuleCard(
      icon: Icons.receipt_outlined,
      label: 'Fatura Yönetimi',
      color: Color(0xFFF59E0B),
      subCount: 5,
      id: 'fatura',
    ),
    _ModuleCard(
      icon: Icons.bar_chart_outlined,
      label: 'Analitik & Raporlama',
      color: Color(0xFFEC4899),
      subCount: 6,
      id: 'analitik',
    ),
  ];

  static const _financeModules = [
    _ModuleCard(
      icon: Icons.account_balance_wallet_outlined,
      label: 'Kasa Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 6,
      id: 'kasa',
    ),
    _ModuleCard(
      icon: Icons.account_balance_outlined,
      label: 'Banka Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 8,
      id: 'banka',
    ),
    _ModuleCard(
      icon: Icons.receipt_long_outlined,
      label: 'Çek & Senet Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 7,
      id: 'cek',
    ),
    _ModuleCard(
      icon: Icons.calendar_today_outlined,
      label: 'Bütçe & Plan Yönetimi',
      color: Color(0xFF10B981),
      subCount: 5,
      id: 'plan',
    ),
    _ModuleCard(
      icon: Icons.timeline_outlined,
      label: 'Nakit Akış Yönetimi',
      color: Color(0xFFF59E0B),
      subCount: 4,
      id: 'nakit',
    ),
    _ModuleCard(
      icon: Icons.insights_outlined,
      label: 'Analitik & Raporlama',
      color: Color(0xFFEC4899),
      subCount: 9,
      id: 'analitik',
    ),
  ];

  static const _projectModules = [
    _ModuleCard(
      icon: Icons.create_new_folder_outlined,
      label: 'Proje Oluşturma',
      color: Color(0xFF3B82F6),
      subCount: 6,
      id: 'olusturma',
    ),
    _ModuleCard(
      icon: Icons.event_note_outlined,
      label: 'Planlama & Takvim',
      color: Color(0xFF8B5CF6),
      subCount: 7,
      id: 'planlama',
    ),
    _ModuleCard(
      icon: Icons.group_outlined,
      label: 'Kaynak Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 5,
      id: 'kaynak',
    ),
    _ModuleCard(
      icon: Icons.attach_money_outlined,
      label: 'Bütçe & Maliyet Yönetimi',
      color: Color(0xFF10B981),
      subCount: 6,
      id: 'butce',
    ),
    _ModuleCard(
      icon: Icons.track_changes_outlined,
      label: 'Takip & İzleme',
      color: Color(0xFFF59E0B),
      subCount: 8,
      id: 'takip',
    ),
    _ModuleCard(
      icon: Icons.assessment_outlined,
      label: 'Analitik & Raporlama',
      color: Color(0xFFEC4899),
      subCount: 5,
      id: 'analitik',
    ),
  ];

  static const _hrModules = [
    _ModuleCard(
      icon: Icons.person_add_outlined,
      label: 'Personel Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 9,
      id: 'personel',
    ),
    _ModuleCard(
      icon: Icons.access_time_outlined,
      label: 'Zaman & Devamsızlık',
      color: Color(0xFF8B5CF6),
      subCount: 6,
      id: 'zaman',
    ),
    _ModuleCard(
      icon: Icons.payments_outlined,
      label: 'Bordro Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 7,
      id: 'bordro',
    ),
    _ModuleCard(
      icon: Icons.trending_up_outlined,
      label: 'Performans Yönetimi',
      color: Color(0xFF10B981),
      subCount: 5,
      id: 'performans',
    ),
    _ModuleCard(
      icon: Icons.school_outlined,
      label: 'Eğitim & Gelişim',
      color: Color(0xFFF59E0B),
      subCount: 4,
      id: 'egitim',
    ),
    _ModuleCard(
      icon: Icons.work_outline,
      label: 'İşe Alım & Onboarding',
      color: Color(0xFFEC4899),
      subCount: 6,
      id: 'iseAlim',
    ),
  ];

  static const _serviceModules = [
    _ModuleCard(
      icon: Icons.confirmation_number_outlined,
      label: 'Talep & Ticket Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 7,
      id: 'ticket',
    ),
    _ModuleCard(
      icon: Icons.support_agent_outlined,
      label: 'Saha Servis Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 6,
      id: 'saha',
    ),
    _ModuleCard(
      icon: Icons.build_outlined,
      label: 'Bakım & Onarım Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 5,
      id: 'bakim',
    ),
    _ModuleCard(
      icon: Icons.shield_outlined,
      label: 'Garanti & Kontrat Yönetimi',
      color: Color(0xFF10B981),
      subCount: 4,
      id: 'garanti',
    ),
    _ModuleCard(
      icon: Icons.devices_outlined,
      label: 'Ekipman & Varlık Yönetimi',
      color: Color(0xFFF59E0B),
      subCount: 6,
      id: 'ekipman',
    ),
    _ModuleCard(
      icon: Icons.speed_outlined,
      label: 'SLA & Performans İzleme',
      color: Color(0xFFEC4899),
      subCount: 5,
      id: 'sla',
    ),
  ];

  static const _crmModules = [
    _ModuleCard(
      icon: Icons.person_search_outlined,
      label: 'Fırsat Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 6,
      id: 'firsat',
    ),
    _ModuleCard(
      icon: Icons.campaign_outlined,
      label: 'Kampanya Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 5,
      id: 'kampanya',
    ),
    _ModuleCard(
      icon: Icons.call_outlined,
      label: 'Aktivite Yönetimi',
      color: Color(0xFF06B6D4),
      subCount: 7,
      id: 'aktivite',
    ),
    _ModuleCard(
      icon: Icons.star_outline,
      label: 'Sadakat & Bağlılık',
      color: Color(0xFF10B981),
      subCount: 4,
      id: 'sadakat',
    ),
    _ModuleCard(
      icon: Icons.show_chart_outlined,
      label: 'Analitik & Raporlama',
      color: Color(0xFFEC4899),
      subCount: 8,
      id: 'analitik',
    ),
  ];

  static const _reportingModules = [
    _ModuleCard(
      icon: Icons.dashboard_customize_outlined,
      label: 'Dashboard Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 5,
      id: 'dashboard',
    ),
    _ModuleCard(
      icon: Icons.list_alt_outlined,
      label: 'Standart Raporlar',
      color: Color(0xFF8B5CF6),
      subCount: 12,
      id: 'standart',
    ),
    _ModuleCard(
      icon: Icons.tune_outlined,
      label: 'Özel Rapor Editörü',
      color: Color(0xFF06B6D4),
      subCount: 8,
      id: 'ozel',
    ),
  ];

  static const _integrationModules = [
    _ModuleCard(
      icon: Icons.api_outlined,
      label: 'API Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 4,
      id: 'api',
    ),
    _ModuleCard(
      icon: Icons.email_outlined,
      label: 'E-posta Entegrasyonu',
      color: Color(0xFF8B5CF6),
      subCount: 3,
      id: 'eposta',
    ),
    _ModuleCard(
      icon: Icons.shopping_cart_outlined,
      label: 'E-ticaret Entegrasyonu',
      color: Color(0xFF06B6D4),
      subCount: 5,
      id: 'eticaret',
    ),
    _ModuleCard(
      icon: Icons.receipt_outlined,
      label: 'E-Fatura/Arşiv',
      color: Color(0xFF10B981),
      subCount: 4,
      id: 'efatura',
    ),
    _ModuleCard(
      icon: Icons.storage_outlined,
      label: 'Veri İçe/Dışa Aktarma',
      color: Color(0xFFF59E0B),
      subCount: 6,
      id: 'veri',
    ),
  ];

  static const _complianceModules = [
    _ModuleCard(
      icon: Icons.policy_outlined,
      label: 'KVKK Yönetimi',
      color: Color(0xFF3B82F6),
      subCount: 5,
      id: 'kvkk',
    ),
    _ModuleCard(
      icon: Icons.security_outlined,
      label: 'Denetim & Loglama',
      color: Color(0xFF8B5CF6),
      subCount: 6,
      id: 'denetim',
    ),
    _ModuleCard(
      icon: Icons.verified_user_outlined,
      label: 'Yetkilendirme & Roller',
      color: Color(0xFF06B6D4),
      subCount: 4,
      id: 'yetkilendirme',
    ),
  ];

  static const _settingsModules = [
    _ModuleCard(
      icon: Icons.business_outlined,
      label: 'Şirket Ayarları',
      color: Color(0xFF3B82F6),
      subCount: 8,
      id: 'sirket',
    ),
    _ModuleCard(
      icon: Icons.people_outlined,
      label: 'Kullanıcı Yönetimi',
      color: Color(0xFF8B5CF6),
      subCount: 5,
      id: 'kullanici',
    ),
    _ModuleCard(
      icon: Icons.edit_notifications_outlined,
      label: 'Bildirim Ayarları',
      color: Color(0xFF06B6D4),
      subCount: 4,
      id: 'bildirim',
    ),
    _ModuleCard(
      icon: Icons.language_outlined,
      label: 'Dil & Bölge Ayarları',
      color: Color(0xFF10B981),
      subCount: 3,
      id: 'dil',
    ),
    _ModuleCard(
      icon: Icons.backup_outlined,
      label: 'Yedekleme & Geri Yükleme',
      color: Color(0xFFF59E0B),
      subCount: 4,
      id: 'yedekleme',
    ),
  ];

  static const _menuItems = <_MenuItem>[
    _MenuItem(Icons.space_dashboard_rounded, 'Dashboard', Color(0xFF007AFF)),
    _MenuItem(Icons.groups_rounded, 'Cari Hesap Yönetimi', Color(0xFF34C759)),
    _MenuItem(
        Icons.inventory_2_rounded, 'Stok & Ürün Yönetimi', Color(0xFFFF9500)),
    _MenuItem(Icons.trending_up_rounded, 'Satış Yönetimi', Color(0xFFFF3B30)),
    _MenuItem(
        Icons.shopping_bag_rounded, 'Satın Alma Yönetimi', Color(0xFF5856D6)),
    _MenuItem(Icons.account_balance_wallet_rounded, 'Finans Yönetimi',
        Color(0xFF00C7BE)),
    _MenuItem(Icons.timeline_rounded, 'Proje Yönetimi', Color(0xFFFF2D55)),
    _MenuItem(Icons.badge_rounded, 'İK Yönetimi', Color(0xFFAF52DE)),
    _MenuItem(Icons.build_circle_rounded, 'Servis Yönetimi', Color(0xFFFFCC00)),
    _MenuItem(Icons.hub_rounded, 'CRM Yönetimi', Color(0xFF32ADE6)),
    _MenuItem(Icons.insights_rounded, 'Raporlama Yönetimi', Color(0xFFFF6482)),
    _MenuItem(
        Icons.device_hub_rounded, 'Entegrasyon Yönetimi', Color(0xFF8E8E93)),
    _MenuItem(
        Icons.verified_user_rounded, 'Uyumluluk Yönetimi', Color(0xFF5AC8FA)),
    _MenuItem(Icons.tune_rounded, 'Ayarlar Yönetimi', Color(0xFF64D2FF)),
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
      case 1: // Cari
        builder = (ctx) => CustomersPage(
              onOpenCustomerCard: _openCustomerCardTab,
              onOpenCustomerList: _openCustomerListTab,
              onOpenCustomer360: _openCustomer360Tab,
            );
        break;
      case 2: // Stok
        builder = (ctx) => InventoryPage(
              onOpenSubModule: _openInventorySubModule,
            );
        break;
      case 3: // Satış
        builder = (ctx) => const SalesPage();
        break;
      case 4: // Satın Alma
        builder = (ctx) => const PurchasingPage();
        break;
      case 5: // Finans
        builder = (ctx) => const FinancePage();
        break;
      case 6: // Proje
        builder = (ctx) => const ProjectsPage();
        break;
      case 7: // İK
        builder = (ctx) => const HrPage();
        break;
      case 8: // Servis
        builder = (ctx) => const ServicePage();
        break;
      case 9: // CRM
        builder = (ctx) => const CrmPage();
        break;
      case 10: // Raporlama
        builder = (ctx) => const ReportsPage();
        break;
      case 11: // Entegrasyon
        builder = (ctx) => const IntegrationPage();
        break;
      case 12: // Uyumluluk
        builder = (ctx) => const CompliancePage();
        break;
      case 13: // Ayarlar
        builder = (ctx) => const SettingsPage();
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
  //  TAB SCROLL KONTROLÜ
  // ---------------------------------------------------------------------------

  /// Tab scroll kontrolü için
  final ScrollController _tabScrollController = ScrollController();

  /// Aktif sekmeyi görünür alana kaydır
  void _scrollToActiveTab() {
    if (_activeTabId == null || _tabs.isEmpty) return;

    final activeIndex = _tabs.indexWhere((tab) => tab.id == _activeTabId);
    if (activeIndex == -1) return;

    // Eğer scroll controller hazırsa kaydır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabScrollController.hasClients) {
        // Son sekmeye kaydırmak için maxScrollExtent kullan
        // Bu, yeni eklenen sekmenin görünür olmasını sağlar
        _tabScrollController.animateTo(
          _tabScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    super.dispose();
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
    _scrollToActiveTab();
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
          builder: (ctx) => CustomerCardPage(
            onClose: () => _closeTab(id),
            customerId: null,
          ),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 1; // Cari modülü
    });
    _scrollToActiveTab();
  }

  void _openCustomerListTab() {
    const id = 'customer_list';

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: Icons.list_alt_rounded,
          label: 'Müşteri Listesi',
          builder: (ctx) => CustomerListPage(
            onOpenCustomerCard: (customerId) => _openCustomerCardTab(),
          ),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 1; // Cari modülü
    });
    _scrollToActiveTab();
  }

  void _openCustomer360Tab() {
    const id = 'customer_360';

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: Icons.dashboard_customize_outlined,
          label: 'Müşteri 360',
          builder: (ctx) => const Customer360Page(),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 1; // Cari modülü
    });
    _scrollToActiveTab();
  }

  void _openInventorySubModule(String subModuleId) {
    final id = 'inventory_$subModuleId';

    final moduleNames = {
      'urun': 'Ürün Yönetimi',
      'varyant': 'Varyant & Barkod',
      'depo': 'Depo & Lokasyon',
      'hareket': 'Envanter Hareketleri',
      'sayim': 'Sayım & Uyum',
      'kalite': 'Kalite & Uygunluk',
      'planlama': 'Tedarik & Planlama',
      'maliyet': 'Maliyet & Fiyat',
      'analitik': 'Analitik & Raporlama',
      'entegr': 'Entegrasyonlar',
      'hizmet': 'Hizmet Yönetimi',
      'ayarlar': 'Ayarlar & Sözlükler',
    };

    final moduleIcons = {
      'urun': Icons.inventory_2_rounded,
      'varyant': Icons.view_module_rounded,
      'depo': Icons.warehouse_rounded,
      'hareket': Icons.sync_alt_rounded,
      'sayim': Icons.rule_folder_rounded,
      'kalite': Icons.verified_rounded,
      'planlama': Icons.event_repeat_rounded,
      'maliyet': Icons.price_change_rounded,
      'analitik': Icons.insights_rounded,
      'entegr': Icons.hub_rounded,
      'hizmet': Icons.design_services_rounded,
      'ayarlar': Icons.tune_rounded,
    };

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: moduleIcons[subModuleId] ?? Icons.category_rounded,
          label: moduleNames[subModuleId] ?? subModuleId,
          builder: (ctx) => _PlaceholderPage(
            title: moduleNames[subModuleId] ?? subModuleId,
          ),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 2; // Stok modülü
    });
    _scrollToActiveTab();
  }

  void _openSalesSubModule(String subModuleId) {
    final id = 'sales_$subModuleId';
    final card = _salesModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 3;
    });
  }

  void _openPurchaseSubModule(String subModuleId) {
    final id = 'purchase_$subModuleId';
    final card = _purchaseModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 4;
    });
  }

  void _openFinanceSubModule(String subModuleId) {
    final id = 'finance_$subModuleId';
    final card = _financeModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 5;
    });
  }

  void _openProjectSubModule(String subModuleId) {
    final id = 'project_$subModuleId';
    final card = _projectModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 6;
    });
  }

  void _openHRSubModule(String subModuleId) {
    final id = 'hr_$subModuleId';
    final card = _hrModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 7;
    });
  }

  void _openServiceSubModule(String subModuleId) {
    final id = 'service_$subModuleId';
    final card = _serviceModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 8;
    });
  }

  void _openCRMSubModule(String subModuleId) {
    final id = 'crm_$subModuleId';
    final card = _crmModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 9;
    });
  }

  void _openReportingSubModule(String subModuleId) {
    final id = 'reporting_$subModuleId';
    final card = _reportingModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 10;
    });
  }

  void _openIntegrationSubModule(String subModuleId) {
    final id = 'integration_$subModuleId';
    final card = _integrationModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 11;
    });
  }

  void _openComplianceSubModule(String subModuleId) {
    final id = 'compliance_$subModuleId';
    final card = _complianceModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 12;
    });
  }

  void _openSettingsSubModule(String subModuleId) {
    final id = 'settings_$subModuleId';
    final card = _settingsModules.firstWhere((m) => m.id == subModuleId);

    final existingIndex = _tabs.indexWhere((t) => t.id == id);
    if (existingIndex == -1) {
      _tabs.add(
        _WorkspaceTabItem(
          id: id,
          icon: card.icon,
          label: card.label,
          builder: (ctx) => _PlaceholderPage(title: card.label),
        ),
      );
    }

    setState(() {
      _activeTabId = id;
      _selectedMenuIndex = 13;
    });
  }

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

    // 💻 Desktop / Tablet - YENİ YAPI
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // HEADER (Üst - Rounded)
              _buildTopHeader(),
              const SizedBox(height: 12),

              // ORTA ALAN (Sidebar + Content)
              Expanded(
                child: Row(
                  children: [
                    // Sol Sidebar
                    _buildCompactSidebar(),
                    const SizedBox(width: 12),
                    // Sağ İçerik
                    Expanded(child: _buildMainContent(theme)),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // FOOTER (Alt - Rounded)
              _buildBottomFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // Header Widget
  Widget _buildTopHeader() {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Logo
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text(
                'E',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Eksen ERP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Text(
                    'v2.0 Pro',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF86868B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Enterprise',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF34C759),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Kullanıcı bilgisi alanı (header'ın parçası gibi, sağa yapışık)
          Container(
            height: 60,
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
              ),
              border: Border(
                left: BorderSide(color: const Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'SA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Selman Aksaya',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF34C759),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Sistem Yöneticisi',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF86868B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Color(0xFF86868B),
                ),
                const SizedBox(width: 12),
                // Dikey çizgi
                Container(
                  width: 1,
                  height: 32,
                  color: const Color(0xFFE2E8F0),
                ),
                const SizedBox(width: 12),
                // Ayarlar ikonu
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings_outlined, size: 20),
                  color: const Color(0xFF86868B),
                  tooltip: 'Ayarlar',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Compact Sidebar
  Widget _buildCompactSidebar() {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'MODÜLLER',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF86868B),
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                final selected = _selectedMenuIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openModuleFromSidebar(index),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: selected
                              ? item.color.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 18,
                              color: selected
                                  ? item.color
                                  : const Color(0xFF86868B),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: selected
                                      ? item.color
                                      : const Color(0xFF1D1D1F),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Main Content
  Widget _buildMainContent(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (_tabs.isNotEmpty) ...[
            _buildPageHeader(),
            _buildWorkspaceTabs(),
          ],
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

  // Footer
  Widget _buildBottomFooter() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Text(
            'Eksen ERP Pro Edition',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF86868B),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '© 2025',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF86868B),
            ),
          ),
          const Spacer(),
          const Text(
            'Version 2.0.0',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF86868B),
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Build 1025-12/21',
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF86868B),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF34C759),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Aktif ve Bağlı',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF34C759),
            ),
          ),
        ],
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
          // Workspace tabcontrol (sadece sekme varsa göster)
          if (_tabs.isNotEmpty) ...[
            _buildPageHeader(),
            _buildWorkspaceTabs(),
          ],

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
  //  SAYFA BAŞLIĞI (TAB BAR ÜSTÜNDE)
  // ---------------------------------------------------------------------------

  Widget _buildPageHeader() {
    if (_activeTabId == null) return const SizedBox.shrink();

    // Aktif sekmenin bilgilerini al
    final activeTab = _tabs.firstWhere((t) => t.id == _activeTabId);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xCCFFFFFF), Color(0xB0F9FAFB)],
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: _getHeaderGradient(),
            ),
            child: Icon(
              activeTab.icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activeTab.label,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getPageDescription(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getHeaderGradient() {
    if (_activeTabId == null) {
      return const LinearGradient(
        colors: [Color(0xFF64748B), Color(0xFF334155)],
      );
    }

    // Modül index'e göre gradient belirle
    if (_activeTabId!.startsWith('module_')) {
      final index =
          int.tryParse(_activeTabId!.substring('module_'.length)) ?? 0;

      switch (index) {
        case 1: // Cari Hesap
          return const LinearGradient(
            colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
          );
        case 2: // Stok & Ürün
          return const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          );
        case 3: // Satış
          return const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          );
        case 4: // Satın Alma
          return const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          );
        case 5: // Finans
          return const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          );
        case 6: // Proje
          return const LinearGradient(
            colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
          );
        case 7: // İK
          return const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
          );
        case 8: // Servis
          return const LinearGradient(
            colors: [Color(0xFFF97316), Color(0xFFEA580C)],
          );
        case 9: // CRM
          return const LinearGradient(
            colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
          );
        case 10: // Raporlama
          return const LinearGradient(
            colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
          );
        case 11: // Entegrasyon
          return const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFF6366F1)],
          );
        case 12: // Uyumluluk
          return const LinearGradient(
            colors: [Color(0xFF64748B), Color(0xFF475569)],
          );
        case 13: // Ayarlar
          return const LinearGradient(
            colors: [Color(0xFF64748B), Color(0xFF334155)],
          );
        default:
          return const LinearGradient(
            colors: [Color(0xFF64748B), Color(0xFF334155)],
          );
      }
    }

    return const LinearGradient(
      colors: [Color(0xFF38BDF8), Color(0xFF6366F1)],
    );
  }

  String _getPageDescription() {
    if (_activeTabId == null) return '';

    if (_activeTabId!.startsWith('module_')) {
      final index =
          int.tryParse(_activeTabId!.substring('module_'.length)) ?? 0;

      switch (index) {
        case 1:
          return 'Müşteri ve tedarikçi tüm cari hesap fonksiyonlarına tek merkezden erişin.';
        case 2:
          return 'Ürün, stok ve envanter yönetimi işlemlerinizi buradan yönetin.';
        case 3:
          return 'Satış süreçlerinizi teklif, sipariş ve faturalama ile yönetin.';
        case 4:
          return 'Tedarik, sipariş ve satın alma operasyonlarınızı takip edin.';
        case 5:
          return 'Finans, muhasebe ve bütçe yönetimi işlemlerinizi gerçekleştirin.';
        case 6:
          return 'Proje planlama, takip ve kaynak yönetimi işlemlerinizi yapın.';
        case 7:
          return 'İnsan kaynakları, bordro ve personel yönetimi süreçlerinizi yönetin.';
        case 8:
          return 'Servis talepleri, bakım ve destek süreçlerinizi takip edin.';
        case 9:
          return 'Müşteri ilişkileri, satış ve pazarlama faaliyetlerinizi yönetin.';
        case 10:
          return 'Raporlar, analizler ve iş zekası araçlarına erişin.';
        case 11:
          return 'Sistem entegrasyonları ve API yönetimi işlemlerinizi yapın.';
        case 12:
          return 'Uyumluluk, risk yönetimi ve denetim süreçlerinizi takip edin.';
        case 13:
          return 'Sistem ayarları, parametreler ve bildirim yönetimi.';
        default:
          return '';
      }
    }

    return '';
  }

  // ---------------------------------------------------------------------------
  //  WORKSPACE TABCONTROL
  // ---------------------------------------------------------------------------

  Widget _buildWorkspaceTabs() {
    return Container(
      height: 46,
      padding:
          const EdgeInsets.fromLTRB(12, 6, 12, 0), // Alt padding kaldırıldı
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
      child: Scrollbar(
        controller: _tabScrollController,
        thumbVisibility: true,
        trackVisibility: true,
        thickness: 6,
        radius: const Radius.circular(3),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 6), // Scrollbar için boşluk
          child: ListView.separated(
            controller: _tabScrollController,
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
                    _scrollToActiveTab();
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
                            fontWeight:
                                isActive ? FontWeight.w600 : FontWeight.w500,
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
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  //  SIDEBAR (Apple Premium Design - Dark Theme)
  // ---------------------------------------------------------------------------

  Widget _buildSidebarPanel() {
    return Container(
      width: 360,
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
        // Premium Full-Width Header - Apple Style
        Container(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF2563EB).withOpacity(0.12),
                const Color(0xFF38BDF8).withOpacity(0.08),
                Colors.white.withOpacity(0.03),
              ],
            ),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Logo
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2563EB),
                      Color(0xFF38BDF8),
                      Color(0xFF60C4FF),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withOpacity(0.4),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color(0xFF38BDF8).withOpacity(0.3),
                      blurRadius: 24,
                      spreadRadius: 2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  size: 26,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              // Başlık ve Slogan
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ERPlus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Kurumsal Yönetim',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Kompakt Kullanıcı Profil Paneli
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar - Kullanıcı
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF2563EB),
                            Color(0xFF38BDF8),
                            Color(0xFF60C4FF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                          BoxShadow(
                            color: const Color(0xFF38BDF8).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Kullanıcı Bilgisi
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selman',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Admin',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '192.168.1.100',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Aksiyon Butonları
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      icon: Icons.notifications_rounded,
                      hasNotification: true,
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.mail_rounded,
                      hasNotification: true,
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.person_rounded,
                      onTap: () {},
                    ),
                    _buildActionButton(
                      icon: Icons.logout_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Ayırıcı çizgi
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
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
          padding: EdgeInsets.fromLTRB(16, 6, 16, 3),
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              final item = _menuItems[index];
              final selected = index == _selectedMenuIndex;
              return _buildMenuItem(item, index, selected, isDrawer);
            },
          ),
        ),

        // Footer separator
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
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

        // Alt bilgi
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 10),
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
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF38BDF8).withOpacity(0.15)
                        : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Icon(
                    item.icon,
                    size: 18,
                    color: selected
                        ? const Color(0xFF38BDF8)
                        : Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : Colors.white.withOpacity(0.82),
                      fontSize: 12.5,
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
                    size: 16,
                    color: Color(0xFF38BDF8),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Premium aksiyon butonları
  Widget _buildActionButton({
    required IconData icon,
    bool hasNotification = false,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: Colors.white.withOpacity(0.85),
              ),
              if (hasNotification)
                Positioned(
                  top: 6,
                  right: 6,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF34C759),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF34C759).withOpacity(0.6),
                                blurRadius: 4,
                                spreadRadius: value * 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    onEnd: () {
                      // Sonsuz animasyon için tekrar başlat
                      if (mounted) {
                        setState(() {});
                      }
                    },
                  ),
                ),
            ],
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
  final Color color;
  const _MenuItem(this.icon, this.label, this.color);
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

// Modern Module Page with Grid Layout
class _ModulePage extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_ModuleCard> modules;
  final Function(String) onOpenSubModule;

  const _ModulePage({
    required this.title,
    required this.icon,
    required this.modules,
    required this.onOpenSubModule,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F7),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1).withOpacity(0.1),
                          const Color(0xFF8B5CF6).withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, size: 32, color: const Color(0xFF6366F1)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${modules.length} modül mevcut',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 280,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.3,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final module = modules[index];
                  return _buildModuleCard(module, context);
                },
                childCount: modules.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCard(_ModuleCard module, BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => onOpenSubModule(module.id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: module.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(module.icon, size: 24, color: module.color),
              ),
              const Spacer(),
              Text(
                module.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '${module.subCount} alt modül',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final int subCount;

  const _ModuleCard({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    required this.subCount,
  });
}
