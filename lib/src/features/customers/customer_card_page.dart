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
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _neighborhoodController = TextEditingController(); // Mahalle
  final _streetController = TextEditingController(); // Cadde
  final _avenueController = TextEditingController(); // Sokak
  final _openAddressController = TextEditingController(); // Açık Adres
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _locationNameController = TextEditingController();
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
  final _mobile3Controller = TextEditingController();
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

  // Muhasebe/Özel Kodlar
  final _accountingCodeController = TextEditingController();
  final _costCenterController = TextEditingController();
  final _profitCenterController = TextEditingController();
  final _glAccountController = TextEditingController();
  final _customCode1Controller = TextEditingController();
  final _customCode2Controller = TextEditingController();
  final _customCode3Controller = TextEditingController();
  final _sortKeyController = TextEditingController();
  final _reconciliationAccountController = TextEditingController();
  final _cashDiscountAccountController = TextEditingController();

  // Şube ve Müşteri Grubu
  String _branch = 'İstanbul Merkez'; // Dropdown - varsayılan değer
  String _customerGroup = 'Standart'; // Standart, VIP, Premium, Yeni
  String _customerClass = 'A Sınıfı'; // Dropdown

  // Şirket ve Sektör Kodu arama için
  final _companyCodeController = TextEditingController();
  final _sectorCodeController = TextEditingController();

  String _accountGroup = 'Müşteri'; // Varsayılan
  String _status = 'Aktif'; // Varsayılan aktif
  String _currency = 'TRY';
  String _customerType = 'Perakende'; // Perakende, Kurumsal, Kamu
  String _salesOrg = '1000'; // Satış Organizasyonu
  String _distributionChannel = '10'; // Dağıtım Kanalı
  String _division = '00'; // Bölüm
  String _priceList = 'Standart'; // Fiyat Listesi
  String _paymentMethod = 'Havale'; // Ödeme Yöntemi
  String _incoterms = 'EXW'; // Teslim Şartları
  String _shippingCondition = 'Standart'; // Sevkiyat Şartı
  String _riskCategory = 'Düşük Risk'; // Risk Kategorisi
  bool _taxExempt = false; // Vergi Muafiyeti
  bool _blocked = false; // Blokeli
  bool _oneTimeCustomer = false; // Tek Seferlik Müşteri

  // Vergi Kategorisi & Sınıflandırma
  String _taxCategory = 'Genel Vergilendirme';
  String _taxLiabilityType = 'Tam Mükellef';
  String _vatWithholdingRate = 'Yok';
  String _incomeTaxWithholding = 'Yok';
  String _corporateTaxWithholding = 'Yok';
  String _stampTax = 'Yok';
  String _paymentTerms = '30 Gün';

  // e-Fatura & e-Defter
  bool _eInvoiceActive = false;
  bool _eArchiveActive = false;
  bool _eLedgerActive = false;
  String _eArchiveScenario = 'Temel';
  final _eInvoiceLabelController = TextEditingController();

  // Form değişiklik kontrolü
  bool _hasUnsavedChanges = false;
  bool _isSaved = false;

  // Kişi bilgileri (Şahıs firmalar için)
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

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

  void _showCompanyCodeSearch() {
    showDialog(
      context: context,
      builder: (context) => _CompanyCodeSearchDialog(
        initialQuery: _companyCodeController.text,
        onSelected: (code, name) {
          setState(() {
            _companyCodeController.text = '$code - $name';
          });
        },
      ),
    );
  }

  void _showSectorCodeSearch() {
    showDialog(
      context: context,
      builder: (context) => _SectorCodeSearchDialog(
        initialQuery: _sectorCodeController.text,
        onSelected: (code, name) {
          setState(() {
            _sectorCodeController.text = '$code - $name';
          });
        },
      ),
    );
  }

  void _formatPhoneNumber(TextEditingController controller) {
    String text = controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (text.isEmpty) return;

    // Eğer başta 0 yoksa ekle
    if (!text.startsWith('0')) {
      text = '0$text';
    }

    String formatted = '';
    if (text.length >= 1) {
      formatted = text[0]; // 0
      if (text.length > 1) {
        formatted +=
            '(${text.substring(1, text.length > 4 ? 4 : text.length)}'; // (5xx)
        if (text.length > 4) {
          formatted +=
              ') ${text.substring(4, text.length > 7 ? 7 : text.length)}'; // xxx
          if (text.length > 7) {
            formatted +=
                ' ${text.substring(7, text.length > 9 ? 9 : text.length)}'; // xx
            if (text.length > 9) {
              formatted +=
                  ' ${text.substring(9, text.length > 11 ? 11 : text.length)}'; // xx
            }
          }
        }
      }
    }

    if (formatted != controller.text) {
      controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _searchAddress() {
    showDialog(
      context: context,
      builder: (context) => _AddressSearchDialog(
        initialQuery: _addressController.text,
        onSelected: (country, city, district, neighborhood, street, avenue,
            postalCode, latitude, longitude, locationName) {
          setState(() {
            _countryController.text = country;
            _cityController.text = city;
            _districtController.text = district;
            _neighborhoodController.text = neighborhood;
            _streetController.text = street;
            _avenueController.text = avenue;
            _postalCodeController.text = postalCode;
            _latitudeController.text = latitude;
            _longitudeController.text = longitude;
            _locationNameController.text = locationName;
          });
        },
      ),
    );
  }

  void _checkEInvoiceStatus(String taxOrIdentityNo, bool isTaxNo) {
    // Simule edilmiş e-Fatura/e-Arşiv kontrolü
    // Gerçek uygulamada GİB web servisi sorgulanacak

    // Demo: %70 e-Fatura, %30 e-Arşiv mükellefi
    final isEInvoice = int.parse(taxOrIdentityNo.substring(0, 1)) % 3 != 0;

    if (isEInvoice) {
      // e-Fatura Mükellefi
      setState(() {
        _eInvoiceActive = true;
        _eArchiveActive = false;
        // Demo alias - gerçek uygulamada API'den gelecek
        _eInvoiceLabelController.text =
            'urn:mail:defaultpk@${_taxNoController.text}.com';
      });

      ToastNotification.show(
        context,
        message: '✓ e-Fatura Mükellefi - Alias otomatik yüklendi',
        type: ToastType.success,
      );
    } else {
      // e-Arşiv Fatura Mükellefi
      setState(() {
        _eInvoiceActive = false;
        _eArchiveActive = true;
        _eInvoiceLabelController.text = '';
      });

      ToastNotification.show(
        context,
        message: 'ℹ e-Arşiv Fatura Mükellefi',
        type: ToastType.info,
      );
    }
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

      // e-Fatura/e-Arşiv kontrolü yap
      _checkEInvoiceStatus(taxNo, true);

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
    _whatsappController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _postalCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _locationNameController.dispose();
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
    _mobile3Controller.dispose();
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
    _accountingCodeController.dispose();
    _costCenterController.dispose();
    _profitCenterController.dispose();
    _glAccountController.dispose();
    _customCode1Controller.dispose();
    _customCode2Controller.dispose();
    _customCode3Controller.dispose();
    _sortKeyController.dispose();
    _reconciliationAccountController.dispose();
    _cashDiscountAccountController.dispose();
    _companyCodeController.dispose();
    _sectorCodeController.dispose();
    _eInvoiceLabelController.dispose();
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
        backgroundColor: const Color(0xFFF8F9FA),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildHeader(),
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
                    _buildAccountingTab(),
                    _buildNotesTab(),
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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: const Color(0xFF2563EB),
        unselectedLabelColor: const Color(0xFF94A3B8),
        indicatorColor: const Color(0xFF2563EB),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        tabs: const [
          Tab(icon: Icon(Icons.info_outline), text: 'Genel Bilgiler'),
          Tab(icon: Icon(Icons.contact_phone), text: 'İletişim'),
          Tab(icon: Icon(Icons.account_balance), text: 'Vergi & Kimlik'),
          Tab(icon: Icon(Icons.storefront), text: 'Satış'),
          Tab(icon: Icon(Icons.payments), text: 'Finans'),
          Tab(icon: Icon(Icons.code), text: 'Muhasebe & Kodlar'),
          Tab(icon: Icon(Icons.note), text: 'Notlar'),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E293B),
            const Color(0xFF334155),
            const Color(0xFF475569),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF2563EB),
                  const Color(0xFF38BDF8),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Icon(Icons.business, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Müşteri Kartı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.customerId ?? 'Yeni Kayıt',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _status == 'Aktif'
                    ? [
                        const Color(0xFF10B981),
                        const Color(0xFF34D399),
                      ]
                    : [
                        const Color(0xFF64748B),
                        const Color(0xFF94A3B8),
                      ],
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: (_status == 'Aktif'
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B))
                      .withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _status == 'Aktif' ? Icons.check_circle : Icons.cancel,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  _status == 'Aktif' ? 'Aktif' : 'Pasif',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 20,
                  child: Switch(
                    value: _status == 'Aktif',
                    onChanged: (val) {
                      setState(() {
                        _status = val ? 'Aktif' : 'Pasif';
                        _hasUnsavedChanges = true;
                      });
                    },
                    activeColor: Colors.white,
                    activeTrackColor: Colors.white.withOpacity(0.3),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.white.withOpacity(0.2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
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
                  'Müşteri Tipi *',
                  _customerType,
                  ['Perakende', 'Kurumsal', 'Kamu', 'İhracat'],
                  (val) => setState(() => _customerType = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Şube',
                  _branch,
                  [
                    'İstanbul Merkez',
                    'İstanbul Anadolu',
                    'Ankara',
                    'İzmir',
                    'Bursa',
                    'Antalya',
                  ],
                  (val) => setState(() => _branch = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSearchField(
                  label: 'Şirket Kodu',
                  controller: _companyCodeController,
                  onSearch: () => _showCompanyCodeSearch(),
                  isRequired: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSearchField(
                  label: 'Sektör Kodu',
                  controller: _sectorCodeController,
                  onSearch: () => _showSectorCodeSearch(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Müşteri Grubu',
                  _customerGroup,
                  [
                    'Standart',
                    'VIP',
                    'Premium',
                    'Yeni',
                    'Kurumsal',
                    'Bireysel'
                  ],
                  (val) => setState(() => _customerGroup = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Müşteri Sınıfı',
                  _customerClass,
                  [
                    'A Sınıfı',
                    'B Sınıfı',
                    'C Sınıfı',
                    'Yeni Müşteri',
                    'Stratejik',
                  ],
                  (val) => setState(() => _customerClass = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildField(
                  'Müşteri Adı (Ünvan) *',
                  _nameController,
                  validator: (val) =>
                      val?.isEmpty ?? true ? 'Zorunlu alan' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField('Kısa Ad', _shortNameController),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                    'Ad (Şahıs Firmalar İçin)', _firstNameController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                    'Soyad (Şahıs Firmalar İçin)', _lastNameController),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField('Arama Terimi', _searchTermController),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() {
                  _oneTimeCustomer = !_oneTimeCustomer;
                  _hasUnsavedChanges = true;
                }),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: _oneTimeCustomer
                        ? const LinearGradient(
                            colors: [
                              Color(0xFF3B82F6),
                              Color(0xFF60A5FA),
                            ],
                          )
                        : null,
                    color: _oneTimeCustomer ? null : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _oneTimeCustomer
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    boxShadow: _oneTimeCustomer
                        ? [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _oneTimeCustomer
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: _oneTimeCustomer
                            ? Colors.white
                            : const Color(0xFF64748B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Tek Seferlik Müşteri',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _oneTimeCustomer
                              ? Colors.white
                              : const Color(0xFF475569),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              InkWell(
                onTap: () => setState(() {
                  _blocked = !_blocked;
                  _hasUnsavedChanges = true;
                }),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: _blocked
                        ? const LinearGradient(
                            colors: [
                              Color(0xFFEF4444),
                              Color(0xFFF87171),
                            ],
                          )
                        : null,
                    color: _blocked ? null : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _blocked
                          ? const Color(0xFFDC2626)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                    boxShadow: _blocked
                        ? [
                            BoxShadow(
                              color: const Color(0xFFEF4444).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _blocked ? Icons.block : Icons.radio_button_unchecked,
                        color:
                            _blocked ? Colors.white : const Color(0xFF64748B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Blokeli Müşteri',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              _blocked ? Colors.white : const Color(0xFF475569),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
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
          Row(
            children: [
              Expanded(
                child:
                    _buildField('Yetkili Kişi Adı', _contactPersonController),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container()),
              const SizedBox(width: 16),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Telefon Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildFieldWithChange(
                  'Telefon 1',
                  _phoneController,
                  hintText: '0(2xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_phoneController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithChange(
                  'Telefon 2',
                  _phone2Controller,
                  hintText: '0(2xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_phone2Controller),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithChange(
                  'Faks',
                  _faxController,
                  hintText: '0(2xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_faxController),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFieldWithChange(
                  'Mobil 1',
                  _mobileController,
                  hintText: '0(5xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_mobileController),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithChange(
                  'Mobil 2',
                  _mobile2Controller,
                  hintText: '0(5xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_mobile2Controller),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithChange(
                  'Mobil 3',
                  _mobile3Controller,
                  hintText: '0(5xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_mobile3Controller),
                ),
              ),
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
              const SizedBox(width: 16),
              Expanded(
                child: _buildFieldWithChange(
                  'WhatsApp',
                  _whatsappController,
                  hintText: '0(5xx) xxx xx xx',
                  onChanged: (value) => _formatPhoneNumber(_whatsappController),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Adres Bilgileri'),
          const SizedBox(height: 20),
          _buildFieldWithChange(
            'Adres Ara',
            _addressController,
            hintText: 'Örn: Şeker Mah., Ataşehir, İstanbul',
            onChanged: (value) {
              if (value.length >= 3) {
                _searchAddress();
              }
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('Ülke', _countryController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('İl', _cityController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('İlçe', _districtController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('Mahalle', _neighborhoodController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Cadde', _streetController)),
              const SizedBox(width: 16),
              Expanded(child: _buildField('Sokak', _avenueController)),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Posta Kodu',
                  _postalCodeController,
                  enabled: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildField(
            'Açık Adres',
            _openAddressController,
            maxLines: 2,
            hintText: 'Kapı no, daire no, bina adı vb. detaylar',
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Konum Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Enlem (Latitude)',
                  _latitudeController,
                  hintText: 'Örn: 41.0082',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Boylam (Longitude)',
                  _longitudeController,
                  hintText: 'Örn: 28.9784',
                  enabled: false,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Konum Adı',
                  _locationNameController,
                  hintText: 'Harita üzerinden seçilecek',
                  enabled: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Tab 3: Vergi & Kimlik
  Widget _buildTaxTab() {
    final taxNoLength =
        _taxNoController.text.replaceAll(RegExp(r'[^0-9]'), '').length;
    final identityNoLength =
        _identityNoController.text.replaceAll(RegExp(r'[^0-9]'), '').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Vergi Bilgileri'),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldWithChange(
                      'Vergi Numarası',
                      _taxNoController,
                      hintText: '10 haneli vergi numarası',
                      onChanged: (value) {
                        final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (cleaned.length <= 10) {
                          setState(() {});
                          if (cleaned.length == 10) {
                            _searchByTaxNo();
                          }
                        } else {
                          _taxNoController.text = cleaned.substring(0, 10);
                          _taxNoController.selection = TextSelection.collapsed(
                            offset: _taxNoController.text.length,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Karakter: $taxNoLength/10',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: taxNoLength == 10
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          taxNoLength == 10 ? Icons.check_circle : Icons.error,
                          size: 16,
                          color: taxNoLength == 10
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _buildFieldWithChange(
                    'Vergi Kodu',
                    _taxOfficeCodeController,
                    hintText: 'Kod ara...',
                    onChanged: (value) {
                      if (value.length >= 3) {
                        _searchTaxOffice();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _buildFieldWithChange(
                    'Vergi Dairesi',
                    _taxOfficeController,
                    hintText: 'Vergi dairesi ara...',
                    onChanged: (value) {
                      if (value.length >= 3) {
                        _searchTaxOffice();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildField('KDV Numarası', _vatNoController)),
              const SizedBox(width: 16),
              Expanded(
                child: CheckboxListTile(
                  title: const Text(
                    'Vergi Muafiyeti',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  value: _taxExempt,
                  onChanged: (val) => setState(() => _taxExempt = val!),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Kimlik Bilgileri'),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldWithChange(
                      'TC Kimlik No',
                      _identityNoController,
                      hintText: '11 haneli TC kimlik numarası',
                      onChanged: (value) {
                        final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (cleaned.length <= 11) {
                          setState(() {});
                          if (cleaned.length == 11) {
                            // TC Kimlik No ile e-Fatura kontrolü
                            _checkEInvoiceStatus(cleaned, false);
                          }
                        } else {
                          _identityNoController.text = cleaned.substring(0, 11);
                          _identityNoController.selection =
                              TextSelection.collapsed(
                            offset: _identityNoController.text.length,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Karakter: $identityNoLength/11',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: identityNoLength == 11
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          identityNoLength == 11
                              ? Icons.check_circle
                              : Icons.error,
                          size: 16,
                          color: identityNoLength == 11
                              ? const Color(0xFF10B981)
                              : const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _buildField(
                    'Ticaret Sicil No',
                    _tradeRegisterController,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: _buildField('Ticaret Odası', _chamberController),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Vergi Kategorisi & Sınıflandırma'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Vergi Kategorisi',
                  _taxCategory,
                  [
                    'Genel Vergilendirme',
                    'Stopaj Uygulamalı',
                    'Özel Matrah',
                    'İstisna/Muafiyet',
                    'Tam Tevkifat',
                  ],
                  (val) => setState(() => _taxCategory = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Vergi Mükellefiyet Türü',
                  _taxLiabilityType,
                  [
                    'Tam Mükellef',
                    'Dar Mükellef',
                    'Vergiden Muaf',
                    'Basit Usul',
                  ],
                  (val) => setState(() => _taxLiabilityType = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'KDV Tevkifat Oranı',
                  _vatWithholdingRate,
                  [
                    'Yok',
                    '%1/2 (Katma Değer Vergisi)',
                    '%3/7 (Metal, Çimento)',
                    '%5/10 (İnşaat)',
                    '%9/10 (Hurda)',
                  ],
                  (val) => setState(() => _vatWithholdingRate = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Gelir & Stopaj Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Gelir Vergisi Tevkifat',
                  _incomeTaxWithholding,
                  [
                    'Yok',
                    '%15 (Serbest Meslek)',
                    '%20 (Gayrimenkul)',
                    '%10 (Kira Geliri)',
                    '%5 (Komisyon)',
                  ],
                  (val) => setState(() => _incomeTaxWithholding = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Kurumlar Vergisi Tevkifat',
                  _corporateTaxWithholding,
                  [
                    'Yok',
                    '%0 (Kurumlar)',
                    '%15 (Danışmanlık)',
                    '%20 (Kira)',
                  ],
                  (val) => setState(() => _corporateTaxWithholding = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Damga Vergisi',
                  _stampTax,
                  [
                    'Yok',
                    '%0,948 (Standart)',
                    '%0,189 (Kağıt)',
                    'Muaf',
                  ],
                  (val) => setState(() => _stampTax = val!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('e-Fatura & e-Defter Bilgileri'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _eInvoiceActive,
                          onChanged: (val) =>
                              setState(() => _eInvoiceActive = val!),
                        ),
                        const Text(
                          'e-Fatura Mükellefi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (_eInvoiceActive)
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildField(
                              'e-Fatura GB/PK Etiketi (Alias)',
                              _eInvoiceLabelController,
                              hintText: 'urn:mail:defaultpk@...',
                              enabled: false,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _eInvoiceLabelController.text.isEmpty
                                  ? '⚠ Alias otomatik yüklenecek'
                                  : 'ℹ Birden fazla alias varsa değiştirebilirsiniz',
                              style: TextStyle(
                                fontSize: 11,
                                color: _eInvoiceLabelController.text.isEmpty
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF3B82F6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _eArchiveActive,
                          onChanged: (val) =>
                              setState(() => _eArchiveActive = val!),
                        ),
                        const Text(
                          'e-Arşiv Fatura',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (_eArchiveActive)
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: _buildDropdown(
                          'e-Arşiv Senaryosu',
                          _eArchiveScenario,
                          ['Temel', 'Ticari', 'Internet'],
                          (val) => setState(() => _eArchiveScenario = val!),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _eLedgerActive,
                          onChanged: (val) =>
                              setState(() => _eLedgerActive = val!),
                        ),
                        const Text(
                          'e-Defter Mükellefi',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Ödeme & Risk Yönetimi'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  'Ödeme Koşulu',
                  _paymentTerms,
                  [
                    '0 Gün (Peşin)',
                    '30 Gün',
                    '60 Gün',
                    '90 Gün',
                    '120 Gün',
                    'Özel Vade',
                  ],
                  (val) => setState(() => _paymentTerms = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDropdown(
                  'Risk Kategorisi',
                  _riskCategory,
                  [
                    'Düşük Risk',
                    'Orta Risk',
                    'Yüksek Risk',
                    'Çok Yüksek Risk',
                  ],
                  (val) => setState(() => _riskCategory = val!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Kredi Limiti (TL)',
                  _creditLimitController,
                  hintText: '0.00',
                ),
              ),
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
                child: _buildDropdown(
                    'Para Birimi',
                    _currency,
                    [
                      'TRY',
                      'USD',
                      'EUR',
                      'GBP',
                    ],
                    (val) => setState(() => _currency = val!)),
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
            ['Düşük Risk', 'Orta Risk', 'Yüksek Risk', 'Çok Yüksek Risk'],
            (val) => setState(() => _riskCategory = val!),
          ),
        ],
      ),
    );
  }

  // Tab 6: Muhasebe & Özel Kodlar
  Widget _buildAccountingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Muhasebe Kodları'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Muhasebe Hesap Kodu',
                  _accountingCodeController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Mutabakat Hesabı',
                  _reconciliationAccountController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Genel Muhasebe Hesabı',
                  _glAccountController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Nakit İskonto Hesabı',
                  _cashDiscountAccountController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Sıralama Anahtarı',
                  _sortKeyController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Maliyet ve Kâr Merkezi'),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  'Maliyet Merkezi',
                  _costCenterController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildField(
                  'Kâr Merkezi',
                  _profitCenterController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Özel Kodlar'),
          const SizedBox(height: 20),
          _buildField(
            'Özel Kod 1',
            _customCode1Controller,
          ),
          const SizedBox(height: 16),
          _buildField(
            'Özel Kod 2',
            _customCode2Controller,
          ),
          const SizedBox(height: 16),
          _buildField(
            'Özel Kod 3',
            _customCode3Controller,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2563EB).withOpacity(0.05),
                  const Color(0xFF38BDF8).withOpacity(0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF2563EB).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF2563EB),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Muhasebe kodları ve özel kodlar SAP FI/CO modülü ile entegrasyon için kullanılır. Bu alanlar opsiyoneldir.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF475569),
                      height: 1.4,
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

  // Tab 7: Notlar
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
      padding: const EdgeInsets.only(bottom: 14, top: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF2563EB).withOpacity(0.2),
            width: 1.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 24,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF38BDF8),
                ],
              ),
              borderRadius: BorderRadius.circular(3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1E293B),
              letterSpacing: -0.2,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldWithChange(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? hintText,
    void Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          validator: validator,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFF3498DB),
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    bool enabled = true,
    int maxLines = 1,
    String? Function(String?)? validator,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF334155),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 9),
        TextFormField(
          controller: controller,
          enabled: enabled,
          maxLines: maxLines,
          validator: validator,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 13,
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFEF4444),
                width: 2,
              ),
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
            color: Color(0xFF334155),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 9),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(value: item, child: Text(item)))
              .toList(),
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSearch,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
                letterSpacing: -0.1,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFEF4444),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          onSubmitted: (_) => onSearch(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            suffixIcon: IconButton(
              icon: const Icon(Icons.more_horiz, color: Color(0xFF64748B)),
              onPressed: onSearch,
              tooltip: 'Ara',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFCBD5E1),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 2,
              ),
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
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Kod veya vergi dairesi adı ile arayın...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF2563EB), width: 2),
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

// Şirket Kodu Arama Dialog
class _CompanyCodeSearchDialog extends StatefulWidget {
  final String initialQuery;
  final Function(String code, String name) onSelected;

  const _CompanyCodeSearchDialog({
    required this.onSelected,
    this.initialQuery = '',
  });

  @override
  State<_CompanyCodeSearchDialog> createState() =>
      _CompanyCodeSearchDialogState();
}

class _CompanyCodeSearchDialogState extends State<_CompanyCodeSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredList = [];

  final List<Map<String, String>> _companyData = [
    {'code': '1000', 'name': 'Merkez Şirket'},
    {'code': '2000', 'name': 'Üretim Şirketi'},
    {'code': '3000', 'name': 'Pazarlama Şirketi'},
    {'code': '4000', 'name': 'Lojistik Şirketi'},
    {'code': '5000', 'name': 'İthalat Şirketi'},
    {'code': '6000', 'name': 'İhracat Şirketi'},
  ];

  @override
  void initState() {
    super.initState();
    // Extract search query from initial text (e.g., "1000 - Merkez Şirket" -> "1000" or just use as-is)
    String query = widget.initialQuery;
    if (query.contains(' - ')) {
      query = query.split(' - ')[0];
    }
    _searchController.text = query;
    _filterList();
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    if (query.length < 3) {
      setState(() => _filteredList = []);
      return;
    }

    setState(() {
      _filteredList = _companyData
          .where((e) =>
              e['code']!.contains(query) ||
              e['name']!.toLowerCase().contains(query))
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 500,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFFFFFFF),
              Color(0xFFF1F5F9),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.business,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Şirket Kodu Ara',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: 'Arama (en az 3 karakter)',
                  labelStyle: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2563EB)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2563EB), width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: _filteredList.length,
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.business,
                              color: Colors.white, size: 20),
                        ),
                        title: Text(
                          '${item['code']} - ${item['name']}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 14, color: Color(0xFF94A3B8)),
                        onTap: () {
                          widget.onSelected(item['code']!, item['name']!);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Sektör Kodu Arama Dialog
class _SectorCodeSearchDialog extends StatefulWidget {
  final String initialQuery;
  final Function(String code, String name) onSelected;

  const _SectorCodeSearchDialog({
    required this.onSelected,
    this.initialQuery = '',
  });

  @override
  State<_SectorCodeSearchDialog> createState() =>
      _SectorCodeSearchDialogState();
}

class _SectorCodeSearchDialogState extends State<_SectorCodeSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredList = [];

  final List<Map<String, String>> _sectorData = [
    {'code': '10', 'name': 'Gıda Ürünleri İmalatı'},
    {'code': '11', 'name': 'İçecek İmalatı'},
    {'code': '13', 'name': 'Tekstil Ürünleri İmalatı'},
    {'code': '14', 'name': 'Giyim Eşyası İmalatı'},
    {'code': '20', 'name': 'Kimyasal Ürünlerin İmalatı'},
    {'code': '25', 'name': 'Metal Ürünleri İmalatı'},
    {'code': '26', 'name': 'Bilgisayar, Elektronik ve Optik Ürünler'},
    {'code': '28', 'name': 'Makine ve Ekipman İmalatı'},
    {'code': '46', 'name': 'Toptan Ticaret'},
    {'code': '47', 'name': 'Perakende Ticaret'},
    {'code': '49', 'name': 'Kara Taşımacılığı'},
    {'code': '52', 'name': 'Depolama ve Taşımacılık'},
    {'code': '62', 'name': 'Bilgisayar Programlama'},
    {'code': '63', 'name': 'Bilgi Hizmet Faaliyetleri'},
  ];

  @override
  void initState() {
    super.initState();
    // Extract search query from initial text (e.g., "10 - Gıda Ürünleri İmalatı" -> "10" or just use as-is)
    String query = widget.initialQuery;
    if (query.contains(' - ')) {
      query = query.split(' - ')[0];
    }
    _searchController.text = query;
    _filterList();
    _searchController.addListener(_filterList);
  }

  void _filterList() {
    final query = _searchController.text.toLowerCase();
    if (query.length < 3) {
      setState(() => _filteredList = []);
      return;
    }

    setState(() {
      _filteredList = _sectorData
          .where((e) =>
              e['code']!.contains(query) ||
              e['name']!.toLowerCase().contains(query))
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 500,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8FAFC),
              Color(0xFFFFFFFF),
              Color(0xFFF1F5F9),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2563EB).withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2563EB),
                    Color(0xFF3B82F6),
                    Color(0xFF60A5FA),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2563EB).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.category,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Sektör Kodu Ara',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Arama (en az 3 karakter)',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF2563EB)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2563EB), width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: _filteredList.length,
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.category,
                              color: Colors.white, size: 20),
                        ),
                        title: Text(
                          '${item['code']} - ${item['name']}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 14, color: Color(0xFF94A3B8)),
                        onTap: () {
                          widget.onSelected(item['code']!, item['name']!);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Adres Arama Dialog
class _AddressSearchDialog extends StatefulWidget {
  final String initialQuery;
  final Function(
    String country,
    String city,
    String district,
    String neighborhood,
    String street,
    String avenue,
    String postalCode,
    String latitude,
    String longitude,
    String locationName,
  ) onSelected;

  const _AddressSearchDialog({
    required this.onSelected,
    this.initialQuery = '',
  });

  @override
  State<_AddressSearchDialog> createState() => _AddressSearchDialogState();
}

class _AddressSearchDialogState extends State<_AddressSearchDialog> {
  final _searchController = TextEditingController();
  List<Map<String, String>> _filteredList = [];

  // Örnek adres verileri (gerçek uygulamada API'den gelecek)
  final List<Map<String, String>> _addressData = [
    {
      'country': 'Türkiye',
      'city': 'İstanbul',
      'district': 'Ataşehir',
      'neighborhood': 'Şeker Mah.',
      'street': 'Atatürk Cad.',
      'avenue': 'No:15 Sok.',
      'postal': '34750',
      'latitude': '40.9927',
      'longitude': '29.1244',
      'locationName': 'Ataşehir Merkez',
    },
    {
      'country': 'Türkiye',
      'city': 'İstanbul',
      'district': 'Kadıköy',
      'neighborhood': 'Şeker Mah.',
      'street': 'İnönü Cad.',
      'avenue': 'Gül Sok.',
      'postal': '34710',
      'latitude': '40.9902',
      'longitude': '29.0316',
      'locationName': 'Kadıköy Merkez',
    },
    {
      'country': 'Türkiye',
      'city': 'Ankara',
      'district': 'Çankaya',
      'neighborhood': 'Şeker Mah.',
      'street': 'Cumhuriyet Cad.',
      'avenue': 'İstiklal Sok.',
      'postal': '06420',
      'latitude': '39.9046',
      'longitude': '32.8597',
      'locationName': 'Çankaya Merkez',
    },
    {
      'country': 'Türkiye',
      'city': 'İzmir',
      'district': 'Konak',
      'neighborhood': 'Alsancak Mah.',
      'street': 'Kıbrıs Şehitleri Cad.',
      'avenue': 'Barış Sok.',
      'postal': '35220',
      'latitude': '38.4237',
      'longitude': '27.1428',
      'locationName': 'Konak Alsancak',
    },
    {
      'country': 'Türkiye',
      'city': 'Bursa',
      'district': 'Osmangazi',
      'neighborhood': 'Şeker Mah.',
      'street': 'Zafer Cad.',
      'avenue': 'Hürriyet Sok.',
      'postal': '16200',
      'latitude': '40.1885',
      'longitude': '29.0610',
      'locationName': 'Osmangazi Merkez',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.initialQuery;
    _filterList();
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
                e['neighborhood']!.toLowerCase().contains(query) ||
                e['street']!.toLowerCase().contains(query) ||
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
              autofocus: true,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'En az 3 harf yazarak arayın...',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF2563EB)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF2563EB), width: 2),
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
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 2,
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3498DB), Color(0xFF5DADE2)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        '${item['neighborhood']} ${item['street']} ${item['avenue']}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${item['district']} / ${item['city']}',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Posta Kodu: ${item['postal']}',
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                      onTap: () {
                        widget.onSelected(
                          item['country']!,
                          item['city']!,
                          item['district']!,
                          item['neighborhood']!,
                          item['street']!,
                          item['avenue']!,
                          item['postal']!,
                          item['latitude']!,
                          item['longitude']!,
                          item['locationName']!,
                        );
                        Navigator.pop(context);
                      },
                    ),
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
