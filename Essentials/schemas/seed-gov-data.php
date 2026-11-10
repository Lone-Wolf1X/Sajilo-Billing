<?php
$host = '127.0.0.1';
$user = 'root';
$pass = '';
$db   = 'cheque_blacklist_db';

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db;charset=utf8mb4", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "Seeding Government Hierarchy Data...\n";

    // Disable foreign key checks for truncation
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 0");

    // Truncate tables
    $pdo->exec("TRUNCATE TABLE gov_tiers");
    $pdo->exec("TRUNCATE TABLE gov_authorities");
    $pdo->exec("TRUNCATE TABLE gov_provinces");
    $pdo->exec("TRUNCATE TABLE gov_districts");
    $pdo->exec("TRUNCATE TABLE gov_local_bodies");
    $pdo->exec("TRUNCATE TABLE gov_org_types");
    $pdo->exec("TRUNCATE TABLE gov_offices");
    $pdo->exec("TRUNCATE TABLE gov_directorates");
    $pdo->exec("TRUNCATE TABLE gov_departments");
    $pdo->exec("TRUNCATE TABLE gov_ministries");
    $pdo->exec("TRUNCATE TABLE gov_other_orgs");

    // Re-enable foreign key checks
    $pdo->exec("SET FOREIGN_KEY_CHECKS = 1");

    // 1. Tiers
    $tiers = [
        ['Federal', 'संघीय'],
        ['Provincial', 'प्रदेश'],
        ['Local', 'स्थानीय']
    ];
    $stmt = $pdo->prepare("INSERT INTO gov_tiers (name_en, name_np) VALUES (?, ?)");
    foreach ($tiers as $t) {
        $stmt->execute($t);
    }
    $tierFed = 1;
    $tierProv = 2;
    $tierLoc = 3;

    // 2. Authorities
    $auths = [
        [$tierFed, 'Nepal Government', 'नेपाल सरकार'],
        [$tierProv, 'Provincial Government', 'प्रदेश सरकार'],
        [$tierLoc, 'Local Government', 'स्थानीय सरकार']
    ];
    $stmt = $pdo->prepare("INSERT INTO gov_authorities (tier_id, name_en, name_np) VALUES (?, ?, ?)");
    foreach ($auths as $a) {
        $stmt->execute($a);
    }
    $authFed = 1;

    // 3. Provinces
    $provinces = [
        ['Koshi Province', 'कोशी प्रदेश'],
        ['Madhesh Province', 'मधेश प्रदेश'],
        ['Bagmati Province', 'बागमती प्रदेश'],
        ['Gandaki Province', 'गण्डकी प्रदेश'],
        ['Lumbini Province', 'लुम्बिनी प्रदेश'],
        ['Karnali Province', 'कर्णाली प्रदेश'],
        ['Sudurpashchim Province', 'सुदूरपश्चिम प्रदेश']
    ];
    $stmt = $pdo->prepare("INSERT INTO gov_provinces (name_en, name_np) VALUES (?, ?)");
    foreach ($provinces as $p) {
        $stmt->execute($p);
    }

    // 3.1 All 77 Districts
    $districts = [
        [1, "Bhojpur", "भोजपुर"], [1, "Dhankuta", "धनकुटा"], [1, "Ilam", "इलाम"], [1, "Jhapa", "झापा"],
        [1, "Khotang", "खोटाङ"], [1, "Morang", "मोरङ"], [1, "Okhaldhunga", "ओखलढुङ्गा"], [1, "Panchthar", "पाँचथर"],
        [1, "Sankhuwasabha", "सङ्खुवासभा"], [1, "Solukhumbu", "सोलुखुम्बु"], [1, "Sunsari", "सुनसरी"], [1, "Taplejung", "ताप्लेजुङ"],
        [1, "Terhathum", "तेह्रथुम"], [1, "Udayapur", "उदयपुर"],
        [2, "Bara", "बारा"], [2, "Dhanusha", "धनुषा"], [2, "Mahottari", "महोत्तरी"], [2, "Parsa", "पर्सा"],
        [2, "Rautahat", "रौतहट"], [2, "Saptari", "सप्तरी"], [2, "Sarlahi", "सर्लाही"], [2, "Siraha", "सिराहा"],
        [3, "Bhaktapur", "भक्तपुर"], [3, "Chitwan", "चितवन"], [3, "Dhading", "धादिङ"], [3, "Dolakha", "दोलखा"],
        [3, "Kathmandu", "काठमाडौँ"], [3, "Kavrepalanchok", "काभ्रेपलाञ्चोक"], [3, "Lalitpur", "ललितपुर"], [3, "Makwanpur", "मकवानपुर"],
        [3, "Nuwakot", "नुवाकोट"], [3, "Ramechhap", "रामेछाप"], [3, "Rasuwa", "रसुवा"], [3, "Sindhuli", "सिन्धुली"], [3, "Sindhupalchok", "सिन्धुपाल्चोक"],
        [4, "Baglung", "बागलुङ"], [4, "Gorkha", "गोरखा"], [4, "Kaski", "कास्की"], [4, "Lamjung", "लमजुङ"],
        [4, "Manang", "मनाङ"], [4, "Mustang", "मुस्ताङ"], [4, "Myagdi", "म्याग्दी"], [4, "Nawalpur", "नवलपुर"],
        [4, "Parbat", "पर्वत"], [4, "Syangja", "स्याङ्जा"], [4, "Tanahun", "तनहुँ"],
        [5, "Arghakhanchi", "अर्घाखाँची"], [5, "Banke", "बाँके"], [5, "Bardiya", "बर्दिया"], [5, "Dang", "दाङ"],
        [5, "Gulmi", "गुल्मी"], [5, "Kapilvastu", "कपिलवस्तु"], [5, "Palpa", "पाल्पा"], [5, "Parasi", "परासी"],
        [5, "Pyuthan", "प्युठान"], [5, "Rolpa", "रोल्पा"], [5, "Rukum East", "पूर्वी रुकुम"], [5, "Rupandehi", "रुपन्देही"],
        [6, "Dailekh", "दैलेख"], [6, "Dolpa", "डोल्पा"], [6, "Humla", "हुम्ला"], [6, "Jajarkot", "जाजरकोट"],
        [6, "Jumla", "जुम्ला"], [6, "Kalikot", "कालिकोट"], [6, "Mugu", "मुगु"], [6, "Rukum West", "पश्चिम रुकुम"],
        [6, "Salyan", "सल्यान"], [6, "Surkhet", "सुर्खेत"],
        [7, "Achham", "अछाम"], [7, "Baitadi", "बैतडी"], [7, "Bajhang", "बझाङ"], [7, "Bajura", "बाजुरा"],
        [7, "Dadeldhura", "डडेलधुरा"], [7, "Darchula", "दार्चुला"], [7, "Doti", "डोटी"], [7, "Kailali", "कैलाली"], [7, "Kanchanpur", "कञ्चनपुर"]
    ];
    $stmtDist = $pdo->prepare("INSERT INTO gov_districts (province_id, name_en, name_np, status) VALUES (?, ?, ?, 'Active')");
    foreach ($districts as $d) {
        $stmtDist->execute($d);
    }

    // 4. Org Types
    $orgTypes = [
        ['Ministry', 'मन्त्रालय'],
        ['Department', 'विभाग'],
        ['Directorate', 'निर्देशनालय'],
        ['Office', 'कार्यालय'],
        ['Authority', 'प्राधिकरण'],
        ['Board', 'बोर्ड'],
        ['Commission', 'आयोग'],
        ['Council', 'परिषद्'],
        ['Corporation', 'संस्थान / निगम'],
        ['Secretariat', 'सचिवालय'],
        ['Centre', 'केन्द्र'],
        ['Fund', 'कोष'],
        ['Academy', 'प्रतिष्ठान / अकादमी'],
        ['Committee', 'समिति'],
        ['Other', 'अन्य']
    ];
    $stmt = $pdo->prepare("INSERT INTO gov_org_types (name_en, name_np) VALUES (?, ?)");
    foreach ($orgTypes as $ot) {
        $stmt->execute($ot);
    }
    
    // Fetch org type IDs
    $types = [];
    $stmt = $pdo->query("SELECT id, name_en FROM gov_org_types");
    while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
        $types[$row['name_en']] = $row['id'];
    }

    // 5. Federal Ministries (Updated to 18)
    $ministries = [
        ['Office of the Prime Minister and Council of Ministers', 'प्रधानमन्त्री तथा मन्त्रिपरिषद्को कार्यालय'],
        ['Ministry of Finance', 'अर्थ मन्त्रालय'],
        ['Ministry of Industry, Commerce and Supplies', 'उद्योग, वाणिज्य तथा आपूर्ति मन्त्रालय'],
        ['Ministry of Energy, Water Resources and Irrigation', 'ऊर्जा, जलस्रोत तथा सिँचाइ मन्त्रालय'],
        ['Ministry of Law, Justice and Parliamentary Affairs', 'कानून, न्याय तथा संसदीय मामिला मन्त्रालय'],
        ['Ministry of Agriculture, Forestry and Environment', 'कृषि, वन तथा पर्यावरण मन्त्रालय'],
        ['Ministry of Home Affairs', 'गृह मन्त्रालय'],
        ['Ministry of Foreign Affairs', 'परराष्ट्र मन्त्रालय'],
        ['Ministry of Infrastructure Development', 'पूर्वाधार विकास मन्त्रालय'],
        ['Ministry of Land, Cooperatives, Federal Affairs and General Administration', 'भूमि, सहकारी, सङ्घीय मामिला तथा सामान्य प्रशासन मन्त्रालय'],
        ['Ministry of Women, Children, Gender and Sexual Minorities and Social Security', 'महिला, बालबालिका, लैङ्गिक तथा यौनिक अल्पसंख्यक र सामाजिक सुरक्षा मन्त्रालय'],
        ['Ministry of Youth, Labour and Employment', 'युवा, श्रम तथा रोजगार मन्त्रालय'],
        ['Ministry of Defence', 'रक्षा मन्त्रालय'],
        ['Ministry of Science, Technology and Innovation', 'विज्ञान, प्रविधि तथा नवप्रवर्तन'],
        ['Ministry of Education and Sports', 'शिक्षा तथा खेलकुद मन्त्रालय'],
        ['Ministry of Information and Communication', 'सूचना तथा सञ्चार मन्त्रालय'],
        ['Ministry of Culture, Tourism and Civil Aviation', 'संस्कृति, पर्यटन तथा नागरिक उड्डयन मन्त्रालय'],
        ['Ministry of Health and Food Security', 'स्वास्थ्य तथा खाद्य सुरक्षा मन्त्रालय']
    ];

    $stmt = $pdo->prepare("INSERT INTO gov_ministries (tier_id, authority_id, name_en, name_np) VALUES (?, ?, ?, ?)");
    $minIds = [];
    foreach ($ministries as $m) {
        $stmt->execute([$tierFed, $authFed, $m[0], $m[1]]);
        $minIds[$m[0]] = $pdo->lastInsertId();
    }

    // 6. Federal Departments (Attached to corresponding ministries as best effort based on standard structure)
    $departments = [
        ['Department of Customs', 'भन्सार विभाग', 'Ministry of Finance'],
        ['Inland Revenue Department', 'आन्तरिक राजस्व विभाग', 'Ministry of Finance'],
        ['Department of Revenue Investigation', 'राजस्व अनुसन्धान विभाग', 'Office of the Prime Minister and Council of Ministers'],
        ['Department of Immigration', 'अध्यागमन विभाग', 'Ministry of Home Affairs'],
        ['Department of National ID and Civil Registration', 'राष्ट्रिय परिचयपत्र तथा पञ्जीकरण विभाग', 'Ministry of Home Affairs'],
        ['Department of Prison Management', 'कारागार व्यवस्थापन विभाग', 'Ministry of Home Affairs'],
        ['Department of Passports', 'राहदानी विभाग', 'Ministry of Foreign Affairs'],
        ['Department of Industry', 'उद्योग विभाग', 'Ministry of Industry, Commerce and Supplies'],
        ['Department of Commerce, Supplies and Consumer Protection', 'वाणिज्य, आपूर्ति तथा उपभोक्ता संरक्षण विभाग', 'Ministry of Industry, Commerce and Supplies'],
        ['Department of Agriculture', 'कृषि विभाग', 'Ministry of Agriculture, Forestry and Environment'],
        ['Department of Livestock Services', 'पशु सेवा विभाग', 'Ministry of Agriculture, Forestry and Environment'],
        ['Department of Food Technology and Quality Control', 'खाद्य प्रविधि तथा गुण नियन्त्रण विभाग', 'Ministry of Health and Food Security'],
        ['Department of Health Services', 'स्वास्थ्य सेवा विभाग', 'Ministry of Health and Food Security'],
        ['Department of Drug Administration', 'औषधि व्यवस्था विभाग', 'Ministry of Health and Food Security'],
        ['Department of Tourism', 'पर्यटन विभाग', 'Ministry of Culture, Tourism and Civil Aviation'],
        ['Department of Archaeology', 'पुरातत्त्व विभाग', 'Ministry of Culture, Tourism and Civil Aviation']
    ];

    $stmt = $pdo->prepare("INSERT INTO gov_departments (tier_id, authority_id, ministry_id, name_en, name_np) VALUES (?, ?, ?, ?, ?)");
    $deptIds = [];
    foreach ($departments as $d) {
        $parentId = isset($minIds[$d[2]]) ? $minIds[$d[2]] : null;
        $stmt->execute([$tierFed, $authFed, $parentId, $d[0], $d[1]]);
        $deptIds[$d[0]] = $pdo->lastInsertId();
    }

    // 7. Authority 4: Autonomous Bodies / Other
    $stmtAuth = $pdo->prepare("INSERT INTO gov_authorities (id, tier_id, name_en, name_np) VALUES (4, ?, ?, ?)");
    $stmtAuth->execute([$tierFed, 'Autonomous Bodies / Other', 'स्वायत्त / अन्य निकाय']);
    $authAuto = 4;

    // 8. Offices
    $offices = [
        ['Office of Company Registrar', 'कम्पनी रजिष्ट्रारको कार्यालय', 'Department of Industry'],
        ['Inland Revenue Office (Kathmandu Sector-1)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. १)', 'Inland Revenue Department'],
        ['Inland Revenue Office (Kathmandu Sector-2)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. २)', 'Inland Revenue Department'],
        ['Inland Revenue Office (Kathmandu Sector-3)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. ३)', 'Inland Revenue Department'],
        ['Inland Revenue Office (Lalitpur)', 'आन्तरिक राजस्व कार्यालय (ललितपुर)', 'Inland Revenue Department'],
        ['Inland Revenue Office (Bhaktapur)', 'आन्तरिक राजस्व कार्यालय (भक्तपुर)', 'Inland Revenue Department'],
        ['Inland Revenue Office (Pokhara)', 'आन्तरिक राजस्व कार्यालय (पोखरा)', 'Inland Revenue Department'],
        ['Large Taxpayers Office', 'ठूला करदाता कार्यालय', 'Inland Revenue Department'],
        ['Medium Taxpayers Office', 'मध्यम करदाता कार्यालय', 'Inland Revenue Department'],
        ['Tribhuvan International Airport Customs Office', 'त्रिभुवन अन्तर्राष्ट्रिय विमानस्थल भन्सार कार्यालय', 'Department of Customs'],
        ['Birgunj Customs Office', 'वीरगञ्ज भन्सार कार्यालय', 'Department of Customs'],
        ['Bhairahawa Customs Office', 'भैरहवा भन्सार कार्यालय', 'Department of Customs'],
        ['Mechi Customs Office', 'मेची भन्सार कार्यालय', 'Department of Customs'],
        ['Biratnagar Customs Office', 'विराटनगर भन्सार कार्यालय', 'Department of Customs'],
        ['Dry Port Customs Office (Sirsiya)', 'सुक्खा बन्दरगाह भन्सार कार्यालय (सिर्सिया)', 'Department of Customs'],
        ['Department of Passports Counter Office', 'राहदानी विभाग शाखा कार्यालय', 'Department of Passports'],
        ['Immigration Office (TIA)', 'अध्यागमन कार्यालय (त्रि.अ.वि.)', 'Department of Immigration'],
        ['Cottage and Small Industry Office (Kathmandu)', 'घरेलु तथा साना उद्योग कार्यालय (काठमाडौँ)', 'Department of Industry'],
        ['Cottage and Small Industry Office (Lalitpur)', 'घरेलु तथा साना उद्योग कार्यालय (ललितपुर)', 'Department of Industry']
    ];

    $stmtOffice = $pdo->prepare("INSERT INTO gov_offices (tier_id, authority_id, department_id, name_en, name_np) VALUES (?, ?, ?, ?, ?)");
    foreach ($offices as $o) {
        $depId = $deptIds[$o[2]] ?? null;
        $stmtOffice->execute([$tierFed, $authFed, $depId, $o[0], $o[1]]);
    }

    // 9. Autonomous / Other Organizations
    $otherOrgs = [
        [$authAuto, $types['Authority'] ?? 5, 'Nepal Rastra Bank (Central Bank)', 'नेपाल राष्ट्र बैंक'],
        [$authAuto, $types['Board'] ?? 6, 'Securities Board of Nepal (SEBON)', 'नेपाल धितोपत्र बोर्ड'],
        [$authAuto, $types['Authority'] ?? 5, 'Nepal Insurance Authority (NIA)', 'नेपाल बीमा प्राधिकरण'],
        [$authAuto, $types['Fund'] ?? 12, 'Social Security Fund (SSF)', 'सामाजिक सुरक्षा कोष'],
        [$authAuto, $types['Fund'] ?? 12, 'Employees Provident Fund (EPF)', 'कर्मचारी सञ्चय कोष'],
        [$authAuto, $types['Fund'] ?? 12, 'Citizen Investment Trust (CIT)', 'नागरिक लगानी कोष'],
        [$authAuto, $types['Corporation'] ?? 9, 'Credit Information Bureau of Nepal (CIB)', 'कर्जा सूचना केन्द्र (सी.आई.बी.)'],
        [$authAuto, $types['Authority'] ?? 5, 'Nepal Telecommunications Authority (NTA)', 'नेपाल दूरसञ्चार प्राधिकरण'],
        [$authAuto, $types['Authority'] ?? 5, 'Nepal Electricity Authority (NEA)', 'नेपाल विद्युत प्राधिकरण'],
        [$authAuto, $types['Corporation'] ?? 9, 'Nepal Oil Corporation (NOC)', 'नेपाल आयल निगम'],
        [$authAuto, $types['Authority'] ?? 5, 'Civil Aviation Authority of Nepal (CAAN)', 'नेपाल नागरिक उड्डयन प्राधिकरण'],
        [$authAuto, $types['Commission'] ?? 7, 'Election Commission of Nepal', 'निर्वाचन आयोग'],
        [$authAuto, $types['Commission'] ?? 7, 'Commission for the Investigation of Abuse of Authority (CIAA)', 'अख्तियार दुरुपयोग अनुसन्धान आयोग'],
        [$authAuto, $types['Commission'] ?? 7, 'Public Service Commission (PSC)', 'लोक सेवा आयोग']
    ];

    $stmtOther = $pdo->prepare("INSERT INTO gov_other_orgs (tier_id, authority_id, type_id, name_en, name_np) VALUES (?, ?, ?, ?, ?)");
    foreach ($otherOrgs as $org) {
        $stmtOther->execute([$tierFed, $org[0], $org[1], $org[2], $org[3]]);
    }

    echo "Data seeded successfully!\n";

} catch (PDOException $e) {
    echo "Error: " . $e->getMessage() . "\n";
}
?>
