<?php
require_once 'includes/functions.php';
requireLogin();

$currentUser = getCurrentUser();
$isViewAction = (isset($_GET['action']) && $_GET['action'] === 'view');
if (!in_array($currentUser['role'] ?? '', ['Maker', 'Admin']) && !$isViewAction) {
    die('<div style="font-family:sans-serif; text-align:center; padding:40px; color:#dc2626;"><h3>⛔ Access Denied</h3><p>Only Makers can initiate or edit cases. Other roles can only view.</p><a href="index.php" style="display:inline-block; margin-top:15px; padding:10px 20px; background:#2563eb; color:white; border-radius:8px; text-decoration:none;">← Return to Dashboard</a></div>');
}

$profileId = $_GET['profile_id'] ?? $_POST['profile_id'] ?? '';
$caseId    = $_GET['case_id'] ?? $_POST['case_id'] ?? '';
$isEdit    = isset($_GET['edit']) || isset($_POST['edit']) || (isset($_GET['action']) && $_GET['action'] === 'view');
$isModal   = isset($_GET['modal']); // iframe/modal embed mode

$profile = getProfileById($profileId);
if (!$profile) {
    die('<div style="font-family:sans-serif; padding:40px;">Profile not found. <a href="index.php">Go back</a></div>');
}

$existingCheque = [];
if ($isEdit && $caseId) {
    $caseCheck = getCaseById($profileId, $caseId);
    $currentUser = getCurrentUser();
    $isView = (isset($_GET['action']) && $_GET['action'] === 'view');
    if (!$isView && $caseCheck && !empty($caseCheck['is_locked']) && ($currentUser['role'] ?? '') !== 'Admin') {
        die('<div style="font-family:sans-serif; padding:40px; color:#dc2626;"><h3>🔒 Case is Locked</h3><p>This case is currently locked for review/verification and cannot be modified.</p><a href="case-view.php?profile_id='.urlencode($profileId).'&case_id='.urlencode($caseId).'">← Back to Case View</a></div>');
    }
    
    $pdo = getDbConnection();
    $stmt = $pdo->prepare("SELECT * FROM cheque_details WHERE case_id = ?");
    $stmt->execute([$caseId]);
    $res = $stmt->fetch();
    if ($res) {
        $existingCheque = $res;
        if (isset($existingCheque['presentmentDates'])) {
            $existingCheque['presentmentDates'] = json_decode($existingCheque['presentmentDates'], true) ?: [];
        }
    }
}

$errors = [];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $accountHolderName = trim($_POST['accountHolderName'] ?? '');
    $accountNumber     = trim($_POST['accountNumber'] ?? '');
    $chequeNumber      = trim($_POST['chequeNumber'] ?? '');
    $chequeDate        = trim($_POST['chequeDate'] ?? '');
    $chequeDateAD      = trim($_POST['chequeDateAD'] ?? '');
    $chequeDateType    = trim($_POST['chequeDateType'] ?? 'BS');
    $amount            = trim($_POST['chequeAmount'] ?? '');

    $reasonSelect      = trim($_POST['dishonour_reason_select'] ?? '');
    $reasonCustom      = trim($_POST['dishonour_reason_custom'] ?? '');
    $dishonourReason   = ($reasonSelect === 'Custom') ? $reasonCustom : $reasonSelect;
    if (empty($dishonourReason)) {
        $dishonourReason = 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको';
    }

    $isBalanceSufficient = (isset($_POST['is_balance_sufficient']) && $_POST['is_balance_sufficient'] === '1') ? 1 : 0;
    
    $noticeType = '45_Days';
    if ($dishonourReason !== 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको' && $isBalanceSufficient === 1) {
        $noticeType = '7_Days';
    }

    if ($chequeNumber === '') $errors[] = 'Cheque Number is required.';
    if ($chequeDate === '') $errors[] = 'Cheque Date (BS) is required.';
    if ($chequeDateAD === '') $errors[] = 'Cheque Date (AD) is required.';
    if ($amount === '' || !is_numeric($amount)) $errors[] = 'Please enter a valid Cheque Amount.';
    
    $branchNameEn = trim($_POST['branchNameEn'] ?? '');
    if (empty($branchNameEn)) $errors[] = 'Please enter Branch Name (English).';
    $branchNameNp = trim($_POST['branchNameNp'] ?? '');
    if (!empty($branchNameNp)) {
        $branchNameNp = preetiToUnicode($branchNameNp);
    }

    $amountWords = trim($_POST['chequeAmountWords'] ?? '');
    if (empty($amountWords)) {
        $amountWords = numberToNepaliWords($amount);
    }
    
    $isApplicantPayee = trim($_POST['isApplicantPayee'] ?? 'yes');
    $payeeName = '';
    $payeeNameNepali = '';
    
    if ($isApplicantPayee === 'yes') {
        $payeeName = ''; // Handled by generator
        $payeeNameNepali = '';
    } else {
        $payeeName = trim($_POST['payeeName'] ?? '');
        $payeeNameNepali = trim($_POST['payeeNameNepali'] ?? '');
        if (!empty($payeeNameNepali)) {
            $payeeNameNepali = preetiToUnicode($payeeNameNepali);
        }
    }

    $acqBranchEn = trim($_POST['acqBranchEn'] ?? '');
    $acqBranchNp = trim($_POST['acqBranchNp'] ?? '');
    if (!empty($acqBranchNp)) {
        $acqBranchNp = preetiToUnicode($acqBranchNp);
    }

    if (empty($errors)) {
        $chequeDetails = [
            'accountHolderName' => $accountHolderName,
            'accountNumber'     => $accountNumber,
            'branchNameEn'      => $branchNameEn,
            'branchNameNp'      => $branchNameNp,
            'acqBranchEn'       => $acqBranchEn,
            'acqBranchNp'       => $acqBranchNp,
            'chequeNumber'      => $chequeNumber,
            'chequeDate'        => $chequeDate,
            'chequeDateAD'      => $chequeDateAD,
            'chequeDateType'    => $chequeDateType,
            'chequeAmount'      => $amount,
            'chequeAmountWords' => $amountWords,
            'dishonour_reason'  => $dishonourReason,
            'isApplicantPayee'  => $isApplicantPayee,
            'payeeName'         => $payeeName,
            'payeeNameNepali'   => $payeeNameNepali,
            'presentmentDates'  => array_values(array_filter($_POST['presentmentDates'] ?? []))
        ];
        $pdo = getDbConnection();
        $presentmentJson = json_encode(array_values(array_filter($_POST['presentmentDates'] ?? [])));
        
        if ($isEdit && !empty($caseId)) {
            $stmt = $pdo->prepare("UPDATE cheque_details SET 
                accountHolderName = ?, accountNumber = ?, branchNameEn = ?, branchNameNp = ?, acqBranchEn = ?, acqBranchNp = ?, chequeNumber = ?, chequeDate = ?, chequeDateAD = ?, chequeDateType = ?, 
                chequeAmount = ?, chequeAmountWords = ?, dishonour_reason_select = ?, 
                isApplicantPayee = ?, payeeName = ?, payeeNameNepali = ?, presentmentDates = ?, is_balance_sufficient = ?
                WHERE case_id = ?");
            $stmt->execute([
                $accountHolderName, $accountNumber, $branchNameEn, $branchNameNp, $acqBranchEn, $acqBranchNp, $chequeNumber, $chequeDate, $chequeDateAD, $chequeDateType, 
                $amount, $amountWords, $dishonourReason, 
                $isApplicantPayee, $payeeName, $payeeNameNepali, $presentmentJson, $isBalanceSufficient,
                $caseId
            ]);
            
            $stmtCases = $pdo->prepare("UPDATE cases SET notice_type = ? WHERE case_id = ?");
            $stmtCases->execute([$noticeType, $caseId]);
            
            logAuditAction($caseId, "Updated Cheque Details");
            if ($isModal) {
                header('Location: modal-saved.php?msg=' . urlencode('Cheque details updated successfully.'));
            } else {
                header('Location: case-view.php?profile_id=' . urlencode($profile['profile_id']) . '&case_id=' . urlencode($caseId) . '&tab=cheque&updated=1');
            }
            exit;
        } else {
            $caseId = generateCaseId($profile['profile_id']);
            $pdo->beginTransaction();
            try {
                $stmt1 = $pdo->prepare("INSERT INTO cases (case_id, profile_id, status, notice_type, branch_id) VALUES (?, ?, 'Pending Drawer', ?, ?)");
                $stmt1->execute([$caseId, $profile['profile_id'], $noticeType, $currentUser['branch_id']]);
                
                $stmt2 = $pdo->prepare("INSERT INTO cheque_details (
                    case_id, accountHolderName, accountNumber, branchNameEn, branchNameNp, acqBranchEn, acqBranchNp, chequeNumber, chequeDate, chequeDateAD, chequeDateType, 
                    chequeAmount, chequeAmountWords, dishonour_reason_select, 
                    isApplicantPayee, payeeName, payeeNameNepali, presentmentDates, is_balance_sufficient
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
                
                $stmt2->execute([
                    $caseId, $accountHolderName, $accountNumber, $branchNameEn, $branchNameNp, $acqBranchEn, $acqBranchNp, $chequeNumber, $chequeDate, $chequeDateAD, $chequeDateType, 
                    $amount, $amountWords, $dishonourReason, 
                    $isApplicantPayee, $payeeName, $payeeNameNepali, $presentmentJson, $isBalanceSufficient
                ]);
                
                $pdo->commit();
                logAuditAction($caseId, "Created Case & Saved Cheque Details");
                if ($isModal) {
                    header('Location: modal-saved.php?msg=' . urlencode('Case created and cheque details saved.'));
                } else {
                    header('Location: case-view.php?profile_id=' . urlencode($profile['profile_id']) . '&case_id=' . urlencode($caseId) . '&tab=cheque&created=1');
                }
                exit;
            } catch (Exception $e) {
                $pdo->rollBack();
                $errors[] = "Database error: " . $e->getMessage();
            }
        }
    }
}

$existingReason = $existingCheque['dishonour_reason'] ?? $existingCheque['return_reason'] ?? 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको';
$standardReasons = [
    'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको',
    'दस्तखत नमिलेको',
    'खाता बन्द भएको',
    'भुक्तानी रोक्का राखिएको',
    'म्याद नाघेको चेक'
];
$isCustomReason = !in_array($existingReason, $standardReasons) && !empty($existingReason);
?>
<?php if ($isModal): require_once 'includes/modal-header.php'; else: require_once 'includes/header.php'; endif; ?>


<div class="page-wrap">
  <div class="breadcrumb-app">
      <a href="<?= $isEdit ? 'case-view.php?profile_id='.urlencode($profile['profile_id']).'&case_id='.urlencode($caseId) : 'profile.php?id='.urlencode($profile['profile_id']) ?>">
          ← Back to <?= $isEdit ? h($caseId) : h($profile['applicant_name']) ?>
      </a>
  </div>

  <div class="page-header">
    <div>
      <h1><?= $isEdit ? 'Edit Cheque Details' : 'New Case' ?></h1>
      <div class="subtitle">Profile: <?= h($profile['profile_id']) ?> — <?= h($profile['applicant_name']) ?></div>
    </div>
  </div>

  <?php if (!empty($errors)): ?>
    <div class="alert alert-danger">
      <ul class="mb-0">
        <?php foreach ($errors as $err): ?><li><?= h($err) ?></li><?php endforeach; ?>
      </ul>
    </div>
  <?php endif; ?>

  <form method="POST" action="case-form.php" id="chequeMainForm" onsubmit="return showChecklistModal(event)">
    <input type="hidden" name="profile_id" value="<?= h($profile['profile_id']) ?>">
    <input type="hidden" name="case_id" value="<?= h($caseId) ?>">
    <?php if($isEdit): ?><input type="hidden" name="edit" value="1"><?php endif; ?>

    <style>
        .form-section { border: 1px solid #e5e7eb; border-radius: 8px; padding: 20px; margin-bottom: 20px; background: #fff; }
        .form-section-title { font-size: 16px; font-weight: 600; color: #333; padding-bottom: 12px; margin-bottom: 18px; border-bottom: 1px solid #eee; }
        .required { color: #dc3545; }
        .presentment-box { background: #f8f9fa; border: 1px dashed #cfd4da; border-radius: 8px; padding: 15px; }
        .presentment-row { display: flex; align-items: flex-end; gap: 12px; margin-bottom: 12px; }
        .presentment-input { flex: 1; }
        .presentment-action { flex: 0 0 auto; }
        .presentment-action .btn { height: 40px; }
    </style>

    <div class="card-app">
      <div class="form-section">
          <div class="form-section-title">Cheque & Dishonour Information</div>
          <div class="row g-3">
              <div class="col-md-3">
                  <label class="form-label">Account Holder Name <span class="required">*</span></label>
                  <input type="text" name="accountHolderName" class="form-control" value="<?= h($existingCheque['accountHolderName'] ?? '') ?>" required>
              </div>
              <div class="col-md-3">
                  <label class="form-label">Account Number <span class="required">*</span></label>
                  <input type="text" name="accountNumber" class="form-control" value="<?= h($existingCheque['accountNumber'] ?? '') ?>" required>
              </div>
              <div class="col-md-3">
                  <label class="form-label">Drawer Branch Name (English) <span class="required">*</span></label>
                  <input type="text" name="branchNameEn" class="form-control" value="<?= h($existingCheque['branchNameEn'] ?? '') ?>" required>
              </div>
              <div class="col-md-3">
                  <label class="form-label">Drawer Branch Name (Nepali)</label>
                  <input type="text" name="branchNameNp" id="branchNameNp" class="form-control preeti-input" style="font-family: 'Preeti', sans-serif; font-size: 22px;" value="<?= h($existingCheque['branchNameNp'] ?? '') ?>">
              </div>
              <div class="col-md-3">
                  <label class="form-label">Cheque Number <span class="required">*</span></label>
                  <input type="text" name="chequeNumber" class="form-control" value="<?= h($existingCheque['chequeNumber'] ?? '') ?>" required>
              </div>
              <div class="col-md-3">
                  <label class="form-label">Date written on Cheque <span class="required">*</span></label>
                  <div class="mt-2">
                      <div class="form-check form-check-inline">
                          <input class="form-check-input" type="radio" name="chequeDateType" id="dateTypeBS" value="BS" <?= (!isset($existingCheque['chequeDateType']) || $existingCheque['chequeDateType'] === 'BS') ? 'checked' : '' ?>>
                          <label class="form-check-label" for="dateTypeBS">BS</label>
                      </div>
                      <div class="form-check form-check-inline">
                          <input class="form-check-input" type="radio" name="chequeDateType" id="dateTypeAD" value="AD" <?= (isset($existingCheque['chequeDateType']) && $existingCheque['chequeDateType'] === 'AD') ? 'checked' : '' ?>>
                          <label class="form-check-label" for="dateTypeAD">AD</label>
                      </div>
                  </div>
              </div>
              <div class="col-md-3 position-relative">
                  <label class="form-label">Cheque Date (BS) <span class="required">*</span></label>
                  <div class="input-group">
                      <input type="text" name="chequeDate" id="chequeDateInputBs" class="form-control" value="<?= h($existingCheque['chequeDate'] ?? '') ?>" readonly onclick="toggleNepaliDatePicker('chequeDateInputBs')" style="cursor: pointer;" required>
                      <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('chequeDateInputBs')">📅</button>
                  </div>
                  <div id="picker_chequeDateInputBs" class="collapse position-absolute z-3 mt-1" style="z-index: 1000;">
                      <iframe src="../widgets/nepali_calendar_widget.php?target=chequeDateInputBs" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                  </div>
              </div>
              <div class="col-md-3">
                  <label class="form-label">Cheque Date (AD) <span class="required">*</span></label>
                  <input type="date" name="chequeDateAD" id="chequeDateInput" class="form-control" value="<?= h($existingCheque['chequeDateAD'] ?? '') ?>" required>
              </div>
                  <div class="col-12">
                    <label class="form-label d-block">Are Applicant and Payee the same person? <span class="required">*</span></label>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="isApplicantPayee" id="isApplicantPayeeYes" value="yes" <?= ($existingCheque['isApplicantPayee'] ?? 'yes') === 'yes' ? 'checked' : '' ?> onchange="togglePayeeFields()">
                      <label class="form-check-label" for="isApplicantPayeeYes">Yes</label>
                    </div>
                    <div class="form-check form-check-inline">
                      <input class="form-check-input" type="radio" name="isApplicantPayee" id="isApplicantPayeeNo" value="no" <?= ($existingCheque['isApplicantPayee'] ?? 'yes') === 'no' ? 'checked' : '' ?> onchange="togglePayeeFields()">
                      <label class="form-check-label" for="isApplicantPayeeNo">No</label>
                    </div>
                  </div>

                  <div id="payeeFields" class="col-12 <?= ($existingCheque['isApplicantPayee'] ?? 'yes') === 'yes' ? 'd-none' : '' ?>">
                    <div class="alert alert-warning mb-3">
                        <strong>⚠️ Notice:</strong> Since the Applicant and Payee are different, please ensure the correct legal authorization/endorsement documents are uploaded.
                    </div>
                    <div class="row g-3">
                      <div class="col-md-6">
                        <label class="form-label">Payee Name (English) <span class="required">*</span></label>
                        <input type="text" name="payeeName" id="payeeNameInput" class="form-control" value="<?= h($existingCheque['payeeName'] ?? '') ?>">
                      </div>
                      <div class="col-md-6">
                        <label class="form-label">Payee Name (Nepali)</label>
                        <input type="text" name="payeeNameNepali" id="payeeNameNepali" class="form-control preeti-input" style="font-family: 'Preeti', sans-serif; font-size: 22px;" value="<?= h($existingCheque['payeeNameNepali'] ?? '') ?>">
                      </div>
                    </div>
                  </div>

                  <script>
                  function togglePayeeFields() {
                      const isYes = document.getElementById('isApplicantPayeeYes').checked;
                      const fields = document.getElementById('payeeFields');
                      const payeeInput = document.getElementById('payeeNameInput');
                      if (isYes) {
                          fields.classList.add('d-none');
                          payeeInput.removeAttribute('required');
                      } else {
                          fields.classList.remove('d-none');
                          payeeInput.setAttribute('required', 'required');
                      }
                  }
                  // Initialize required state on load
                  document.addEventListener('DOMContentLoaded', togglePayeeFields);
                  </script>
              <div class="col-md-3">
                  <label class="form-label">Cheque Amount (रू.) <span class="required">*</span></label>
                  <input type="number" name="chequeAmount" id="chequeAmountInput" class="form-control" min="0" step="0.01" value="<?= h($existingCheque['chequeAmount'] ?? '') ?>" required>
              </div>
              <div class="col-md-9">
                  <label class="form-label">Cheque Amount in Words (Nepali / नेपाली अक्षरेपी)</label>
                  <input type="text" name="chequeAmountWords" id="chequeAmountWordsInput" class="form-control" value="<?= h($existingCheque['chequeAmountWords'] ?? '') ?>">
              </div>

              <!-- CHEQUE RETURN REASON FIELD -->
              <div class="col-12 mt-3">
                  <label class="form-label fw-bold text-dark">Cheque Return Reason (अनादरको कारण) <span class="required">*</span></label>
                  <select name="dishonour_reason_select" id="dishonour_reason_select" class="form-select" onchange="toggleCustomReason(this); updateNoticeTypeBadge();">
                      <option value="खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको" <?= ($existingReason === 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको' || empty($existingReason)) ? 'selected' : '' ?>>खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको (Insufficient Funds)</option>
                      <option value="दस्तखत नमिलेको" <?= ($existingReason === 'दस्तखत नमिलेको') ? 'selected' : '' ?>>दस्तखत नमिलेको (Signature Mismatch)</option>
                      <option value="खाता बन्द भएको" <?= ($existingReason === 'खाता बन्द भएको') ? 'selected' : '' ?>>खाता बन्द भएको (Account Closed)</option>
                      <option value="भुक्तानी रोक्का राखिएको" <?= ($existingReason === 'भुक्तानी रोक्का राखिएको') ? 'selected' : '' ?>>भुक्तानी रोक्का राखिएको (Payment Stopped)</option>
                      <option value="म्याद नाघेको चेक" <?= ($existingReason === 'म्याद नाघेको चेक') ? 'selected' : '' ?>>म्याद नाघेको चेक (Stale Cheque)</option>
                      <option value="Custom" <?= $isCustomReason ? 'selected' : '' ?>>अन्य (Custom Reason)</option>
                  </select>
                  <input type="text" name="dishonour_reason_custom" id="dishonour_reason_custom" class="form-control mt-2 <?= $isCustomReason ? '' : 'd-none' ?>" value="<?= h($isCustomReason ? $existingReason : '') ?>">
              </div>

              <div class="col-12 mt-3">
                  <label class="form-label fw-bold text-dark">Is there sufficient balance in the account? <span class="required">*</span></label>
                  <div class="form-check">
                      <input class="form-check-input" type="radio" name="is_balance_sufficient" id="balSufficientYes" value="1" <?= (isset($existingCheque['is_balance_sufficient']) && $existingCheque['is_balance_sufficient'] == 1) ? 'checked' : '' ?> onchange="updateNoticeTypeBadge()">
                      <label class="form-check-label" for="balSufficientYes">Yes, Balance is Sufficient</label>
                  </div>
                  <div class="form-check">
                      <input class="form-check-input" type="radio" name="is_balance_sufficient" id="balSufficientNo" value="0" <?= (!isset($existingCheque['is_balance_sufficient']) || $existingCheque['is_balance_sufficient'] == 0) ? 'checked' : '' ?> onchange="updateNoticeTypeBadge()">
                      <label class="form-check-label" for="balSufficientNo">No, Balance is Insufficient</label>
                  </div>
              </div>
              
              <div class="col-12 mt-3">
                  <div id="noticeTypeBadgeWrapper" class="p-3 rounded border" style="background-color: #eef2ff; border-color: #c7d2fe;">
                      <strong>Notice Type: </strong>
                      <span id="noticeTypeBadge" class="badge bg-primary fs-6">Calculating...</span>
                      <p class="mb-0 mt-1 small text-muted" id="noticeTypeDesc"></p>
                  </div>
              </div>
          </div>
      </div>

      <div class="form-section">
          <div class="form-section-title">
              <div style="display:flex; justify-content:space-between; align-items:center; gap:15px;">
                  <div>Presentment Dates (पेश गरिएको मितिहरू)</div>
                  <button type="button" class="btn btn-primary btn-sm" id="addPresentmentBtn">+ Add Presentment Date</button>
              </div>
          </div>
          <div class="presentment-box">
              <div id="presentmentDatesContainer"></div>
          </div>
      </div>
    </div>

    <div class="d-flex gap-2 mb-5">
      <button type="submit" class="btn-primary-app border-0">Save Cheque Details</button>
      <a href="<?= $isEdit ? 'case-view.php?profile_id='.urlencode($profile['profile_id']).'&case_id='.urlencode($caseId) : 'profile.php?id='.urlencode($profile['profile_id']) ?>" class="btn-outline-app">Cancel</a>
    </div>
  </form>
</div>

<script>
    function updateNoticeTypeBadge() {
        const reasonSelect = document.getElementById('dishonour_reason_select');
        const balYes = document.getElementById('balSufficientYes');
        const balNo = document.getElementById('balSufficientNo');
        const badge = document.getElementById('noticeTypeBadge');
        const desc = document.getElementById('noticeTypeDesc');
        
        if (!reasonSelect || !balYes || !balNo || !badge) return;

        const reason = reasonSelect.value;
        
        // Sync the "Sufficient Balance" radio based on the reason
        if (reason === 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको') {
            balNo.checked = true;
            balYes.disabled = true;
            balNo.disabled = false;
        } else {
            balYes.disabled = false;
            balNo.disabled = false;
            if (!balYes.checked && !balNo.checked) {
                balYes.checked = true;
            }
        }

        const isBalSufficient = balYes.checked;
        
        if (reason !== 'खातामा मौज्दात नभएको / मौज्दात पर्याप्त नभएको' && isBalSufficient) {
            badge.className = 'badge bg-warning text-dark fs-6';
            badge.innerText = '7-Day Notice Workflow';
            desc.innerText = 'Due to a non-balance issue with sufficient funds, a 7-day working notice will be issued as per Directive 12.';
        } else {
            badge.className = 'badge bg-primary fs-6';
            badge.innerText = '45-Day Notice Workflow';
            desc.innerText = 'Since funds are insufficient (or reason is insufficient funds), the standard 45-day notice applies.';
        }
    }
    document.addEventListener("DOMContentLoaded", updateNoticeTypeBadge);

    function toggleCustomReason(selectEl) {
        const customInput = document.getElementById('dishonour_reason_custom');
        if (selectEl.value === 'Custom') {
            customInput.classList.remove('d-none');
            customInput.focus();
        } else {
            customInput.classList.add('d-none');
        }
    }

    // Convert Number to Nepali Devanagari Words
    function numberToNepaliWords(num) {
        if (num === null || num === undefined || isNaN(num) || num === '') return '';
        num = parseInt(num, 10);
        if (num === 0) return 'शून्य रूपैयाँ मात्र';

        const wordsMap = {
            0: '', 1: 'एक', 2: 'दुई', 3: 'तीन', 4: 'चार', 5: 'पाँच',
            6: 'छ', 7: 'सात', 8: 'आठ', 9: 'नौ', 10: 'दस',
            11: 'एघार', 12: 'बाह्र', 13: 'तेह्र', 14: 'चौध', 15: 'पन्ध्र',
            16: 'सोह्र', 17: 'सत्र', 18: 'अठार', 19: 'उन्नाइस', 20: 'बीस',
            21: 'एक्काइस', 22: 'बाइस', 23: 'तेइस', 24: 'चौबीस', 25: 'पच्चिस',
            26: 'छब्बिस', 27: 'सत्ताइस', 28: 'अट्ठाइस', 29: 'उनन्तिस', 30: 'तीस',
            31: 'एकत्तिस', 32: 'बत्तीस', 33: 'तेत्तीस', 34: 'चौँतीस', 35: 'पैँतीस',
            36: 'छत्तीस', 37: 'सैँतीस', 38: 'अड्तीस', 39: 'उनन्चालीस', 40: 'चालीस',
            41: 'एकचालीस', 42: 'बयालीस', 43: 'त्रिचालीस', 44: 'चौवालिस', 45: 'पैँतालीस',
            46: 'छयालीस', 47: 'सत्चालीस', 48: 'अठचालीस', 49: 'उनन्पचास', 50: 'पचास',
            51: 'एकाउन्न', 52: 'बाउन्न', 53: 'त्रिपन', 54: 'चौवन', 55: 'पचपन्न',
            56: 'छप्पन्न', 57: 'संताउन्न', 58: 'अन्ठाउन्न', 59: 'उनन्साठ्ठी', 60: 'साठ्ठी',
            61: 'एकसाठ्ठी', 62: 'बासाठ्ठी', 63: 'त्रिसाठ्ठी', 64: 'चौँसाठ्ठी', 65: 'पैँसाठ्ठी',
            66: 'छ्यासाठ्ठी', 67: 'सरसाठ्ठी', 68: 'अरसाठ्ठी', 69: 'उनन्सत्तरी', 70: 'सत्तरी',
            71: 'एकहत्तर', 72: 'बहत्तर', 73: 'त्रिहत्तर', 74: 'चौहत्तर', 75: 'पचहत्तर',
            76: 'छिहत्तर', 77: 'सतहत्तर', 78: 'अठहत्तर', 79: 'उननासी', 80: 'असी',
            81: 'एकासी', 82: 'बयासी', 83: 'त्रिरासी', 84: 'चौरासी', 85: 'पचासी',
            86: 'छियासी', 87: 'सत्तासी', 88: 'अठासी', 89: 'उनन्नब्बे', 90: 'नब्बे',
            91: 'एकानब्बे', 92: 'बयानब्बे', 93: 'त्रियानब्बे', 94: 'चौरान्नब्बे', 95: 'पञ्चानब्बे',
            96: 'छियानब्बे', 97: 'सन्तानब्बे', 98: 'अनठानब्बे', 99: 'उनन्साउ'
        };

        let crore = Math.floor(num / 10000000);
        let rem = num % 10000000;
        let lakh = Math.floor(rem / 100000);
        rem = rem % 100000;
        let thousand = Math.floor(rem / 1000);
        rem = rem % 1000;
        let hundred = Math.floor(rem / 100);
        rem = rem % 100;

        let out = [];
        if (crore > 0) out.push((wordsMap[crore] || crore) + ' करोड');
        if (lakh > 0) out.push((wordsMap[lakh] || lakh) + ' लाख');
        if (thousand > 0) out.push((wordsMap[thousand] || thousand) + ' हजार');
        if (hundred > 0) out.push((wordsMap[hundred] || hundred) + ' सय');
        if (rem > 0) out.push(wordsMap[rem] || rem);

        return out.join(' ') + ' मात्र';
    }

    document.addEventListener("DOMContentLoaded", () => {
        const chequeForm = document.querySelector('form');
        const cancelBtn = document.querySelector('a.btn-outline-app');
        setupFormDirtyTracker(chequeForm, cancelBtn);

        const amtInput = document.getElementById('chequeAmountInput');
        const wordsInput = document.getElementById('chequeAmountWordsInput');
        
        if (amtInput && wordsInput) {
            amtInput.addEventListener('input', (e) => {
                let val = parseFloat(e.target.value);
                if (!isNaN(val)) {
                    wordsInput.value = numberToNepaliWords(val);
                } else {
                    wordsInput.value = '';
                }
            });
        }

        const datesContainer = document.getElementById("presentmentDatesContainer");
        const addBtn = document.getElementById("addPresentmentBtn");

        function createPresentmentRow(val = '') {
            const div = document.createElement("div");
            div.className = "presentment-row";
            const uniqueId = 'pd_' + Math.random().toString(36).substr(2, 9);
            div.innerHTML = `
                <div class="presentment-input position-relative">
                    <label class="form-label">Date <span class="required">*</span></label>
                    <div class="input-group">
                        <input type="text" class="form-control" name="presentmentDates[]" id="${uniqueId}" value="${val}" readonly onclick="toggleNepaliDatePicker('${uniqueId}')" style="cursor: pointer;" required>
                        <button class="btn btn-outline-secondary" type="button" onclick="toggleNepaliDatePicker('${uniqueId}')">📅</button>
                    </div>
                    <div id="picker_${uniqueId}" class="collapse position-absolute z-3 mt-1" style="z-index: 1000;">
                        <iframe src="../widgets/nepali_calendar_widget.php?target=${uniqueId}" style="width: 320px; height: 380px; border: none; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.12);" scrolling="no"></iframe>
                    </div>
                </div>
                <div class="presentment-action">
                    <button type="button" class="btn btn-danger" onclick="this.closest('.presentment-row').remove()">Remove</button>
                </div>
            `;
            return div;
        }

        addBtn.addEventListener('click', () => {
            datesContainer.appendChild(createPresentmentRow());
        });

        const existingDates = <?= json_encode($existingCheque['presentmentDates'] ?? []) ?>;
        if (Array.isArray(existingDates) && existingDates.length > 0) {
            existingDates.forEach(d => {
                datesContainer.appendChild(createPresentmentRow(d));
            });
        } else {
            datesContainer.appendChild(createPresentmentRow());
        }
    });
</script>
<?php if (($_GET['action'] ?? '') === 'view'): ?>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Disable all inputs
    const formContainer = document.querySelector('form');
    if (formContainer) {
        const inputs = formContainer.querySelectorAll('input, select, textarea');
        inputs.forEach(i => i.disabled = true);
        const submitBtn = formContainer.querySelector('button[type="submit"]');
        if (submitBtn) submitBtn.style.display = 'none';
        
        const addBtn = document.getElementById('addPresentmentBtn');
        if (addBtn) addBtn.style.display = 'none';
        const removeBtns = formContainer.querySelectorAll('.btn-danger');
        removeBtns.forEach(btn => btn.style.display = 'none');
    }
    
    // Update Title
    const h1 = document.querySelector('h1');
    if (h1) h1.innerText = 'Viewing Cheque Details';
    
    // Change Back button text
    const backBtn = document.querySelector('.breadcrumb-app a');
    if (backBtn) backBtn.innerText = '← Back to Case View';
});
</script>
<?php endif; ?>

<!-- Pre-Submit Checklist Modal -->
<div class="modal fade" id="checklistModal" tabindex="-1" aria-labelledby="checklistModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header bg-primary text-white">
        <h5 class="modal-title" id="checklistModalLabel">Maker Pre-Submit Checklist</h5>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <p>Please confirm the following before saving this case:</p>
        <div class="form-check mb-2">
          <input class="form-check-input checklist-item" type="checkbox" id="check1">
          <label class="form-check-label" for="check1">Verified the Account Holder Name matches the cheque.</label>
        </div>
        <div class="form-check mb-2">
          <input class="form-check-input checklist-item" type="checkbox" id="check2">
          <label class="form-check-label" for="check2">Verified the Account Balance Status is accurate.</label>
        </div>
        <div class="form-check mb-2">
          <input class="form-check-input checklist-item" type="checkbox" id="check3">
          <label class="form-check-label" for="check3">Verified the Cheque Amount and Dishonour Reason.</label>
        </div>
        <div class="form-check mb-2">
          <input class="form-check-input checklist-item" type="checkbox" id="check4">
          <label class="form-check-label" for="check4">Verified Presentment Dates are correct.</label>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn btn-primary" id="confirmSubmitBtn" disabled>Confirm & Save</button>
      </div>
    </div>
  </div>
</div>

<script>
    function showChecklistModal(e) {
        // Only show checklist if we are not in view mode
        <?php if (($_GET['action'] ?? '') === 'view'): ?>
            return true; 
        <?php endif; ?>

        e.preventDefault();
        const modalEl = document.getElementById('checklistModal');
        let modal = bootstrap.Modal.getInstance(modalEl);
        if (!modal) {
            modal = new bootstrap.Modal(modalEl);
        }
        modal.show();
        
        const checkboxes = document.querySelectorAll('.checklist-item');
        const confirmBtn = document.getElementById('confirmSubmitBtn');
        
        checkboxes.forEach(cb => {
            cb.checked = false; // reset
            cb.addEventListener('change', () => {
                const allChecked = Array.from(checkboxes).every(c => c.checked);
                confirmBtn.disabled = !allChecked;
            });
        });
        confirmBtn.disabled = true;
        
        confirmBtn.onclick = function() {
            modal.hide();
            const form = document.getElementById('chequeMainForm');
            form.onsubmit = null; 
            form.submit();
        };
        return false;
    }
</script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const adInput = document.getElementById('chequeDateInput');
    const bsInput = document.getElementById('chequeDateInputBs');

    if (adInput && bsInput) {
        adInput.addEventListener('change', function() {
            if (this.value) {
                fetch('ajax-convert-date.php?from=AD&date=' + encodeURIComponent(this.value))
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.converted) {
                            bsInput.value = data.converted;
                        }
                    })
                    .catch(err => console.error('Error converting date:', err));
            }
        });
        
        // Also listen to BS input just in case it is modified manually
        bsInput.addEventListener('change', function() {
            if (this.value && this.value.match(/^\d{4}-\d{2}-\d{2}$/)) {
                fetch('ajax-convert-date.php?from=BS&date=' + encodeURIComponent(this.value))
                    .then(response => response.json())
                    .then(data => {
                        if (data.success && data.converted) {
                            adInput.value = data.converted;
                        }
                    })
                    .catch(err => console.error('Error converting date:', err));
            }
        });
    }
});
</script>
<?php if ($isModal): require_once 'includes/modal-footer.php'; else: require_once 'includes/footer.php'; endif; ?>


