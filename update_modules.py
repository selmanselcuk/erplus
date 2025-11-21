#!/usr/bin/env python3
"""
ERPlus - Modül güncelleme script'i
Service, Inventory, Sales, Purchasing, Finance, CRM, Reports modüllerini günceller
"""

import re
import os

# Modül tanımları
modules = {
    'service': {
        'file': 'lib/src/features/service/service_page.dart',
        'colors': ['#06B6D4', '#0891B2', '#0E7490', '#164E63'],
        'groups': ['Servis', 'Ekip', 'Planlama', 'Form', 'Fatura', 'Analitik']
    },
    'inventory': {
        'file': 'lib/src/features/inventory/inventory_page.dart',
        'colors': ['#6366F1', '#8B5CF6', '#7C3AED', '#6D28D9'],
        'groups': ['Stok', 'Ürün', 'Depo', 'Transfer', 'Sayım', 'Analitik']
    },
    'sales': {
        'file': 'lib/src/features/sales/sales_page.dart',
        'colors': ['#10B981', '#059669', '#22C55E', '#16A34A'],
        'groups': ['Satış', 'Teklif', 'Sipariş', 'Sevkiyat', 'Kampanya', 'Analitik']
    },
    'purchasing': {
        'file': 'lib/src/features/purchasing/purchasing_page.dart',
        'colors': ['#F97316', '#EA580C', '#FB923C', '#F59E0B'],
        'groups': ['Satınalma', 'Talep', 'Sipariş', 'Tedarikçi', 'Kalite', 'Analitik']
    },
    'finance': {
        'file': 'lib/src/features/finance/finance_page.dart',
        'colors': ['#1E40AF', '#1E3A8A', '#334155', '#475569'],
        'groups': ['Finans', 'Kasa', 'Banka', 'Çek', 'Senet', 'Muhasebe']
    },
    'crm': {
        'file': 'lib/src/features/crm/crm_page.dart',
        'colors': ['#6366F1', '#4F46E5', '#4338CA', '#3730A3'],
        'groups': ['CRM', 'Fırsat', 'Aktivite', 'Kampanya', 'Lead', 'Analitik']
    },
    'reports': {
        'file': 'lib/src/features/reports/reports_page.dart',
        'colors': ['#F59E0B', '#D97706', '#B45309', '#92400E'],
        'groups': ['Rapor', 'Finans', 'Satış', 'Stok', 'Dashboard', 'BI']
    }
}

def update_feature_model(content):
    """_Feature sınıfına group ve color ekle"""
    old_model = r'class _Feature \{\s+final String id;\s+final String sectionId;\s+final String title;\s+final String description;\s+final IconData icon;\s+_Feature\(\{\s+required this\.id,\s+required this\.sectionId,\s+required this\.title,\s+required this\.description,\s+required this\.icon,\s+\}\);'
    
    new_model = '''class _Feature {
  final String id;
  final String sectionId;
  final String title;
  final String description;
  final String group;
  final IconData icon;
  final Color color;

  const _Feature({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.group,
    required this.icon,
    required this.color,
  });'''
    
    return re.sub(old_model, new_model, content, flags=re.DOTALL)

print("ERPlus modül güncelleme script'i başlatılıyor...")
print(f"\n{len(modules)} modül işlenecek:\n")

for name, config in modules.items():
    print(f"  ✓ {name.capitalize()}")

print("\nNOT: Bu script sadece bilgi amaçlıdır.")
print("Gerçek güncellemeleri VS Code üzerinden yapınız.")
