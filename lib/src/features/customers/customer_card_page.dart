import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../widgets/toast_notification.dart';

/// SAP-style Professional Customer Card with Tab Navigation
class CustomerCardPage extends StatefulWidget {
  final VoidCallback onClose;
  final String? customerId;

  const CustomerCardPage({super.key, required this.onClose, this.customerId});

  @override
  State<CustomerCardPage> createState() => _CustomerCardPageState();
}

class _CustomerCardPageState extends State<CustomerCardPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;

  // Tax office data (Maliye Bakanlığı Vergi Dairesi Kodları)
  final Map<String, String> _taxOfficeData = {
    '01101': 'Adana Vergi Dairesi Başkanlığı',
    '01102': 'Seyhan Vergi Dairesi',
    '01103': 'Çukurova Vergi Dairesi',
    '06101': 'Ankara Vergi Dairesi Başkanlığı',
    '06102': 'Çankaya Vergi Dairesi',
    '06103': 'Yenimahalle Vergi Dairesi',
    '34101': 'İstanbul Vergi Dairesi Başkanlığı',
    '34102': 'Kadıköy Vergi Dairesi',
    '34103': 'Beşiktaş Vergi Dairesi',
    '34104': 'Şişli Vergi Dairesi',
    '34105': 'Beyoğlu Vergi Dairesi',
    '35101': 'İzmir Vergi Dairesi Başkanlığı',
    '35102': 'Konak Vergi Dairesi',
    '35103': 'Karşıyaka Vergi Dairesi',
  };

  // Müşteri/Tedarikçi kodları için sayaçlar
  static int _customerCounter = 1;
  static int _supplierCounter = 1;
  static int _bothCounter = 1;

  // Basic controllers
  final _codeController = TextEditingController();
  final _taxOfficeCodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mobileController = TextEditingController();
  final _faxController = TextEditingController();
  final _emailController = TextEditingController();
  final _websiteController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _countryController = TextEditingController(text: 'Türkiye');
  final _taxNoController = TextEditingController();
  final _taxOfficeController = TextEditingController();
  final _identityNoController = TextEditingController();
  final _ibanController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _creditLimitController = TextEditingController(text: '0.00');
  final _paymentTermController = TextEditingController(text: '0');
  final _discountRateController = TextEditingController(text: '0.00');

  // SAP Extended Fields
  final _shortNameController = TextEditingController();
  final _searchTermController = TextEditingController();
  final _industryCodeController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _mobile2Controller = TextEditingController();
  final _phone2Controller = TextEditingController();
  final _deliveryNotesController = TextEditingController();
  final _internalNotesController = TextEditingController();
  final _vatNoController = TextEditingController();
  final _tradeRegisterController = TextEditingController();
  final _chamberController = TextEditingController();
  final _routeController = TextEditingController();
  final _territoryController = TextEditingController();
  final _priceGroupController = TextEditingController();
  final _customerClassController = TextEditingController();

  String _accountGroup = 'Müşteri';
  String _companyCode = '1000';
  String _status = 'Aktif';
  String _currency = 'TRY';
  String _customerType = 'Perakende'; // Perakende, Kurumsal, Kamu
  String _salesOrg = '1000'; // Satış Organizasyonu
  String _distributionChannel = '10'; // Dağıtım Kanalı
  String _division = '00'; // Bölüm
  String _priceList = 'Standart'; // Fiyat Listesi
  String _paymentMethod = 'Havale'; // Ödeme Yöntemi
  String _incoterms = 'EXW'; // Teslim Şartları
  String _shippingCondition = 'Standart'; // Sevkiyat Şartı
  String _riskCategory = 'Düşük'; // Risk Kategorisi
  String _language = 'TR'; // Dil
  bool _taxExempt = false; // Vergi Muafiyeti
  bool _blocked = false; // Blokeli
  bool _oneTimeCustomer = false; // Tek Seferlik Müşteri

  // Form değişiklik kontrolü
  bool _hasUnsavedChanges = false;
  bool _isSaved = false;

  // Kişi bilgileri (Sahis şirketler için)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Müşteri kodunu otomatik üret
    _generateCustomerCode();

    // Ünvan değiştiğinde sol paneli güncelle
    _nameController.addListener(() {
      setState(() {});
    });

    // Vergi dairesi kodu değiştiğinde vergi dairesi adını doldur
    _taxOfficeCodeController.addListener(_updateTaxOfficeName);

    // Tüm controller'lara change listener ekle
    _addChangeListeners();
  }

  void _addChangeListeners() {
    final controllers = [
      _codeController,
      _nameController,
      _phoneController,
      _mobileController,
      _emailController,
      _addressController,
      _cityController,
      _districtController,
      _taxNoController,
      _taxOfficeController,
      _identityNoController,
      _firstNameController,
      _lastNameController,
    ];

    for (var controller in controllers) {
      controller.addListener(_markAsChanged);
    }
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges && !_isSaved) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  void _generateCustomerCode() {
    // Sadece kaydet butonuna basıldığında kod artırılır
    String prefix;
    int counter;

    if (_accountGroup == 'Müşteri') {
      prefix = '120';
      counter = _customerCounter;
    } else if (_accountGroup == 'Tedarikçi') {
      prefix = '320';
      counter = _supplierCounter;
    } else {
      prefix = '120';
      counter = _bothCounter;
    }

    _codeController.text = '$prefix.${counter.toString().padLeft(3, '0')}.0001';
  }

  void _updateTaxOfficeName() {
    final code = _taxOfficeCodeController.text;
    if (_taxOfficeData.containsKey(code)) {
      _taxOfficeController.text = _taxOfficeData[code]!;
    }
  }

  void _searchTaxOffice() {
    showDialog(
      context: context,
      builder: (context) => _TaxOfficeSearchDialog(
        taxOfficeData: _taxOfficeData,
        onSelected: (code, name) {
          _taxOfficeCodeController.text = code;
          _taxOfficeController.text = name;
        },
      ),
    );
  }

  void _searchAddress() {
    showDialog(
      context: context,
      builder: (context) => _AddressSearchDialog(
        onSelected: (address, city, district, postalCode) {
          _addressController.text = address;
          _cityController.text = city;
          _districtController.text = district;
          _postalCodeController.text = postalCode;
        },
      ),
    );
  }

  void _searchByTaxNo() {
    final taxNo = _taxNoController.text;
    if (taxNo.isEmpty || taxNo.length != 10) {
      ToastNotification.show(
        context,
        message: 'Lütfen geçerli bir vergi numarası giriniz (10 hane)',
        type: ToastType.warning,
      );
      return;
    }

    // Simule edilmiş veri - Gerçek uygulamada API çağrısı yapılacak
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);

      // Örnek veri doldur
      _nameController.text = 'Örnek Firma A.Ş.';
      _taxOfficeController.text = 'Kadıköy Vergi Dairesi';
      _taxOfficeCodeController.text = '34102';
      _addressController.text = 'Caferağa Mah. Moda Cad. No:123';
      _cityController.text = 'İstanbul';
      _districtController.text = 'Kadıköy';
      _postalCodeController.text = '34710';

      ToastNotification.show(
        context,
        message: 'Firma bilgileri getirildi',
        type: ToastType.success,
      );
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _mobileController.dispose();
    _faxController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalCodeController.dispose();
    _countryController.dispose();
    _taxNoController.dispose();
    _taxOfficeController.dispose();
    _identityNoController.dispose();
    _ibanController.dispose();
    _bankNameController.dispose();
    _creditLimitController.dispose();
    _paymentTermController.dispose();
    _discountRateController.dispose();
    _shortNameController.dispose();
    _searchTermController.dispose();
    _industryCodeController.dispose();
    _contactPersonController.dispose();
    _mobile2Controller.dispose();
    _phone2Controller.dispose();
    _deliveryNotesController.dispose();
    _internalNotesController.dispose();
    _vatNoController.dispose();
    _tradeRegisterController.dispose();
    _chamberController.dispose();
    _routeController.dispose();
    _territoryController.dispose();
    _priceGroupController.dispose();
    _customerClassController.dispose();
    _taxOfficeCodeController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  String? _validateCustomerCode(String? value) {
    if (value == null || value.isEmpty) return 'Müşteri kodu zorunludur';

    final parts = value.split('.');
    if (parts.length != 3) return 'Geçersiz format (XXX.XXX.XXXX)';

    final prefix = parts[0];
    if (_accountGroup == 'Müşteri' && prefix != '120') {
      return 'Müşteri hesap grubu için kod 120 ile başlamalı';
    } else if (_accountGroup == 'Tedarikçi' && prefix != '320') {
      return 'Tedarikçi hesap grubu için kod 320 ile başlamalı';
    } else if (_accountGroup == 'Müşteri/Tedarikçi' &&
        prefix != '120' &&
        prefix != '320') {
      return 'Kod 120 veya 320 ile başlamalı';
    }

    return null;
  }

  String? _validateTaxNo(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 10) return 'Vergi numarası 10 haneli olmalıdır';
    if (int.tryParse(value) == null) return 'Sadece rakam giriniz';
    return null;
  }

  String? _validateIdentityNo(String? value) {
    if (value == null || value.isEmpty) return null;
    if (value.length != 11) return 'TC Kimlik No 11 haneli olmalıdır';
    if (int.tryParse(value) == null) return 'Sadece rakam giriniz';

    // TC Kimlik No algoritması
    final digits = value.split('').map((e) => int.parse(e)).toList();
    if (digits[0] == 0) return 'İlk hane 0 olamaz';

    final sum1 =
        (digits[0] + digits[2] + digits[4] + digits[6] + digits[8]) * 7;
    final sum2 = digits[1] + digits[3] + digits[5] + digits[7];
    final digit10 = (sum1 - sum2) % 10;

    if (digit10 != digits[9]) return 'Geçersiz TC Kimlik No';

    final sum3 = digits.sublist(0, 10).reduce((a, b) => a + b);
    if (sum3 % 10 != digits[10]) return 'Geçersiz TC Kimlik No';

    return null;
  }

  Future<bool> _checkUnsavedChanges() async {
    if (_hasUnsavedChanges && !_isSaved) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Kaydedilmemiş Değişiklikler'),
          content: const Text(
            'Kaydedilmemiş değişiklikler var. Devam etmek istiyor musunuz?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Vazgeç'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Devam Et'),
            ),
          ],
        ),
      );
      return result ?? false;
    }
    return true;
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Kaydet butonuna basıldığında kod sayıcısını artır
      if (!_isSaved) {
        if (_accountGroup == 'Müşteri') {
          _customerCounter++;
        } else if (_accountGroup == 'Tedarikçi') {
          _supplierCounter++;
        } else {
          _bothCounter++;
        }
      }

      setState(() {
        _hasUnsavedChanges = false;
        _isSaved = true;
      });

      ToastNotification.show(
        context,
        message: 'Müşteri kaydı başarıyla kaydedildi',
        type: ToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _checkUnsavedChanges,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  children: [
                    // Sol panel - Info
                    Container(
                      width: 320,
                      color: Colors.white,
                      child: _buildInfoPanel(),
                    ),
                    // Dikey çizgi
                    Container(width: 1, color: const Color(0xFFE0E0E0)),
                    // Sağ panel - Tabs + Form
                    Expanded(
                      child: Column(
                        children: [
                          _buildTabBar(),
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildGeneralTab(),
                                _buildContactTab(),
                                _buildTaxTab(),
                                _buildSalesTab(),
                                _buildFinancialTab(),
                                _buildNotesTab(),
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
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFF3498DB),
        unselectedLabelColor: const Color(0xFF7F8C8D),
        indicatorColor: const Color(0xFF3498DB),
        indicatorWeight: 3,
        tabs: const [
          Tab(icon: Icon(Icons.info_outline), text: 'Genel Bilgiler'),
          Tab(icon: Icon(Icons.contact_phone), text: 'İletişim'),
          Tab(icon: Icon(Icons.account_balance), text: 'Vergi & Kimlik'),
          Tab(icon: Icon(Icons.storefront), text: 'Satış'),
          Tab(icon: Icon(Icons.payments), text: 'Finans'),
          Tab(icon: Icon(Icons.note), text: 'Notlar'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3E50), Color(0xFF34495E)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              if (await _checkUnsavedChanges()) {
                widget.onClose();
              }
            },
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.business, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Müşteri Kartı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.customerId ?? 'Yeni Kayıt',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF27AE60),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 14, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  'Aktif',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _onSave,
            tooltip: 'Kaydet (Ctrl+S)',
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
            tooltip: 'Diğer İşlemler',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer info - Kompakt tasarım
          _buildInfoSection('Müşteri Bilgisi', [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3498DB), Color(0xFF2980B9)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.business,
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
                        _nameController.text.isEmpty
                            ? 'Yeni Müşteri'
                            : _nameController.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _codeController.text,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]),

          const SizedBox(height: 16),

          // Organization info
          _buildInfoSection('Organizasyon', [
            _buildInfoRow('Hesap Grubu', _accountGroup),
            _buildInfoRow('Şirket Kodu', _companyCode),
            _buildInfoRow('Durum', _status),
          ]),

          const SizedBox(height: 20),

          // Quick stats
          _buildInfoSection('Özet Bilgiler', [
            _buildStatRow(Icons.shopping_cart, 'Sipariş', '0', Colors.blue),
            _buildStatRow(Icons.local_shipping, 'Teslimat', '0', Colors.orange),
            _buildStatRow(Icons.receipt_long, 'Fatura', '0', Colors.green),
            _buildStatRow(Icons.account_balance, 'Bakiye', '₺0.00', Colors.red),
          ]),

          const SizedBox(height: 20),

          // Quick actions
          _buildInfoSection('Hızlı İşlemler', [
            _buildActionButton('Yeni Sipariş', Icons.add_shopping_cart),
            const SizedBox(height: 8),
            _buildActionButton('Ödeme Girişi', Icons.payment),
            const SizedBox(height: 8),
            _buildActionButton('Rapor Görüntüle', Icons.assessment),
            const SizedBox(height: 8),
            _buildActionButton('Geçmiş İşlemler', Icons.history),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Color(0xFF95A5A6),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF95A5A6),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF3498DB)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF2C3E50)),
              ),
            ),
            const Icon(Icons.chevron_right, size: 16, color: Color(0xFF95A5A6)),
          ],
        ),
      ),
    );
  }

  // Tab 1: Genel Bilgiler
  Widget _buildGeneralTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Temel Bilgiler'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildField(
                  'Müşteri Numarası *',
                  _codeController,
                  validator: _validateCustomerCode,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Hesap Grubu *',
                  _accountGroup,
                  ['Müşteri', 'Tedarikçi', 'Müşteri/Tedarikçi'],
                  (val) {
                    setState(() {
                      _accountGroup = val!;
                      _generateCustomerCode();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Şirket Kodu *',
                  _companyCode,
                  ['1000', '2000', '3000'],
                  (val) => setState(() => _companyCode = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField(
            'Müşteri Adı (Ünvan) *',
            _nameController,
            validator: (val) => val?.isEmpty ?? true ? 'Zorunlu alan' : null,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('Kısa Ad', _shortNameController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField('Arama Terimi', _searchTermController),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Sınıflandırma'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Müşteri Tipi',
                  _customerType,
                  ['Perakende', 'Kurumsal', 'Kamu', 'İhracat'],
                  (val) => setState(() => _customerType = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Dil', _language, [
                  'TR',
                  'EN',
                  'DE',
                  'FR',
                ], (val) => setState(() => _language = val!)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Durum', _status, [
                  'Aktif',
                  'Pasif',
                  'Beklemede',
                ], (val) => setState(() => _status = val!)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField('Sektör Kodu', _industryCodeController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField('Müşteri Sınıfı', _customerClassController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Tek Seferlik Müşteri',
                    style: TextStyle(fontSize: 13),
                  ),
                  value: _oneTimeCustomer,
                  onChanged: (val) => setState(() => _oneTimeCustomer = val!),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
              Expanded(
                child: CheckboxListTile(
                  title: const Text('Blokeli', style: TextStyle(fontSize: 13)),
                  value: _blocked,
                  onChanged: (val) => setState(() => _blocked = val!),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 2: İletişim
  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Yetkili Kişi'),
          const SizedBox(height: 20),
          _buildField('Yetkili Kişi Adı', _contactPersonController),
          const SizedBox(height: 24),
          _buildSectionTitle('Telefon Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildField('Telefon 1', _phoneController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Telefon 2', _phone2Controller)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Faks', _faxController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('Mobil 1', _mobileController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Mobil 2', _mobile2Controller)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Dijital İletişim'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildField('E-posta', _emailController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Web Sitesi', _websiteController)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Adres Bilgileri'),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildField('Adres', _addressController, maxLines: 1),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Color(0xFF3498DB)),
                  tooltip: 'Adres Ara (min 3 harf)',
                  onPressed: _searchAddress,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('Şehir', _cityController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('İlçe', _districtController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Posta Kodu', _postalCodeController)),
            ],
          ),
          const SizedBox(height: 16),
          _buildField('Ülke', _countryController),
        ],
      ),
    );
  }

  // Tab 3: Vergi & Kimlik
  Widget _buildTaxTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Vergi Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        'Vergi Dairesi Kodu',
                        _taxOfficeCodeController,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF3498DB),
                        ),
                        tooltip: 'Vergi Dairesi Ara',
                        onPressed: _searchTaxOffice,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: _buildField('Vergi Dairesi', _taxOfficeController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _buildField(
                        'Vergi Numarası (10 Hane)',
                        _taxNoController,
                        validator: _validateTaxNo,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: IconButton(
                        icon: const Icon(
                          Icons.search,
                          color: Color(0xFF3498DB),
                        ),
                        tooltip: 'Vergi No ile Firma Sorgula',
                        onPressed: _searchByTaxNo,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildField('KDV Numarası', _vatNoController)),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text(
              'Vergi Muafiyeti',
              style: TextStyle(fontSize: 13),
            ),
            value: _taxExempt,
            onChanged: (val) => setState(() => _taxExempt = val!),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Kimlik Bilgileri'),
          const SizedBox(height: 20),
          _buildField(
            'TC Kimlik No (11 Hane)',
            _identityNoController,
            validator: _validateIdentityNo,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Ticaret Sicil No',
                  _tradeRegisterController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Ticaret Odası', _chamberController)),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 4: Satış
  Widget _buildSalesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Satış Organizasyonu'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Satış Org.',
                  TextEditingController(text: _salesOrg),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Dağıtım Kanalı',
                  TextEditingController(text: _distributionChannel),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Bölüm',
                  TextEditingController(text: _division),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Fiyatlandırma'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Fiyat Listesi',
                  _priceList,
                  ['Standart', 'Promosyon', 'VIP', 'Özel'],
                  (val) => setState(() => _priceList = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField('Fiyat Grubu', _priceGroupController),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Bölge Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildField('Rota', _routeController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Bölge', _territoryController)),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Nakliye'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Teslim Şartları (Incoterms)',
                  _incoterms,
                  [
                    'EXW',
                    'FCA',
                    'CPT',
                    'CIP',
                    'DAP',
                    'DPU',
                    'DDP',
                    'FAS',
                    'FOB',
                    'CFR',
                    'CIF',
                  ],
                  (val) => setState(() => _incoterms = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Sevkiyat Şartı',
                  _shippingCondition,
                  ['Standart', 'Ekspres', 'Kargo', 'Özel Araç'],
                  (val) => setState(() => _shippingCondition = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField(
            'Teslimat Notları',
            _deliveryNotesController,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // Tab 5: Finans
  Widget _buildFinancialTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Kredi ve Limit'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildField('Kredi Limiti', _creditLimitController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown('Para Birimi', _currency, [
                  'TRY',
                  'USD',
                  'EUR',
                  'GBP',
                ], (val) => setState(() => _currency = val!)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Ödeme Vadesi (Gün)',
                  _paymentTermController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'İskonto Oranı (%)',
                  _discountRateController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Banka Bilgileri'),
          const SizedBox(height: 20),
          _buildField('IBAN', _ibanController),
          const SizedBox(height: 16),
          _buildField('Banka Adı', _bankNameController),
          const SizedBox(height: 16),
          _buildDropdown(
            'Ödeme Yöntemi',
            _paymentMethod,
            ['Havale', 'Kredi Kartı', 'Çek', 'Senet', 'Nakit'],
            (val) => setState(() => _paymentMethod = val!),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Risk Yönetimi'),
          const SizedBox(height: 20),
          _buildDropdown(
            'Risk Kategorisi',
            _riskCategory,
            ['Düşük', 'Orta', 'Yüksek', 'Kritik'],
            (val) => setState(() => _riskCategory = val!),
          ),
        ],
      ),
    );
  }

  // Tab 6: Notlar
  Widget _buildNotesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Dahili Notlar'),
          const SizedBox(height: 20),
          _buildField('Dahili Notlar', _internalNotesController, maxLines: 10),
          const SizedBox(height: 24),
          _buildSectionTitle('Teslimat Notları'),
          const SizedBox(height: 20),
          _buildField(
            'Teslimat Notları',
            _deliveryNotesController,
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF3498DB), width: 2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: const Color(0xFF3498DB),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF5F5F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE74C3C)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFBDBDBD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF3498DB), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

// Vergi Dairesi Arama Dialog
class _TaxOfficeSearchDialog extends StatefulWidget {
  final Map<String, String> taxOfficeData;
  final Function(String code, String name) onSelected;

  const _TaxOfficeSearchDialog({
    required this.taxOfficeData,
    required this.onSelected,
  });

  @override
  State<_TaxOfficeSearchDialog> createState() => _TaxOfficeSearchDialogState();
}

class _TaxOfficeSearchDialogState extends State<_TaxOfficeSearchDialog> {
  final _searchController = TextEditingController();
  List<MapEntry<String, String>> _filteredList = [];

  @override
  void initState() {
    super.initState();
    _filteredList = widget.taxOfficeData.entries.toList();
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredList = widget.taxOfficeData.entries
          .where(
            (e) =>
                e.key.contains(query) || e.value.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.search, color: Color(0xFF3498DB)),
                const SizedBox(width: 12),
                const Text(
                  'Vergi Dairesi Ara',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Kod veya vergi dairesi adı ile arayın...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  final entry = _filteredList[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3498DB).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3498DB),
                        ),
                      ),
                    ),
                    title: Text(entry.value),
                    onTap: () {
                      widget.onSelected(entry.key, entry.value);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Adres Arama Dialog
class _AddressSearchDialog extends StatefulWidget {
  final Function(
    String address,
    String city,
    String district,
    String postalCode,
  )
  onSelected;

  const _AddressSearchDialog({required this.onSelected});

  @override
  State<_AddressSearchDialog> createState() => _AddressSearchDialogState();
}

class _AddressSearchDialogState extends State<_AddressSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredList = [];

  // Örnek adres verileri
  final List<Map<String, String>> _addressData = [
    {
      'address': 'Atatürk Cad. No:15',
      'city': 'İstanbul',
      'district': 'Kadıköy',
      'postal': '34710',
    },
    {
      'address': 'Cumhuriyet Mah. İstiklal Sok. No:42',
      'city': 'Ankara',
      'district': 'Çankaya',
      'postal': '06420',
    },
    {
      'address': 'Alsancak Mah. Kıbrıs Şehitleri Cad. No:8',
      'city': 'İzmir',
      'district': 'Konak',
      'postal': '35220',
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredList = _addressData;
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    if (query.length < 3) {
      setState(() => _filteredList = []);
      return;
    }

    setState(() {
      _filteredList = _addressData
          .where(
            (e) =>
                e['address']!.toLowerCase().contains(query) ||
                e['city']!.toLowerCase().contains(query) ||
                e['district']!.toLowerCase().contains(query),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 500,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on, color: Color(0xFF3498DB)),
                const SizedBox(width: 12),
                const Text(
                  'Adres Ara',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'En az 3 harf yazarak arayın...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_searchController.text.isNotEmpty &&
                _searchController.text.length < 3)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Arama yapmak için en az 3 karakter giriniz',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  final item = _filteredList[index];
                  return ListTile(
                    leading: const Icon(
                      Icons.location_city,
                      color: Color(0xFF3498DB),
                    ),
                    title: Text(item['address']!),
                    subtitle: Text(
                      '${item['district']} / ${item['city']} - ${item['postal']}',
                    ),
                    onTap: () {
                      widget.onSelected(
                        item['address']!,
                        item['city']!,
                        item['district']!,
                        item['postal']!,
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
