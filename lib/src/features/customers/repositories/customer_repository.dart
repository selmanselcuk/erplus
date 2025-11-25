import 'package:uuid/uuid.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../../core/database/database_helper.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final _uuid = const Uuid();

  // Yeni müşteri oluştur
  Future<Customer> createCustomer(Customer customer) async {
    final now = DateTime.now();
    final customerWithId = customer.copyWith(
      id: customer.id.isEmpty ? _uuid.v4() : customer.id,
      createdAt: customer.createdAt ?? now,
      updatedAt: now,
    );

    await _dbHelper.insert('customers', _customerToMap(customerWithId));
    return customerWithId;
  }

  // Müşteri güncelle
  Future<void> updateCustomer(Customer customer) async {
    final updatedCustomer = customer.copyWith(updatedAt: DateTime.now());

    await _dbHelper.update(
      'customers',
      _customerToMap(updatedCustomer),
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  // Müşteri sil
  Future<void> deleteCustomer(String id) async {
    await _dbHelper.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // ID'ye göre müşteri getir
  Future<Customer?> getCustomerById(String id) async {
    final results = await _dbHelper.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) return null;
    return _customerFromMap(results.first);
  }

  // Müşteri koduna göre getir
  Future<Customer?> getCustomerByCode(String code) async {
    final results = await _dbHelper.query(
      'customers',
      where: 'code = ?',
      whereArgs: [code],
    );

    if (results.isEmpty) return null;
    return _customerFromMap(results.first);
  }

  // Tüm müşterileri getir
  Future<List<Customer>> getAllCustomers({
    String? orderBy = 'name ASC',
    int? limit,
  }) async {
    final results = await _dbHelper.query(
      'customers',
      orderBy: orderBy,
      limit: limit,
    );

    return results.map((map) => _customerFromMap(map)).toList();
  }

  // Aktif müşterileri getir
  Future<List<Customer>> getActiveCustomers() async {
    final results = await _dbHelper.query(
      'customers',
      where: 'status = ?',
      whereArgs: ['Aktif'],
      orderBy: 'name ASC',
    );

    return results.map((map) => _customerFromMap(map)).toList();
  }

  // Hesap grubuna göre müşterileri getir
  Future<List<Customer>> getCustomersByGroup(String accountGroup) async {
    final results = await _dbHelper.query(
      'customers',
      where: 'account_group = ?',
      whereArgs: [accountGroup],
      orderBy: 'name ASC',
    );

    return results.map((map) => _customerFromMap(map)).toList();
  }

  // Müşteri ara (isim, kod, email, telefon)
  Future<List<Customer>> searchCustomers(String query) async {
    final db = await _dbHelper.database;
    final searchPattern = '%$query%';

    final results = await db.rawQuery(
      '''
      SELECT * FROM customers 
      WHERE name LIKE ? 
         OR code LIKE ? 
         OR email LIKE ? 
         OR phone LIKE ? 
         OR mobile LIKE ?
      ORDER BY name ASC
      ''',
      [
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
        searchPattern,
      ],
    );

    return results.map((map) => _customerFromMap(map)).toList();
  }

  // Toplam müşteri sayısı
  Future<int> getCustomerCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM customers');
    return result.first['count'] as int;
  }

  // Hesap grubuna göre sayı
  Future<Map<String, int>> getCustomerCountByGroup() async {
    final db = await _dbHelper.database;
    final results = await db.rawQuery(
      'SELECT account_group, COUNT(*) as count FROM customers GROUP BY account_group',
    );

    final counts = <String, int>{};
    for (var row in results) {
      counts[row['account_group'] as String] = row['count'] as int;
    }
    return counts;
  }

  // Müşteri kodunun benzersiz olup olmadığını kontrol et
  Future<bool> isCodeUnique(String code, {String? excludeId}) async {
    final results = await _dbHelper.query(
      'customers',
      where: excludeId != null ? 'code = ? AND id != ?' : 'code = ?',
      whereArgs: excludeId != null ? [code, excludeId] : [code],
    );

    return results.isEmpty;
  }

  // Senkronizasyon gereken kayıtları getir
  Future<List<Customer>> getUnsyncedCustomers() async {
    final results = await _dbHelper.query(
      'customers',
      where: 'needs_sync = ?',
      whereArgs: [1],
    );

    return results.map((map) => _customerFromMap(map)).toList();
  }

  // Senkronizasyon flag'ini güncelle
  Future<void> markAsSynced(String id) async {
    await _dbHelper.update(
      'customers',
      {'needs_sync': 0, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Toplu kayıt ekleme (import için)
  Future<void> importCustomers(List<Customer> customers) async {
    final db = await _dbHelper.database;
    final batch = db.batch();

    for (var customer in customers) {
      batch.insert(
        'customers',
        _customerToMap(customer),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  // Customer nesnesini Map'e çevir
  Map<String, dynamic> _customerToMap(Customer customer) {
    return {
      'id': customer.id,
      'code': customer.code,
      'account_group': customer.accountGroup,
      'customer_type': customer.customerType,
      'branch': customer.branch,
      'customer_group': customer.customerGroup,
      'customer_class': customer.customerClass,
      'name': customer.name,
      'company_code': customer.companyCode,
      'sector_code': customer.sectorCode,
      'phone': customer.phone,
      'mobile': customer.mobile,
      'fax': customer.fax,
      'email': customer.email,
      'website': customer.website,
      'whatsapp': customer.whatsapp,
      'address': customer.address,
      'neighborhood': customer.neighborhood,
      'street': customer.street,
      'avenue': customer.avenue,
      'open_address': customer.openAddress,
      'city': customer.city,
      'district': customer.district,
      'postal_code': customer.postalCode,
      'country': customer.country,
      'latitude': customer.latitude,
      'longitude': customer.longitude,
      'location_name': customer.locationName,
      'tax_office_code': customer.taxOfficeCode,
      'tax_office_name': customer.taxOfficeName,
      'tax_number': customer.taxNumber,
      'tax_category': customer.taxCategory,
      'tax_liability_type': customer.taxLiabilityType,
      'vat_withholding_rate': customer.vatWithholdingRate,
      'income_tax_withholding': customer.incomeTaxWithholding,
      'corporate_tax_withholding': customer.corporateTaxWithholding,
      'stamp_tax': customer.stampTax,
      'tax_exempt': customer.taxExempt == 'Evet' ? 1 : 0,
      'e_invoice_active': customer.eInvoiceActive == 'Evet' ? 1 : 0,
      'e_archive_active': customer.eArchiveActive == 'Evet' ? 1 : 0,
      'e_archive_scenario': customer.eArchiveScenario,
      'e_ledger_active': customer.eLedgerActive == 'Evet' ? 1 : 0,
      'payment_terms': customer.paymentTerms,
      'payment_method': customer.paymentMethod,
      'currency': customer.currency,
      'credit_limit': customer.creditLimit,
      'risk_category': customer.riskCategory,
      'sales_org': customer.salesOrg,
      'distribution_channel': customer.distributionChannel,
      'division': customer.division,
      'price_list': customer.priceList,
      'incoterms': customer.incoterms,
      'shipping_condition': customer.shippingCondition,
      'iban': customer.iban,
      'status': customer.status,
      'created_at': customer.createdAt?.toIso8601String(),
      'updated_at': customer.updatedAt?.toIso8601String(),
      'needs_sync': customer.needsSync ? 1 : 0,
    };
  }

  // Map'i Customer nesnesine çevir
  Customer _customerFromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id'] as String,
      code: map['code'] as String,
      accountGroup: map['account_group'] as String,
      customerType: map['customer_type'] as String?,
      branch: map['branch'] as String?,
      customerGroup: map['customer_group'] as String?,
      customerClass: map['customer_class'] as String?,
      name: map['name'] as String,
      companyCode: map['company_code'] as String?,
      sectorCode: map['sector_code'] as String?,
      phone: map['phone'] as String?,
      mobile: map['mobile'] as String?,
      fax: map['fax'] as String?,
      email: map['email'] as String?,
      website: map['website'] as String?,
      whatsapp: map['whatsapp'] as String?,
      address: map['address'] as String?,
      neighborhood: map['neighborhood'] as String?,
      street: map['street'] as String?,
      avenue: map['avenue'] as String?,
      openAddress: map['open_address'] as String?,
      city: map['city'] as String?,
      district: map['district'] as String?,
      postalCode: map['postal_code'] as String?,
      country: map['country'] as String?,
      latitude: map['latitude'] as String?,
      longitude: map['longitude'] as String?,
      locationName: map['location_name'] as String?,
      taxOfficeCode: map['tax_office_code'] as String?,
      taxOfficeName: map['tax_office_name'] as String?,
      taxNumber: map['tax_number'] as String?,
      taxCategory: map['tax_category'] as String?,
      taxLiabilityType: map['tax_liability_type'] as String?,
      vatWithholdingRate: map['vat_withholding_rate'] as String?,
      incomeTaxWithholding: map['income_tax_withholding'] as String?,
      corporateTaxWithholding: map['corporate_tax_withholding'] as String?,
      stampTax: map['stamp_tax'] as String?,
      taxExempt: (map['tax_exempt'] as int?) == 1 ? 'Evet' : 'Hayır',
      eInvoiceActive: (map['e_invoice_active'] as int?) == 1 ? 'Evet' : 'Hayır',
      eArchiveActive: (map['e_archive_active'] as int?) == 1 ? 'Evet' : 'Hayır',
      eArchiveScenario: map['e_archive_scenario'] as String?,
      eLedgerActive: (map['e_ledger_active'] as int?) == 1 ? 'Evet' : 'Hayır',
      paymentTerms: map['payment_terms'] as String?,
      paymentMethod: map['payment_method'] as String?,
      currency: map['currency'] as String? ?? 'TRY',
      creditLimit: (map['credit_limit'] as num?)?.toDouble(),
      riskCategory: map['risk_category'] as String?,
      salesOrg: map['sales_org'] as String?,
      distributionChannel: map['distribution_channel'] as String?,
      division: map['division'] as String?,
      priceList: map['price_list'] as String?,
      incoterms: map['incoterms'] as String?,
      shippingCondition: map['shipping_condition'] as String?,
      iban: map['iban'] as String?,
      status: map['status'] as String? ?? 'Aktif',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
      needsSync: (map['needs_sync'] as int) == 1,
    );
  }
}
