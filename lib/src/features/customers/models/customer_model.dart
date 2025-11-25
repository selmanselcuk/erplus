import 'package:json_annotation/json_annotation.dart';

part 'customer_model.g.dart';

@JsonSerializable()
class Customer {
  final String id;
  final String code;
  @JsonKey(name: 'account_group')
  final String accountGroup;
  @JsonKey(name: 'customer_type')
  final String? customerType;
  final String? branch;
  @JsonKey(name: 'customer_group')
  final String? customerGroup;
  @JsonKey(name: 'customer_class')
  final String? customerClass;
  final String name;
  @JsonKey(name: 'company_code')
  final String? companyCode;
  @JsonKey(name: 'sector_code')
  final String? sectorCode;
  final String? phone;
  final String? mobile;
  final String? fax;
  final String? email;
  final String? website;
  final String? whatsapp;
  final String? address;
  final String? neighborhood;
  final String? street;
  final String? avenue;
  @JsonKey(name: 'open_address')
  final String? openAddress;
  final String? city;
  final String? district;
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  final String? country;
  final String? latitude;
  final String? longitude;
  @JsonKey(name: 'location_name')
  final String? locationName;
  @JsonKey(name: 'tax_office_code')
  final String? taxOfficeCode;
  @JsonKey(name: 'tax_office_name')
  final String? taxOfficeName;
  @JsonKey(name: 'tax_number')
  final String? taxNumber;
  @JsonKey(name: 'tax_category')
  final String? taxCategory;
  @JsonKey(name: 'tax_liability_type')
  final String? taxLiabilityType;
  @JsonKey(name: 'vat_withholding_rate')
  final String? vatWithholdingRate;
  @JsonKey(name: 'income_tax_withholding')
  final String? incomeTaxWithholding;
  @JsonKey(name: 'corporate_tax_withholding')
  final String? corporateTaxWithholding;
  @JsonKey(name: 'stamp_tax')
  final String? stampTax;
  @JsonKey(name: 'tax_exempt')
  final String? taxExempt;
  @JsonKey(name: 'e_invoice_active')
  final String? eInvoiceActive;
  @JsonKey(name: 'e_archive_active')
  final String? eArchiveActive;
  @JsonKey(name: 'e_archive_scenario')
  final String? eArchiveScenario;
  @JsonKey(name: 'e_ledger_active')
  final String? eLedgerActive;
  @JsonKey(name: 'payment_terms')
  final String? paymentTerms;
  @JsonKey(name: 'payment_method')
  final String? paymentMethod;
  final String currency;
  @JsonKey(name: 'credit_limit')
  final double? creditLimit;
  @JsonKey(name: 'risk_category')
  final String? riskCategory;
  @JsonKey(name: 'sales_org')
  final String? salesOrg;
  @JsonKey(name: 'distribution_channel')
  final String? distributionChannel;
  final String? division;
  @JsonKey(name: 'price_list')
  final String? priceList;
  final String? incoterms;
  @JsonKey(name: 'shipping_condition')
  final String? shippingCondition;
  final String? iban;
  final String status;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'needs_sync')
  final bool needsSync;

  Customer({
    required this.id,
    required this.code,
    required this.accountGroup,
    this.customerType,
    this.branch,
    this.customerGroup,
    this.customerClass,
    required this.name,
    this.companyCode,
    this.sectorCode,
    this.phone,
    this.mobile,
    this.fax,
    this.email,
    this.website,
    this.whatsapp,
    this.address,
    this.neighborhood,
    this.street,
    this.avenue,
    this.openAddress,
    this.city,
    this.district,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
    this.locationName,
    this.taxOfficeCode,
    this.taxOfficeName,
    this.taxNumber,
    this.taxCategory,
    this.taxLiabilityType,
    this.vatWithholdingRate,
    this.incomeTaxWithholding,
    this.corporateTaxWithholding,
    this.stampTax,
    this.taxExempt,
    this.eInvoiceActive,
    this.eArchiveActive,
    this.eArchiveScenario,
    this.eLedgerActive,
    this.paymentTerms,
    this.paymentMethod,
    this.currency = 'TRY',
    this.creditLimit,
    this.riskCategory,
    this.salesOrg,
    this.distributionChannel,
    this.division,
    this.priceList,
    this.incoterms,
    this.shippingCondition,
    this.iban,
    this.status = 'Aktif',
    this.createdAt,
    this.updatedAt,
    this.needsSync = false,
  });

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  Customer copyWith({
    String? id,
    String? code,
    String? accountGroup,
    String? customerType,
    String? branch,
    String? customerGroup,
    String? customerClass,
    String? name,
    String? companyCode,
    String? sectorCode,
    String? phone,
    String? mobile,
    String? fax,
    String? email,
    String? website,
    String? whatsapp,
    String? address,
    String? neighborhood,
    String? street,
    String? avenue,
    String? openAddress,
    String? city,
    String? district,
    String? postalCode,
    String? country,
    String? latitude,
    String? longitude,
    String? locationName,
    String? taxOfficeCode,
    String? taxOfficeName,
    String? taxNumber,
    String? taxCategory,
    String? taxLiabilityType,
    String? vatWithholdingRate,
    String? incomeTaxWithholding,
    String? corporateTaxWithholding,
    String? stampTax,
    String? taxExempt,
    String? eInvoiceActive,
    String? eArchiveActive,
    String? eArchiveScenario,
    String? eLedgerActive,
    String? paymentTerms,
    String? paymentMethod,
    String? currency,
    double? creditLimit,
    String? riskCategory,
    String? salesOrg,
    String? distributionChannel,
    String? division,
    String? priceList,
    String? incoterms,
    String? shippingCondition,
    String? iban,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? needsSync,
  }) {
    return Customer(
      id: id ?? this.id,
      code: code ?? this.code,
      accountGroup: accountGroup ?? this.accountGroup,
      customerType: customerType ?? this.customerType,
      branch: branch ?? this.branch,
      customerGroup: customerGroup ?? this.customerGroup,
      customerClass: customerClass ?? this.customerClass,
      name: name ?? this.name,
      companyCode: companyCode ?? this.companyCode,
      sectorCode: sectorCode ?? this.sectorCode,
      phone: phone ?? this.phone,
      mobile: mobile ?? this.mobile,
      fax: fax ?? this.fax,
      email: email ?? this.email,
      website: website ?? this.website,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
      neighborhood: neighborhood ?? this.neighborhood,
      street: street ?? this.street,
      avenue: avenue ?? this.avenue,
      openAddress: openAddress ?? this.openAddress,
      city: city ?? this.city,
      district: district ?? this.district,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locationName: locationName ?? this.locationName,
      taxOfficeCode: taxOfficeCode ?? this.taxOfficeCode,
      taxOfficeName: taxOfficeName ?? this.taxOfficeName,
      taxNumber: taxNumber ?? this.taxNumber,
      taxCategory: taxCategory ?? this.taxCategory,
      taxLiabilityType: taxLiabilityType ?? this.taxLiabilityType,
      vatWithholdingRate: vatWithholdingRate ?? this.vatWithholdingRate,
      incomeTaxWithholding: incomeTaxWithholding ?? this.incomeTaxWithholding,
      corporateTaxWithholding:
          corporateTaxWithholding ?? this.corporateTaxWithholding,
      stampTax: stampTax ?? this.stampTax,
      taxExempt: taxExempt ?? this.taxExempt,
      eInvoiceActive: eInvoiceActive ?? this.eInvoiceActive,
      eArchiveActive: eArchiveActive ?? this.eArchiveActive,
      eArchiveScenario: eArchiveScenario ?? this.eArchiveScenario,
      eLedgerActive: eLedgerActive ?? this.eLedgerActive,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      currency: currency ?? this.currency,
      creditLimit: creditLimit ?? this.creditLimit,
      riskCategory: riskCategory ?? this.riskCategory,
      salesOrg: salesOrg ?? this.salesOrg,
      distributionChannel: distributionChannel ?? this.distributionChannel,
      division: division ?? this.division,
      priceList: priceList ?? this.priceList,
      incoterms: incoterms ?? this.incoterms,
      shippingCondition: shippingCondition ?? this.shippingCondition,
      iban: iban ?? this.iban,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      needsSync: needsSync ?? this.needsSync,
    );
  }
}
