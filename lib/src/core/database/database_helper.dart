import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// DatabaseHelper - SQLite veritabanı yönetimi için singleton sınıf
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('erplus.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Desktop için FFI kullan
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Customers (Cari Hesaplar) tablosu
    await db.execute(
      'CREATE TABLE customers ('
      'id TEXT PRIMARY KEY, '
      'code TEXT NOT NULL UNIQUE, '
      'account_group TEXT NOT NULL, '
      'customer_type TEXT, '
      'branch TEXT, '
      'customer_group TEXT, '
      'customer_class TEXT, '
      'name TEXT NOT NULL, '
      'company_code TEXT, '
      'sector_code TEXT, '
      'phone TEXT, '
      'mobile TEXT, '
      'fax TEXT, '
      'email TEXT, '
      'website TEXT, '
      'whatsapp TEXT, '
      'address TEXT, '
      'neighborhood TEXT, '
      'street TEXT, '
      'avenue TEXT, '
      'open_address TEXT, '
      'city TEXT, '
      'district TEXT, '
      'postal_code TEXT, '
      'country TEXT, '
      'latitude TEXT, '
      'longitude TEXT, '
      'location_name TEXT, '
      'tax_office_code TEXT, '
      'tax_office_name TEXT, '
      'tax_number TEXT, '
      'tax_category TEXT, '
      'tax_liability_type TEXT, '
      'vat_withholding_rate TEXT, '
      'income_tax_withholding TEXT, '
      'corporate_tax_withholding TEXT, '
      'stamp_tax TEXT, '
      'tax_exempt INTEGER DEFAULT 0, '
      'e_invoice_active INTEGER DEFAULT 0, '
      'e_archive_active INTEGER DEFAULT 0, '
      'e_archive_scenario TEXT, '
      'e_ledger_active INTEGER DEFAULT 0, '
      'payment_terms TEXT, '
      'payment_method TEXT, '
      'currency TEXT DEFAULT "TRY", '
      'credit_limit REAL DEFAULT 0, '
      'risk_category TEXT, '
      'sales_org TEXT, '
      'distribution_channel TEXT, '
      'division TEXT, '
      'price_list TEXT, '
      'incoterms TEXT, '
      'shipping_condition TEXT, '
      'iban TEXT, '
      'status TEXT DEFAULT "Aktif", '
      'created_at TEXT NOT NULL, '
      'updated_at TEXT NOT NULL, '
      'needs_sync INTEGER DEFAULT 0'
      ')',
    );

    // İndeksler
    await db.execute('CREATE INDEX idx_customers_code ON customers(code)');
    await db.execute('CREATE INDEX idx_customers_name ON customers(name)');
    await db.execute('CREATE INDEX idx_customers_status ON customers(status)');
    await db.execute(
      'CREATE INDEX idx_customers_sync ON customers(needs_sync)',
    );

    print('✅ Database tables created successfully');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    // Gelecekteki veritabanı güncellemeleri için
    if (oldVersion < newVersion) {
      // Örnek: yeni sütun ekle
      // await db.execute('ALTER TABLE customers ADD COLUMN new_field TEXT');
    }
  }

  // CRUD işlemleri
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
