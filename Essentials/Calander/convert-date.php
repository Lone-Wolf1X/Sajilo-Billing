<?php
require_once __DIR__ . '/../../widgets/bs_date.php';

header('Content-Type: application/json');

if (isset($_GET['ad'])) {
    $bs = adToBs($_GET['ad']);
    $bsStr = sprintf('%04d-%02d-%02d', $bs['year'], $bs['month'], $bs['day']);
    echo json_encode(['ad' => $_GET['ad'], 'bs' => $bsStr]);
    exit;
}

if (isset($_GET['bs'])) {
    $parts = explode('-', $_GET['bs']);
    if (count($parts) === 3) {
        $ad = bsToAd((int)$parts[0], (int)$parts[1], (int)$parts[2]);
        echo json_encode(['bs' => $_GET['bs'], 'ad' => $ad]);
        exit;
    }
}

echo json_encode(['error' => 'Invalid parameters']);
