import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/number_formatters.dart';
import 'models/customer_model.dart';
import 'providers/customer_provider.dart';

class CustomerCardPage extends StatefulWidget {
  final VoidCallback onClose;
  final String? customerId;

  const CustomerCardPage({
    super.key,
    required this.onClose,
    this.customerId,
  });

  @override
  State<CustomerCardPage> createState() => _CustomerCardPageState();
}

class _CustomerCardPageState extends State<CustomerCardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  final List<_TabItem> _tabs = [
    _TabItem(
      icon: Icons.person_outline_rounded,
      label: 'Genel',
      activeColor: Color(0xFF007AFF),
    ),
    _TabItem(
      icon: Icons.location_on_outlined,
      label: 'Adresler',
      activeColor: Color(0xFF34C759),
    ),
    _TabItem(
      icon: Icons.receipt_long_outlined,
      label: 'Vergi',
      activeColor: Color(0xFF5856D6),
    ),
    _TabItem(
      icon: Icons.shopping_bag_outlined,
      label: 'Satış',
      activeColor: Color(0xFFFF9500),
    ),
    _TabItem(
      icon: Icons.account_balance_outlined,
      label: 'Finans',
      activeColor: Color(0xFFFF3B30),
    ),
    _TabItem(
      icon: Icons.analytics_outlined,
      label: 'Muhasebe',
      activeColor: Color(0xFFAF52DE),
    ),
    _TabItem(
      icon: Icons.description_outlined,
      label: 'Notlar',
      activeColor: Color(0xFF32ADE6),
    ),
  ];

  // Hesap kodu state'leri
  String? _selectedAccountType;
  String? _previousAccountType;
  String _tempAccountCode = '';
  final TextEditingController _accountCodeController = TextEditingController();

  // Form controllers
  final TextEditingController _unvanController = TextEditingController();
  final TextEditingController _unvan2Controller = TextEditingController();
  final TextEditingController _kisaAdController = TextEditingController();
  String? _selectedAccountCategory;
  String? _selectedGroup;
  String? _selectedBranch;

  // Vergi bilgileri controllers
  final TextEditingController _vergiNoController = TextEditingController();
  final TextEditingController _tcKimlikNoController = TextEditingController();
  final TextEditingController _vergiDairesiController = TextEditingController();
  final TextEditingController _vergiKoduController = TextEditingController();
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _soyadController = TextEditingController();

  // İletişim bilgileri controllers
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _cepTelefonuController = TextEditingController();
  final TextEditingController _cepTelefonu2Controller = TextEditingController();
  final TextEditingController _epostaController = TextEditingController();
  final TextEditingController _webSitesiController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  // Adres bilgileri
  String? _selectedIl;
  String? _selectedIlce;
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _mahalleController = TextEditingController();
  final TextEditingController _caddeController = TextEditingController();
  final TextEditingController _sokakController = TextEditingController();
  final TextEditingController _postaKoduController = TextEditingController();
  final TextEditingController _adresDetayController = TextEditingController();
  final TextEditingController _adresAraController = TextEditingController();
  List<Map<String, String>> _adresSonuclari = [];
  bool _adresAraniyor = false;

  // Ticari bilgiler
  final TextEditingController _riskLimitiController = TextEditingController();
  final TextEditingController _vadeSuresiController = TextEditingController();
  String? _selectedOdemeSekli;
  String? _selectedParaBirimi;
  final TextEditingController _iskontoController = TextEditingController();

  // FocusNodes for numeric fields
  final FocusNode _riskLimitiFocusNode = FocusNode();
  final FocusNode _iskontoFocusNode = FocusNode();
  final TextEditingController _yetkiliKisiController = TextEditingController();

  // Vergi dairesi arama sonuçları
  List<Map<String, String>> _vergiDairesiSonuclari = [];
  bool _vergiDairesiAraniyor = false;

  // Vergi sekmesi state değişkenleri
  final TextEditingController _kdvOraniController = TextEditingController();
  bool _kdvIstisnasiVar = false;
  final TextEditingController _kdvIstisnaBelgeNoController =
      TextEditingController();
  final TextEditingController _kdvIstisnaBelgeTarihiController =
      TextEditingController();
  bool _ozelMatrahUygulamasi = false;
  final TextEditingController _ozelMatrahOraniController =
      TextEditingController();
  final TextEditingController _kdvTevkifatOraniController =
      TextEditingController();
  final TextEditingController _kdvTevkifatKoduController =
      TextEditingController();

  final TextEditingController _gelirVergisiStopajOraniController =
      TextEditingController();
  bool _stopajIstisnasiVar = false;
  final TextEditingController _stopajIstisnaBelgeTarihiController =
      TextEditingController();
  bool _damgaVergisiUygulamasi = false;
  bool _bsmvUygulamasi = false;

  String? _selectedEFaturaDurumu = 'Değil';
  String? _selectedEFaturaSenaryosu;
  final TextEditingController _eFaturaPostaKutusuController =
      TextEditingController();
  String? _selectedEArsivDurumu = 'Değil';
  String? _selectedEIrsaliyeDurumu = 'Değil';
  bool _eMustahsilUygulamasi = false;
  String? _selectedEFaturaGonderimSekli = 'Otomatik';

  bool _engelliIndirimiVar = false;
  final TextEditingController _engelliIndirimiOraniController =
      TextEditingController();
  bool _argeIndirimiVar = false;
  final TextEditingController _argeIndirimiBelgeNoController =
      TextEditingController();
  bool _yatirimTesvik = false;
  final TextEditingController _yatirimTesvikBelgeNoController =
      TextEditingController();
  final TextEditingController _yatirimTesvikGecerlilikController =
      TextEditingController();
  bool _teknolojiGelistirmeBolgesi = false;
  bool _serbestBolge = false;
  bool _osb = false;
  bool _gumrukMusavirligi = false;
  final TextEditingController _gumrukMusavirlikBelgeNoController =
      TextEditingController();

  String? _selectedKDVBeyanDonemi = 'Aylık';
  bool _geciciVergiMukellefi = false;
  bool _muhtasarBeyanname = false;

  final TextEditingController _faturaOzelNotController =
      TextEditingController();
  final TextEditingController _muhasebeNotlariController =
      TextEditingController();
  final TextEditingController _vergiDairesiOzelAnlasmalarController =
      TextEditingController();

  bool _iadeTalepDurumu = false;
  String? _selectedIadeYontemi;
  final TextEditingController _mahsubenIadeIBANController =
      TextEditingController();
  String? _selectedVergiIadesiSikligi;

  bool _otvMukellefi = false;
  final TextEditingController _otvOraniController = TextEditingController();

  final TextEditingController _sonVergiIncelemeTarihiController =
      TextEditingController();
  final TextEditingController _sonVergiIncelemeSonucuController =
      TextEditingController();
  bool _vergiBorcuVar = false;
  final TextEditingController _vergiBorcuTutariController =
      TextEditingController();
  final TextEditingController _vergiBorcuTaksitController =
      TextEditingController();
  bool _uzlasmaSureci = false;
  bool _ozelgeDurumu = false;
  final TextEditingController _ozelgeNoController = TextEditingController();

  String? _selectedKDVBeyannameDetay = 'Özet';
  bool _baFormGerekli = false;
  bool _formAAGerekli = false;

  // Toggle state'leri
  bool _isActive = true;
  bool _isPotential = false;

  // Form değişiklik takibi
  bool _hasUnsavedChanges = false;
  bool _isSaving = false;

  // Adres Yönetim Sistemi
  String? _selectedAdresTuru = 'Fatura Adresi';
  final List<Map<String, dynamic>> _kayitliAdresler = [];

  // Kayıtlı hesap kodları (simülasyon için)
  final Set<String> _usedAccountCodes = {'120.001', '120.002', '320.001'};
  int _lastCustomerCode = 2;
  int _lastSupplierCode = 1;

  // Vergi dairesi veritabanı (simülasyon)
  final List<Map<String, String>> _vergiDaireleri = [
    {'ad': 'Meram Vergi Dairesi', 'kod': '42201'},
    {'ad': 'Selçuklu Vergi Dairesi', 'kod': '42202'},
    {'ad': 'Karatay Vergi Dairesi', 'kod': '42203'},
    {'ad': 'Merkez Vergi Dairesi', 'kod': '06100'},
    {'ad': 'Çankaya Vergi Dairesi', 'kod': '06101'},
    {'ad': 'Kadıköy Vergi Dairesi', 'kod': '34201'},
    {'ad': 'Beşiktaş Vergi Dairesi', 'kod': '34202'},
    {'ad': 'İstanbul Vergi Dairesi', 'kod': '34001'},
  ];

  // Mükellef veritabanı (simülasyon)
  final Map<String, Map<String, String>> _mukellefler = {
    '1234567890': {
      'unvan': 'Örnek A.Ş.',
      'vergiDairesi': 'Meram Vergi Dairesi',
      'vergiKodu': '42201',
    },
    '9876543210': {
      'unvan': 'Test Ltd. Şti.',
      'vergiDairesi': 'Selçuklu Vergi Dairesi',
      'vergiKodu': '42202',
    },
  };

  // TC Kimlik veritabanı (simülasyon)
  final Map<String, Map<String, String>> _tcKimlikler = {
    '12345678901': {
      'ad': 'Ahmet',
      'soyad': 'Yılmaz',
    },
    '98765432109': {
      'ad': 'Ayşe',
      'soyad': 'Demir',
    },
  };

  // Otomatik hesap kodu üretme (geçici)
  String _generateTempAccountCode(String type) {
    switch (type) {
      case 'Müşteri':
        return '120.${(_lastCustomerCode + 1).toString().padLeft(3, '0')}';
      case 'Tedarikçi':
        return '320.${(_lastSupplierCode + 1).toString().padLeft(3, '0')}';
      case 'Müşteri & Tedarikçi':
        return '120.${(_lastCustomerCode + 1).toString().padLeft(3, '0')}';
      default:
        return '120.001';
    }
  }

  // Kalıcı hesap kodu üretme (kayıt sonrası)
  String _generateFinalAccountCode(String type) {
    switch (type) {
      case 'Müşteri':
        _lastCustomerCode++;
        return '120.${_lastCustomerCode.toString().padLeft(3, '0')}';
      case 'Tedarikçi':
        _lastSupplierCode++;
        return '320.${_lastSupplierCode.toString().padLeft(3, '0')}';
      case 'Müşteri & Tedarikçi':
        _lastCustomerCode++;
        return '120.${_lastCustomerCode.toString().padLeft(3, '0')}';
      default:
        return '120.001';
    }
  }

  // Hesap kodu kontrolü
  bool _checkAccountCodeExists(String code) {
    return _usedAccountCodes.contains(code);
  }

  // En son boşta olan kodu bul
  String _findNextAvailableCode(String prefix) {
    int counter = 1;
    while (true) {
      String code = '$prefix.${counter.toString().padLeft(3, '0')}';
      if (!_usedAccountCodes.contains(code)) {
        return code;
      }
      counter++;
    }
  }

  // Vergi dairesi arama
  void _araVergiDairesi(String query) {
    if (query.length < 3) {
      setState(() {
        _vergiDairesiSonuclari = [];
        _vergiDairesiAraniyor = false;
      });
      return;
    }

    setState(() {
      _vergiDairesiAraniyor = true;
      _vergiDairesiSonuclari = _vergiDaireleri
          .where((vd) =>
              vd['ad']!.toLowerCase().contains(query.toLowerCase()) ||
              vd['kod']!.contains(query))
          .toList();
    });
  }

  // Adres arama
  void _araAdres(String query) {
    if (query.length < 2) {
      setState(() {
        _adresSonuclari = [];
        _adresAraniyor = false;
      });
      return;
    }

    setState(() {
      _adresAraniyor = true;
      // Adres veritabanı simülasyonu
      final adresler = [
        {
          'il': 'İstanbul',
          'ilce': 'Ümraniye',
          'mahalle': 'Esentepe Mahallesi',
          'postaKodu': '34768'
        },
        {
          'il': 'İstanbul',
          'ilce': 'Ümraniye',
          'mahalle': 'Çakmak Mahallesi',
          'postaKodu': '34770'
        },
        {
          'il': 'İstanbul',
          'ilce': 'Ümraniye',
          'mahalle': 'Hekimbaşı Mahallesi',
          'postaKodu': '34771'
        },
        {
          'il': 'İstanbul',
          'ilce': 'Kadıköy',
          'mahalle': 'Acıbadem Mahallesi',
          'postaKodu': '34718'
        },
        {
          'il': 'İstanbul',
          'ilce': 'Kadıköy',
          'mahalle': 'Fenerbahçe Mahallesi',
          'postaKodu': '34726'
        },
        {
          'il': 'İstanbul',
          'ilce': 'Beşiktaş',
          'mahalle': 'Levent Mahallesi',
          'postaKodu': '34330'
        },
        {
          'il': 'Ankara',
          'ilce': 'Çankaya',
          'mahalle': 'Kızılay Mahallesi',
          'postaKodu': '06420'
        },
        {
          'il': 'Ankara',
          'ilce': 'Çankaya',
          'mahalle': 'Bahçelievler Mahallesi',
          'postaKodu': '06490'
        },
        {
          'il': 'İzmir',
          'ilce': 'Karşıyaka',
          'mahalle': 'Bostanlı Mahallesi',
          'postaKodu': '35590'
        },
        {
          'il': 'İzmir',
          'ilce': 'Karşıyaka',
          'mahalle': 'Mavişehir Mahallesi',
          'postaKodu': '35580'
        },
        {
          'il': 'Konya',
          'ilce': 'Selçuklu',
          'mahalle': 'Yazır Mahallesi',
          'postaKodu': '42250'
        },
        {
          'il': 'Konya',
          'ilce': 'Selçuklu',
          'mahalle': 'Bosna Hersek Mahallesi',
          'postaKodu': '42070'
        },
        {
          'il': 'Konya',
          'ilce': 'Meram',
          'mahalle': 'Yaka Mahallesi',
          'postaKodu': '42090'
        },
      ];

      _adresSonuclari = adresler
          .where((adres) =>
              adres['il']!.toLowerCase().contains(query.toLowerCase()) ||
              adres['ilce']!.toLowerCase().contains(query.toLowerCase()) ||
              adres['mahalle']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Vergi numarası sorgulama
  void _sorgulaVergiNo(String vergiNo) {
    if (vergiNo.length != 10) return;

    if (_mukellefler.containsKey(vergiNo)) {
      final mukellef = _mukellefler[vergiNo]!;
      setState(() {
        _unvanController.text = mukellef['unvan']!;
        _vergiDairesiController.text = mukellef['vergiDairesi']!;
        _vergiKoduController.text = mukellef['vergiKodu']!;
      });
      _showSuccessMessage('Mükellef bilgileri bulundu ve dolduruldu');
    } else {
      _showValidationError('Bu vergi numarasına ait mükellef bulunamadı');
    }
  }

  // TC Kimlik numarası sorgulama
  void _sorgulaTcKimlik(String tcKimlik) {
    if (tcKimlik.length != 11) return;

    if (_tcKimlikler.containsKey(tcKimlik)) {
      final kisi = _tcKimlikler[tcKimlik]!;
      setState(() {
        _adController.text = kisi['ad']!;
        _soyadController.text = kisi['soyad']!;
        _unvanController.text = '${kisi['ad']} ${kisi['soyad']}';
      });
      _showSuccessMessage('Kişi bilgileri bulundu ve dolduruldu');
    } else {
      _showValidationError('Bu TC kimlik numarasına ait kişi bulunamadı');
    }
  }

  // Form validasyonu
  bool _validateForm() {
    if (_selectedAccountType == null || _selectedAccountType!.isEmpty) {
      _showValidationError('Hesap tipi seçmelisiniz');
      return false;
    }
    if (_selectedAccountCategory == null) {
      _showValidationError('Hesap türü seçmelisiniz');
      return false;
    }
    if (_unvanController.text.trim().isEmpty) {
      _showValidationError('Ünvan alanı zorunludur');
      return false;
    }

    // E-posta formatı kontrolü
    if (_epostaController.text.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(_epostaController.text.trim())) {
        _showValidationError('Geçerli bir e-posta adresi giriniz');
        return false;
      }
    }

    // Telefon numarası kontrolü
    if (_telefonController.text.trim().isNotEmpty) {
      final cleanPhone =
          _telefonController.text.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanPhone.length != 11) {
        _showValidationError('Telefon numarası 11 haneli olmalıdır');
        return false;
      }
    }

    // Vergi No kontrolü (10 haneli olmalı)
    if (_vergiNoController.text.trim().isNotEmpty &&
        _vergiNoController.text.length != 10) {
      _showValidationError('Vergi numarası 10 haneli olmalıdır');
      return false;
    }

    // TC Kimlik No kontrolü (11 haneli olmalı)
    if (_tcKimlikNoController.text.trim().isNotEmpty &&
        _tcKimlikNoController.text.length != 11) {
      _showValidationError('TC Kimlik numarası 11 haneli olmalıdır');
      return false;
    }

    return true;
  }

  // Form doluluk kontrolü
  bool _hasFormData() {
    return _unvanController.text.trim().isNotEmpty ||
        _unvan2Controller.text.trim().isNotEmpty ||
        _kisaAdController.text.trim().isNotEmpty ||
        _vergiNoController.text.trim().isNotEmpty ||
        _tcKimlikNoController.text.trim().isNotEmpty ||
        _telefonController.text.trim().isNotEmpty ||
        _cepTelefonuController.text.trim().isNotEmpty ||
        _epostaController.text.trim().isNotEmpty ||
        _selectedAccountType != null ||
        _selectedIl != null ||
        _kayitliAdresler.isNotEmpty;
  }

  void _showValidationError(String message) {
    _showAnimatedNotification(
      message: message,
      icon: Icons.warning_rounded,
      backgroundColor: const Color(0xFFFF3B30),
    );
  }

  void _showAccountCodeWarning(String code) {
    _showAnimatedNotification(
      message:
          '$code kodu daha önce kullanılmış! Yeni kod: ${_tempAccountCode}',
      icon: Icons.info_rounded,
      backgroundColor: const Color(0xFFFF9500),
    );
  }

  void _showSuccessMessage(String message) {
    _showAnimatedNotification(
      message: message,
      icon: Icons.check_circle_rounded,
      backgroundColor: const Color(0xFF34C759),
      duration: const Duration(seconds: 2),
    );
  }

  void _showAnimatedNotification({
    required String message,
    required IconData icon,
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedNotificationCard(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        onDismiss: () => overlayEntry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(overlayEntry);
  }

  // Telefon numarası formatlama
  void _formatPhoneNumber(String value, TextEditingController controller) {
    // Sadece rakamları al
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      controller.value = TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    String formatted = '';
    int cursorPosition = 0;

    // İlk rakam 0 değilse otomatik ekle
    final phoneDigits = digits.startsWith('0') ? digits : '0$digits';

    // Format: 0(xxx) xxx xx xx
    if (phoneDigits.length > 0) {
      formatted = phoneDigits[0]; // 0
      if (phoneDigits.length > 1) {
        formatted +=
            '(${phoneDigits.substring(1, phoneDigits.length > 4 ? 4 : phoneDigits.length)}';
        if (phoneDigits.length >= 4) {
          formatted += ')';
          if (phoneDigits.length > 4) {
            formatted +=
                ' ${phoneDigits.substring(4, phoneDigits.length > 7 ? 7 : phoneDigits.length)}';
            if (phoneDigits.length > 7) {
              formatted +=
                  ' ${phoneDigits.substring(7, phoneDigits.length > 9 ? 9 : phoneDigits.length)}';
              if (phoneDigits.length > 9) {
                formatted +=
                    ' ${phoneDigits.substring(9, phoneDigits.length > 11 ? 11 : phoneDigits.length)}';
              }
            }
          }
        }
      }
    }

    cursorPosition = formatted.length;

    controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }

  // Çıkış uyarısı göster
  Future<bool> _showExitConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9500).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_rounded,
                color: Color(0xFFFF9500),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Kaydedilmemiş Değişiklikler',
              style: TextStyle(
                fontFamily: '.SF Pro Display',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1E),
              ),
            ),
          ],
        ),
        content: const Text(
          'Kaydedilmemiş değişiklikleriniz var. Çıkmak istediğinize emin misiniz?',
          style: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 14,
            color: Color(0xFF8E8E93),
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'İptal',
              style: TextStyle(
                fontFamily: '.SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Çık',
              style: TextStyle(
                fontFamily: '.SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });
    // Hesap kodu başlangıçta boş
    _accountCodeController.text = '';

    // Add listeners for decimal formatting on blur
    _riskLimitiFocusNode.addListener(_onRiskLimitiFocusChange);
    _iskontoFocusNode.addListener(_onIskontoFocusChange);

    // Form değişiklik takibi için listener'lar ekle
    _unvanController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _unvan2Controller
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _kisaAdController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _vergiNoController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _tcKimlikNoController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _telefonController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _cepTelefonuController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
    _epostaController
        .addListener(() => setState(() => _hasUnsavedChanges = true));
  }

  // Müşteri kaydetme
  Future<void> _saveCustomer() async {
    // Validation
    if (_unvanController.text.trim().isEmpty) {
      _showErrorSnackbar('Ünvan alanı zorunludur');
      return;
    }

    if (_accountCodeController.text.trim().isEmpty) {
      _showErrorSnackbar('Hesap kodu alanı zorunludur');
      return;
    }

    if (_selectedAccountType == null) {
      _showErrorSnackbar('Hesap tipi seçimi zorunludur');
      return;
    }

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<CustomerProvider>(context, listen: false);

      // Customer nesnesi oluştur
      final customer = Customer(
        id: widget.customerId ?? const Uuid().v4(),
        code: _accountCodeController.text.trim(),
        accountGroup: _selectedAccountType!,
        customerType: _selectedAccountCategory,
        branch: _selectedBranch,
        customerGroup: _selectedGroup,
        name: _unvanController.text.trim(),
        companyCode: _kisaAdController.text.trim(),
        taxOfficeName: _vergiDairesiController.text.trim(),
        taxNumber: _vergiNoController.text.trim(),
        phone: _telefonController.text.trim(),
        mobile: _cepTelefonuController.text.trim(),
        email: _epostaController.text.trim(),
        website: _webSitesiController.text.trim(),
        whatsapp: _whatsappController.text.trim(),
        city: _selectedIl,
        district: _selectedIlce,
        address: _adresController.text.trim(),
        neighborhood: _mahalleController.text.trim(),
        street: _sokakController.text.trim(),
        avenue: _caddeController.text.trim(),
        postalCode: _postaKoduController.text.trim(),
        openAddress: _adresDetayController.text.trim(),
        creditLimit:
            NumberParser.parseTurkish(_riskLimitiController.text) ?? 0.0,
        paymentTerms: _vadeSuresiController.text.trim(),
        paymentMethod: _selectedOdemeSekli,
        currency: _selectedParaBirimi ?? 'TRY',
        status: _isActive ? 'Aktif' : 'Pasif',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        needsSync: false,
      );

      // Provider aracılığıyla kaydet
      bool success;
      if (widget.customerId != null) {
        success = await provider.updateCustomer(customer);
      } else {
        success = await provider.addCustomer(customer);
      }

      if (success) {
        setState(() {
          _isSaving = false;
          _hasUnsavedChanges = false;
        });
        _showSuccessSnackbar(
          widget.customerId != null
              ? 'Müşteri başarıyla güncellendi'
              : 'Müşteri başarıyla kaydedildi',
        );

        // 1.5 saniye sonra kapat
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) {
            widget.onClose();
          }
        });
      } else {
        setState(() => _isSaving = false);
        _showErrorSnackbar('Kayıt sırasında bir hata oluştu');
      }
    } catch (e) {
      setState(() => _isSaving = false);
      _showErrorSnackbar('Hata: ${e.toString()}');
    }
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFFFF3B30),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _accountCodeController.dispose();
    _unvanController.dispose();
    _kisaAdController.dispose();
    _vergiNoController.dispose();
    _tcKimlikNoController.dispose();
    _vergiDairesiController.dispose();
    _vergiKoduController.dispose();
    _adController.dispose();
    _soyadController.dispose();
    _telefonController.dispose();
    _cepTelefonuController.dispose();
    _cepTelefonu2Controller.dispose();
    _adresAraController.dispose();
    _epostaController.dispose();
    _webSitesiController.dispose();
    _whatsappController.dispose();
    _adresController.dispose();
    _postaKoduController.dispose();
    _riskLimitiController.dispose();
    _vadeSuresiController.dispose();
    _iskontoController.dispose();
    _yetkiliKisiController.dispose();
    _riskLimitiFocusNode.dispose();
    _iskontoFocusNode.dispose();
    super.dispose();
  }

  // Ondalık formatlama fonksiyonları
  void _onRiskLimitiFocusChange() {
    if (!_riskLimitiFocusNode.hasFocus) {
      _formatDecimalField(_riskLimitiController, 2);
    }
  }

  void _onIskontoFocusChange() {
    if (!_iskontoFocusNode.hasFocus) {
      _formatDecimalField(_iskontoController, 2);
    }
  }

  void _formatDecimalField(TextEditingController controller, int decimals) {
    String text = controller.text.trim();
    if (text.isEmpty) return;

    // Noktaları temizle ve virgülü noktaya çevir
    text = text.replaceAll('.', '').replaceAll(',', '.');

    try {
      double value = double.parse(text);

      // Türk formatına çevir
      String integerPart = value.floor().toString();
      String decimalPart = ((value - value.floor()) * 100)
          .round()
          .toString()
          .padLeft(decimals, '0');

      // Binlik ayracı ekle
      String formattedInteger = '';
      int count = 0;
      for (int i = integerPart.length - 1; i >= 0; i--) {
        if (count == 3) {
          formattedInteger = '.' + formattedInteger;
          count = 0;
        }
        formattedInteger = integerPart[i] + formattedInteger;
        count++;
      }

      controller.text = '$formattedInteger,$decimalPart';
    } catch (e) {
      // Hatalı format, olduğu gibi bırak
    }
  }

  // Adres Ekle Butonu
  Widget _buildAdresEkleButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Container(
          height: 44,
          child: ElevatedButton.icon(
            onPressed: _adresEkle,
            icon: const Icon(Icons.add_location_rounded, size: 16),
            label: const Text(
              'Adres Ekle',
              style: TextStyle(
                fontFamily: '.SF Pro Display',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  // Adres kaydetme
  void _adresEkle() {
    if (_selectedAdresTuru == null || _selectedAdresTuru!.isEmpty) {
      _showValidationError('Lütfen adres türü seçiniz');
      return;
    }

    // En az bir adres bilgisi girilmiş olmalı
    final hasAnyAddress = _selectedIl != null ||
        _mahalleController.text.trim().isNotEmpty ||
        _caddeController.text.trim().isNotEmpty ||
        _sokakController.text.trim().isNotEmpty ||
        _adresController.text.trim().isNotEmpty ||
        _adresDetayController.text.trim().isNotEmpty;

    if (!hasAnyAddress) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Lütfen en az bir adres bilgisi giriniz',
                  style: TextStyle(
                    fontFamily: '.SF Pro Display',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFFF9500),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
        ),
      );
      return;
    }

    final mevcutAdres = _kayitliAdresler.firstWhere(
      (adres) => adres['tur'] == _selectedAdresTuru,
      orElse: () => {},
    );

    if (mevcutAdres.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_rounded,
                    color: Color(0xFFFF9500), size: 24),
              ),
              const SizedBox(width: 12),
              const Text(
                'Adres Güncelle?',
                style: TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1C1E),
                ),
              ),
            ],
          ),
          content: Text(
            '$_selectedAdresTuru zaten kayıtlı. Mevcut adresi güncellemek istiyor musunuz?',
            style: const TextStyle(
              fontFamily: '.SF Pro Display',
              fontSize: 14,
              color: Color(0xFF8E8E93),
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'İptal',
                style: TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _kaydetVeTemizle(guncelle: true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9500),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Güncelle',
                style: TextStyle(
                  fontFamily: '.SF Pro Display',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      _kaydetVeTemizle(guncelle: false);
    }
  }

  void _kaydetVeTemizle({required bool guncelle}) {
    final yeniAdres = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'tur': _selectedAdresTuru ?? '',
      'il': _selectedIl ?? '',
      'ilce': _selectedIlce ?? '',
      'mahalle': _mahalleController.text,
      'cadde': _caddeController.text,
      'sokak': _sokakController.text,
      'postaKodu': _postaKoduController.text,
      'detay': _adresDetayController.text,
      'tamAdres': _buildTamAdresString(),
    };

    setState(() {
      if (guncelle) {
        final index =
            _kayitliAdresler.indexWhere((a) => a['tur'] == _selectedAdresTuru);
        _kayitliAdresler[index] = yeniAdres;
      } else {
        _kayitliAdresler.add(yeniAdres);
      }
      _selectedIl = null;
      _selectedIlce = null;
      _mahalleController.clear();
      _caddeController.clear();
      _sokakController.clear();
      _postaKoduController.clear();
      _adresDetayController.clear();
      _adresAraController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              guncelle
                  ? '✓ Adres güncellendi'
                  : '✓ Adres eklendi (${_kayitliAdresler.length} adres)',
              style: const TextStyle(
                fontFamily: '.SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF34C759),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _buildTamAdresString() {
    final parts = <String>[];
    if (_mahalleController.text.isNotEmpty) parts.add(_mahalleController.text);
    if (_caddeController.text.isNotEmpty) parts.add(_caddeController.text);
    if (_sokakController.text.isNotEmpty) parts.add(_sokakController.text);
    if (_adresDetayController.text.isNotEmpty)
      parts.add(_adresDetayController.text);
    if (_selectedIlce != null && _selectedIlce!.isNotEmpty)
      parts.add(_selectedIlce!);
    if (_selectedIl != null && _selectedIl!.isNotEmpty) parts.add(_selectedIl!);
    if (_postaKoduController.text.isNotEmpty)
      parts.add(_postaKoduController.text);
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildUltraPremiumTabBar(),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              child: _buildTabContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUltraPremiumTabBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _tabs[_currentTabIndex].activeColor,
                      _tabs[_currentTabIndex].activeColor.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color:
                          _tabs[_currentTabIndex].activeColor.withOpacity(0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  _tabs[_currentTabIndex].icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Müşteri Kartı',
                      style: TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.customerId ?? 'Yeni Kayıt',
                      style: const TextStyle(
                        fontFamily: '.SF Pro Display',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8E8E93),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(Icons.close_rounded, widget.onClose),
            ],
          ),
          const SizedBox(height: 24),
          // Cam efektli (glassmorphism) sekme tasarımı
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    return Expanded(
                      child: _buildModernTab(index),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTab(int index) {
    final isActive = index == _currentTabIndex;
    final tab = _tabs[index];

    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          gradient: isActive
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    const Color(0xFFFFFFFE),
                  ],
                )
              : null,
          borderRadius: BorderRadius.circular(14),
          border: isActive
              ? Border.all(
                  color: tab.activeColor.withOpacity(0.2),
                  width: 1.5,
                )
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: tab.activeColor.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.all(isActive ? 5 : 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? tab.activeColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  tab.icon,
                  size: isActive ? 16 : 15,
                  color: isActive ? tab.activeColor : const Color(0xFF8B92A0),
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontFamily: '.SF Pro Display',
                      fontSize: isActive ? 9.5 : 9,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isActive ? tab.activeColor : const Color(0xFF8B92A0),
                      letterSpacing: isActive ? -0.1 : 0,
                      height: 1.0,
                    ),
                    child: Text(
                      tab.label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E5EA),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 22,
            color: const Color(0xFF8E8E93),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildGenelTab(),
        _buildAdreslerTab(),
        _buildVergiTab(),
        _buildPlaceholderTab(3),
        _buildPlaceholderTab(4),
        _buildPlaceholderTab(5),
        _buildPlaceholderTab(6),
      ],
    );
  }

  Widget _buildGenelTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF5F7FA),
            const Color(0xFFE8EDF4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Genel Bilgiler başlığı ve toggle'lar
            Row(
              children: [
                Expanded(
                  child: _buildSectionTitle(
                      'Genel Bilgiler', Icons.business_rounded),
                ),
                _buildCompactToggle(
                  icon: Icons.check_circle_rounded,
                  label: 'Aktif',
                  value: _isActive,
                  activeColor: const Color(0xFF34C759),
                  onChanged: (value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
                const SizedBox(width: 12),
                _buildCompactToggle(
                  icon: Icons.star_rounded,
                  label: 'Potansiyel',
                  value: _isPotential,
                  activeColor: const Color(0xFFFF9500),
                  onChanged: (value) {
                    setState(() {
                      _isPotential = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 18),
            // 1. SATIR: Hesap Kodu + Hesap Tipi + Hesap Türü
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildEditableAccountCode(),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    label: 'Hesap Tipi',
                    hint: 'Tip seçin',
                    icon: Icons.account_tree_rounded,
                    isRequired: true,
                    value: _selectedAccountType,
                    items: ['Müşteri', 'Tedarikçi', 'Müşteri & Tedarikçi'],
                    onChanged: (value) {
                      setState(() {
                        _previousAccountType = _selectedAccountType;
                        _selectedAccountType = value;
                        if (value != null) {
                          _tempAccountCode = _generateTempAccountCode(value);
                          _accountCodeController.text = _tempAccountCode;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    label: 'Hesap Türü',
                    hint: 'Tür seçin',
                    icon: Icons.category_rounded,
                    isRequired: true,
                    items: ['Bireysel', 'Kurumsal'],
                    value: _selectedAccountCategory,
                    onChanged: (value) {
                      setState(() {
                        _selectedAccountCategory = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 2. SATIR: Kısa Ad + Hesap Grubu + Şube
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    label: 'Kısa Ad',
                    hint: 'Kısa tanımlama',
                    icon: Icons.label_rounded,
                    controller: _kisaAdController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    label: 'Hesap Grubu',
                    hint: 'Grup seçin',
                    icon: Icons.workspaces_rounded,
                    items: ['Perakende', 'Toptan', 'VIP', 'Bayi'],
                    value: _selectedGroup,
                    onChanged: (value) {
                      setState(() {
                        _selectedGroup = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: _buildDropdown(
                    label: 'Şube',
                    hint: 'Şube seçin',
                    icon: Icons.location_city_rounded,
                    items: ['Merkez', 'Ankara', 'İstanbul', 'İzmir'],
                    value: _selectedBranch,
                    onChanged: (value) {
                      setState(() {
                        _selectedBranch = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 3. SATIR: Ünvan
            _buildTextField(
              label: 'Ünvan',
              hint: 'Şirket ünvanı veya ad soyad',
              icon: Icons.business_rounded,
              isRequired: true,
              controller: _unvanController,
            ),
            const SizedBox(height: 12),
            // 4. SATIR: Ünvan 2
            _buildTextField(
              label: 'Ünvan 2',
              hint: 'Ek ünvan bilgisi (opsiyonel)',
              icon: Icons.business_outlined,
              controller: _unvan2Controller,
            ),

            const SizedBox(height: 20),
            // Ayırıcı çizgi
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFE5E5EA).withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. SATIR: Vergi No + Vergi Dairesi + Vergi Kodu (Kurumsal)
            Row(
              children: [
                Expanded(
                  child: _buildVergiNoField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVergiDairesiField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildVergiKoduField(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 5. SATIR: TC Kimlik + Ad + Soyad (Bireysel)
            Row(
              children: [
                Expanded(
                  child: _buildTcKimlikField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Ad',
                    hint: 'Adınız',
                    icon: Icons.person_outline_rounded,
                    controller: _adController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    label: 'Soyad',
                    hint: 'Soyadınız',
                    icon: Icons.person_outline_rounded,
                    controller: _soyadController,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // İletişim Bilgileri Bölümü
            _buildPremiumSectionHeader('İletişim Bilgileri',
                Icons.phone_in_talk_rounded, const Color(0xFF34C759)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Telefon',
                    hint: '0(xxx) xxx xx xx',
                    icon: Icons.phone_outlined,
                    controller: _telefonController,
                    accentColor: const Color(0xFF34C759),
                    onChanged: _formatPhoneNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Cep Telefonu',
                    hint: '0(5xx) xxx xx xx',
                    icon: Icons.smartphone_rounded,
                    controller: _cepTelefonuController,
                    accentColor: const Color(0xFF34C759),
                    onChanged: _formatPhoneNumber,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Cep Telefonu 2',
                    hint: '0(5xx) xxx xx xx',
                    icon: Icons.smartphone_rounded,
                    controller: _cepTelefonu2Controller,
                    accentColor: const Color(0xFF34C759),
                    onChanged: _formatPhoneNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'E-posta',
                    hint: 'ornek@sirket.com',
                    icon: Icons.email_outlined,
                    controller: _epostaController,
                    accentColor: const Color(0xFF34C759),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Web Sitesi',
                    hint: 'www.ornek.com',
                    icon: Icons.language_rounded,
                    controller: _webSitesiController,
                    accentColor: const Color(0xFF34C759),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'WhatsApp',
                    hint: '0(5xx) xxx xx xx',
                    icon: Icons.chat_bubble_outline_rounded,
                    controller: _whatsappController,
                    accentColor: const Color(0xFF34C759),
                    onChanged: _formatPhoneNumber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            // Adres Bilgileri Bölümü
            _buildPremiumSectionHeader('Adres Bilgileri',
                Icons.location_on_rounded, const Color(0xFFFF9500)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildAdresAraField(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildPremiumDropdown(
                          label: 'Tür',
                          hint: 'Seçiniz',
                          icon: Icons.label_outlined,
                          items: [
                            'Fatura Adresi',
                            'Sevk Adresi',
                            'İade Adresi',
                            'Şirket Merkez',
                            'Şube Adresi',
                            'Depo Adresi',
                          ],
                          value: _selectedAdresTuru,
                          onChanged: (value) {
                            setState(() {
                              _selectedAdresTuru = value;
                            });
                          },
                          accentColor: const Color(0xFFFF9500),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: _adresEkle,
                                icon: const Icon(Icons.add_location_rounded,
                                    size: 18),
                                label: const Text(
                                  'Ekle',
                                  style: TextStyle(
                                    fontFamily: '.SF Pro Display',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF9500),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                ),
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
            const SizedBox(height: 12),
            // İl | İlçe | Mahalle
            Row(
              children: [
                Expanded(
                  child: _buildPremiumDropdown(
                    label: 'İl',
                    hint: 'İl seçin',
                    icon: Icons.location_city_rounded,
                    items: [
                      'Ankara',
                      'İstanbul',
                      'İzmir',
                      'Konya',
                      'Antalya',
                      'Bursa'
                    ],
                    value: _selectedIl,
                    onChanged: (value) {
                      setState(() {
                        _selectedIl = value;
                        _selectedIlce = null;
                      });
                    },
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumDropdown(
                    label: 'İlçe',
                    hint: _selectedIl == null ? 'Önce il seçin' : 'İlçe seçin',
                    icon: Icons.location_city_outlined,
                    items: _selectedIl == null
                        ? []
                        : (_selectedIl == 'Konya'
                            ? ['Meram', 'Selçuklu', 'Karatay']
                            : ['Merkez']),
                    value: _selectedIl == null ? null : _selectedIlce,
                    onChanged: (value) {
                      if (_selectedIl != null) {
                        setState(() {
                          _selectedIlce = value;
                        });
                      }
                    },
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Mahalle',
                    hint: 'Mahalle adı',
                    icon: Icons.home_work_rounded,
                    controller: _mahalleController,
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Cadde | Sokak | Posta Kodu
            Row(
              children: [
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Cadde',
                    hint: 'Cadde adı',
                    icon: Icons.signpost_rounded,
                    controller: _caddeController,
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Sokak',
                    hint: 'Sokak adı',
                    icon: Icons.route_rounded,
                    controller: _sokakController,
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Posta Kodu',
                    hint: '42000',
                    icon: Icons.markunread_mailbox_rounded,
                    controller: _postaKoduController,
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPremiumTextField(
              label: 'Adres Detayı',
              hint: 'Bina no, kat, daire vb.',
              icon: Icons.home_outlined,
              controller: _adresController,
              accentColor: const Color(0xFFFF9500),
              maxLines: 4,
            ),

            const SizedBox(height: 24),
            // Ticari Bilgiler Bölümü
            _buildPremiumSectionHeader('Ticari Bilgiler',
                Icons.business_center_rounded, const Color(0xFFAF52DE)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Risk Limiti',
                    hint: '0,00',
                    icon: Icons.account_balance_wallet_rounded,
                    controller: _riskLimitiController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' ₺',
                    inputFormatters: [TurkishNumberFormatter(decimalDigits: 2)],
                    focusNode: _riskLimitiFocusNode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Vade',
                    hint: '0',
                    icon: Icons.event_note_rounded,
                    controller: _vadeSuresiController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' Gün',
                    inputFormatters: [TurkishIntegerFormatter()],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumDropdown(
                    label: 'Ödeme Şekli',
                    hint: 'Seçiniz',
                    icon: Icons.payment_rounded,
                    items: [
                      'Nakit',
                      'Kredi Kartı',
                      'Havale/EFT',
                      'Çek',
                      'Senet'
                    ],
                    value: _selectedOdemeSekli,
                    onChanged: (value) {
                      setState(() {
                        _selectedOdemeSekli = value;
                      });
                    },
                    accentColor: const Color(0xFFAF52DE),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildPremiumDropdown(
                    label: 'Para Birimi',
                    hint: 'Seçiniz',
                    icon: Icons.attach_money_rounded,
                    items: ['TRY (₺)', 'USD (\$)', 'EUR (€)', 'GBP (£)'],
                    value: _selectedParaBirimi,
                    onChanged: (value) {
                      setState(() {
                        _selectedParaBirimi = value;
                      });
                    },
                    accentColor: const Color(0xFFAF52DE),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'İskonto Oranı',
                    hint: '0,00',
                    icon: Icons.percent_rounded,
                    controller: _iskontoController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' %',
                    inputFormatters: [PercentageFormatter(decimalDigits: 2)],
                    focusNode: _iskontoFocusNode,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPremiumTextField(
                    label: 'Yetkili Kişi',
                    hint: 'Satış sorumlusu adı',
                    icon: Icons.person_pin_rounded,
                    controller: _yetkiliKisiController,
                    accentColor: const Color(0xFFAF52DE),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Kaydet Butonu - Ultra Premium
            _buildUltraPremiumSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildVergiTab() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8F9FA),
            const Color(0xFFFFFFFF),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Premium Header
            _buildPremiumSectionHeader(
              'Vergi Bilgileri',
              Icons.account_balance_rounded,
              const Color(0xFF5856D6),
            ),
            const SizedBox(height: 24),

            // KDV ve Matrah Bilgileri Kartı
            _buildAppleCard(
              icon: Icons.calculate_outlined,
              title: 'KDV ve Matrah',
              color: const Color(0xFF007AFF),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _kdvOraniController,
                          label: 'KDV Oranı',
                          hint: '%',
                          icon: Icons.percent_rounded,
                          inputFormatters: [PercentageFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'KDV İstisnası',
                          value: _kdvIstisnasiVar,
                          onChanged: (value) {
                            setState(() {
                              _kdvIstisnasiVar = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _kdvIstisnaBelgeNoController,
                          label: 'İstisna Belge No',
                          hint: 'Belge numarası',
                          icon: Icons.badge_outlined,
                          enabled: _kdvIstisnasiVar,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _kdvIstisnaBelgeTarihiController,
                          label: 'İstisna Belgesi Tarihi',
                          hint: 'GG.AA.YYYY',
                          icon: Icons.calendar_today_rounded,
                          enabled: _kdvIstisnasiVar,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Özel Matrah Uygulaması',
                          value: _ozelMatrahUygulamasi,
                          onChanged: (value) {
                            setState(() {
                              _ozelMatrahUygulamasi = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _ozelMatrahOraniController,
                          label: 'Matrah Oranı',
                          hint: '%',
                          icon: Icons.percent_rounded,
                          enabled: _ozelMatrahUygulamasi,
                          inputFormatters: [PercentageFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _kdvTevkifatOraniController,
                          label: 'KDV Tevkifat Oranı',
                          hint: '%',
                          icon: Icons.account_balance_outlined,
                          inputFormatters: [PercentageFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _kdvTevkifatKoduController,
                          label: 'KDV Tevkifat Kodu',
                          hint: 'Kod',
                          icon: Icons.qr_code_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stopaj ve Kesinti Kartı
            _buildAppleCard(
              icon: Icons.cut_outlined,
              title: 'Stopaj ve Kesinti Bilgileri',
              color: const Color(0xFF34C759),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _gelirVergisiStopajOraniController,
                          label: 'Gelir Vergisi Stopajı',
                          hint: '%',
                          icon: Icons.money_off_rounded,
                          inputFormatters: [PercentageFormatter()],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Stopaj İstisnası',
                          value: _stopajIstisnasiVar,
                          onChanged: (value) {
                            setState(() {
                              _stopajIstisnasiVar = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _stopajIstisnaBelgeTarihiController,
                    label: 'İstisna Belgesi Tarihi',
                    hint: 'GG.AA.YYYY',
                    icon: Icons.calendar_today_rounded,
                    enabled: _stopajIstisnasiVar,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Damga Vergisi Uygulaması',
                          value: _damgaVergisiUygulamasi,
                          onChanged: (value) {
                            setState(() {
                              _damgaVergisiUygulamasi = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'BSMV Uygulaması',
                          value: _bsmvUygulamasi,
                          onChanged: (value) {
                            setState(() {
                              _bsmvUygulamasi = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // e-Belge Entegrasyon Kartı
            _buildAppleCard(
              icon: Icons.cloud_outlined,
              title: 'e-Belge Entegrasyon',
              color: const Color(0xFF5856D6),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'e-Fatura Durumu',
                          hint: 'Seçin',
                          icon: Icons.receipt_long_rounded,
                          value: _selectedEFaturaDurumu,
                          items: ['Mükellefi', 'Değil'],
                          onChanged: (value) {
                            setState(() {
                              _selectedEFaturaDurumu = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'e-Fatura Senaryosu',
                          hint: 'Seçin',
                          icon: Icons.category_outlined,
                          value: _selectedEFaturaSenaryosu,
                          items: ['Temel', 'Ticari', 'Kamu'],
                          enabled: _selectedEFaturaDurumu == 'Mükellefi',
                          onChanged: (value) {
                            setState(() {
                              _selectedEFaturaSenaryosu = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _eFaturaPostaKutusuController,
                    label: 'e-Fatura Posta Kutusu Etiketi',
                    hint: 'GİB etiketi',
                    icon: Icons.email_outlined,
                    enabled: _selectedEFaturaDurumu == 'Mükellefi',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'e-Arşiv Durumu',
                          hint: 'Seçin',
                          icon: Icons.archive_outlined,
                          value: _selectedEArsivDurumu,
                          items: ['Mükellefi', 'Değil'],
                          onChanged: (value) {
                            setState(() {
                              _selectedEArsivDurumu = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'e-İrsaliye Durumu',
                          hint: 'Seçin',
                          icon: Icons.local_shipping_outlined,
                          value: _selectedEIrsaliyeDurumu,
                          items: ['Mükellefi', 'Değil'],
                          onChanged: (value) {
                            setState(() {
                              _selectedEIrsaliyeDurumu = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'e-Müstahsil Makbuzu',
                          value: _eMustahsilUygulamasi,
                          onChanged: (value) {
                            setState(() {
                              _eMustahsilUygulamasi = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'e-Fatura Gönderim Şekli',
                          hint: 'Seçin',
                          icon: Icons.send_rounded,
                          value: _selectedEFaturaGonderimSekli,
                          items: ['Otomatik', 'Manuel', 'Toplu'],
                          enabled: _selectedEFaturaDurumu == 'Mükellefi',
                          onChanged: (value) {
                            setState(() {
                              _selectedEFaturaGonderimSekli = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Özel Durum ve Muafiyetler Kartı
            _buildAppleCard(
              icon: Icons.workspace_premium_outlined,
              title: 'Özel Durum ve Muafiyetler',
              color: const Color(0xFFFF9500),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Engelli İndirimi',
                          value: _engelliIndirimiVar,
                          onChanged: (value) {
                            setState(() {
                              _engelliIndirimiVar = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _engelliIndirimiOraniController,
                          label: 'İndirim Oranı',
                          hint: '%',
                          icon: Icons.percent_rounded,
                          enabled: _engelliIndirimiVar,
                          inputFormatters: [PercentageFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Ar-Ge İndirimi',
                          value: _argeIndirimiVar,
                          onChanged: (value) {
                            setState(() {
                              _argeIndirimiVar = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _argeIndirimiBelgeNoController,
                          label: 'Belge No',
                          hint: 'Belge numarası',
                          icon: Icons.badge_outlined,
                          enabled: _argeIndirimiVar,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Yatırım Teşvik Belgesi',
                          value: _yatirimTesvik,
                          onChanged: (value) {
                            setState(() {
                              _yatirimTesvik = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _yatirimTesvikBelgeNoController,
                          label: 'Belge No',
                          hint: 'Belge numarası',
                          icon: Icons.badge_outlined,
                          enabled: _yatirimTesvik,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _yatirimTesvikGecerlilikController,
                    label: 'Geçerlilik Tarihi',
                    hint: 'GG.AA.YYYY',
                    icon: Icons.calendar_today_rounded,
                    enabled: _yatirimTesvik,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Teknoloji Geliştirme Bölgesi',
                          value: _teknolojiGelistirmeBolgesi,
                          onChanged: (value) {
                            setState(() {
                              _teknolojiGelistirmeBolgesi = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Serbest Bölge',
                          value: _serbestBolge,
                          onChanged: (value) {
                            setState(() {
                              _serbestBolge = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Organize Sanayi Bölgesi',
                          value: _osb,
                          onChanged: (value) {
                            setState(() {
                              _osb = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Gümrük Müşavirliği',
                          value: _gumrukMusavirligi,
                          onChanged: (value) {
                            setState(() {
                              _gumrukMusavirligi = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _gumrukMusavirlikBelgeNoController,
                    label: 'Gümrük Müşavirliği Belge No',
                    hint: 'Belge numarası',
                    icon: Icons.badge_outlined,
                    enabled: _gumrukMusavirligi,
                  ),
                ],
              ),
            ),

            // Ödeme ve Vergi Dönemleri Kartı
            _buildAppleCard(
              icon: Icons.event_repeat_outlined,
              title: 'Ödeme ve Vergi Dönemleri',
              color: const Color(0xFFFF2D55),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'KDV Beyan Dönemi',
                          hint: 'Seçin',
                          icon: Icons.calendar_view_month_rounded,
                          value: _selectedKDVBeyanDonemi,
                          items: ['Aylık', '3 Aylık'],
                          onChanged: (value) {
                            setState(() {
                              _selectedKDVBeyanDonemi = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Geçici Vergi Mükellefi',
                          value: _geciciVergiMukellefi,
                          onChanged: (value) {
                            setState(() {
                              _geciciVergiMukellefi = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxField(
                    label: 'Muhtasar Beyanname Verilecek',
                    value: _muhtasarBeyanname,
                    onChanged: (value) {
                      setState(() {
                        _muhtasarBeyanname = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Fatura Notları Kartı
            _buildAppleCard(
              icon: Icons.note_alt_outlined,
              title: 'Fatura Notları ve Uyarılar',
              color: const Color(0xFF30B0C7),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _faturaOzelNotController,
                    label: 'Faturada Yazılacak Özel Not',
                    hint: 'Tevkifat, istisna açıklamaları vb.',
                    icon: Icons.sticky_note_2_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _muhasebeNotlariController,
                    label: 'Muhasebe Notları',
                    hint: 'İç kullanım için notlar',
                    icon: Icons.notes_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _vergiDairesiOzelAnlasmalarController,
                    label: 'Vergi Dairesi ile Özel Anlaşmalar',
                    hint: 'Varsa özel durumlar',
                    icon: Icons.handshake_outlined,
                    maxLines: 2,
                  ),
                ],
              ),
            ),

            // Vergi İadesi Kartı
            _buildAppleCard(
              icon: Icons.currency_exchange_outlined,
              title: 'Vergi İadesi ve Mahsup',
              color: const Color(0xFF34C759),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'İade Talep Durumu',
                          value: _iadeTalepDurumu,
                          onChanged: (value) {
                            setState(() {
                              _iadeTalepDurumu = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDropdown(
                          label: 'İade Yöntemi',
                          hint: 'Seçin',
                          icon: Icons.payment_rounded,
                          value: _selectedIadeYontemi,
                          items: ['Nakit', 'Mahsup'],
                          enabled: _iadeTalepDurumu,
                          onChanged: (value) {
                            setState(() {
                              _selectedIadeYontemi = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _mahsubenIadeIBANController,
                    label: 'Mahsuben İade IBAN',
                    hint: 'TR00 0000 0000 0000 0000 0000 00',
                    icon: Icons.account_balance_rounded,
                    enabled: _iadeTalepDurumu,
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Vergi İadesi Sıklığı',
                    hint: 'Seçin',
                    icon: Icons.repeat_rounded,
                    value: _selectedVergiIadesiSikligi,
                    items: ['Aylık', 'Dönemsel'],
                    enabled: _iadeTalepDurumu,
                    onChanged: (value) {
                      setState(() {
                        _selectedVergiIadesiSikligi = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Diğer Vergiler Kartı
            _buildAppleCard(
              icon: Icons.receipt_outlined,
              title: 'Diğer Vergiler',
              color: const Color(0xFFAF52DE),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildCheckboxField(
                      label: 'ÖTV Mükellefi',
                      value: _otvMukellefi,
                      onChanged: (value) {
                        setState(() {
                          _otvMukellefi = value ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _otvOraniController,
                      label: 'ÖTV Oranı',
                      hint: '%',
                      icon: Icons.percent_rounded,
                      enabled: _otvMukellefi,
                      inputFormatters: [PercentageFormatter()],
                    ),
                  ),
                ],
              ),
            ),

            // Denetim ve Uyumluluk Kartı (zaten doğru)
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'e-Fatura Durumu',
                    hint: 'Seçin',
                    icon: Icons.receipt_long_rounded,
                    value: _selectedEFaturaDurumu,
                    items: ['Mükellefi', 'Değil'],
                    onChanged: (value) {
                      setState(() {
                        _selectedEFaturaDurumu = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'e-Fatura Senaryosu',
                    hint: 'Seçin',
                    icon: Icons.category_outlined,
                    value: _selectedEFaturaSenaryosu,
                    items: ['Temel', 'Ticari', 'Kamu'],
                    enabled: _selectedEFaturaDurumu == 'Mükellefi',
                    onChanged: (value) {
                      setState(() {
                        _selectedEFaturaSenaryosu = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _eFaturaPostaKutusuController,
              label: 'e-Fatura Posta Kutusu Etiketi',
              hint: 'GİB etiketi',
              icon: Icons.email_outlined,
              enabled: _selectedEFaturaDurumu == 'Mükellefi',
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'e-Arşiv Durumu',
                    hint: 'Seçin',
                    icon: Icons.archive_outlined,
                    value: _selectedEArsivDurumu,
                    items: ['Mükellefi', 'Değil'],
                    onChanged: (value) {
                      setState(() {
                        _selectedEArsivDurumu = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'e-İrsaliye Durumu',
                    hint: 'Seçin',
                    icon: Icons.local_shipping_outlined,
                    value: _selectedEIrsaliyeDurumu,
                    items: ['Mükellefi', 'Değil'],
                    onChanged: (value) {
                      setState(() {
                        _selectedEIrsaliyeDurumu = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'e-Müstahsil Makbuzu',
                    value: _eMustahsilUygulamasi,
                    onChanged: (value) {
                      setState(() {
                        _eMustahsilUygulamasi = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'e-Fatura Gönderim Şekli',
                    hint: 'Seçin',
                    icon: Icons.send_rounded,
                    value: _selectedEFaturaGonderimSekli,
                    items: ['Otomatik', 'Manuel', 'Toplu'],
                    enabled: _selectedEFaturaDurumu == 'Mükellefi',
                    onChanged: (value) {
                      setState(() {
                        _selectedEFaturaGonderimSekli = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Özel Durum ve Muafiyetler
            _buildSectionTitle(
                'Özel Durum ve Muafiyetler', Icons.workspace_premium_outlined),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Engelli İndirimi',
                    value: _engelliIndirimiVar,
                    onChanged: (value) {
                      setState(() {
                        _engelliIndirimiVar = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _engelliIndirimiOraniController,
                    label: 'İndirim Oranı',
                    hint: '%',
                    icon: Icons.percent_rounded,
                    enabled: _engelliIndirimiVar,
                    inputFormatters: [PercentageFormatter()],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Ar-Ge İndirimi',
                    value: _argeIndirimiVar,
                    onChanged: (value) {
                      setState(() {
                        _argeIndirimiVar = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _argeIndirimiBelgeNoController,
                    label: 'Belge No',
                    hint: 'Belge numarası',
                    icon: Icons.badge_outlined,
                    enabled: _argeIndirimiVar,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Yatırım Teşvik Belgesi',
                    value: _yatirimTesvik,
                    onChanged: (value) {
                      setState(() {
                        _yatirimTesvik = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _yatirimTesvikBelgeNoController,
                    label: 'Belge No',
                    hint: 'Belge numarası',
                    icon: Icons.badge_outlined,
                    enabled: _yatirimTesvik,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _yatirimTesvikGecerlilikController,
              label: 'Geçerlilik Tarihi',
              hint: 'GG.AA.YYYY',
              icon: Icons.calendar_today_rounded,
              enabled: _yatirimTesvik,
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Teknoloji Geliştirme Bölgesi',
                    value: _teknolojiGelistirmeBolgesi,
                    onChanged: (value) {
                      setState(() {
                        _teknolojiGelistirmeBolgesi = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Serbest Bölge',
                    value: _serbestBolge,
                    onChanged: (value) {
                      setState(() {
                        _serbestBolge = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Organize Sanayi Bölgesi',
                    value: _osb,
                    onChanged: (value) {
                      setState(() {
                        _osb = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Gümrük Müşavirliği',
                    value: _gumrukMusavirligi,
                    onChanged: (value) {
                      setState(() {
                        _gumrukMusavirligi = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _gumrukMusavirlikBelgeNoController,
              label: 'Gümrük Müşavirliği Belge No',
              hint: 'Belge numarası',
              icon: Icons.badge_outlined,
              enabled: _gumrukMusavirligi,
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Ödeme ve Vergi Dönemleri
            _buildSectionTitle(
                'Ödeme ve Vergi Dönemleri', Icons.event_repeat_outlined),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'KDV Beyan Dönemi',
                    hint: 'Seçin',
                    icon: Icons.calendar_view_month_rounded,
                    value: _selectedKDVBeyanDonemi,
                    items: ['Aylık', '3 Aylık'],
                    onChanged: (value) {
                      setState(() {
                        _selectedKDVBeyanDonemi = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCheckboxField(
                    label: 'Geçici Vergi Mükellefi',
                    value: _geciciVergiMukellefi,
                    onChanged: (value) {
                      setState(() {
                        _geciciVergiMukellefi = value ?? false;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildCheckboxField(
              label: 'Muhtasar Beyanname Verilecek',
              value: _muhtasarBeyanname,
              onChanged: (value) {
                setState(() {
                  _muhtasarBeyanname = value ?? false;
                });
              },
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Fatura Notları ve Uyarılar
            _buildSectionTitle(
                'Fatura Notları ve Uyarılar', Icons.note_alt_outlined),
            const SizedBox(height: 14),
            _buildTextField(
              controller: _faturaOzelNotController,
              label: 'Faturada Yazılacak Özel Not',
              hint: 'Tevkifat, istisna açıklamaları vb.',
              icon: Icons.sticky_note_2_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _muhasebeNotlariController,
              label: 'Muhasebe Notları',
              hint: 'İç kullanım için notlar',
              icon: Icons.notes_rounded,
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _vergiDairesiOzelAnlasmalarController,
              label: 'Vergi Dairesi ile Özel Anlaşmalar',
              hint: 'Varsa özel durumlar',
              icon: Icons.handshake_outlined,
              maxLines: 2,
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Vergi İadesi ve Mahsup
            _buildSectionTitle(
                'Vergi İadesi ve Mahsup', Icons.currency_exchange_outlined),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'İade Talep Durumu',
                    value: _iadeTalepDurumu,
                    onChanged: (value) {
                      setState(() {
                        _iadeTalepDurumu = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'İade Yöntemi',
                    hint: 'Seçin',
                    icon: Icons.payment_rounded,
                    value: _selectedIadeYontemi,
                    items: ['Nakit', 'Mahsup'],
                    enabled: _iadeTalepDurumu,
                    onChanged: (value) {
                      setState(() {
                        _selectedIadeYontemi = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _mahsubenIadeIBANController,
              label: 'Mahsuben İade IBAN',
              hint: 'TR00 0000 0000 0000 0000 0000 00',
              icon: Icons.account_balance_rounded,
              enabled: _iadeTalepDurumu,
            ),
            const SizedBox(height: 12),
            _buildDropdown(
              label: 'Vergi İadesi Sıklığı',
              hint: 'Seçin',
              icon: Icons.repeat_rounded,
              value: _selectedVergiIadesiSikligi,
              items: ['Aylık', 'Dönemsel'],
              enabled: _iadeTalepDurumu,
              onChanged: (value) {
                setState(() {
                  _selectedVergiIadesiSikligi = value;
                });
              },
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Diğer Vergiler
            _buildSectionTitle('Diğer Vergiler', Icons.receipt_outlined),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildCheckboxField(
                    label: 'ÖTV Mükellefi',
                    value: _otvMukellefi,
                    onChanged: (value) {
                      setState(() {
                        _otvMukellefi = value ?? false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _otvOraniController,
                    label: 'ÖTV Oranı',
                    hint: '%',
                    icon: Icons.percent_rounded,
                    enabled: _otvMukellefi,
                    inputFormatters: [PercentageFormatter()],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            _buildDivider(),
            const SizedBox(height: 24),

            // Denetim ve Uyumluluk Kartı
            _buildAppleCard(
              icon: Icons.security_outlined,
              title: 'Denetim ve Uyumluluk',
              color: const Color(0xFFFF3B30),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _sonVergiIncelemeTarihiController,
                          label: 'Son Vergi İncelemesi',
                          hint: 'GG.AA.YYYY',
                          icon: Icons.calendar_today_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _sonVergiIncelemeSonucuController,
                          label: 'İnceleme Sonucu',
                          hint: 'Sonuç',
                          icon: Icons.assignment_turned_in_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Vergi Borcu Var',
                          value: _vergiBorcuVar,
                          onChanged: (value) {
                            setState(() {
                              _vergiBorcuVar = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _vergiBorcuTutariController,
                          label: 'Borç Tutarı',
                          hint: '0,00',
                          icon: Icons.attach_money_rounded,
                          enabled: _vergiBorcuVar,
                          inputFormatters: [TurkishNumberFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _vergiBorcuTaksitController,
                    label: 'Taksit Bilgisi',
                    hint: 'Taksit sayısı ve detayları',
                    icon: Icons.info_outline_rounded,
                    enabled: _vergiBorcuVar,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Uzlaşma Süreci Devam Ediyor',
                          value: _uzlasmaSureci,
                          onChanged: (value) {
                            setState(() {
                              _uzlasmaSureci = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Özelge Durumu',
                          value: _ozelgeDurumu,
                          onChanged: (value) {
                            setState(() {
                              _ozelgeDurumu = value ?? false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _ozelgeNoController,
                    label: 'Özelge No',
                    hint: 'Özelge numarası',
                    icon: Icons.confirmation_number_outlined,
                    enabled: _ozelgeDurumu,
                  ),
                ],
              ),
            ),

            // Raporlama Tercihleri Kartı
            _buildAppleCard(
              icon: Icons.analytics_outlined,
              title: 'Raporlama Tercihleri',
              color: const Color(0xFF007AFF),
              child: Column(
                children: [
                  _buildDropdown(
                    label: 'KDV Beyanname Detay Seviyesi',
                    hint: 'Seçin',
                    icon: Icons.list_alt_rounded,
                    value: _selectedKDVBeyannameDetay,
                    items: ['Özet', 'Detaylı'],
                    onChanged: (value) {
                      setState(() {
                        _selectedKDVBeyannameDetay = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'BA/BS Formu Gerekli',
                          value: _baFormGerekli,
                          onChanged: (value) {
                            setState(() {
                              _baFormGerekli = value ?? false;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCheckboxField(
                          label: 'Form AA/AB Gerekli',
                          value: _formAAGerekli,
                          onChanged: (value) {
                            setState(() {
                              _formAAGerekli = value ?? false;
                            });
                          },
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
    );
  }

  Widget _buildAppleCard({
    required IconData icon,
    required String title,
    required Color color,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.08),
                  color.withOpacity(0.03),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: '.SF Pro Display',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1C1C1E),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          // Card Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(int index) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _tabs[index].activeColor.withOpacity(0.1),
                  _tabs[index].activeColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _tabs[index].icon,
              color: _tabs[index].activeColor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _tabs[index].label,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'İçerik eklenecek',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E93),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF007AFF).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF007AFF),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildEditableAccountCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Hesap Kodu',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C3C43),
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 6),
            Tooltip(
              message: 'Manuel olarak düzenleyebilirsiniz',
              child: Icon(
                Icons.edit_rounded,
                size: 14,
                color: const Color(0xFF007AFF).withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: TextField(
                  controller: _accountCodeController,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    if (_checkAccountCodeExists(value)) {
                      // Kod daha önce kullanılmış - boşta olan ilk kodu bul
                      String prefix = value.startsWith('120') ? '120' : '320';
                      final newCode = _findNextAvailableCode(prefix);
                      _showAccountCodeWarning(value);
                      setState(() {
                        _tempAccountCode = newCode;
                        _accountCodeController.text = newCode;
                      });
                    } else {
                      // Kod kullanılmamış - geçerli
                      setState(() {
                        _tempAccountCode = value;
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Hesap kodu girin',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.numbers_rounded,
                      size: 18,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompactToggle({
    required IconData icon,
    required String label,
    required bool value,
    required Color activeColor,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: 44,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => onChanged(!value),
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: value ? 1 : 0),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            builder: (context, animValue, child) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(
                          const Color(0xFFF8F9FA), activeColor, animValue)!,
                      Color.lerp(const Color(0xFFF0F1F3),
                          activeColor.withOpacity(0.85), animValue)!,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color.lerp(
                      const Color(0xFFE5E5EA),
                      activeColor.withOpacity(0.4),
                      animValue,
                    )!,
                    width: 1 + (animValue * 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(
                        Colors.black.withOpacity(0.02),
                        activeColor.withOpacity(0.28),
                        animValue,
                      )!,
                      blurRadius: 4 + (animValue * 10),
                      spreadRadius: animValue * 0.5,
                      offset: Offset(0, 1 + (animValue * 3)),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: value ? 1 : 0),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.elasticOut,
                      builder: (context, iconAnim, child) {
                        return Transform.rotate(
                          angle: iconAnim * 6.28,
                          child: Icon(
                            icon,
                            size: 16,
                            color: Color.lerp(
                              const Color(0xFF8E8E93),
                              Colors.white,
                              animValue,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.lerp(
                          FontWeight.w500,
                          FontWeight.w700,
                          animValue,
                        ),
                        color: Color.lerp(
                          const Color(0xFF6C757D),
                          Colors.white,
                          animValue,
                        ),
                        letterSpacing: animValue * 0.25,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required IconData icon,
    bool isRequired = false,
    bool enabled = true,
    TextEditingController? controller,
    List<TextInputFormatter>? inputFormatters,
    int? maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C3C43),
                letterSpacing: -0.1,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF3B30),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                decoration: BoxDecoration(
                  color: enabled ? Colors.white : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: TextField(
                  enabled: enabled,
                  controller: controller,
                  inputFormatters: inputFormatters,
                  maxLines: maxLines,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93).withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                    ),
                    prefixIcon: Icon(
                      icon,
                      size: 18,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : (enabled
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFFC7C7CC)),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                    letterSpacing: -0.2,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool isRequired = false,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C3C43),
                letterSpacing: -0.1,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 3),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF3B30),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isFocused
                                ? const Color(0xFF5AC8FA).withOpacity(0.08)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 18,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : (enabled
                                    ? const Color(0xFF8E8E93)
                                    : const Color(0xFFC7C7CC)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8E8E93).withOpacity(0.6),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 20,
                      color: Color(0xFF8E8E93),
                    ),
                    isExpanded: true,
                    isDense: true,
                    items: enabled
                        ? items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                curve: Curves.easeInOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF5AC8FA)
                                            .withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Icon(
                                        icon,
                                        size: 14,
                                        color: const Color(0xFF5AC8FA),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF1C1C1E),
                                          letterSpacing: -0.1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList()
                        : null,
                    onChanged: enabled ? onChanged : null,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxField({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE5E5EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 0.85,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF34C759),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1C1C1E),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE5E5EA).withOpacity(0.0),
            const Color(0xFFE5E5EA),
            const Color(0xFFE5E5EA).withOpacity(0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildVergiNoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Vergi No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C3C43),
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: '10 haneli vergi numarası',
              child: Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: const Color(0xFF8E8E93).withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: TextField(
                  controller: _vergiNoController,
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    if (value.length == 10) {
                      _sorgulaVergiNo(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '10 hane',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                      letterSpacing: -0.2,
                    ),
                    prefixIcon: Icon(
                      Icons.assignment_outlined,
                      size: 18,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    suffixIcon: _vergiNoController.text.length == 10
                        ? const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF34C759),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTcKimlikField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'TC Kimlik No',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C3C43),
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: '11 haneli TC kimlik numarası',
              child: Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: const Color(0xFF8E8E93).withOpacity(0.7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: TextField(
                  controller: _tcKimlikNoController,
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (value) {
                    if (value.length == 11) {
                      _sorgulaTcKimlik(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '11 hane',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      size: 18,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    suffixIcon: _tcKimlikNoController.text.length == 11
                        ? const Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF34C759),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    isDense: true,
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1C1E),
                    letterSpacing: -0.2,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVergiDairesiField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vergi Dairesi',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C43),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused
                            ? const Color(0xFF5AC8FA)
                            : const Color(0xFFE5E5EA),
                        width: isFocused ? 1.5 : 1,
                      ),
                      boxShadow: [
                        if (isFocused)
                          BoxShadow(
                            color: const Color(0xFF5AC8FA).withOpacity(0.12),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _vergiDairesiController,
                            textAlignVertical: TextAlignVertical.center,
                            onChanged: _araVergiDairesi,
                            decoration: InputDecoration(
                              hintText: '3+ karakter',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFF8E8E93).withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                                letterSpacing: -0.2,
                              ),
                              prefixIcon: Icon(
                                Icons.account_balance_outlined,
                                size: 18,
                                color: isFocused
                                    ? const Color(0xFF5AC8FA)
                                    : const Color(0xFF8E8E93),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C1E),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _vergiDairesiAraniyor = !_vergiDairesiAraniyor;
                                if (_vergiDairesiAraniyor) {
                                  _vergiDairesiSonuclari = _vergiDaireleri;
                                } else {
                                  _vergiDairesiSonuclari = [];
                                }
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Icon(
                                Icons.more_horiz_rounded,
                                size: 18,
                                color: const Color(0xFF5AC8FA),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_vergiDairesiSonuclari.isNotEmpty)
                    Positioned(
                      top: 36,
                      left: 0,
                      right: 0,
                      child: Material(
                        elevation: 8,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE5E5EA),
                            ),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _vergiDairesiSonuclari.length,
                            itemBuilder: (context, index) {
                              final vd = _vergiDairesiSonuclari[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _vergiDairesiController.text = vd['ad']!;
                                    _vergiKoduController.text = vd['kod']!;
                                    _vergiDairesiSonuclari = [];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: index <
                                                _vergiDairesiSonuclari.length -
                                                    1
                                            ? const Color(0xFFE5E5EA)
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF5AC8FA)
                                              .withOpacity(0.08),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.account_balance_outlined,
                                          size: 14,
                                          color: Color(0xFF5AC8FA),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vd['ad']!,
                                              style: const TextStyle(
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1C1C1E),
                                              ),
                                            ),
                                            Text(
                                              'Kod: ${vd['kod']}',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: const Color(0xFF8E8E93)
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdresAraField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Adres Ara',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C43),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isFocused
                            ? const Color(0xFF5AC8FA)
                            : const Color(0xFFE5E5EA),
                        width: isFocused ? 1.5 : 1,
                      ),
                      boxShadow: [
                        if (isFocused)
                          BoxShadow(
                            color: const Color(0xFF5AC8FA).withOpacity(0.12),
                            blurRadius: 12,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                      ],
                    ),
                    child: TextField(
                      controller: _adresAraController,
                      maxLines: 1,
                      textAlignVertical: TextAlignVertical.center,
                      onChanged: (value) {
                        _araAdres(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'İl, ilçe veya mahalle yazın...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF8E8E93).withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.2,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 14, right: 6),
                          child: Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  if (_adresSonuclari.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE5E5EA),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _adresSonuclari.length,
                        itemBuilder: (context, index) {
                          final adres = _adresSonuclari[index];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIl = adres['il'];
                                  _selectedIlce = adres['ilce'];
                                  _adresController.text = adres['mahalle']!;
                                  _postaKoduController.text =
                                      adres['postaKodu']!;
                                  _adresAraController.text =
                                      '${adres['il']}, ${adres['ilce']} - ${adres['mahalle']}';
                                  _adresSonuclari = [];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: index < _adresSonuclari.length - 1
                                          ? const Color(0xFFF2F2F7)
                                          : Colors.transparent,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${adres['il']}, ${adres['ilce']}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF007AFF),
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      adres['mahalle']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF1C1C1E),
                                      ),
                                    ),
                                    Text(
                                      'Posta Kodu: ${adres['postaKodu']}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF8E8E93)
                                            .withOpacity(0.8),
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
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildVergiKoduField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vergi Kodu',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C43),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _vergiKoduController,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: (value) {
                          if (value.length >= 3) {
                            // Vergi koduna göre vergi dairesi bul
                            final vd = _vergiDaireleri.firstWhere(
                              (d) => d['kod'] == value,
                              orElse: () => {'ad': '', 'kod': ''},
                            );
                            if (vd['ad']!.isNotEmpty) {
                              setState(() {
                                _vergiDairesiController.text = vd['ad']!;
                              });
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Kod',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8E8E93).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                          ),
                          prefixIcon: Icon(
                            Icons.numbers_rounded,
                            size: 18,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          isDense: true,
                          counterText: '',
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _vergiDairesiAraniyor = !_vergiDairesiAraniyor;
                            if (_vergiDairesiAraniyor) {
                              _vergiDairesiSonuclari = _vergiDaireleri;
                            } else {
                              _vergiDairesiSonuclari = [];
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.more_horiz_rounded,
                            size: 18,
                            color: const Color(0xFF5AC8FA),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Premium Section Header (Genel Bilgiler ile aynı stil)
  Widget _buildPremiumSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1C1E),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // Premium TextField (Genel Bilgiler ile aynı stil)
  Widget _buildPremiumTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required Color accentColor,
    String? suffix,
    int maxLines = 1,
    void Function(String, TextEditingController)? onChanged,
    List<TextInputFormatter>? inputFormatters,
    FocusNode? focusNode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C43),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: maxLines > 1 ? null : 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        maxLines: maxLines,
                        inputFormatters: inputFormatters,
                        textAlignVertical: TextAlignVertical.center,
                        onChanged: onChanged != null
                            ? (value) => onChanged(value, controller)
                            : null,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFFAEAEB2),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 14, right: 6),
                            child: Icon(
                              icon,
                              size: 18,
                              color: isFocused
                                  ? const Color(0xFF5AC8FA)
                                  : const Color(0xFF8E8E93),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: maxLines > 1 ? 12 : 12,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    if (suffix != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          suffix,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Premium Dropdown (Genel Bilgiler ile aynı stil)
  Widget _buildPremiumDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    required Color accentColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C3C43),
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 6),
        Focus(
          child: Builder(
            builder: (context) {
              final isFocused = Focus.of(context).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                height: 44,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isFocused
                        ? const Color(0xFF5AC8FA)
                        : const Color(0xFFE5E5EA),
                    width: isFocused ? 1.5 : 1,
                  ),
                  boxShadow: [
                    if (isFocused)
                      BoxShadow(
                        color: const Color(0xFF5AC8FA).withOpacity(0.12),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      )
                    else
                      BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: items.isEmpty
                        ? null
                        : (items.contains(value) ? value : null),
                    hint: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isFocused
                                ? const Color(0xFF5AC8FA).withOpacity(0.08)
                                : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            icon,
                            size: 18,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color(0xFF8E8E93).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_rounded,
                      size: 20,
                      color: Color(0xFF8E8E93),
                    ),
                    isExpanded: true,
                    isDense: true,
                    items: items.isEmpty
                        ? null
                        : items.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Row(
                                children: [
                                  Icon(
                                    icon,
                                    size: 18,
                                    color: const Color(0xFF8E8E93),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1C1C1E),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    onChanged: items.isEmpty ? null : onChanged,
                    dropdownColor: Colors.white,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Ultra Premium Save Button
  Widget _buildUltraPremiumSaveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Kaydet Butonu
        Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF007AFF),
                Color(0xFF0051D5),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF007AFF).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveCustomer,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 18),
            label: Text(
              _isSaving ? 'Kaydediliyor...' : 'Kaydet',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Temizle Butonu
        Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFCC00),
                Color(0xFFFFB800),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFCC00).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              setState(() {
                // Tüm alanları temizle
                _unvanController.clear();
                _unvan2Controller.clear();
                _kisaAdController.clear();
                _vergiNoController.clear();
                _tcKimlikNoController.clear();
                _vergiDairesiController.clear();
                _vergiKoduController.clear();
                _adController.clear();
                _soyadController.clear();
                _telefonController.clear();
                _cepTelefonuController.clear();
                _cepTelefonu2Controller.clear();
                _epostaController.clear();
                _webSitesiController.clear();
                _whatsappController.clear();
                _mahalleController.clear();
                _caddeController.clear();
                _sokakController.clear();
                _postaKoduController.clear();
                _adresController.clear();
                _riskLimitiController.clear();
                _vadeSuresiController.clear();
                _iskontoController.clear();
                _yetkiliKisiController.clear();
                _selectedAccountType = null;
                _selectedAccountCategory = null;
                _selectedGroup = null;
                _selectedBranch = null;
                _selectedIl = null;
                _selectedIlce = null;
                _selectedAdresTuru = 'Fatura Adresi';
                _selectedOdemeSekli = null;
                _selectedParaBirimi = null;
                _hasUnsavedChanges = false;
              });
            },
            icon: const Icon(Icons.cleaning_services_rounded, size: 18),
            label: const Text(
              'Temizle',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Vazgeç Butonu
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE5E5EA),
              width: 1,
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: () async {
              if (_hasFormData() && _hasUnsavedChanges) {
                final shouldExit = await _showExitConfirmation();
                if (shouldExit) {
                  widget.onClose();
                }
              } else {
                widget.onClose();
              }
            },
            icon: const Icon(Icons.close_rounded, size: 18),
            label: const Text(
              'Vazgeç',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.3,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: const Color(0xFF8E8E93),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
      ],
    );
  }

  // Adresler Sekmesi
  Widget _buildAdreslerTab() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _kayitliAdresler.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF34C759).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.location_off_outlined,
                      size: 40,
                      color: Color(0xFF34C759),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Henüz Adres Eklenmemiş',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Genel sekmesinden adres ekleyebilirsiniz',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _kayitliAdresler.length,
              itemBuilder: (context, index) {
                final adres = _kayitliAdresler[index];
                final cardColors = [
                  [const Color(0xFF007AFF), const Color(0xFF5AC8FA)],
                  [const Color(0xFF34C759), const Color(0xFF30D158)],
                  [const Color(0xFFFF9500), const Color(0xFFFFCC00)],
                  [const Color(0xFFAF52DE), const Color(0xFFBF5AF2)],
                  [const Color(0xFFFF3B30), const Color(0xFFFF6961)],
                ];
                final colorPair = cardColors[index % cardColors.length];

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [colorPair[0], colorPair[1]],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: colorPair[0].withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Pattern arka plan
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.1,
                            child: Image.asset(
                              'assets/card_pattern.png',
                              repeat: ImageRepeat.repeat,
                              errorBuilder: (_, __, ___) => Container(),
                            ),
                          ),
                        ),
                        // İçerik
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Üst - İkon ve Tür
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.location_on,
                                      size: 28,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.25),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      adres['tur'] ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // Orta - Tam Adres
                              if (adres['tamAdres']?.isNotEmpty == true)
                                Text(
                                  adres['tamAdres']!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.3,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 12),
                              // Alt - Detaylar ve Butonlar
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (adres['il']?.isNotEmpty == true)
                                            _buildWalletInfo(
                                              Icons.location_city,
                                              '${adres['il']} / ${adres['ilce'] ?? ''}',
                                            ),
                                          if (adres['postaKodu']?.isNotEmpty ==
                                              true)
                                            _buildWalletInfo(
                                              Icons.mail_outline,
                                              adres['postaKodu']!,
                                            ),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xFFFF3B30)
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: const Icon(
                                                    Icons.warning_rounded,
                                                    color: Color(0xFFFF3B30),
                                                    size: 24,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                const Text(
                                                  'Adresi Sil',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        '.SF Pro Display',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            content: const Text(
                                              'Bu adresi silmek istediğinizden emin misiniz?',
                                              style: TextStyle(
                                                fontFamily: '.SF Pro Display',
                                                fontSize: 14,
                                                color: Color(0xFF8E8E93),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text(
                                                  'İptal',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        '.SF Pro Display',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xFF007AFF),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _kayitliAdresler
                                                        .removeAt(index);
                                                  });
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: const Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.white,
                                                              size: 20),
                                                          SizedBox(width: 12),
                                                          Text(
                                                            '✓ Adres silindi',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  '.SF Pro Display',
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          const Color(
                                                              0xFFFF3B30),
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      duration: const Duration(
                                                          seconds: 2),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Sil',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        '.SF Pro Display',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFFF3B30),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                );
              },
            ),
    );
  }

  Widget _buildAdresDetayRow(IconData icon, String label, String value) {
    final iconColors = {
      Icons.location_city_rounded: const Color(0xFF007AFF),
      Icons.home_work_rounded: const Color(0xFF34C759),
      Icons.signpost_rounded: const Color(0xFFFF9500),
      Icons.route_rounded: const Color(0xFFAF52DE),
      Icons.mail_outline_rounded: const Color(0xFFFF3B30),
      Icons.notes_rounded: const Color(0xFF5AC8FA),
    };
    final iconColor = iconColors[icon] ?? const Color(0xFF8E8E93);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 13,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1C1C1E),
                  fontFamily: '.SF Pro Display',
                  letterSpacing: -0.1,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8E8E93),
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1C1E),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.white70),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final String label;
  final Color activeColor;

  _TabItem({
    required this.icon,
    required this.label,
    required this.activeColor,
  });
}

class _AnimatedNotificationCard extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onDismiss;
  final Duration duration;

  const _AnimatedNotificationCard({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.onDismiss,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<_AnimatedNotificationCard> createState() =>
      _AnimatedNotificationCardState();
}

class _AnimatedNotificationCardState extends State<_AnimatedNotificationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.2, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 24,
      bottom: 24,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.backgroundColor,
                    widget.backgroundColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: widget.backgroundColor.withOpacity(0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    _controller.reverse().then((_) => widget.onDismiss());
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
