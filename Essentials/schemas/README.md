# Banking Essentials - Database Schemas & Seed Data

This directory contains database DDL definitions, master data seeds, migration scripts, and comprehensive data dictionaries for enterprise banking deployments.

---

## 📁 Files Included

| File | Type | Description |
| :--- | :--- | :--- |
| `complete_database_schema.sql` | SQL DDL | Complete standalone MySQL/MariaDB DDL for creating the `cheque_blacklist_db` database, tables, primary keys, foreign key constraints, and utf8mb4 collation. |
| `seed_master_data.sql` | SQL DML | Seed script inserting default branches, user roles, weekend settings, all 7 provinces, 77 districts, ministries, departments, revenue offices, and autonomous bodies (NRB, SEBON, CIB, SSF, EPF, etc.). |
| `database_setup.php` | PHP Installer | Automated PHP script executing schema setup and seeding via PDO with error handling. |
| `patch_gov_hierarchy_db.php` | PHP Migration | Specialized migration splitting government structures into normalized tiers, authorities, ministries, departments, directorates, and offices. |
| `seed-gov-data.php` | PHP Script | Comprehensive data seeder for all 77 districts and federal hierarchies in Nepal. |
| `update_schema.sql` & `update_schema2.sql` | SQL Delta | Historical incremental migration patches for linked individuals and relational normalization. |
| `form_to_database_mapping.md` | Documentation | Complete data dictionary mapping each form field (Individual, Institutional, Cheque, Drawer) to its database table and column. |

---

## 🚀 How to Deploy

### Option 1: Using MySQL CLI or phpMyAdmin
```bash
# 1. Import Schema
mysql -u root -p < complete_database_schema.sql

# 2. Import Master Seed Data
mysql -u root -p cheque_blacklist_db < seed_master_data.sql
```

### Option 2: Automated PHP Deployment
Run the self-contained setup script directly in your terminal or browser:
```bash
php database_setup.php
```
