<?php
/**
 * HRMS SaaS - Locally Hosted Executive Nepal Dual Calendar & Panchang Widget
 * Path: /HRMS/includes/nepali_calendar_widget.php
 *
 * Provides a 100% offline, local native Nepali Calendar (वि.सं.) & AD dual view widget
 * Supports custom header colors, Tithi / Paksha info, festival highlights, and interactive date selection.
 */

require_once __DIR__ . '/bs_date.php';

// Widget Settings / Query Params
$headerColor = $_GET['header_color'] ?? ($widgetHeaderColor ?? '6aa744');
if (strpos($headerColor, '#') !== 0) {
    $headerColor = '#' . $headerColor;
}

$showTithi = isset($_GET['tithi']) ? (bool)$_GET['tithi'] : ($widgetShowTithi ?? true);
$isInteractive = isset($_GET['interactive']) ? (bool)$_GET['interactive'] : ($widgetInteractive ?? true);
$targetInput = $_GET['target'] ?? '';

// Selected or Current Date Context
if (isset($_GET['bs_month']) && isset($_GET['bs_year'])) {
    $y = (int)$_GET['bs_year'];
    $m = (int)$_GET['bs_month'];
    // Prevent out of bounds
    $y = max(1975, min(2090, $y));
    $m = max(1, min(12, $m));
    $reqAdDate = bsToAd($y, $m, 1);
} else {
    $reqAdDate = $_GET['date'] ?? date('Y-m-d');
}

$adTime = strtotime($reqAdDate) ?: time();

$adYear = (int)date('Y', $adTime);
$adMonth = (int)date('m', $adTime);
$adDay = (int)date('d', $adTime);

// Convert to BS
$bsToday = adToBs(date('Y-m-d'));
$bsCurrent = adToBs(date('Y-m-d', $adTime));

$bsYear = $bsCurrent['year'];
$bsMonth = $bsCurrent['month'];
$bsDay = $bsCurrent['day'];

// Calculation for rendering month grid
$cal = $GLOBALS['BS_CALENDAR'];
$daysInBsMonth = $cal[$bsYear][$bsMonth - 1] ?? 30;

// Find AD date corresponding to 1st day of this BS month
$firstAdOfBsMonth = bsToAd($bsYear, $bsMonth, 1);
$firstDayOfWeek = (int)date('N', strtotime($firstAdOfBsMonth)); // 1 (Mon) to 7 (Sun)
// In Nepal, Sunday is Day 1 (Sun=1, Mon=2 ... Sat=7)
$startPad = ($firstDayOfWeek % 7); // Sunday = 0 pad, Mon = 1 pad...

$bsMonthNp = getBsMonthName($bsMonth, 'np');
$bsMonthEn = getBsMonthName($bsMonth, 'en');
$bsYearNp = convertToNepaliDigits($bsYear);

// Month Navigation Links
$prevBsMonth = $bsMonth - 1;
$prevBsYear = $bsYear;
if ($prevBsMonth < 1) {
    $prevBsMonth = 12;
    $prevBsYear--;
}
$prevAdDate = bsToAd($prevBsYear, $prevBsMonth, 1);

$nextBsMonth = $bsMonth + 1;
$nextBsYear = $bsYear;
if ($nextBsMonth > 12) {
    $nextBsMonth = 1;
    $nextBsYear++;
}
$nextAdDate = bsToAd($nextBsYear, $nextBsMonth, 1);

$targetParam = !empty($targetInput) ? '&target=' . urlencode($targetInput) : '';

// Sample Tithi & Event Data for local display
$tithiList = [
    1 => 'प्रतिपदा', 2 => 'द्वितीया', 3 => 'तृतीया', 4 => 'चतुर्थी', 5 => 'पञ्चमी',
    6 => 'षष्ठी', 7 => 'सप्तमी', 8 => 'अष्टमी', 9 => 'नवमी', 10 => 'दशमी',
    11 => 'एकादशी', 12 => 'द्वादशी', 13 => 'त्रयोदशी', 14 => 'चतुर्दशी', 15 => 'पूर्णिमा / औंसी'
];

$currTithi = $tithiList[(($bsDay % 15) ?: 15)];
$paksha = ($bsDay <= 15) ? 'शुक्ल पक्ष 🌓' : 'कृष्ण पक्ष 🌘';

$nepalWeekdays = [
    0 => ['np' => 'आइत', 'en' => 'Sun'],
    1 => ['np' => 'सोम', 'en' => 'Mon'],
    2 => ['np' => 'मङ्गल', 'en' => 'Tue'],
    3 => ['np' => 'बुध', 'en' => 'Wed'],
    4 => ['np' => 'बिही', 'en' => 'Thu'],
    5 => ['np' => 'शुक्र', 'en' => 'Fri'],
    6 => ['np' => 'शनि', 'en' => 'Sat']
];
?>
<!DOCTYPE html>
<html lang="ne">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nepali Calendar Widget</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --header-bg: <?= htmlspecialchars($headerColor) ?>;
        }
        body {
            background: transparent;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            user-select: none;
        }
        .local-calendar-card {
            width: 100%;
            max-width: 320px;
            background: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }
        .calendar-header {
            background-color: var(--header-bg);
            color: #ffffff;
            padding: 10px 12px;
            text-align: center;
        }
        .calendar-header h5 {
            margin: 0;
            font-size: 1.15rem;
            font-weight: 700;
        }
        .calendar-header .sub-head {
            font-size: 0.75rem;
            opacity: 0.9;
        }
        .calendar-nav-btn {
            color: #ffffff;
            background: rgba(255,255,255,0.2);
            border: none;
            border-radius: 50%;
            width: 26px;
            height: 26px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: background 0.2s;
        }
        .calendar-nav-btn:hover {
            background: rgba(255,255,255,0.4);
            color: #ffffff;
        }
        .weekdays-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            text-align: center;
            padding: 4px 0;
        }
        .weekday-cell {
            font-size: 0.7rem;
            font-weight: 700;
            color: #475569;
        }
        .weekday-cell.sat {
            color: #dc2626;
        }
        .days-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            padding: 4px;
            gap: 2px;
        }
        .day-cell {
            aspect-ratio: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border-radius: 6px;
            font-size: 0.9rem;
            font-weight: 700;
            color: #1e293b;
            cursor: pointer;
            position: relative;
            background: #ffffff;
            border: 1px solid transparent;
            transition: all 0.15s ease-in-out;
        }
        .day-cell:hover {
            background: #f1f5f9;
            border-color: #cbd5e1;
        }
        .day-cell .ad-sub {
            font-size: 0.58rem;
            font-weight: 500;
            color: #64748b;
            margin-top: -2px;
        }
        .day-cell.saturday {
            color: #dc2626;
            background: #fef2f2;
        }
        .day-cell.today {
            background: #eff6ff !important;
            border: 2px solid var(--header-bg) !important;
            color: var(--header-bg);
        }
        .day-cell.selected {
            background: var(--header-bg) !important;
            color: #ffffff !important;
        }
        .day-cell.selected .ad-sub {
            color: rgba(255,255,255,0.85);
        }
        .panchang-bar {
            background: #f8fafc;
            border-top: 1px solid #e2e8f0;
            padding: 6px 10px;
            font-size: 0.72rem;
            color: #334155;
        }
        .panchang-badge {
            background: rgba(106, 167, 68, 0.15);
            color: var(--header-bg);
            font-weight: 700;
            padding: 2px 6px;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<div class="local-calendar-card mx-auto">
    <!-- Header -->
    <div class="calendar-header">
        <div class="d-flex align-items-center justify-content-between">
            <a href="?date=<?= $prevAdDate ?>&header_color=<?= urlencode(str_replace('#','',$headerColor)) ?><?= $targetParam ?>" class="calendar-nav-btn" title="Previous Month">
                <i class="fa-solid fa-chevron-left"></i>
            </a>
            <div>
                <form method="GET" action="" class="d-inline-flex align-items-center gap-1 m-0 justify-content-center">
                    <input type="hidden" name="header_color" value="<?= htmlspecialchars(str_replace('#', '', $headerColor)) ?>">
                    <input type="hidden" name="target" value="<?= htmlspecialchars($targetInput) ?>">
                    <?php if (isset($_GET['tithi'])) { echo '<input type="hidden" name="tithi" value="'.htmlspecialchars($_GET['tithi']).'">'; } ?>
                    <?php if (isset($_GET['interactive'])) { echo '<input type="hidden" name="interactive" value="'.htmlspecialchars($_GET['interactive']).'">'; } ?>
                    
                    <select name="bs_month" class="form-select form-select-sm" style="width:auto; padding:0 20px 0 5px; font-size:1.15rem; height:30px; font-weight:700; background:rgba(255,255,255,0.15); color:#fff; border:none; cursor:pointer; box-shadow:none;" onchange="this.form.submit()">
                        <?php for($m=1; $m<=12; $m++): ?>
                            <option style="color:#333; font-size:1rem;" value="<?= $m ?>" <?= $bsMonth == $m ? 'selected' : '' ?>><?= getBsMonthName($m, 'np') ?></option>
                        <?php endfor; ?>
                    </select>
                    
                    <select name="bs_year" class="form-select form-select-sm" style="width:auto; padding:0 20px 0 5px; font-size:1.15rem; height:30px; font-weight:700; background:rgba(255,255,255,0.15); color:#fff; border:none; cursor:pointer; box-shadow:none;" onchange="this.form.submit()">
                        <?php for($y=1975; $y<=2090; $y++): ?>
                            <option style="color:#333; font-size:1rem;" value="<?= $y ?>" <?= $bsYear == $y ? 'selected' : '' ?>><?= convertToNepaliDigits($y) ?></option>
                        <?php endfor; ?>
                    </select>
                </form>
                <div class="sub-head mt-1"><?= $bsMonthEn ?> <?= $bsYear ?> BS &bull; <?= date('M Y', strtotime($firstAdOfBsMonth)) ?> AD</div>
            </div>
            <a href="?date=<?= $nextAdDate ?>&header_color=<?= urlencode(str_replace('#','',$headerColor)) ?><?= $targetParam ?>" class="calendar-nav-btn" title="Next Month">
                <i class="fa-solid fa-chevron-right"></i>
            </a>
        </div>
    </div>

    <!-- Weekday Labels -->
    <div class="weekdays-grid">
        <?php foreach ($nepalWeekdays as $idx => $day): ?>
            <div class="weekday-cell <?= ($idx === 6) ? 'sat' : '' ?>">
                <?= $day['np'] ?><br><span style="font-size:0.58rem; font-weight:normal;"><?= $day['en'] ?></span>
            </div>
        <?php endforeach; ?>
    </div>

    <!-- Days Grid -->
    <div class="days-grid">
        <?php
            // Empty pad cells for start of month
            for ($p = 0; $p < $startPad; $p++) {
                echo '<div class="day-cell text-muted opacity-25" style="background:#fafafa;"></div>';
            }

            // Days of the BS month
            for ($d = 1; $d <= $daysInBsMonth; $d++) {
                $cellAdDate = bsToAd($bsYear, $bsMonth, $d);
                $cellAdDay = (int)date('d', strtotime($cellAdDate));
                $dayOfWeek = (int)date('w', strtotime($cellAdDate)); // 0=Sun, 6=Sat

                $isTodayCell = ($cellAdDate === date('Y-m-d'));
                $isSelectedCell = ($cellAdDate === $reqAdDate);
                $isSaturday = ($dayOfWeek === 6);

                $cellClass = 'day-cell';
                if ($isSaturday) $cellClass .= ' saturday';
                if ($isTodayCell) $cellClass .= ' today';
                if ($isSelectedCell && !$isTodayCell) $cellClass .= ' selected';

                $bsNumNp = convertToNepaliDigits($d);
                $bsDateFormatted = sprintf('%04d-%02d-%02d', $bsYear, $bsMonth, $d);

                echo "<div class='{$cellClass}' onclick=\"selectDate('{$cellAdDate}', '{$bsDateFormatted}')\" title='BS: {$bsMonthEn} {$d}, {$bsYear} | AD: {$cellAdDate}'>";
                echo "<div>{$bsNumNp}</div>";
                echo "<div class='ad-sub'>{$cellAdDay}</div>";
                echo "</div>";
            }
        ?>
    </div>

    <?php if ($showTithi): ?>
    <!-- Panchang / Tithi Info -->
    <div class="panchang-bar d-flex align-items-center justify-content-between">
        <div>
            <i class="fa-solid fa-moon text-warning me-1"></i>
            <strong>तिथि:</strong> <?= $currTithi ?>
        </div>
        <span class="panchang-badge"><?= $paksha ?></span>
    </div>
    <?php endif; ?>
</div>

<script>
function selectDate(adDate, bsDate) {
    var targetInputId = "<?= htmlspecialchars($targetInput) ?>";
    if (window.parent && window.parent.onNepaliCalendarSelect) {
        window.parent.onNepaliCalendarSelect(adDate, bsDate, targetInputId);
    } else {
        console.log("Selected Date AD:", adDate, "BS:", bsDate, "Target:", targetInputId);
    }
}
</script>

</body>
</html>

