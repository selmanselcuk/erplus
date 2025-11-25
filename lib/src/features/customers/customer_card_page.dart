import 'dart:ui';
import 'package:flutter/material.dart';

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
      icon: Icons.phone_outlined,
      label: 'İletişim',
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
  String? _selectedParaBirimi;
  final TextEditingController _iskontoController = TextEditingController();
  final TextEditingController _yetkiliKisiController = TextEditingController();

  // Vergi dairesi arama sonuçları
  List<Map<String, String>> _vergiDairesiSonuclari = [];
  bool _vergiDairesiAraniyor = false;

  // Toggle state'leri
  bool _isActive = true;
  bool _isPotential = false;

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
    return true;
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

  void _saveCustomer() {
    if (!_validateForm()) {
      return;
    }

    // Kalıcı hesap kodu üret ve kayıtlı kodlara ekle
    final finalCode = _generateFinalAccountCode(_selectedAccountType!);
    _usedAccountCodes.add(finalCode);

    // Başarı mesajı göster
    _showSuccessMessage('Müşteri başarıyla kaydedildi: $finalCode');

    // Yeni kayıt için formu temizle ve yeni geçici kod ata
    setState(() {
      // Mevcut hesap tipine göre yeni geçici kod üret
      if (_selectedAccountType != null) {
        _tempAccountCode = _generateTempAccountCode(_selectedAccountType!);
        _accountCodeController.text = _tempAccountCode;
      }

      // Diğer alanları temizle
      _unvanController.clear();
      _kisaAdController.clear();
      _selectedAccountCategory = null;
      _selectedGroup = null;
      _selectedBranch = null;
      _isActive = true;
      _isPotential = false;
    });
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
    super.dispose();
  }

  // Adres Ekle Butonu
  Widget _buildAdresEkleButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 18),
        Container(
          height: 36,
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Lütfen adres türü seçiniz')),
      );
      return;
    }
    if (_selectedIl == null || _selectedIl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Lütfen il seçiniz')),
      );
      return;
    }
    if (_selectedIlce == null || _selectedIlce!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Lütfen ilçe seçiniz')),
      );
      return;
    }
    if (_adresDetayController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Lütfen adres detayı giriniz')),
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
      'tur': _selectedAdresTuru!,
      'il': _selectedIl!,
      'ilce': _selectedIlce!,
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
      margin: const EdgeInsets.all(24),
      constraints: const BoxConstraints(maxWidth: 1200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 40,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUltraPremiumTabBar(),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E5EA)),
          Container(
            height: 500,
            padding: const EdgeInsets.all(32),
            child: _buildTabContent(),
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
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1C1E),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.customerId ?? 'Yeni Kayıt',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ),
              ),
              _buildActionButton(Icons.close_rounded, widget.onClose),
            ],
          ),
          const SizedBox(height: 20),
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
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(6),
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
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(
                  color: tab.activeColor.withOpacity(0.15),
                  width: 1.5,
                )
              : null,
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: tab.activeColor.withOpacity(0.12),
                    blurRadius: 16,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOutCubic,
                padding: EdgeInsets.all(isActive ? 6 : 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? tab.activeColor.withOpacity(0.08)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  tab.icon,
                  size: isActive ? 18 : 17,
                  color: isActive ? tab.activeColor : const Color(0xFF8B92A0),
                ),
              ),
              const SizedBox(height: 3),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutCubic,
                    style: TextStyle(
                      fontSize: isActive ? 9.5 : 9,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isActive ? tab.activeColor : const Color(0xFF8B92A0),
                      letterSpacing: isActive ? 0.05 : 0,
                      height: 1.1,
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
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
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
        _buildPlaceholderTab(1),
        _buildPlaceholderTab(2),
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
        padding: const EdgeInsets.all(20),
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
            const SizedBox(height: 14),
            // 1. SATIR: Hesap Kodu + Hesap Tipi + Hesap Türü
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildEditableAccountCode(),
                ),
                const SizedBox(width: 12),
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
            _buildAdresAraField(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 4,
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
                  flex: 4,
                  child: _buildPremiumDropdown(
                    label: 'İlçe',
                    hint: 'İlçe seçin',
                    icon: Icons.location_city_outlined,
                    items: _selectedIl == 'Konya'
                        ? ['Meram', 'Selçuklu', 'Karatay']
                        : ['Merkez'],
                    value: _selectedIlce,
                    onChanged: (value) {
                      setState(() {
                        _selectedIlce = value;
                      });
                    },
                    accentColor: const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
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
              label: 'Adres',
              hint: 'Mahalle, Cadde, Sokak, No, Daire',
              icon: Icons.home_outlined,
              controller: _adresController,
              accentColor: const Color(0xFFFF9500),
              maxLines: 2,
            ),

            const SizedBox(height: 24),
            // Ticari Bilgiler Bölümü
            _buildPremiumSectionHeader('Ticari Bilgiler',
                Icons.business_center_rounded, const Color(0xFFAF52DE)),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: _buildPremiumTextField(
                    label: 'Risk Limiti',
                    hint: '0.00',
                    icon: Icons.account_balance_wallet_rounded,
                    controller: _riskLimitiController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' ₺',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: _buildPremiumTextField(
                    label: 'Vade Süresi',
                    hint: '0',
                    icon: Icons.event_note_rounded,
                    controller: _vadeSuresiController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' Gün',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 4,
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
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildPremiumTextField(
                    label: 'İskonto Oranı',
                    hint: '0',
                    icon: Icons.percent_rounded,
                    controller: _iskontoController,
                    accentColor: const Color(0xFFAF52DE),
                    suffix: ' %',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 5,
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
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                      fontSize: 12.5,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.numbers_rounded,
                      size: 16,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 12.5,
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
      height: 36,
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
                  horizontal: 12,
                  vertical: 7,
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
                height: 36,
                decoration: BoxDecoration(
                  color: enabled ? Colors.white : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
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
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      icon,
                      size: 16,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : (enabled
                              ? const Color(0xFF8E8E93)
                              : const Color(0xFFC7C7CC)),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 12.5,
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

  Widget _buildDropdown({
    required String label,
    required String hint,
    required IconData icon,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
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
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                            size: 16,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: const Color(0xFF8E8E93).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
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
                    items: items.map((String item) {
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
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF5AC8FA).withOpacity(0.08),
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
                                    fontSize: 12.5,
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
                    }).toList(),
                    onChanged: onChanged,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1C1C1E),
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
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                  onChanged: (value) {
                    if (value.length == 10) {
                      _sorgulaVergiNo(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '10 hane',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.assignment_outlined,
                      size: 16,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    suffixIcon: _vergiNoController.text.length == 10
                        ? const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Color(0xFF34C759),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
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
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                  onChanged: (value) {
                    if (value.length == 11) {
                      _sorgulaTcKimlik(value);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: '11 hane',
                    hintStyle: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF8E8E93).withOpacity(0.7),
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      Icons.badge_outlined,
                      size: 16,
                      color: isFocused
                          ? const Color(0xFF5AC8FA)
                          : const Color(0xFF8E8E93),
                    ),
                    suffixIcon: _tcKimlikNoController.text.length == 11
                        ? const Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: Color(0xFF34C759),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    isDense: true,
                    counterText: '',
                  ),
                  style: const TextStyle(
                    fontSize: 12,
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
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                            onChanged: _araVergiDairesi,
                            decoration: InputDecoration(
                              hintText: '3+ karakter',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF8E8E93).withOpacity(0.7),
                                fontWeight: FontWeight.w400,
                              ),
                              prefixIcon: Icon(
                                Icons.account_balance_outlined,
                                size: 16,
                                color: isFocused
                                    ? const Color(0xFF5AC8FA)
                                    : const Color(0xFF8E8E93),
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF1C1C1E),
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
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                      onChanged: (value) {
                        _araAdres(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'İl, ilçe veya mahalle yazın...',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: const Color(0xFF8E8E93).withOpacity(0.7),
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.1,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 6),
                          child: Icon(
                            Icons.search_rounded,
                            size: 16,
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
                          horizontal: 12,
                          vertical: 7,
                        ),
                        isDense: true,
                      ),
                      style: const TextStyle(
                        fontSize: 12.5,
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
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                            fontSize: 12,
                            color: const Color(0xFF8E8E93).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.numbers_rounded,
                            size: 16,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          isDense: true,
                          counterText: '',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1C1C1E),
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
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF1C1C1E),
        ),
        const SizedBox(width: 8),
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
                height: maxLines > 1 ? null : 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                        maxLines: maxLines,
                        onChanged: onChanged != null
                            ? (value) => onChanged(value, controller)
                            : null,
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFFAEAEB2),
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.1,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 6),
                            child: Icon(
                              icon,
                              size: 16,
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
                            horizontal: 12,
                            vertical: maxLines > 1 ? 7 : 0,
                          ),
                          isDense: true,
                        ),
                        style: const TextStyle(
                          fontSize: 12.5,
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
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
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
                            size: 16,
                            color: isFocused
                                ? const Color(0xFF5AC8FA)
                                : const Color(0xFF8E8E93),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          hint,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: const Color(0xFF8E8E93).withOpacity(0.7),
                            fontWeight: FontWeight.w400,
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
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Row(
                          children: [
                            Icon(
                              icon,
                              size: 16,
                              color: const Color(0xFF8E8E93),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              item,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF1C1C1E),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: onChanged,
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
    return Container(
      alignment: Alignment.centerRight,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _saveCustomer,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF007AFF),
                  Color(0xFF0051D5),
                ],
                stops: [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF007AFF).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF007AFF).withOpacity(0.2),
                  blurRadius: 40,
                  spreadRadius: -10,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.save_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Kaydet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
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

  // Adresler Sekmesi
  Widget _buildAdreslerTab() {
    return Center(
      child: Text('Adresler sekmesi - Geliştirme aşamasında'),
    );
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
