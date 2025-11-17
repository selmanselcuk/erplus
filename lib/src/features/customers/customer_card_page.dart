import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import '../../widgets/toast_notification.dart';

/// Premium tab meta
class _PremiumTabInfo {
  final IconData icon;
  final String label;
  final Color color;
  const _PremiumTabInfo(this.icon, this.label, this.color);
}

/// 🔹 Ultra Premium Apple-style Cari Hesap Kartı
class CustomerCardView extends StatefulWidget {
  final VoidCallback onClose;

  const CustomerCardView({super.key, required this.onClose});

  @override
  State<CustomerCardView> createState() => _CustomerCardViewState();
}

class _CustomerCardViewState extends State<CustomerCardView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  final _scrollController = ScrollController();
  bool _isScrolled = false;

  /// Sekmelerin ikon + başlık + renk bilgisi
  static const List<_PremiumTabInfo> _tabsMeta = [
    _PremiumTabInfo(
      CupertinoIcons.person_circle_fill,
      'Genel',
      Color(0xFF007AFF),
    ),
    _PremiumTabInfo(CupertinoIcons.doc_text_fill, 'Vergi', Color(0xFFFF9500)),
    _PremiumTabInfo(
      CupertinoIcons.phone_circle_fill,
      'İletişim',
      Color(0xFF34C759),
    ),
    _PremiumTabInfo(
      CupertinoIcons.location_circle_fill,
      'Adres',
      Color(0xFFFF3B30),
    ),
    _PremiumTabInfo(
      CupertinoIcons.creditcard_fill,
      'Finansal',
      Color(0xFF5856D6),
    ),
    _PremiumTabInfo(
      CupertinoIcons.chart_bar_circle_fill,
      'Muhasebe',
      Color(0xFFAF52DE),
    ),
  ];

  // FocusNodes
  final _nameFocus = FocusNode();
  final _name2Focus = FocusNode();
  final _firstNameFocus = FocusNode();
  final _lastNameFocus = FocusNode();
  final _taxNoFocus = FocusNode();
  final _taxOfficeFocus = FocusNode();
  final _taxCodeFocus = FocusNode();
  final _identityNoFocus = FocusNode();
  final _mersisNoFocus = FocusNode();
  final _kepFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _mobileFocus = FocusNode();
  final _faxFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _email2Focus = FocusNode();
  final _websiteFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _districtFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _priceListFocus = FocusNode();
  final _discountFocus = FocusNode();
  final _paymentTermFocus = FocusNode();
  final _creditLimitFocus = FocusNode();
  final _riskLimitFocus = FocusNode();
  final _creditDaysFocus = FocusNode();
  final _ibanFocus = FocusNode();
  final _bankNameFocus = FocusNode();
  final _bankBranchFocus = FocusNode();
  final _bankAccountFocus = FocusNode();
  final _accountCodeFocus = FocusNode();
  final _costCenterFocus = FocusNode();
  final _projectCodeFocus = FocusNode();
  final _salesPersonFocus = FocusNode();
  final _regionFocus = FocusNode();

  // Controllers
  final _codeController = TextEditingController(text: '120.001.0001');
  final _nameController = TextEditingController();
  final _name2Controller = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _taxNoController = TextEditingController();
  final _taxOfficeController = TextEditingController();
  final _taxCodeController = TextEditingController();
  final _identityNoController = TextEditingController();
  final _mersisNoController = TextEditingController();
  final _kepAddressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _faxController = TextEditingController();
  final _emailController = TextEditingController();
  final _email2Controller = TextEditingController();
  final _websiteController = TextEditingController();
  final _countryController = TextEditingController(text: 'TR');
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _priceListController = TextEditingController();
  final _discountRateController = TextEditingController(text: '0.00');
  final _paymentTermController = TextEditingController(text: '0');
  final _creditLimitController = TextEditingController(text: '0.00');
  final _riskLimitController = TextEditingController(text: '0.00');
  final _creditDaysController = TextEditingController(text: '0');
  final _accountCodeController = TextEditingController();
  final _costCenterController = TextEditingController();
  final _projectCodeController = TextEditingController();
  final _salesPersonController = TextEditingController();
  final _regionController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankBranchController = TextEditingController();
  final _bankAccountNoController = TextEditingController();

  String _customerType = 'Bireysel';
  String _accountCategory = 'Müşteri';
  String _branch = 'Ankara';
  String _currency = 'TRY';
  String _taxStatus = 'Tam Mükellef';
  String _accountingType = 'Ticari';
  bool _isActive = true;
  bool _isEInvoice = false;
  bool _isEArchive = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabsMeta.length, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 10 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _nameFocus.addListener(() => setState(() {}));
    _name2Focus.addListener(() => setState(() {}));
    _firstNameFocus.addListener(() => setState(() {}));
    _lastNameFocus.addListener(() => setState(() {}));
    _taxNoFocus.addListener(() => setState(() {}));
    _taxOfficeFocus.addListener(() => setState(() {}));
    _taxCodeFocus.addListener(() => setState(() {}));
    _identityNoFocus.addListener(() => setState(() {}));
    _mersisNoFocus.addListener(() => setState(() {}));
    _kepFocus.addListener(() => setState(() {}));
    _phoneFocus.addListener(() => setState(() {}));
    _mobileFocus.addListener(() => setState(() {}));
    _faxFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _email2Focus.addListener(() => setState(() {}));
    _websiteFocus.addListener(() => setState(() {}));
    _cityFocus.addListener(() => setState(() {}));
    _districtFocus.addListener(() => setState(() {}));
    _addressFocus.addListener(() => setState(() {}));
    _postalCodeFocus.addListener(() => setState(() {}));
    _priceListFocus.addListener(() => setState(() {}));
    _discountFocus.addListener(() => setState(() {}));
    _paymentTermFocus.addListener(() => setState(() {}));
    _creditLimitFocus.addListener(() => setState(() {}));
    _riskLimitFocus.addListener(() => setState(() {}));
    _creditDaysFocus.addListener(() => setState(() {}));
    _ibanFocus.addListener(() => setState(() {}));
    _bankNameFocus.addListener(() => setState(() {}));
    _bankBranchFocus.addListener(() => setState(() {}));
    _bankAccountFocus.addListener(() => setState(() {}));
    _accountCodeFocus.addListener(() => setState(() {}));
    _costCenterFocus.addListener(() => setState(() {}));
    _projectCodeFocus.addListener(() => setState(() {}));
    _salesPersonFocus.addListener(() => setState(() {}));
    _regionFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _nameFocus.dispose();
    _name2Focus.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _taxNoFocus.dispose();
    _taxOfficeFocus.dispose();
    _taxCodeFocus.dispose();
    _identityNoFocus.dispose();
    _mersisNoFocus.dispose();
    _kepFocus.dispose();
    _phoneFocus.dispose();
    _mobileFocus.dispose();
    _faxFocus.dispose();
    _emailFocus.dispose();
    _email2Focus.dispose();
    _websiteFocus.dispose();
    _cityFocus.dispose();
    _districtFocus.dispose();
    _addressFocus.dispose();
    _postalCodeFocus.dispose();
    _priceListFocus.dispose();
    _discountFocus.dispose();
    _paymentTermFocus.dispose();
    _creditLimitFocus.dispose();
    _riskLimitFocus.dispose();
    _creditDaysFocus.dispose();
    _ibanFocus.dispose();
    _bankNameFocus.dispose();
    _bankBranchFocus.dispose();
    _bankAccountFocus.dispose();
    _accountCodeFocus.dispose();
    _costCenterFocus.dispose();
    _projectCodeFocus.dispose();
    _salesPersonFocus.dispose();
    _regionFocus.dispose();
    _codeController.dispose();
    _nameController.dispose();
    _name2Controller.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _taxNoController.dispose();
    _taxOfficeController.dispose();
    _taxCodeController.dispose();
    _identityNoController.dispose();
    _mersisNoController.dispose();
    _kepAddressController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _faxController.dispose();
    _emailController.dispose();
    _email2Controller.dispose();
    _websiteController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _priceListController.dispose();
    _discountRateController.dispose();
    _paymentTermController.dispose();
    _creditLimitController.dispose();
    _riskLimitController.dispose();
    _creditDaysController.dispose();
    _accountCodeController.dispose();
    _costCenterController.dispose();
    _projectCodeController.dispose();
    _salesPersonController.dispose();
    _regionController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    _bankBranchController.dispose();
    _bankAccountNoController.dispose();
    super.dispose();
  }

  // Vergi numarası sorgulama
  Future<void> _queryTaxNumber() async {
    if (_taxNoController.text.isEmpty) {
      _showError('Lütfen vergi numarası giriniz');
      return;
    }
    _showLoading();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
    setState(() {
      _nameController.text = 'ABC TEKNOLOJİ A.Ş.';
      _taxOfficeController.text = 'Kadıköy';
    });
    _showSuccess("GİB'den bilgiler alındı:\nABC TEKNOLOJİ A.Ş. - Kadıköy VD");
  }

  // TC Kimlik sorgulama
  Future<void> _queryIdentityNo() async {
    if (_identityNoController.text.isEmpty ||
        _identityNoController.text.length != 11) {
      _showError('Geçerli bir TC kimlik numarası giriniz (11 hane)');
      return;
    }
    _showLoading();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
    _showSuccess(
      'Nüfus kaydından bilgiler alındı:\nAhmet YILMAZ - 1985 doğumlu',
    );
  }

  // MERSİS sorgulama
  Future<void> _queryMersis() async {
    if (_mersisNoController.text.isEmpty) {
      _showError('Lütfen MERSİS numarası giriniz');
      return;
    }
    _showLoading();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
    _showSuccess("MERSİS'ten şirket bilgileri alındı");
  }

  void _showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Center(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 400),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 60,
                          offset: const Offset(0, 30),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFF007AFF),
                            ),
                          ),
                        ),
                        SizedBox(height: 28),
                        Text(
                          'Sorgulanıyor...',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D1D1F),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Lütfen bekleyin',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF8E8E93),
                            letterSpacing: -0.2,
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

  void _showSuccess(String message) {
    ToastNotification.show(
      context,
      message: message,
      type: ToastType.success,
      duration: const Duration(seconds: 4),
    );
  }

  void _showError(String message) {
    ToastNotification.show(
      context,
      message: message,
      type: ToastType.error,
      duration: const Duration(seconds: 4),
    );
  }

  void _showWarning(String message) {
    ToastNotification.show(
      context,
      message: message,
      type: ToastType.warning,
      duration: const Duration(seconds: 4),
    );
  }

  void _showInfo(String message) {
    ToastNotification.show(
      context,
      message: message,
      type: ToastType.info,
      duration: const Duration(seconds: 3),
    );
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      _showSuccess('Cari hesap başarıyla kaydedildi!');
    } else {
      _showError('Lütfen zorunlu alanları doldurunuz');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildGlassmorphicHeader(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGeneralTab(),
                  _buildTaxTab(),
                  _buildContactTab(),
                  _buildAddressTab(),
                  _buildFinancialTab(),
                  _buildAccountingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Ultra Premium Glassmorphic Header
  Widget _buildGlassmorphicHeader() {
    final currentTab = _tabsMeta[_tabController.index];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            currentTab.color.withOpacity(0.15),
            currentTab.color.withOpacity(0.05),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: _isScrolled
                ? Colors.black.withOpacity(0.1)
                : Colors.transparent,
            width: 0.5,
          ),
        ),
        boxShadow: _isScrolled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(
                children: [
                  // Top Action Bar
                  Row(
                    children: [
                      _buildGlassButton(
                        icon: CupertinoIcons.chevron_left,
                        color: const Color(0xFF8E8E93),
                        onTap: widget.onClose,
                      ),
                      const Spacer(),
                      _buildGlassButton(
                        icon: CupertinoIcons.square_arrow_up,
                        color: const Color(0xFF007AFF),
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _buildGlassButton(
                        icon: CupertinoIcons.ellipsis_circle,
                        color: const Color(0xFF8E8E93),
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Customer Info Card
                  _buildCustomerInfoCard(),

                  const SizedBox(height: 16),

                  // Premium Tab Pills
                  _buildPremiumTabPills(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _tabsMeta[_tabController.index].color,
                  _tabsMeta[_tabController.index].color.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: _tabsMeta[_tabController.index].color.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.building_2_fill,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.isEmpty
                      ? 'Yeni Cari Hesap'
                      : _nameController.text,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1F),
                    letterSpacing: -0.4,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _codeController.text,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF007AFF),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: _isActive
                            ? const Color(0xFF34C759)
                            : const Color(0xFF8E8E93),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _isActive ? 'Aktif' : 'Pasif',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _isActive
                            ? const Color(0xFF34C759)
                            : const Color(0xFF8E8E93),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Save Button
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _onSave,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF007AFF), Color(0xFF0051D5)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF007AFF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.checkmark_alt,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Kaydet',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTabPills() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabsMeta.length, (index) {
          final tab = _tabsMeta[index];
          final isSelected = index == _tabController.index;

          return Padding(
            padding: EdgeInsets.only(
              right: index < _tabsMeta.length - 1 ? 8 : 0,
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _tabController.animateTo(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [tab.color, tab.color.withOpacity(0.8)],
                          )
                        : null,
                    color: isSelected ? null : Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white.withOpacity(0.4)
                          : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: tab.color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF8E8E93),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tab.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF8E8E93),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ==== GENEL / VERGİ / İLETİŞİM / ADRES / FİNANSAL / MUHASEBE TABLARI ====
  // (Aşağıdakiler senin önce yazdığın ile birebir aynı mantık, dokunmadım)

  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('Temel Bilgiler', [
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _codeController,
                    label: 'Cari Kodu',
                    required: true,
                    readOnly: true,
                    prefixIcon: CupertinoIcons.barcode,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Hesap Kategorisi',
                    value: _accountCategory,
                    items: const [
                      'Müşteri',
                      'Tedarikçi',
                      'Müşteri/Tedarikçi',
                      'Personel',
                      'Ortak',
                    ],
                    onChanged: (val) => setState(() => _accountCategory = val!),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Kişi/Kurum Tipi',
                    value: _customerType,
                    items: const ['Bireysel', 'Kurumsal'],
                    onChanged: (val) => setState(() => _customerType = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Şube',
                    value: _branch,
                    items: const ['Ankara', 'İstanbul', 'İzmir', 'Merkez'],
                    onChanged: (val) => setState(() => _branch = val!),
                  ),
                ),
              ],
            ),
            _buildModernField(
              controller: _nameController,
              focusNode: _nameFocus,
              label: 'Ünvan',
              required: true,
              prefixIcon: CupertinoIcons.textformat,
              validator: (val) =>
                  val?.isEmpty ?? true ? 'Ünvan zorunludur' : null,
              onChanged: (_) => setState(() {}),
            ),
            _buildModernField(
              controller: _name2Controller,
              focusNode: _name2Focus,
              label: 'Ünvan 2 (Ek Açıklama)',
              prefixIcon: CupertinoIcons.text_append,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _firstNameController,
                    focusNode: _firstNameFocus,
                    label: 'Adı',
                    prefixIcon: CupertinoIcons.person,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _lastNameController,
                    focusNode: _lastNameFocus,
                    label: 'Soyadı',
                    prefixIcon: CupertinoIcons.person_fill,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _salesPersonController,
                    focusNode: _salesPersonFocus,
                    label: 'Satış Temsilcisi',
                    suffixIcon: CupertinoIcons.search,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _regionController,
                    focusNode: _regionFocus,
                    label: 'Bölge/Sektör',
                    prefixIcon: CupertinoIcons.map,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildModernCheckbox(
                  'Aktif',
                  _isActive,
                  (val) => setState(() => _isActive = val ?? true),
                ),
                const SizedBox(width: 24),
                _buildModernCheckbox(
                  'e-Fatura',
                  _isEInvoice,
                  (val) => setState(() => _isEInvoice = val ?? false),
                ),
                const SizedBox(width: 24),
                _buildModernCheckbox(
                  'e-Arşiv',
                  _isEArchive,
                  (val) => setState(() => _isEArchive = val ?? false),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTaxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('Vergi Bilgileri', [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildModernField(
                    controller: _taxNoController,
                    focusNode: _taxNoFocus,
                    label: 'Vergi Numarası',
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    prefixIcon: CupertinoIcons.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildModernButton(
                    label: 'GİB Sorgula',
                    icon: CupertinoIcons.search,
                    onPressed: _queryTaxNumber,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _taxOfficeController,
                    focusNode: _taxOfficeFocus,
                    label: 'Vergi Dairesi',
                    prefixIcon: CupertinoIcons.building_2_fill,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _taxCodeController,
                    focusNode: _taxCodeFocus,
                    label: 'Vergi Kodu',
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    prefixIcon: CupertinoIcons.barcode,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildModernField(
                    controller: _identityNoController,
                    focusNode: _identityNoFocus,
                    label: 'TC Kimlik No',
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    prefixIcon: CupertinoIcons.person_badge_plus,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildModernButton(
                    label: 'Nüfus Sorgula',
                    icon: CupertinoIcons.search,
                    onPressed: _queryIdentityNo,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildModernField(
                    controller: _mersisNoController,
                    focusNode: _mersisNoFocus,
                    label: 'MERSİS No',
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    prefixIcon: CupertinoIcons.doc_text,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildModernButton(
                    label: 'MERSİS Sorgula',
                    icon: CupertinoIcons.search,
                    onPressed: _queryMersis,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Vergi Durumu',
                    value: _taxStatus,
                    items: const [
                      'Tam Mükellef',
                      'Dar Mükellef',
                      'Muaf',
                      'İstisna',
                    ],
                    onChanged: (val) => setState(() => _taxStatus = val!),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Muhasebe Tipi',
                    value: _accountingType,
                    items: const ['Ticari', 'Serbest Meslek', 'Diğer'],
                    onChanged: (val) => setState(() => _accountingType = val!),
                  ),
                ),
              ],
            ),
            _buildModernField(
              controller: _kepAddressController,
              focusNode: _kepFocus,
              label: 'KEP Adresi',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: CupertinoIcons.mail,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('İletişim Bilgileri', [
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _phoneController,
                    focusNode: _phoneFocus,
                    label: 'Telefon',
                    keyboardType: TextInputType.phone,
                    prefixIcon: CupertinoIcons.phone,
                    prefixText: '+90 ',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _mobileController,
                    focusNode: _mobileFocus,
                    label: 'Mobil',
                    keyboardType: TextInputType.phone,
                    prefixIcon: CupertinoIcons.device_phone_portrait,
                    prefixText: '+90 ',
                  ),
                ),
              ],
            ),
            _buildModernField(
              controller: _faxController,
              focusNode: _faxFocus,
              label: 'Faks',
              keyboardType: TextInputType.phone,
              prefixIcon: CupertinoIcons.printer,
              prefixText: '+90 ',
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    label: 'E-posta',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: CupertinoIcons.mail,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _email2Controller,
                    focusNode: _email2Focus,
                    label: 'E-posta 2',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: CupertinoIcons.mail_solid,
                  ),
                ),
              ],
            ),
            _buildModernField(
              controller: _websiteController,
              focusNode: _websiteFocus,
              label: 'Web Sitesi',
              keyboardType: TextInputType.url,
              prefixIcon: CupertinoIcons.globe,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAddressTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('Adres Bilgileri', [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildModernField(
                    controller: _countryController,
                    label: 'Ülke',
                    readOnly: true,
                    prefixIcon: CupertinoIcons.flag,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildModernField(
                    controller: _cityController,
                    focusNode: _cityFocus,
                    label: 'Şehir',
                    prefixIcon: CupertinoIcons.location,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildModernField(
                    controller: _districtController,
                    focusNode: _districtFocus,
                    label: 'İlçe',
                    prefixIcon: CupertinoIcons.placemark,
                  ),
                ),
              ],
            ),
            _buildModernField(
              controller: _addressController,
              focusNode: _addressFocus,
              label: 'Açık Adres',
              maxLines: 3,
              prefixIcon: CupertinoIcons.location,
            ),
            _buildModernField(
              controller: _postalCodeController,
              focusNode: _postalCodeFocus,
              label: 'Posta Kodu',
              keyboardType: TextInputType.number,
              maxLength: 5,
              prefixIcon: CupertinoIcons.map,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('Fiyat ve İskonto', [
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _priceListController,
                    focusNode: _priceListFocus,
                    label: 'Fiyat Listesi',
                    suffixIcon: CupertinoIcons.search,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernDropdown(
                    label: 'Para Birimi',
                    value: _currency,
                    items: const ['TRY', 'USD', 'EUR', 'GBP'],
                    onChanged: (val) => setState(() => _currency = val!),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _discountRateController,
                    focusNode: _discountFocus,
                    label: 'İskonto Oranı',
                    keyboardType: TextInputType.number,
                    suffixText: '%',
                    prefixIcon: CupertinoIcons.percent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _paymentTermController,
                    focusNode: _paymentTermFocus,
                    label: 'Ödeme Vadesi',
                    keyboardType: TextInputType.number,
                    suffixText: 'Gün',
                    prefixIcon: CupertinoIcons.calendar,
                  ),
                ),
              ],
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionCard('Limit ve Risk', [
            _buildModernField(
              controller: _creditLimitController,
              focusNode: _creditLimitFocus,
              label: 'Kredi Limiti',
              keyboardType: TextInputType.number,
              prefixIcon: CupertinoIcons.creditcard,
              suffixText: _currency,
            ),
            _buildModernField(
              controller: _riskLimitController,
              focusNode: _riskLimitFocus,
              label: 'Risk Limiti',
              keyboardType: TextInputType.number,
              prefixIcon: CupertinoIcons.shield,
              suffixText: _currency,
            ),
            _buildModernField(
              controller: _creditDaysController,
              focusNode: _creditDaysFocus,
              label: 'Maksimum Vade Süresi',
              keyboardType: TextInputType.number,
              prefixIcon: CupertinoIcons.time,
              suffixText: 'Gün',
            ),
          ]),
          const SizedBox(height: 16),
          _buildSectionCard('Banka Bilgileri', [
            _buildModernField(
              controller: _ibanController,
              focusNode: _ibanFocus,
              label: 'IBAN',
              maxLength: 26,
              prefixIcon: CupertinoIcons.creditcard,
            ),
            _buildModernField(
              controller: _bankNameController,
              focusNode: _bankNameFocus,
              label: 'Banka Adı',
              prefixIcon: CupertinoIcons.building_2_fill,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildModernField(
                    controller: _bankBranchController,
                    focusNode: _bankBranchFocus,
                    label: 'Şube Adı',
                    prefixIcon: CupertinoIcons.location,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernField(
                    controller: _bankAccountNoController,
                    focusNode: _bankAccountFocus,
                    label: 'Hesap No',
                    keyboardType: TextInputType.number,
                    prefixIcon: CupertinoIcons.number,
                  ),
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAccountingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSectionCard('Muhasebe Kodları', [
            _buildModernField(
              controller: _accountCodeController,
              focusNode: _accountCodeFocus,
              label: 'Ana Hesap Kodu',
              prefixIcon: CupertinoIcons.chart_bar_square,
              suffixIcon: CupertinoIcons.search,
            ),
            _buildModernField(
              controller: _costCenterController,
              focusNode: _costCenterFocus,
              label: 'Masraf Merkezi',
              prefixIcon: CupertinoIcons.squares_below_rectangle,
              suffixIcon: CupertinoIcons.search,
            ),
            _buildModernField(
              controller: _projectCodeController,
              focusNode: _projectCodeFocus,
              label: 'Proje Kodu',
              prefixIcon: CupertinoIcons.folder,
              suffixIcon: CupertinoIcons.search,
            ),
          ]),
        ],
      ),
    );
  }

  // ====== ORTAK WIDGET’LAR ==================================================
  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D1D1F),
                letterSpacing: -0.3,
              ),
            ),
          ),
          Container(height: 1, color: Colors.grey.shade100),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    FocusNode? focusNode,
    bool required = false,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    bool readOnly = false,
    int maxLines = 1,
    int? maxLength,
    IconData? prefixIcon,
    IconData? suffixIcon,
    String? suffixText,
    String? prefixText,
  }) {
    final isFocused = focusNode?.hasFocus ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                  letterSpacing: -0.2,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF3B30),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: isFocused
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF007AFF).withOpacity(0.12),
                        const Color(0xFF007AFF).withOpacity(0.06),
                      ],
                    )
                  : null,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isFocused
                    ? const Color(0xFF007AFF).withOpacity(0.4)
                    : Colors.transparent,
                width: isFocused ? 1.5 : 0,
              ),
            ),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              validator: validator,
              onChanged: onChanged,
              keyboardType: keyboardType,
              readOnly: readOnly,
              maxLines: maxLines,
              maxLength: maxLength,
              style: TextStyle(
                fontSize: 14,
                color: readOnly
                    ? Colors.grey.shade700
                    : const Color(0xFF1D1D1F),
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixIcon: prefixIcon != null
                    ? Icon(prefixIcon, size: 18, color: Colors.grey.shade600)
                    : null,
                prefixText: prefixText,
                prefixStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                ),
                suffixIcon: suffixIcon != null
                    ? Icon(suffixIcon, size: 18, color: Colors.grey.shade600)
                    : null,
                suffixText: suffixText,
                suffixStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFFF3B30)),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Color(0xFFFF3B30), width: 1.5),
                ),
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D1D1F),
                  letterSpacing: -0.2,
                ),
              ),
              if (required)
                const Text(
                  ' *',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF3B30),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                borderRadius: BorderRadius.circular(10),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1D1D1F),
                ),
                icon: Icon(
                  CupertinoIcons.chevron_down,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                items: items
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernCheckbox(
    String label,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 1.1,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF007AFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1D1D1F),
          ),
        ),
      ],
    );
  }

  Widget _buildModernButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007AFF),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}

/// Tam ekran wrapper
class CustomerCardPage extends StatelessWidget {
  final VoidCallback onClose;

  const CustomerCardPage({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return CustomerCardView(onClose: onClose);
  }
}
