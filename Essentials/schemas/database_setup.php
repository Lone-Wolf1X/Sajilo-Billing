<?php
$host = '127.0.0.1';
$user = 'root';
$pass = '';

try {
    $pdo = new PDO("mysql:host=$host", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create database
    $pdo->exec("CREATE DATABASE IF NOT EXISTS cheque_blacklist_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "Database created successfully.\n";
    
    $pdo->exec("USE cheque_blacklist_db");
    
    // Branches table
    $pdo->exec("CREATE TABLE IF NOT EXISTS branches (
        id INT AUTO_INCREMENT PRIMARY KEY,
        branch_name_en VARCHAR(255) NOT NULL,
        branch_name_np VARCHAR(255) NOT NULL,
        branch_address_en VARCHAR(255) NOT NULL,
        branch_address_np VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");

    // Add branch_id column to users table if not existing
    $cols = $pdo->query("SHOW COLUMNS FROM users LIKE 'branch_id'")->fetchAll();
    if (empty($cols)) {
        $pdo->exec("ALTER TABLE users ADD COLUMN branch_id INT NULL, ADD CONSTRAINT fk_user_branch FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL");
    }

    // Seed Branches if empty
    $bCount = $pdo->query("SELECT COUNT(*) FROM branches")->fetchColumn();
    if ($bCount == 0) {
        $pdo->exec("INSERT INTO branches (branch_name_en, branch_name_np, branch_address_en, branch_address_np) VALUES
            ('Kathmandu Main Branch', 'काठमाडौँ मुख्य शाखा', 'Durbar Marg, Kathmandu', 'दरबार मार्ग, काठमाडौँ'),
            ('Pokhara Branch', 'पोखरा शाखा', 'New Road, Pokhara', 'न्यू रोड, पोखरा'),
            ('Lalitpur Branch', 'ललितपुर शाखा', 'Patan Dhoka, Lalitpur', 'पाटन ढोका, ललितपुर')
        ");
    }

    // Users table
    $pdo->exec("CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        password_hash VARCHAR(255) NOT NULL,
        role ENUM('Maker', 'Checker', 'Reviewer', 'Approver', 'Admin') NOT NULL,
        branch_id INT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL
    )");
    
    // Insert default users
    $hash = password_hash('password123', PASSWORD_DEFAULT);
    $pdo->exec("INSERT IGNORE INTO users (username, password_hash, role, branch_id) VALUES 
        ('maker1', '$hash', 'Maker', 1),
        ('checker1', '$hash', 'Checker', 1),
        ('reviewer1', '$hash', 'Reviewer', 1),
        ('approver1', '$hash', 'Approver', 1),
        ('admin1', '$hash', 'Admin', 1)
    ");

    // Assign branch 1 to existing users if null
    $pdo->exec("UPDATE users SET branch_id = 1 WHERE branch_id IS NULL");

    // Tables are created using IF NOT EXISTS to prevent accidental data loss.
    // Removed DROP TABLE statements to safeguard existing data.
    // Profiles table (Individual & Institutional combined)
    $pdo->exec("CREATE TABLE IF NOT EXISTS profiles (
        id INT AUTO_INCREMENT PRIMARY KEY,
        profile_id VARCHAR(50) UNIQUE NOT NULL,
        applicant_type ENUM('Individual', 'Institutional', 'Joint') NOT NULL,
        applicant_name VARCHAR(255) NOT NULL,
        applicant_name_np VARCHAR(255) NULL,
        contact_no VARCHAR(50) NULL,
        
        -- Individual Fields
        salutation VARCHAR(20) NULL,
        fullNameEnglish VARCHAR(255) NULL,
        fullNameNepali VARCHAR(255) NULL,
        dob VARCHAR(50) NULL,
        dobBs VARCHAR(50) NULL,
        gender VARCHAR(50) NULL,
        maritalStatus VARCHAR(30) NULL,
        nidNumber VARCHAR(100) NULL,
        citizenshipNumber VARCHAR(100) NULL,
        citizenshipIssueDate VARCHAR(50) NULL,
        citizenshipIssueDistrict VARCHAR(100) NULL,
        citizenshipAuthority VARCHAR(100) NULL,
        citizenshipIssuePlace VARCHAR(255) NULL,
        mobile VARCHAR(50) NULL,
        email VARCHAR(100) NULL,
        reissueYes VARCHAR(10) NULL,
        reissueNo VARCHAR(10) NULL,
        reissueDetails VARCHAR(255) NULL,
        reissueDate VARCHAR(50) NULL,
        pratilipiType VARCHAR(50) NULL,
        reissueDistrict VARCHAR(255) NULL,
        reissueAuthority VARCHAR(255) NULL,
        reissuePlace VARCHAR(255) NULL,
        perProvince VARCHAR(100) NULL,
        perDistrict VARCHAR(100) NULL,
        perMunicipality VARCHAR(100) NULL,
        perWard VARCHAR(50) NULL,
        perTown VARCHAR(100) NULL,
        perStreet VARCHAR(100) NULL,
        sameAddress VARCHAR(10) NULL,
        tempProvince VARCHAR(100) NULL,
        tempDistrict VARCHAR(100) NULL,
        tempMunicipality VARCHAR(100) NULL,
        tempWard VARCHAR(50) NULL,
        tempTown VARCHAR(100) NULL,
        tempStreet VARCHAR(100) NULL,
        grandfather VARCHAR(255) NULL,
        grandmother VARCHAR(255) NULL,
        father VARCHAR(255) NULL,
        mother VARCHAR(255) NULL,
        spouse VARCHAR(255) NULL,
        daughter VARCHAR(255) NULL,
        son VARCHAR(255) NULL,
        fatherInLaw VARCHAR(255) NULL,
        motherInLaw VARCHAR(255) NULL,

        -- Institutional Fields
        unitNameEnglish VARCHAR(255) NULL,
        unitNameNepali VARCHAR(255) NULL,
        registrationType VARCHAR(100) NULL,
        registrationNumber VARCHAR(100) NULL,
        registrationDate VARCHAR(50) NULL,
        registrationDateBs VARCHAR(50) NULL,
        registrationAuthority VARCHAR(500) NULL,
        registrationAuthorityNp VARCHAR(500) NULL,
        registration_org_id VARCHAR(50) NULL,
        registration_org_type VARCHAR(50) NULL,
        reg_authority_id VARCHAR(50) NULL,
        reg_ministry_id VARCHAR(50) NULL,
        reg_department_id VARCHAR(50) NULL,
        reg_office_id VARCHAR(50) NULL,
        reg_district_id VARCHAR(50) NULL,
        panNumber VARCHAR(100) NULL,
        panIssueDate VARCHAR(50) NULL,
        panAuthority VARCHAR(100) NULL,
        panDistrict VARCHAR(100) NULL,
        contact VARCHAR(50) NULL,
        website VARCHAR(255) NULL,
        registeredProvince VARCHAR(100) NULL,
        registeredDistrict VARCHAR(100) NULL,
        registeredMunicipality VARCHAR(100) NULL,
        registeredWard VARCHAR(50) NULL,
        registeredTown VARCHAR(100) NULL,
        registeredStreet VARCHAR(100) NULL,
        sameRegisteredAddress VARCHAR(10) NULL,
        mailingProvince VARCHAR(100) NULL,
        mailingDistrict VARCHAR(100) NULL,
        mailingMunicipality VARCHAR(100) NULL,
        mailingWard VARCHAR(50) NULL,
        mailingTown VARCHAR(100) NULL,
        mailingStreet VARCHAR(100) NULL,
        jointHolders LONGTEXT NULL,
        authorizedPersons LONGTEXT NULL,
        
        branch_id INT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    // Cases table
    $pdo->exec("CREATE TABLE IF NOT EXISTS cases (
        id INT AUTO_INCREMENT PRIMARY KEY,
        case_id VARCHAR(50) UNIQUE NOT NULL,
        profile_id VARCHAR(50) NOT NULL,
        status VARCHAR(50) NOT NULL DEFAULT 'Draft',
        is_locked TINYINT(1) DEFAULT 0,
        notice_sent_date DATE NULL,
        memo_data JSON NULL,
        cib_data JSON NULL,
        release_memo_data JSON NULL,
        branch_id INT NULL,
        assigned_checker VARCHAR(50) NULL,
        maker_remarks TEXT NULL,
        checker_remarks TEXT NULL,
        reviewer_remarks TEXT NULL,
        approver_remarks TEXT NULL,
        return_origin VARCHAR(50) NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (profile_id) REFERENCES profiles(profile_id) ON DELETE CASCADE,
        FOREIGN KEY (branch_id) REFERENCES branches(id) ON DELETE SET NULL
    )");
    
    // Holiday Tracking & Settings
    $pdo->exec("CREATE TABLE IF NOT EXISTS system_settings (
        setting_key VARCHAR(50) PRIMARY KEY,
        setting_value JSON NOT NULL,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )");
    
    // Seed default weekends (Saturday and Sunday)
    $stmt = $pdo->prepare("INSERT IGNORE INTO system_settings (setting_key, setting_value) VALUES ('weekend_days', ?)");
    $stmt->execute([json_encode(['Saturday', 'Sunday'])]);

    $pdo->exec("CREATE TABLE IF NOT EXISTS holidays (
        id INT AUTO_INCREMENT PRIMARY KEY,
        holiday_date DATE UNIQUE NOT NULL,
        description VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )");
    
    // Cheque Details table
    $pdo->exec("CREATE TABLE IF NOT EXISTS cheque_details (
        id INT AUTO_INCREMENT PRIMARY KEY,
        case_id VARCHAR(50) NOT NULL,
        accountHolderName VARCHAR(255) NULL,
        accountNumber VARCHAR(100) NULL,
        branchNameEn VARCHAR(255) NULL,
        branchNameNp VARCHAR(255) NULL,
        acqBranchEn VARCHAR(255) NULL,
        acqBranchNp VARCHAR(255) NULL,
        chequeNumber VARCHAR(100) NULL,
        chequeDate VARCHAR(50) NULL,
        chequeDateAD VARCHAR(50) NULL,
        chequeDateType VARCHAR(10) NULL,
        isApplicantPayee VARCHAR(10) NULL,
        payeeName VARCHAR(255) NULL,
        payeeNameNepali VARCHAR(255) NULL,
        chequeAmount DECIMAL(15,2) NULL,
        chequeAmountWords VARCHAR(255) NULL,
        dishonour_reason_select VARCHAR(255) NULL,
        dishonour_reason_custom VARCHAR(255) NULL,
        is_balance_sufficient TINYINT(1) NULL,
        presentmentDates TEXT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
    )");
    
    // Drawer Details table
    $pdo->exec("CREATE TABLE IF NOT EXISTS drawer_details (
        id INT AUTO_INCREMENT PRIMARY KEY,
        case_id VARCHAR(50) NOT NULL,
        drawer_type ENUM('Individual', 'Institutional', 'Joint') NOT NULL,
        
        -- Individual Fields
        fullNameEnglish VARCHAR(255) NULL,
        fullNameNepali VARCHAR(255) NULL,
        dob VARCHAR(50) NULL,
        dobBs VARCHAR(50) NULL,
        gender VARCHAR(50) NULL,
        maritalStatus VARCHAR(30) NULL,
        nidNumber VARCHAR(100) NULL,
        citizenshipNumber VARCHAR(100) NULL,
        citizenshipIssueDate VARCHAR(50) NULL,
        citizenshipIssueDistrict VARCHAR(100) NULL,
        citizenshipAuthority VARCHAR(100) NULL,
        citizenshipIssuePlace VARCHAR(255) NULL,
        mobile VARCHAR(50) NULL,
        email VARCHAR(100) NULL,
        reissueYes VARCHAR(10) NULL,
        reissueNo VARCHAR(10) NULL,
        reissueDetails VARCHAR(255) NULL,
        reissueDate VARCHAR(50) NULL,
        pratilipiType VARCHAR(50) NULL,
        reissueDistrict VARCHAR(255) NULL,
        reissueAuthority VARCHAR(255) NULL,
        reissuePlace VARCHAR(255) NULL,
        perProvince VARCHAR(100) NULL,
        perDistrict VARCHAR(100) NULL,
        perMunicipality VARCHAR(100) NULL,
        perWard VARCHAR(50) NULL,
        perTown VARCHAR(100) NULL,
        perStreet VARCHAR(100) NULL,
        sameAddress VARCHAR(10) NULL,
        tempProvince VARCHAR(100) NULL,
        tempDistrict VARCHAR(100) NULL,
        tempMunicipality VARCHAR(100) NULL,
        tempWard VARCHAR(50) NULL,
        tempTown VARCHAR(100) NULL,
        tempStreet VARCHAR(100) NULL,
        grandfather VARCHAR(255) NULL,
        grandmother VARCHAR(255) NULL,
        father VARCHAR(255) NULL,
        mother VARCHAR(255) NULL,
        spouse VARCHAR(255) NULL,
        daughter VARCHAR(255) NULL,
        son VARCHAR(255) NULL,
        fatherInLaw VARCHAR(255) NULL,
        motherInLaw VARCHAR(255) NULL,

        -- Institutional Fields
        unitNameEnglish VARCHAR(255) NULL,
        unitNameNepali VARCHAR(255) NULL,
        registrationType VARCHAR(100) NULL,
        registrationNumber VARCHAR(100) NULL,
        registrationDate VARCHAR(50) NULL,
        registrationDateBs VARCHAR(50) NULL,
        registrationAuthority VARCHAR(500) NULL,
        registrationAuthorityNp VARCHAR(500) NULL,
        registration_org_id VARCHAR(50) NULL,
        registration_org_type VARCHAR(50) NULL,
        reg_authority_id VARCHAR(50) NULL,
        reg_ministry_id VARCHAR(50) NULL,
        reg_department_id VARCHAR(50) NULL,
        reg_office_id VARCHAR(50) NULL,
        reg_district_id VARCHAR(50) NULL,
        panNumber VARCHAR(100) NULL,
        panIssueDate VARCHAR(50) NULL,
        panAuthority VARCHAR(100) NULL,
        panDistrict VARCHAR(100) NULL,
        contact VARCHAR(50) NULL,
        website VARCHAR(255) NULL,
        registeredProvince VARCHAR(100) NULL,
        registeredDistrict VARCHAR(100) NULL,
        registeredMunicipality VARCHAR(100) NULL,
        registeredWard VARCHAR(50) NULL,
        registeredTown VARCHAR(100) NULL,
        registeredStreet VARCHAR(100) NULL,
        sameRegisteredAddress VARCHAR(10) NULL,
        mailingProvince VARCHAR(100) NULL,
        mailingDistrict VARCHAR(100) NULL,
        mailingMunicipality VARCHAR(100) NULL,
        mailingWard VARCHAR(50) NULL,
        mailingTown VARCHAR(100) NULL,
        mailingStreet VARCHAR(100) NULL,
        
        jointHolders JSON NULL,
        authorizedPersons JSON NULL,
        
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
    )");
    
    // Audit Logs table
    $pdo->exec("CREATE TABLE IF NOT EXISTS audit_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        case_id VARCHAR(50) NOT NULL,
        username VARCHAR(50) NOT NULL,
        role VARCHAR(50) NOT NULL,
        action VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
    )");
    
    // Documents table
    $pdo->exec("CREATE TABLE IF NOT EXISTS documents (
        id INT AUTO_INCREMENT PRIMARY KEY,
        case_id VARCHAR(50) NOT NULL,
        document_type VARCHAR(100) NOT NULL,
        drawer_name VARCHAR(255) NOT NULL,
        file_path VARCHAR(255) NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (case_id) REFERENCES cases(case_id) ON DELETE CASCADE
    )");

    echo "Tables created and seeded successfully.\n";

} catch(PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
