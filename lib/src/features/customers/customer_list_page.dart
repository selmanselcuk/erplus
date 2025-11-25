import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'models/customer_model.dart';
import 'providers/customer_provider.dart';

/// Enterprise-grade Customer List - SAP/Oracle/Apple Design System
class CustomerListPage extends StatefulWidget {
  final Function(String? customerId)? onOpenCustomerCard;

  const CustomerListPage({super.key, this.onOpenCustomerCard});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  // Search & Filter State
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterStatus = 'Tümü';
  String _filterType = 'Tümü';
  String _filterRiskLevel = 'Tümü';
  String _sortBy = 'code';
  bool _sortAscending = true;

  // View State
  String _viewMode = 'table'; // table, card, compact
  bool _showFilters = true;
  bool _showStats = true;
  Customer? _selectedCustomer;

  // Hover & Interaction
  int? _hoveredRowIndex; // Pagination
  int _currentPage = 0;
  final int _itemsPerPage = 50;

  // Column Configuration (SAP-style resizable columns)
  final Map<String, bool> _visibleColumns = {
    'code': true,
    'name': true,
    'type': true,
    'status': true,
    'city': true,
    'phone': true,
    'debit': true,
    'credit': true,
    'balance': true,
    'riskLevel': true,
    'creditLimit': true,
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().loadCustomers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ============================================================================
  // Data Filtering & Sorting
  // ============================================================================

  List<Customer> _getFilteredCustomers(List<Customer> customers) {
    var filtered = customers.where((customer) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery;
        final matchesSearch = customer.code
                .toLowerCase()
                .contains(searchLower) ||
            customer.name.toLowerCase().contains(searchLower) ||
            (customer.city?.toLowerCase().contains(searchLower) ?? false) ||
            (customer.email?.toLowerCase().contains(searchLower) ?? false) ||
            (customer.phone?.toLowerCase().contains(searchLower) ?? false);
        if (!matchesSearch) return false;
      }

      // Status filter
      if (_filterStatus != 'Tümü') {
        if (_filterStatus != customer.status) return false;
      }

      // Type filter
      if (_filterType != 'Tümü' && customer.customerType != _filterType) {
        return false;
      }

      return true;
    }).toList();

    // Sorting
    filtered.sort((a, b) {
      int comparison;
      switch (_sortBy) {
        case 'name':
          comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
        case 'city':
          final cityA = a.city ?? '';
          final cityB = b.city ?? '';
          comparison = cityA.toLowerCase().compareTo(cityB.toLowerCase());
          break;
        case 'status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'type':
          final typeA = a.customerType ?? '';
          final typeB = b.customerType ?? '';
          comparison = typeA.compareTo(typeB);
          break;
        case 'code':
        default:
          comparison = a.code.toLowerCase().compareTo(b.code.toLowerCase());
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  // ============================================================================
  // Main Build
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState();
        }

        if (provider.error != null) {
          return _buildErrorState(provider.error!);
        }

        final filteredList = _getFilteredCustomers(provider.customers);
        final paginatedList = _getPaginatedList(filteredList);

        return Container(
          color: const Color(0xFFF9FAFB),
          child: Column(
            children: [
              _buildTopToolbar(provider),
              if (_showStats) _buildStatsPanel(filteredList),
              if (_showFilters) _buildAdvancedFilters(),
              Expanded(
                child: _viewMode == 'table'
                    ? _buildTableView(paginatedList, filteredList.length)
                    : _viewMode == 'card'
                        ? _buildCardView(paginatedList)
                        : _buildCompactView(paginatedList),
              ),
              _buildBottomBar(filteredList.length),
            ],
          ),
        );
      },
    );
  }

  // ============================================================================
  // Top Toolbar - Apple/SAP Style
  // ============================================================================

  Widget _buildTopToolbar(CustomerProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Title & Count
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Müşteriler',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${provider.customers.length} kayıt',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),

          // Search Bar
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Kod, ünvan, vergi no, email, telefon ile ara...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: -0.2,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF6B7280),
                    size: 20,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFF007AFF),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Action Buttons
          _buildActionButton(
            icon: Icons.filter_list_rounded,
            label: 'Filtreler',
            isActive: _showFilters,
            onPressed: () => setState(() => _showFilters = !_showFilters),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            icon: Icons.refresh_rounded,
            label: 'Yenile',
            onPressed: () => provider.loadCustomers(),
          ),
          const SizedBox(width: 8),

          // View Mode Toggle
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildViewModeButton(Icons.table_rows_rounded, 'table'),
                _buildViewModeButton(Icons.grid_view_rounded, 'card'),
                _buildViewModeButton(Icons.view_list_rounded, 'compact'),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // More Options
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, size: 20),
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: const [
                    Icon(Icons.file_download_rounded,
                        size: 18, color: Color(0xFF059669)),
                    SizedBox(width: 12),
                    Text('Excel\'e Aktar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: const [
                    Icon(Icons.file_upload_rounded,
                        size: 18, color: Color(0xFF3B82F6)),
                    SizedBox(width: 12),
                    Text('Excel\'den İçe Aktar'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'columns',
                child: Row(
                  children: const [
                    Icon(Icons.view_column_rounded,
                        size: 18, color: Color(0xFF6B7280)),
                    SizedBox(width: 12),
                    Text('Sütunları Düzenle'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'stats',
                child: Row(
                  children: [
                    Icon(
                      _showStats
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 18,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 12),
                    Text(_showStats
                        ? 'İstatistikleri Gizle'
                        : 'İstatistikleri Göster'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'stats':
                  setState(() => _showStats = !_showStats);
                  break;
                case 'columns':
                  _showColumnSettings();
                  break;
              }
            },
          ),
          const SizedBox(width: 8),

          // Primary Action - New Customer
          ElevatedButton.icon(
            onPressed: () => widget.onOpenCustomerCard?.call(null),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text(
              'Yeni Müşteri',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    VoidCallback? onPressed,
  }) {
    return Material(
      color: isActive
          ? const Color(0xFF007AFF).withOpacity(0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? const Color(0xFF007AFF)
                    : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF007AFF)
                      : const Color(0xFF374151),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewModeButton(IconData icon, String mode) {
    final isActive = _viewMode == mode;
    return Material(
      color: isActive ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: () => setState(() => _viewMode = mode),
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? const Color(0xFF007AFF) : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Stats Panel - SAP-style Dashboard Cards
  // ============================================================================

  Widget _buildStatsPanel(List<Customer> customers) {
    final activeCount = customers.where((c) => c.status == 'Aktif').length;
    final passiveCount = customers.where((c) => c.status == 'Pasif').length;
    final corporateCount =
        customers.where((c) => c.customerType == 'Kurumsal').length;
    final retailCount =
        customers.where((c) => c.customerType == 'Perakende').length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Toplam Müşteri',
              customers.length.toString(),
              Icons.people_rounded,
              const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Aktif',
              activeCount.toString(),
              Icons.check_circle_rounded,
              const Color(0xFF059669),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Pasif',
              passiveCount.toString(),
              Icons.pause_circle_rounded,
              const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Kurumsal',
              corporateCount.toString(),
              Icons.business_rounded,
              const Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildStatCard(
              'Perakende',
              retailCount.toString(),
              Icons.shopping_cart_rounded,
              const Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xFFE0E0E0),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF605E5C)),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF605E5C),
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Advanced Filters - SAP-style Filter Bar
  // ============================================================================

  Widget _buildAdvancedFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _buildFilterChip(
            'Durum',
            _filterStatus,
            ['Tümü', 'Aktif', 'Pasif', 'Blokeli'],
            (val) => setState(() => _filterStatus = val!),
          ),
          _buildFilterChip(
            'Müşteri Tipi',
            _filterType,
            ['Tümü', 'Perakende', 'Kurumsal', 'Kamu'],
            (val) => setState(() => _filterType = val!),
          ),
          _buildFilterChip(
            'Risk Seviyesi',
            _filterRiskLevel,
            ['Tümü', 'Düşük', 'Orta', 'Yüksek'],
            (val) => setState(() => _filterRiskLevel = val!),
          ),
          if (_searchQuery.isNotEmpty ||
              _filterStatus != 'Tümü' ||
              _filterType != 'Tümü')
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _filterStatus = 'Tümü';
                  _filterType = 'Tümü';
                  _filterRiskLevel = 'Tümü';
                });
              },
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: const Text('Filtreleri Temizle'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
              letterSpacing: -0.2,
            ),
          ),
          DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            icon: const Icon(Icons.arrow_drop_down_rounded, size: 18),
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w600,
              letterSpacing: -0.2,
            ),
            items: options.map((opt) {
              return DropdownMenuItem(value: opt, child: Text(opt));
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Table View - Enterprise Grid
  // ============================================================================

  Widget _buildTableView(List<Customer> customers, int totalCount) {
    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              border: Border(
                bottom: BorderSide(color: Color(0xFFD1D5DB), width: 1),
              ),
            ),
            child: Row(
              children: [
                if (_visibleColumns['code']!)
                  _buildTableHeader('Cari Kodu', 'code', flex: 1.2),
                if (_visibleColumns['name']!)
                  _buildTableHeader('Ünvan', 'name', flex: 2.5),
                if (_visibleColumns['type']!)
                  _buildTableHeader('Tip', 'type', flex: 1.0),
                if (_visibleColumns['status']!)
                  _buildTableHeader('Durum', 'status', flex: 1.0),
                if (_visibleColumns['city']!)
                  _buildTableHeader('Şehir', 'city', flex: 1.2),
                if (_visibleColumns['phone']!)
                  _buildTableHeader('Telefon', 'phone', flex: 1.5),
                if (_visibleColumns['debit']!)
                  _buildTableHeader('Alacak', 'debit', flex: 1.3),
                if (_visibleColumns['credit']!)
                  _buildTableHeader('Borç', 'credit', flex: 1.3),
                if (_visibleColumns['balance']!)
                  _buildTableHeader('Bakiye', 'balance', flex: 1.3),
                if (_visibleColumns['riskLevel']!)
                  _buildTableHeader('Risk', 'riskLevel', flex: 0.9),
                if (_visibleColumns['creditLimit']!)
                  _buildTableHeader('Limit', 'creditLimit', flex: 1.2),
              ],
            ),
          ),

          // Table Body
          Expanded(
            child: customers.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      return _buildTableRow(customers[index], index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(String label, String sortKey, {double flex = 1}) {
    final isActive = _sortBy == sortKey;
    return Expanded(
      flex: (flex * 10).round(),
      child: InkWell(
        onTap: () {
          setState(() {
            if (_sortBy == sortKey) {
              _sortAscending = !_sortAscending;
            } else {
              _sortBy = sortKey;
              _sortAscending = true;
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isActive
                      ? const Color(0xFF0078D4)
                      : const Color(0xFF323130),
                  letterSpacing: 0,
                ),
              ),
              if (isActive) ...[
                const SizedBox(width: 4),
                Icon(
                  _sortAscending
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 14,
                  color: const Color(0xFF007AFF),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(Customer customer, int index) {
    final isHovered = _hoveredRowIndex == index;
    final isEven = index % 2 == 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredRowIndex = index),
      onExit: (_) => setState(() => _hoveredRowIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => widget.onOpenCustomerCard?.call(customer.id),
        child: Container(
          decoration: BoxDecoration(
            color: isHovered
                ? const Color(0xFFE3F2FD)
                : isEven
                    ? Colors.white
                    : const Color(0xFFFAFAFA),
            border: const Border(
              bottom: BorderSide(
                color: Color(0xFFEDEBE9),
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              if (_visibleColumns['code']!)
                _buildTableCell(customer.code, flex: 1.2, isBold: true),
              if (_visibleColumns['name']!)
                _buildTableCell(customer.name, flex: 2.5, isBold: true),
              if (_visibleColumns['type']!)
                _buildTableCell(customer.customerType ?? '-', flex: 1.0),
              if (_visibleColumns['status']!)
                _buildStatusBadge(customer.status, flex: 1.0),
              if (_visibleColumns['city']!)
                _buildTableCell(customer.city ?? '-', flex: 1.2),
              if (_visibleColumns['phone']!)
                _buildTableCell(customer.phone ?? '-', flex: 1.5),
              if (_visibleColumns['debit']!)
                _buildAmountCell(0, flex: 1.3, color: const Color(0xFF059669)),
              if (_visibleColumns['credit']!)
                _buildAmountCell(0, flex: 1.3, color: const Color(0xFFDC2626)),
              if (_visibleColumns['balance']!) _buildAmountCell(0, flex: 1.3),
              if (_visibleColumns['riskLevel']!)
                _buildRiskBadge('Düşük', flex: 0.9),
              if (_visibleColumns['creditLimit']!)
                _buildAmountCell(50000, flex: 1.2, showCurrency: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCell(String text, {double flex = 1, bool isBold = false}) {
    return Expanded(
      flex: (flex * 10).round(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: const Color(0xFF323130),
            letterSpacing: 0,
            height: 1.3,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, {double flex = 1}) {
    Color textColor;
    IconData icon;
    switch (status) {
      case 'Aktif':
        textColor = const Color(0xFF107C10);
        icon = Icons.check_circle;
        break;
      case 'Pasif':
        textColor = const Color(0xFF605E5C);
        icon = Icons.remove_circle_outline;
        break;
      case 'Blokeli':
        textColor = const Color(0xFFA80000);
        icon = Icons.block;
        break;
      default:
        textColor = const Color(0xFF605E5C);
        icon = Icons.help_outline;
    }

    return Expanded(
      flex: (flex * 10).round(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: textColor,
            ),
            const SizedBox(width: 4),
            Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: textColor,
                letterSpacing: 0,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCell(double amount,
      {double flex = 1, Color? color, bool showCurrency = false}) {
    final displayAmount = showCurrency ? amount : amount;
    final amountColor = color ??
        (amount >= 0 ? const Color(0xFF059669) : const Color(0xFFEF4444));

    return Expanded(
      flex: (flex * 10).round(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          _formatAmount(displayAmount),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: amountColor,
            letterSpacing: 0,
            height: 1.3,
          ),
          textAlign: TextAlign.right,
        ),
      ),
    );
  }

  Widget _buildRiskBadge(String riskLevel, {double flex = 1}) {
    Color textColor;
    String indicator;
    switch (riskLevel) {
      case 'Yüksek':
        textColor = const Color(0xFFA80000);
        indicator = '●';
        break;
      case 'Orta':
        textColor = const Color(0xFFCA8A04);
        indicator = '●';
        break;
      case 'Düşük':
        textColor = const Color(0xFF107C10);
        indicator = '●';
        break;
      default:
        textColor = const Color(0xFF605E5C);
        indicator = '○';
    }

    return Expanded(
      flex: (flex * 10).round(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              indicator,
              style: TextStyle(
                fontSize: 10,
                color: textColor,
                height: 1.3,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              riskLevel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF323130),
                letterSpacing: 0,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAmount(double amount) {
    final formatter = NumberFormat('#,##0.00', 'tr_TR');
    return '${formatter.format(amount)} ₺';
  }

  // ============================================================================
  // Card View - Modern Card Layout
  // ============================================================================

  Widget _buildCardView(List<Customer> customers) {
    if (customers.isEmpty) return _buildEmptyState();

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 420,
        childAspectRatio: 1.35,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        return _buildCustomerCard(customers[index]);
      },
    );
  }

  Widget _buildCustomerCard(Customer customer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onOpenCustomerCard?.call(customer.id),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with avatar, name and status
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1F2937), Color(0xFF374151)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1F2937).withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          customer.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                              letterSpacing: -0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                customer.code,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 3,
                                height: 3,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD1D5DB),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                customer.customerType ?? '-',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA3AF),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildSmallStatusBadge(customer.status),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 18),
                // Info rows
                Expanded(
                  child: Column(
                    children: [
                      _buildCardInfoRow(Icons.location_on_rounded,
                          customer.city ?? '-', 'Şehir'),
                      const SizedBox(height: 12),
                      _buildCardInfoRow(Icons.phone_rounded,
                          customer.phone ?? '-', 'Telefon'),
                      const SizedBox(height: 12),
                      _buildCardInfoRow(Icons.email_rounded,
                          customer.email ?? '-', 'E-posta'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 16),
                // Financial summary
                Row(
                  children: [
                    Expanded(
                      child: _buildFinancialMetric(
                        'Alacak',
                        _formatCurrency(0),
                        const Color(0xFF059669),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFF3F4F6),
                    ),
                    Expanded(
                      child: _buildFinancialMetric(
                        'Borç',
                        _formatCurrency(0),
                        const Color(0xFFDC2626),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 32,
                      color: const Color(0xFFF3F4F6),
                    ),
                    Expanded(
                      child: _buildFinancialMetric(
                        'Bakiye',
                        _formatCurrency(0),
                        const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallStatusBadge(String status) {
    Color bgColor, textColor;
    switch (status) {
      case 'Aktif':
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF15803D);
        break;
      case 'Pasif':
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF6B7280);
        break;
      default:
        bgColor = const Color(0xFFF9FAFB);
        textColor = const Color(0xFF6B7280);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
          letterSpacing: -0.2,
        ),
      ),
    );
  }

  Widget _buildCardInfoRow(IconData icon, String text, String label) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialMetric(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9CA3AF),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'tr_TR');
    return '${formatter.format(amount)} ₺';
  }

  // ============================================================================
  // Compact View - Dense List
  // ============================================================================

  Widget _buildCompactView(List<Customer> customers) {
    if (customers.isEmpty) return _buildEmptyState();

    return Container(
      margin: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        itemCount: customers.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return _buildCompactRow(customers[index]);
        },
      ),
    );
  }

  Widget _buildCompactRow(Customer customer) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => widget.onOpenCustomerCard?.call(customer.id),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF007AFF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    customer.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${customer.code} • ${customer.customerType ?? '-'}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  customer.city ?? '-',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              _buildSmallStatusBadge(customer.status),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: () => widget.onOpenCustomerCard?.call(customer.id),
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // Empty & Error States
  // ============================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF007AFF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.people_outline_rounded,
              size: 60,
              color: Color(0xFF007AFF),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Henüz müşteri kaydı bulunmuyor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yeni müşteri eklemek için "Yeni Müşteri" butonuna tıklayın',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => widget.onOpenCustomerCard?.call(null),
            icon: const Icon(Icons.add_rounded),
            label: const Text('İlk Müşterinizi Ekleyin'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Müşteriler yükleniyor...',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 60,
            color: Color(0xFFEF4444),
          ),
          const SizedBox(height: 16),
          Text(
            'Hata: $error',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF111827),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<CustomerProvider>().loadCustomers();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Tekrar Dene'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Bottom Bar - Pagination & Info
  // ============================================================================

  Widget _buildBottomBar(int totalCount) {
    final totalPages = (totalCount / _itemsPerPage).ceil();
    final startIndex = _currentPage * _itemsPerPage + 1;
    final endIndex = ((_currentPage + 1) * _itemsPerPage).clamp(0, totalCount);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: const Color(0xFFE5E7EB), width: 1),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Toplam $totalCount kayıt',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),

          // Pagination
          if (totalCount > _itemsPerPage) ...[
            Text(
              '$startIndex-$endIndex arası gösteriliyor',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6B7280),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.chevron_left_rounded),
              onPressed: _currentPage > 0
                  ? () => setState(() => _currentPage--)
                  : null,
              color: const Color(0xFF374151),
            ),
            Text(
              '${_currentPage + 1} / $totalPages',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
                letterSpacing: -0.2,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right_rounded),
              onPressed: _currentPage < totalPages - 1
                  ? () => setState(() => _currentPage++)
                  : null,
              color: const Color(0xFF374151),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================================
  // Dialogs
  // ============================================================================

  void _showColumnSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sütun Ayarları'),
        content: SizedBox(
          width: 400,
          child: ListView(
            shrinkWrap: true,
            children: _visibleColumns.entries.map((entry) {
              return CheckboxListTile(
                title: Text(_getColumnLabel(entry.key)),
                value: entry.value,
                onChanged: (val) {
                  setState(() {
                    _visibleColumns[entry.key] = val ?? true;
                  });
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  String _getColumnLabel(String key) {
    const labels = {
      'code': 'Cari Kodu',
      'name': 'Ünvan',
      'type': 'Tip',
      'status': 'Durum',
      'city': 'Şehir',
      'phone': 'Telefon',
      'debit': 'Alacak',
      'credit': 'Borç',
      'balance': 'Bakiye',
      'riskLevel': 'Risk Seviyesi',
      'creditLimit': 'Kredi Limiti',
    };
    return labels[key] ?? key;
  }

  // ============================================================================
  // Utilities
  // ============================================================================

  List<Customer> _getPaginatedList(List<Customer> customers) {
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, customers.length);
    return customers.sublist(startIndex, endIndex);
  }
}
