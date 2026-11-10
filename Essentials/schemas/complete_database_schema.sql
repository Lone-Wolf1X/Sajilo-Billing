-- ==============================================================================
-- Banking Enterprise & Blacklisting Database Schema
-- Charset: utf8mb4 | Collation: utf8mb4_unicode_ci
-- Target: MySQL 5.7+ / MariaDB 10.3+ / Percona
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `cheque_blacklist_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `cheque_blacklist_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- ------------------------------------------------------------------------------
-- 1. BRANCHES MASTER
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `branches` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `branch_name_en` VARCHAR(255) NOT NULL,
    `branch_name_np` VARCHAR(255) NOT NULL,
    `branch_address_en` VARCHAR(255) NOT NULL,
    `branch_address_np` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. USERS & ACCESS CONTROL (Maker / Checker / Reviewer / Approver / Admin)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(50) UNIQUE NOT NULL,
    `password_hash` VARCHAR(255) NOT NULL,
    `role` ENUM('Maker', 'Checker', 'Reviewer', 'Approver', 'Admin') NOT NULL,
    `branch_id` INT NULL,
    `province` VARCHAR(100) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_user_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. PROFILES (Individual & Institutional Unified Master)
-- Stores applicant/customer master records
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `profiles` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `profile_id` VARCHAR(50) UNIQUE NOT NULL,
    `applicant_type` ENUM('Individual', 'Institutional', 'Joint') NOT NULL,
    `applicant_name` VARCHAR(255) NOT NULL,
    `applicant_name_np` VARCHAR(255) NULL,
    `contact_no` VARCHAR(50) NULL,
    
    -- === INDIVIDUAL DEMOGRAPHICS ===
    `salutation` VARCHAR(20) NULL,
    `fullNameEnglish` VARCHAR(255) NULL,
    `fullNameNepali` VARCHAR(255) NULL,
    `dob` VARCHAR(50) NULL,
    `dobBs` VARCHAR(50) NULL,
    `gender` VARCHAR(50) NULL,
    `maritalStatus` VARCHAR(30) NULL,
    `nidNumber` VARCHAR(100) NULL,
    `citizenshipNumber` VARCHAR(100) NULL,
    `citizenshipIssueDate` VARCHAR(50) NULL,
    `citizenshipIssueDistrict` VARCHAR(100) NULL,
    `citizenshipAuthority` VARCHAR(100) NULL,
    `citizenshipIssuePlace` VARCHAR(255) NULL,
    `mobile` VARCHAR(50) NULL,
    `email` VARCHAR(100) NULL,
    
    -- Reissue Details
    `reissueYes` VARCHAR(10) NULL,
    `reissueNo` VARCHAR(10) NULL,
    `reissueDetails` VARCHAR(255) NULL,
    `reissueDate` VARCHAR(50) NULL,
    `pratilipiType` VARCHAR(50) NULL,
    `reissueDistrict` VARCHAR(255) NULL,
    `reissueAuthority` VARCHAR(255) NULL,
    `reissuePlace` VARCHAR(255) NULL,
    
    -- Permanent Address
    `perProvince` VARCHAR(100) NULL,
    `perDistrict` VARCHAR(100) NULL,
    `perMunicipality` VARCHAR(100) NULL,
    `perWard` VARCHAR(50) NULL,
    `perTown` VARCHAR(100) NULL,
    `perStreet` VARCHAR(100) NULL,
    `sameAddress` VARCHAR(10) NULL,
    
    -- Temporary Address
    `tempProvince` VARCHAR(100) NULL,
    `tempDistrict` VARCHAR(100) NULL,
    `tempMunicipality` VARCHAR(100) NULL,
    `tempWard` VARCHAR(50) NULL,
    `tempTown` VARCHAR(100) NULL,
    `tempStreet` VARCHAR(100) NULL,
    
    -- Family Relations
    `grandfather` VARCHAR(255) NULL,
    `grandmother` VARCHAR(255) NULL,
    `father` VARCHAR(255) NULL,
    `mother` VARCHAR(255) NULL,
    `spouse` VARCHAR(255) NULL,
    `daughter` VARCHAR(255) NULL,
    `son` VARCHAR(255) NULL,
    `fatherInLaw` VARCHAR(255) NULL,
    `motherInLaw` VARCHAR(255) NULL,

    -- === INSTITUTIONAL / CORPORATE DETAILS ===
    `unitNameEnglish` VARCHAR(255) NULL,
    `unitNameNepali` VARCHAR(255) NULL,
    `registrationType` VARCHAR(100) NULL,
    `registrationNumber` VARCHAR(100) NULL,
    `registrationDate` VARCHAR(50) NULL,
    `registrationDateBs` VARCHAR(50) NULL,
    `registrationAuthority` VARCHAR(500) NULL,
    `registrationAuthorityNp` VARCHAR(500) NULL,
    `registration_org_id` INT NULL,
    `registration_org_type` ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL,
    `panNumber` VARCHAR(100) NULL,
    `panIssueDate` VARCHAR(50) NULL,
    `panAuthority` VARCHAR(100) NULL,
    `panDistrict` VARCHAR(100) NULL,
    `contact` VARCHAR(50) NULL,
    `website` VARCHAR(255) NULL,
    
    -- Registered Corporate Address
    `registeredProvince` VARCHAR(100) NULL,
    `registeredDistrict` VARCHAR(100) NULL,
    `registeredMunicipality` VARCHAR(100) NULL,
    `registeredWard` VARCHAR(50) NULL,
    `registeredTown` VARCHAR(100) NULL,
    `registeredStreet` VARCHAR(100) NULL,
    `sameRegisteredAddress` VARCHAR(10) NULL,
    
    -- Mailing Address
    `mailingProvince` VARCHAR(100) NULL,
    `mailingDistrict` VARCHAR(100) NULL,
    `mailingMunicipality` VARCHAR(100) NULL,
    `mailingWard` VARCHAR(50) NULL,
    `mailingTown` VARCHAR(100) NULL,
    `mailingStreet` VARCHAR(100) NULL,
    
    -- Branch Association & Audit
    `branch_id` INT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_profile_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 4. CASES MASTER (Case Lifecycle & Verification Workflow)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cases` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `case_id` VARCHAR(50) UNIQUE NOT NULL,
    `profile_id` VARCHAR(50) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'Draft',
    `is_locked` TINYINT(1) DEFAULT 0,
    `notice_sent_date` DATE NULL,
    `memo_data` JSON NULL,
    `cib_data` JSON NULL,
    `release_memo_data` JSON NULL,
    `branch_id` INT NULL,
    `assigned_checker` VARCHAR(50) NULL,
    `maker_remarks` TEXT NULL,
    `checker_remarks` TEXT NULL,
    `reviewer_remarks` TEXT NULL,
    `approver_remarks` TEXT NULL,
    `return_origin` VARCHAR(50) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_case_profile` FOREIGN KEY (`profile_id`) REFERENCES `profiles`(`profile_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_case_branch` FOREIGN KEY (`branch_id`) REFERENCES `branches`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 5. CHEQUE DETAILS (Instrument Details & Dishonour Rules)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `cheque_details` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `case_id` VARCHAR(50) NOT NULL,
    `accountHolderName` VARCHAR(255) NULL,
    `accountNumber` VARCHAR(100) NULL,
    `branchNameEn` VARCHAR(255) NULL,
    `branchNameNp` VARCHAR(255) NULL,
    `acqBranchEn` VARCHAR(255) NULL,
    `acqBranchNp` VARCHAR(255) NULL,
    `chequeNumber` VARCHAR(100) NULL,
    `chequeDate` VARCHAR(50) NULL,
    `chequeDateAD` VARCHAR(50) NULL,
    `chequeDateType` VARCHAR(10) NULL,
    `isApplicantPayee` VARCHAR(10) NULL,
    `payeeName` VARCHAR(255) NULL,
    `payeeNameNepali` VARCHAR(255) NULL,
    `chequeAmount` DECIMAL(15,2) NULL,
    `chequeAmountWords` VARCHAR(255) NULL,
    `dishonour_reason_select` VARCHAR(255) NULL,
    `dishonour_reason_custom` VARCHAR(255) NULL,
    `is_balance_sufficient` TINYINT(1) NULL,
    `presentmentDates` TEXT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_cheque_case` FOREIGN KEY (`case_id`) REFERENCES `cases`(`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 6. DRAWER DETAILS (The Dishonoured Party)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `drawer_details` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `case_id` VARCHAR(50) NOT NULL,
    `drawer_type` ENUM('Individual', 'Institutional', 'Joint') NOT NULL,
    
    -- Individual Fields
    `fullNameEnglish` VARCHAR(255) NULL,
    `fullNameNepali` VARCHAR(255) NULL,
    `dob` VARCHAR(50) NULL,
    `dobBs` VARCHAR(50) NULL,
    `gender` VARCHAR(50) NULL,
    `maritalStatus` VARCHAR(30) NULL,
    `nidNumber` VARCHAR(100) NULL,
    `citizenshipNumber` VARCHAR(100) NULL,
    `citizenshipIssueDate` VARCHAR(50) NULL,
    `citizenshipIssueDistrict` VARCHAR(100) NULL,
    `citizenshipAuthority` VARCHAR(100) NULL,
    `citizenshipIssuePlace` VARCHAR(255) NULL,
    `mobile` VARCHAR(50) NULL,
    `email` VARCHAR(100) NULL,
    `reissueYes` VARCHAR(10) NULL,
    `reissueNo` VARCHAR(10) NULL,
    `reissueDetails` VARCHAR(255) NULL,
    `reissueDate` VARCHAR(50) NULL,
    `pratilipiType` VARCHAR(50) NULL,
    `reissueDistrict` VARCHAR(255) NULL,
    `reissueAuthority` VARCHAR(255) NULL,
    `reissuePlace` VARCHAR(255) NULL,
    `perProvince` VARCHAR(100) NULL,
    `perDistrict` VARCHAR(100) NULL,
    `perMunicipality` VARCHAR(100) NULL,
    `perWard` VARCHAR(50) NULL,
    `perTown` VARCHAR(100) NULL,
    `perStreet` VARCHAR(100) NULL,
    `sameAddress` VARCHAR(10) NULL,
    `tempProvince` VARCHAR(100) NULL,
    `tempDistrict` VARCHAR(100) NULL,
    `tempMunicipality` VARCHAR(100) NULL,
    `tempWard` VARCHAR(50) NULL,
    `tempTown` VARCHAR(100) NULL,
    `tempStreet` VARCHAR(100) NULL,
    `grandfather` VARCHAR(255) NULL,
    `grandmother` VARCHAR(255) NULL,
    `father` VARCHAR(255) NULL,
    `mother` VARCHAR(255) NULL,
    `spouse` VARCHAR(255) NULL,
    `daughter` VARCHAR(255) NULL,
    `son` VARCHAR(255) NULL,
    `fatherInLaw` VARCHAR(255) NULL,
    `motherInLaw` VARCHAR(255) NULL,

    -- Institutional Fields
    `unitNameEnglish` VARCHAR(255) NULL,
    `unitNameNepali` VARCHAR(255) NULL,
    `registrationType` VARCHAR(100) NULL,
    `registrationNumber` VARCHAR(100) NULL,
    `registrationDate` VARCHAR(50) NULL,
    `registrationDateBs` VARCHAR(50) NULL,
    `registrationAuthority` VARCHAR(500) NULL,
    `registrationAuthorityNp` VARCHAR(500) NULL,
    `registration_org_id` INT NULL,
    `registration_org_type` ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL,
    `panNumber` VARCHAR(100) NULL,
    `panIssueDate` VARCHAR(50) NULL,
    `panAuthority` VARCHAR(100) NULL,
    `panDistrict` VARCHAR(100) NULL,
    `contact` VARCHAR(50) NULL,
    `website` VARCHAR(255) NULL,
    `registeredProvince` VARCHAR(100) NULL,
    `registeredDistrict` VARCHAR(100) NULL,
    `registeredMunicipality` VARCHAR(100) NULL,
    `registeredWard` VARCHAR(50) NULL,
    `registeredTown` VARCHAR(100) NULL,
    `registeredStreet` VARCHAR(100) NULL,
    `sameRegisteredAddress` VARCHAR(10) NULL,
    `mailingProvince` VARCHAR(100) NULL,
    `mailingDistrict` VARCHAR(100) NULL,
    `mailingMunicipality` VARCHAR(100) NULL,
    `mailingWard` VARCHAR(50) NULL,
    `mailingTown` VARCHAR(100) NULL,
    `mailingStreet` VARCHAR(100) NULL,
    
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_drawer_case` FOREIGN KEY (`case_id`) REFERENCES `cases`(`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 7. LINKED INDIVIDUALS (Authorized Persons, Signatories, Joint Holders)
-- Fully relational structure connecting natural persons to institutions or joints
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `linked_individuals` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `entity_type` ENUM('Applicant', 'Drawer') NOT NULL,
    `profile_id` VARCHAR(50) NULL,
    `drawer_id` INT NULL,
    `link_type` ENUM('Authorized Person', 'Signatory', 'Joint Holder') NOT NULL,
    `role_title` VARCHAR(100) NULL,
    `is_signatory` TINYINT(1) DEFAULT 0,
    `source_profile_id` VARCHAR(50) NULL,
    
    `salutation` VARCHAR(20) NULL,
    `fullNameEnglish` VARCHAR(255) NULL,
    `fullNameNepali` VARCHAR(255) NULL,
    `dob` VARCHAR(50) NULL,
    `dobBs` VARCHAR(50) NULL,
    `gender` VARCHAR(50) NULL,
    `maritalStatus` VARCHAR(30) NULL,
    `nidNumber` VARCHAR(100) NULL,
    `citizenshipNumber` VARCHAR(100) NULL,
    `citizenshipIssueDate` VARCHAR(50) NULL,
    `citizenshipIssueDistrict` VARCHAR(100) NULL,
    `citizenshipAuthority` VARCHAR(100) NULL,
    `citizenshipIssuePlace` VARCHAR(255) NULL,
    `mobile` VARCHAR(50) NULL,
    `email` VARCHAR(100) NULL,
    
    `reissueYes` VARCHAR(10) NULL,
    `reissueNo` VARCHAR(10) NULL,
    `reissueDetails` VARCHAR(255) NULL,
    `reissueDate` VARCHAR(50) NULL,
    `pratilipiType` VARCHAR(50) NULL,
    `reissueDistrict` VARCHAR(255) NULL,
    `reissueAuthority` VARCHAR(255) NULL,
    `reissuePlace` VARCHAR(255) NULL,
    
    `perProvince` VARCHAR(100) NULL,
    `perDistrict` VARCHAR(100) NULL,
    `perMunicipality` VARCHAR(100) NULL,
    `perWard` VARCHAR(50) NULL,
    `perTown` VARCHAR(100) NULL,
    `perStreet` VARCHAR(100) NULL,
    `sameAddress` VARCHAR(10) NULL,
    
    `tempProvince` VARCHAR(100) NULL,
    `tempDistrict` VARCHAR(100) NULL,
    `tempMunicipality` VARCHAR(100) NULL,
    `tempWard` VARCHAR(50) NULL,
    `tempTown` VARCHAR(100) NULL,
    `tempStreet` VARCHAR(100) NULL,
    
    `grandfather` VARCHAR(255) NULL,
    `grandmother` VARCHAR(255) NULL,
    `father` VARCHAR(255) NULL,
    `mother` VARCHAR(255) NULL,
    `spouse` VARCHAR(255) NULL,
    `daughter` VARCHAR(255) NULL,
    `son` VARCHAR(255) NULL,
    `fatherInLaw` VARCHAR(255) NULL,
    `motherInLaw` VARCHAR(255) NULL,
    
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_linked_profile` FOREIGN KEY (`profile_id`) REFERENCES `profiles`(`profile_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_linked_drawer` FOREIGN KEY (`drawer_id`) REFERENCES `drawer_details`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 8. AUDIT LOGS & EVIDENCE TRAIL
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `audit_logs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `case_id` VARCHAR(50) NOT NULL,
    `username` VARCHAR(50) NOT NULL,
    `role` VARCHAR(50) NOT NULL,
    `action` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_audit_case` FOREIGN KEY (`case_id`) REFERENCES `cases`(`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 9. ATTACHED DOCUMENTS
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `documents` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `case_id` VARCHAR(50) NOT NULL,
    `document_type` VARCHAR(100) NOT NULL,
    `drawer_name` VARCHAR(255) NOT NULL,
    `file_path` VARCHAR(255) NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_case` FOREIGN KEY (`case_id`) REFERENCES `cases`(`case_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 10. SYSTEM SETTINGS & HOLIDAYS (45-Day & 7-Day Deadline Engine)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `system_settings` (
    `setting_key` VARCHAR(50) PRIMARY KEY,
    `setting_value` JSON NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `holidays` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `holiday_date` DATE UNIQUE NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 11. NEPAL GOVERNMENT HIERARCHY TABLES (Administrative Structure)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `gov_tiers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_authorities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_auth_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_provinces` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_districts` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `province_id` INT NOT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_dist_prov` FOREIGN KEY (`province_id`) REFERENCES `gov_provinces`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_local_bodies` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `district_id` INT NOT NULL,
    `type_en` VARCHAR(100) NOT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `code` VARCHAR(50) NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_local_dist` FOREIGN KEY (`district_id`) REFERENCES `gov_districts`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_org_types` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_ministries` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `authority_id` INT NOT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_min_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_min_auth` FOREIGN KEY (`authority_id`) REFERENCES `gov_authorities`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_departments` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `authority_id` INT NOT NULL,
    `ministry_id` INT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_dept_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dept_auth` FOREIGN KEY (`authority_id`) REFERENCES `gov_authorities`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dept_min` FOREIGN KEY (`ministry_id`) REFERENCES `gov_ministries`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_directorates` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `authority_id` INT NOT NULL,
    `department_id` INT NULL,
    `ministry_id` INT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_dir_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dir_auth` FOREIGN KEY (`authority_id`) REFERENCES `gov_authorities`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dir_dept` FOREIGN KEY (`department_id`) REFERENCES `gov_departments`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_dir_min` FOREIGN KEY (`ministry_id`) REFERENCES `gov_ministries`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_offices` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `authority_id` INT NOT NULL,
    `directorate_id` INT NULL,
    `department_id` INT NULL,
    `ministry_id` INT NULL,
    `province_id` INT NULL,
    `district_id` INT NULL,
    `local_body_id` INT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_off_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_off_auth` FOREIGN KEY (`authority_id`) REFERENCES `gov_authorities`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_off_dir` FOREIGN KEY (`directorate_id`) REFERENCES `gov_directorates`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_off_dept` FOREIGN KEY (`department_id`) REFERENCES `gov_departments`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_off_min` FOREIGN KEY (`ministry_id`) REFERENCES `gov_ministries`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_off_prov` FOREIGN KEY (`province_id`) REFERENCES `gov_provinces`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_off_dist` FOREIGN KEY (`district_id`) REFERENCES `gov_districts`(`id`) ON DELETE SET NULL,
    CONSTRAINT `fk_off_local` FOREIGN KEY (`local_body_id`) REFERENCES `gov_local_bodies`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `gov_other_orgs` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `tier_id` INT NOT NULL,
    `authority_id` INT NOT NULL,
    `type_id` INT NULL,
    `parent_org_type` ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL,
    `parent_org_id` INT NULL,
    `name_en` VARCHAR(255) NOT NULL,
    `name_np` VARCHAR(255) NOT NULL,
    `status` ENUM('Active', 'Inactive') DEFAULT 'Active',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_other_tier` FOREIGN KEY (`tier_id`) REFERENCES `gov_tiers`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_other_auth` FOREIGN KEY (`authority_id`) REFERENCES `gov_authorities`(`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_other_type` FOREIGN KEY (`type_id`) REFERENCES `gov_org_types`(`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;
