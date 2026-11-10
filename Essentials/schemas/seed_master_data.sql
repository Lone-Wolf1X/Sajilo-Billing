-- ==============================================================================
-- Banking Enterprise & Blacklisting Seed Data
-- ==============================================================================

USE `cheque_blacklist_db`;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. Default Branches
INSERT INTO `branches` (`id`, `branch_name_en`, `branch_name_np`, `branch_address_en`, `branch_address_np`) VALUES
(1, 'Kathmandu Main Branch', 'काठमाडौँ मुख्य शाखा', 'Durbar Marg, Kathmandu', 'दरबार मार्ग, काठमाडौँ'),
(2, 'Pokhara Branch', 'पोखरा शाखा', 'New Road, Pokhara', 'न्यू रोड, पोखरा'),
(3, 'Lalitpur Branch', 'ललितपुर शाखा', 'Patan Dhoka, Lalitpur', 'पाटन ढोका, ललितपुर')
ON DUPLICATE KEY UPDATE `branch_name_en` = VALUES(`branch_name_en`);

-- 2. Default Users (Password: password123)
-- Hash generated via password_hash('password123', PASSWORD_DEFAULT)
INSERT INTO `users` (`id`, `username`, `password_hash`, `role`, `branch_id`, `province`) VALUES
(1, 'maker1', '$2y$10$w3p1QZ2eF59xG.c1uCj7f.6kY4K0y41o2VjH9lCq2Uq2Q0j8e7wQe', 'Maker', 1, 'Bagmati Province'),
(2, 'checker1', '$2y$10$w3p1QZ2eF59xG.c1uCj7f.6kY4K0y41o2VjH9lCq2Uq2Q0j8e7wQe', 'Checker', 1, 'Bagmati Province'),
(3, 'reviewer1', '$2y$10$w3p1QZ2eF59xG.c1uCj7f.6kY4K0y41o2VjH9lCq2Uq2Q0j8e7wQe', 'Reviewer', 1, 'Bagmati Province'),
(4, 'approver1', '$2y$10$w3p1QZ2eF59xG.c1uCj7f.6kY4K0y41o2VjH9lCq2Uq2Q0j8e7wQe', 'Approver', 1, 'Bagmati Province'),
(5, 'admin1', '$2y$10$w3p1QZ2eF59xG.c1uCj7f.6kY4K0y41o2VjH9lCq2Uq2Q0j8e7wQe', 'Admin', 1, 'Bagmati Province')
ON DUPLICATE KEY UPDATE `role` = VALUES(`role`);

-- 3. System Settings (Weekend Saturday & Sunday)
INSERT INTO `system_settings` (`setting_key`, `setting_value`) VALUES
('weekend_days', '["Saturday", "Sunday"]')
ON DUPLICATE KEY UPDATE `setting_value` = VALUES(`setting_value`);

-- 4. Government Tiers
INSERT INTO `gov_tiers` (`id`, `name_en`, `name_np`) VALUES
(1, 'Federal', 'संघीय'),
(2, 'Provincial', 'प्रदेश'),
(3, 'Local', 'स्थानीय')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 5. Government Authorities
INSERT INTO `gov_authorities` (`id`, `tier_id`, `name_en`, `name_np`) VALUES
(1, 1, 'Nepal Government', 'नेपाल सरकार'),
(2, 2, 'Provincial Government', 'प्रदेश सरकार'),
(3, 3, 'Local Government', 'स्थानीय सरकार'),
(4, 1, 'Autonomous Bodies / Other', 'स्वायत्त / अन्य निकाय')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 6. Provinces of Nepal
INSERT INTO `gov_provinces` (`id`, `name_en`, `name_np`) VALUES
(1, 'Koshi Province', 'कोशी प्रदेश'),
(2, 'Madhesh Province', 'मधेश प्रदेश'),
(3, 'Bagmati Province', 'बागमती प्रदेश'),
(4, 'Gandaki Province', 'गण्डकी प्रदेश'),
(5, 'Lumbini Province', 'लुम्बिनी प्रदेश'),
(6, 'Karnali Province', 'कर्णाली प्रदेश'),
(7, 'Sudurpashchim Province', 'सुदूरपश्चिम प्रदेश')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 7. All 77 Districts
INSERT INTO `gov_districts` (`id`, `province_id`, `name_en`, `name_np`, `status`) VALUES
(1, 1, 'Bhojpur', 'भोजपुर', 'Active'), (2, 1, 'Dhankuta', 'धनकुटा', 'Active'), (3, 1, 'Ilam', 'इलाम', 'Active'),
(4, 1, 'Jhapa', 'झापा', 'Active'), (5, 1, 'Khotang', 'खोटाङ', 'Active'), (6, 1, 'Morang', 'मोरङ', 'Active'),
(7, 1, 'Okhaldhunga', 'ओखलढुङ्गा', 'Active'), (8, 1, 'Panchthar', 'पाँचथर', 'Active'), (9, 1, 'Sankhuwasabha', 'सङ्खुवासभा', 'Active'),
(10, 1, 'Solukhumbu', 'सोलुखुम्बु', 'Active'), (11, 1, 'Sunsari', 'सुनसरी', 'Active'), (12, 1, 'Taplejung', 'ताप्लेजुङ', 'Active'),
(13, 1, 'Terhathum', 'तेह्रथुम', 'Active'), (14, 1, 'Udayapur', 'उदयपुर', 'Active'),
(15, 2, 'Bara', 'बारा', 'Active'), (16, 2, 'Dhanusha', 'धनुषा', 'Active'), (17, 2, 'Mahottari', 'महोत्तरी', 'Active'),
(18, 2, 'Parsa', 'पर्सा', 'Active'), (19, 2, 'Rautahat', 'रौतहट', 'Active'), (20, 2, 'Saptari', 'सप्तरी', 'Active'),
(21, 2, 'Sarlahi', 'सर्लाही', 'Active'), (22, 2, 'Siraha', 'सिराहा', 'Active'),
(23, 3, 'Bhaktapur', 'भक्तपुर', 'Active'), (24, 3, 'Chitwan', 'चितवन', 'Active'), (25, 3, 'Dhading', 'धादिङ', 'Active'),
(26, 3, 'Dolakha', 'दोलखा', 'Active'), (27, 3, 'Kathmandu', 'काठमाडौँ', 'Active'), (28, 3, 'Kavrepalanchok', 'काभ्रेपलाञ्चोक', 'Active'),
(29, 3, 'Lalitpur', 'ललितपुर', 'Active'), (30, 3, 'Makwanpur', 'मकवानपुर', 'Active'), (31, 3, 'Nuwakot', 'नुवाकोट', 'Active'),
(32, 3, 'Ramechhap', 'रामेछाप', 'Active'), (33, 3, 'Rasuwa', 'रसुवा', 'Active'), (34, 3, 'Sindhuli', 'सिन्धुली', 'Active'),
(35, 3, 'Sindhupalchok', 'सिन्धुपाल्चोक', 'Active'),
(36, 4, 'Baglung', 'बागलुङ', 'Active'), (37, 4, 'Gorkha', 'गोरखा', 'Active'), (38, 4, 'Kaski', 'कास्की', 'Active'),
(39, 4, 'Lamjung', 'लमजुङ', 'Active'), (40, 4, 'Manang', 'मनाङ', 'Active'), (41, 4, 'Mustang', 'मुस्ताङ', 'Active'),
(42, 4, 'Myagdi', 'म्याग्दी', 'Active'), (43, 4, 'Nawalpur', 'नवलपुर', 'Active'), (44, 4, 'Parbat', 'पर्वत', 'Active'),
(45, 4, 'Syangja', 'स्याङ्जा', 'Active'), (46, 4, 'Tanahun', 'तनहुँ', 'Active'),
(47, 5, 'Arghakhanchi', 'अर्घाखाँची', 'Active'), (48, 5, 'Banke', 'बाँके', 'Active'), (49, 5, 'Bardiya', 'बर्दिया', 'Active'),
(50, 5, 'Dang', 'दाङ', 'Active'), (51, 5, 'Gulmi', 'गुल्मी', 'Active'), (52, 5, 'Kapilvastu', 'कपिलवस्तु', 'Active'),
(53, 5, 'Palpa', 'पाल्पा', 'Active'), (54, 5, 'Parasi', 'परासी', 'Active'), (55, 5, 'Pyuthan', 'प्युठान', 'Active'),
(56, 5, 'Rolpa', 'रोल्पा', 'Active'), (57, 5, 'Rukum East', 'पूर्वी रुकुम', 'Active'), (58, 5, 'Rupandehi', 'रुपन्देही', 'Active'),
(59, 6, 'Dailekh', 'दैलेख', 'Active'), (60, 6, 'Dolpa', 'डोल्पा', 'Active'), (61, 6, 'Humla', 'हुम्ला', 'Active'),
(62, 6, 'Jajarkot', 'जाजरकोट', 'Active'), (63, 6, 'Jumla', 'जुम्ला', 'Active'), (64, 6, 'Kalikot', 'कालिकोट', 'Active'),
(65, 6, 'Mugu', 'मुगु', 'Active'), (66, 6, 'Rukum West', 'पश्चिम रुकुम', 'Active'), (67, 6, 'Salyan', 'सल्यान', 'Active'),
(68, 6, 'Surkhet', 'सुर्खेत', 'Active'),
(69, 7, 'Achham', 'अछाम', 'Active'), (70, 7, 'Baitadi', 'बैतडी', 'Active'), (71, 7, 'Bajhang', 'बझाङ', 'Active'),
(72, 7, 'Bajura', 'बाजुरा', 'Active'), (73, 7, 'Dadeldhura', 'डडेलधुरा', 'Active'), (74, 7, 'Darchula', 'दार्चुला', 'Active'),
(75, 7, 'Doti', 'डोटी', 'Active'), (76, 7, 'Kailali', 'कैलाली', 'Active'), (77, 7, 'Kanchanpur', 'कञ्चनपुर', 'Active')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 8. Organization Types
INSERT INTO `gov_org_types` (`id`, `name_en`, `name_np`) VALUES
(1, 'Ministry', 'मन्त्रालय'),
(2, 'Department', 'विभाग'),
(3, 'Directorate', 'निर्देशनालय'),
(4, 'Office', 'कार्यालय'),
(5, 'Authority', 'प्राधिकरण'),
(6, 'Board', 'बोर्ड'),
(7, 'Commission', 'आयोग'),
(8, 'Council', 'परिषद्'),
(9, 'Corporation', 'संस्थान / निगम'),
(10, 'Secretariat', 'सचिवालय'),
(11, 'Centre', 'केन्द्र'),
(12, 'Fund', 'कोष'),
(13, 'Academy', 'प्रतिष्ठान / अकादमी'),
(14, 'Committee', 'समिति'),
(15, 'Other', 'अन्य')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 9. Federal Ministries
INSERT INTO `gov_ministries` (`id`, `tier_id`, `authority_id`, `name_en`, `name_np`) VALUES
(1, 1, 1, 'Office of the Prime Minister and Council of Ministers', 'प्रधानमन्त्री तथा मन्त्रिपरिषद्को कार्यालय'),
(2, 1, 1, 'Ministry of Finance', 'अर्थ मन्त्रालय'),
(3, 1, 1, 'Ministry of Industry, Commerce and Supplies', 'उद्योग, वाणिज्य तथा आपूर्ति मन्त्रालय'),
(4, 1, 1, 'Ministry of Energy, Water Resources and Irrigation', 'ऊर्जा, जलस्रोत तथा सिँचाइ मन्त्रालय'),
(5, 1, 1, 'Ministry of Law, Justice and Parliamentary Affairs', 'कानून, न्याय तथा संसदीय मामिला मन्त्रालय'),
(6, 1, 1, 'Ministry of Agriculture, Forestry and Environment', 'कृषि, वन तथा पर्यावरण मन्त्रालय'),
(7, 1, 1, 'Ministry of Home Affairs', 'गृह मन्त्रालय'),
(8, 1, 1, 'Ministry of Foreign Affairs', 'परराष्ट्र मन्त्रालय'),
(9, 1, 1, 'Ministry of Infrastructure Development', 'पूर्वाधार विकास मन्त्रालय'),
(10, 1, 1, 'Ministry of Land, Cooperatives, Federal Affairs and General Administration', 'भूमि, सहकारी, सङ्घीय मामिला तथा सामान्य प्रशासन मन्त्रालय'),
(11, 1, 1, 'Ministry of Women, Children, Gender and Sexual Minorities and Social Security', 'महिला, बालबालिका, लैङ्गिक तथा यौनिक अल्पसंख्यक र सामाजिक सुरक्षा मन्त्रालय'),
(12, 1, 1, 'Ministry of Youth, Labour and Employment', 'युवा, श्रम तथा रोजगार मन्त्रालय'),
(13, 1, 1, 'Ministry of Defence', 'रक्षा मन्त्रालय'),
(14, 1, 1, 'Ministry of Science, Technology and Innovation', 'विज्ञान, प्रविधि तथा नवप्रवर्तन'),
(15, 1, 1, 'Ministry of Education and Sports', 'शिक्षा तथा खेलकुद मन्त्रालय'),
(16, 1, 1, 'Ministry of Information and Communication', 'सूचना तथा सञ्चार मन्त्रालय'),
(17, 1, 1, 'Ministry of Culture, Tourism and Civil Aviation', 'संस्कृति, पर्यटन तथा नागरिक उड्डयन मन्त्रालय'),
(18, 1, 1, 'Ministry of Health and Food Security', 'स्वास्थ्य तथा खाद्य सुरक्षा मन्त्रालय')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 10. Major Federal Departments
INSERT INTO `gov_departments` (`id`, `tier_id`, `authority_id`, `ministry_id`, `name_en`, `name_np`) VALUES
(1, 1, 1, 2, 'Department of Customs', 'भन्सार विभाग'),
(2, 1, 1, 2, 'Inland Revenue Department', 'आन्तरिक राजस्व विभाग'),
(3, 1, 1, 1, 'Department of Revenue Investigation', 'राजस्व अनुसन्धान विभाग'),
(4, 1, 1, 7, 'Department of Immigration', 'अध्यागमन विभाग'),
(5, 1, 1, 7, 'Department of National ID and Civil Registration', 'राष्ट्रिय परिचयपत्र तथा पञ्जीकरण विभाग'),
(6, 1, 1, 7, 'Department of Prison Management', 'कारागार व्यवस्थापन विभाग'),
(7, 1, 1, 8, 'Department of Passports', 'राहदानी विभाग'),
(8, 1, 1, 3, 'Department of Industry', 'उद्योग विभाग'),
(9, 1, 1, 3, 'Department of Commerce, Supplies and Consumer Protection', 'वाणिज्य, आपूर्ति तथा उपभोक्ता संरक्षण विभाग'),
(10, 1, 1, 6, 'Department of Agriculture', 'कृषि विभाग'),
(11, 1, 1, 6, 'Department of Livestock Services', 'पशु सेवा विभाग'),
(12, 1, 1, 18, 'Department of Food Technology and Quality Control', 'खाद्य प्रविधि तथा गुण नियन्त्रण विभाग'),
(13, 1, 1, 18, 'Department of Health Services', 'स्वास्थ्य सेवा विभाग'),
(14, 1, 1, 18, 'Department of Drug Administration', 'औषधि व्यवस्था विभाग'),
(15, 1, 1, 17, 'Department of Tourism', 'पर्यटन विभाग'),
(16, 1, 1, 17, 'Department of Archaeology', 'पुरातत्त्व विभाग')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 11. Major Registration & Revenue Offices
INSERT INTO `gov_offices` (`id`, `tier_id`, `authority_id`, `department_id`, `name_en`, `name_np`) VALUES
(1, 1, 1, 8, 'Office of Company Registrar', 'कम्पनी रजिष्ट्रारको कार्यालय'),
(2, 1, 1, 2, 'Inland Revenue Office (Kathmandu Sector-1)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. १)'),
(3, 1, 1, 2, 'Inland Revenue Office (Kathmandu Sector-2)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. २)'),
(4, 1, 1, 2, 'Inland Revenue Office (Kathmandu Sector-3)', 'आन्तरिक राजस्व कार्यालय (काठमाडौँ क्षेत्र नं. ३)'),
(5, 1, 1, 2, 'Inland Revenue Office (Lalitpur)', 'आन्तरिक राजस्व कार्यालय (ललितपुर)'),
(6, 1, 1, 2, 'Inland Revenue Office (Bhaktapur)', 'आन्तरिक राजस्व कार्यालय (भक्तपुर)'),
(7, 1, 1, 2, 'Inland Revenue Office (Pokhara)', 'आन्तरिक राजस्व कार्यालय (पोखरा)'),
(8, 1, 1, 2, 'Large Taxpayers Office', 'ठूला करदाता कार्यालय'),
(9, 1, 1, 2, 'Medium Taxpayers Office', 'मध्यम करदाता कार्यालय'),
(10, 1, 1, 1, 'Tribhuvan International Airport Customs Office', 'त्रिभुवन अन्तर्राष्ट्रिय विमानस्थल भन्सार कार्यालय'),
(11, 1, 1, 1, 'Birgunj Customs Office', 'वीरगञ्ज भन्सार कार्यालय'),
(12, 1, 1, 1, 'Bhairahawa Customs Office', 'भैरहवा भन्सार कार्यालय'),
(13, 1, 1, 1, 'Biratnagar Customs Office', 'विराटनगर भन्सार कार्यालय'),
(14, 1, 1, 7, 'Department of Passports Counter Office', 'राहदानी विभाग शाखा कार्यालय'),
(15, 1, 1, 4, 'Immigration Office (TIA)', 'अध्यागमन कार्यालय (त्रि.अ.वि.)'),
(16, 1, 1, 8, 'Cottage and Small Industry Office (Kathmandu)', 'घरेलु तथा साना उद्योग कार्यालय (काठमाडौँ)'),
(17, 1, 1, 8, 'Cottage and Small Industry Office (Lalitpur)', 'घरेलु तथा साना उद्योग कार्यालय (ललितपुर)')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

-- 12. Autonomous Regulatory & Financial Bodies
INSERT INTO `gov_other_orgs` (`id`, `tier_id`, `authority_id`, `type_id`, `name_en`, `name_np`) VALUES
(1, 1, 4, 5, 'Nepal Rastra Bank (Central Bank)', 'नेपाल राष्ट्र बैंक'),
(2, 1, 4, 6, 'Securities Board of Nepal (SEBON)', 'नेपाल धितोपत्र बोर्ड'),
(3, 1, 4, 5, 'Nepal Insurance Authority (NIA)', 'नेपाल बीमा प्राधिकरण'),
(4, 1, 4, 12, 'Social Security Fund (SSF)', 'सामाजिक सुरक्षा कोष'),
(5, 1, 4, 12, 'Employees Provident Fund (EPF)', 'कर्मचारी सञ्चय कोष'),
(6, 1, 4, 12, 'Citizen Investment Trust (CIT)', 'नागरिक लगानी कोष'),
(7, 1, 4, 9, 'Credit Information Bureau of Nepal (CIB)', 'कर्जा सूचना केन्द्र (सी.आई.बी.)'),
(8, 1, 4, 5, 'Nepal Telecommunications Authority (NTA)', 'नेपाल दूरसञ्चार प्राधिकरण'),
(9, 1, 4, 5, 'Nepal Electricity Authority (NEA)', 'नेपाल विद्युत प्राधिकरण'),
(10, 1, 4, 9, 'Nepal Oil Corporation (NOC)', 'नेपाल आयल निगम'),
(11, 1, 4, 5, 'Civil Aviation Authority of Nepal (CAAN)', 'नेपाल नागरिक उड्डयन प्राधिकरण'),
(12, 1, 4, 7, 'Election Commission of Nepal', 'निर्वाचन आयोग'),
(13, 1, 4, 7, 'Commission for the Investigation of Abuse of Authority (CIAA)', 'अख्तियार दुरुपयोग अनुसन्धान आयोग'),
(14, 1, 4, 7, 'Public Service Commission (PSC)', 'लोक सेवा आयोग')
ON DUPLICATE KEY UPDATE `name_en` = VALUES(`name_en`);

SET FOREIGN_KEY_CHECKS = 1;
