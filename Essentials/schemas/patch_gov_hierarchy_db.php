<?php
$host = '127.0.0.1';
$user = 'root';
$pass = '';
$db   = 'cheque_blacklist_db';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "Applying Government Hierarchy Database Patches (Split Tables)...\n";

    // 1. gov_tiers
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_tiers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )");

    // 2. gov_authorities
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_authorities (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE
    )");

    // 3. gov_provinces
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_provinces (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )");

    // 4. gov_districts
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_districts (
        id INT AUTO_INCREMENT PRIMARY KEY,
        province_id INT NOT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (province_id) REFERENCES gov_provinces(id) ON DELETE CASCADE
    )");

    // 5. gov_local_bodies
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_local_bodies (
        id INT AUTO_INCREMENT PRIMARY KEY,
        district_id INT NOT NULL,
        type_en VARCHAR(100) NOT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        code VARCHAR(50) NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (district_id) REFERENCES gov_districts(id) ON DELETE CASCADE
    )");

    // 6. gov_org_types (Still useful for "Other Orgs")
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_org_types (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    )");

    // Remove foreign keys in profiles/drawer_details to gov_organizations if exists
    try {
        $pdo->exec("ALTER TABLE profiles DROP FOREIGN KEY fk_profile_reg_org");
    } catch(Exception $e) {}
    try {
        $pdo->exec("ALTER TABLE drawer_details DROP FOREIGN KEY fk_drawer_reg_org");
    } catch(Exception $e) {}

    // Drop old gov_organizations table
    $pdo->exec("DROP TABLE IF EXISTS gov_organizations");

    // 7. gov_ministries
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_ministries (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        authority_id INT NOT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE,
        FOREIGN KEY (authority_id) REFERENCES gov_authorities(id) ON DELETE CASCADE
    )");

    // 8. gov_departments
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_departments (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        authority_id INT NOT NULL,
        ministry_id INT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE,
        FOREIGN KEY (authority_id) REFERENCES gov_authorities(id) ON DELETE CASCADE,
        FOREIGN KEY (ministry_id) REFERENCES gov_ministries(id) ON DELETE SET NULL
    )");

    // 9. gov_directorates
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_directorates (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        authority_id INT NOT NULL,
        department_id INT NULL,
        ministry_id INT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE,
        FOREIGN KEY (authority_id) REFERENCES gov_authorities(id) ON DELETE CASCADE,
        FOREIGN KEY (department_id) REFERENCES gov_departments(id) ON DELETE SET NULL,
        FOREIGN KEY (ministry_id) REFERENCES gov_ministries(id) ON DELETE SET NULL
    )");

    // 10. gov_offices
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_offices (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        authority_id INT NOT NULL,
        directorate_id INT NULL,
        department_id INT NULL,
        ministry_id INT NULL,
        province_id INT NULL,
        district_id INT NULL,
        local_body_id INT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE,
        FOREIGN KEY (authority_id) REFERENCES gov_authorities(id) ON DELETE CASCADE,
        FOREIGN KEY (directorate_id) REFERENCES gov_directorates(id) ON DELETE SET NULL,
        FOREIGN KEY (department_id) REFERENCES gov_departments(id) ON DELETE SET NULL,
        FOREIGN KEY (ministry_id) REFERENCES gov_ministries(id) ON DELETE SET NULL,
        FOREIGN KEY (province_id) REFERENCES gov_provinces(id) ON DELETE SET NULL,
        FOREIGN KEY (district_id) REFERENCES gov_districts(id) ON DELETE SET NULL,
        FOREIGN KEY (local_body_id) REFERENCES gov_local_bodies(id) ON DELETE SET NULL
    )");

    // 11. gov_other_orgs
    $pdo->exec("CREATE TABLE IF NOT EXISTS gov_other_orgs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        tier_id INT NOT NULL,
        authority_id INT NOT NULL,
        type_id INT NULL,
        parent_org_type ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL,
        parent_org_id INT NULL,
        name_en VARCHAR(255) NOT NULL,
        name_np VARCHAR(255) NOT NULL,
        status ENUM('Active', 'Inactive') DEFAULT 'Active',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (tier_id) REFERENCES gov_tiers(id) ON DELETE CASCADE,
        FOREIGN KEY (authority_id) REFERENCES gov_authorities(id) ON DELETE CASCADE,
        FOREIGN KEY (type_id) REFERENCES gov_org_types(id) ON DELETE SET NULL
    )");

    // Update profiles table
    $cols = $pdo->query("SHOW COLUMNS FROM profiles LIKE 'registration_org_id'")->fetchAll();
    if (empty($cols)) {
        $pdo->exec("ALTER TABLE profiles 
                    ADD COLUMN registration_org_id INT NULL AFTER registrationAuthority,
                    ADD COLUMN registration_org_type ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL AFTER registration_org_id");
        echo "Added registration_org_id and registration_org_type to profiles.\n";
    } else {
        $cols = $pdo->query("SHOW COLUMNS FROM profiles LIKE 'registration_org_type'")->fetchAll();
        if (empty($cols)) {
            $pdo->exec("ALTER TABLE profiles ADD COLUMN registration_org_type ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL AFTER registration_org_id");
            echo "Added registration_org_type to profiles.\n";
        }
    }

    // Update drawer_details table
    $cols = $pdo->query("SHOW COLUMNS FROM drawer_details LIKE 'registration_org_id'")->fetchAll();
    if (empty($cols)) {
        $pdo->exec("ALTER TABLE drawer_details 
                    ADD COLUMN registration_org_id INT NULL AFTER registrationAuthority,
                    ADD COLUMN registration_org_type ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL AFTER registration_org_id");
        echo "Added registration_org_id and registration_org_type to drawer_details.\n";
    } else {
        $cols = $pdo->query("SHOW COLUMNS FROM drawer_details LIKE 'registration_org_type'")->fetchAll();
        if (empty($cols)) {
            $pdo->exec("ALTER TABLE drawer_details ADD COLUMN registration_org_type ENUM('Ministry', 'Department', 'Directorate', 'Office', 'Other') NULL AFTER registration_org_id");
            echo "Added registration_org_type to drawer_details.\n";
        }
    }

    echo "Database migration completed successfully!\n";

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
