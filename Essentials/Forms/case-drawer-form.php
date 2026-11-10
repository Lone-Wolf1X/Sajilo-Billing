<?php
require_once 'includes/functions.php';

$profileId = $_GET['profile_id'] ?? '';
$caseId    = $_GET['case_id'] ?? '';
$drawerType = $_GET['type'] ?? '';
$isModal   = isset($_GET['modal']); // iframe/modal embed mode

$profile = getProfileById($profileId);
if (!$profile) {
    die('<div style="font-family:sans-serif; padding:40px;">Profile not found. <a href="index.php">Go back</a></div>');
}

$case = getCaseById($profileId, $caseId);
if (!$case) {
    die('<div style="font-family:sans-serif; padding:40px;">Case not found. <a href="profile.php?id=' . h($profileId) . '">Go back</a></div>');
}

if (empty($drawerType) && !empty($case['drawer_type'])) {
    $drawerType = $case['drawer_type'];
}

$currentUser = getCurrentUser();
$isView = (isset($_GET['action']) && $_GET['action'] === 'view');
if (!$isView && (!in_array($currentUser['role'] ?? '', ['Maker']) || !empty($case['is_locked']))) {
    die('<div style="font-family:sans-serif; padding:40px; color:#dc2626;"><h3>🔒 Case is Locked</h3><p>This case is currently locked for review/verification and cannot be modified.</p><a href="case-view.php?profile_id='.urlencode($profileId).'&case_id='.urlencode($caseId).'">← Back to Case View</a></div>');
}

if (!in_array($drawerType, ['Individual', 'Institutional', 'Joint'])) {
    die('Invalid drawer type.');
}

?>
<?php if (!$isModal): ?>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Drawer Details — <?= h($case['case_id']) ?></title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="assets/vendor/css/bootstrap.min.css" rel="stylesheet">
<link href="assets/style.css" rel="stylesheet">
<style>
.main-card { box-shadow: none !important; border: 1px solid var(--border) !important; border-radius: 12px !important; margin-bottom:0 !important; }
.page-wrapper { padding: 0 !important; }
</style>
</head>
<body>
<?php require_once 'includes/header.php'; ?>
<?php else: ?>
<?php require_once 'includes/modal-header.php'; ?>
<?php endif; ?>



<div class="page-wrap">
  <div class="breadcrumb-app">
      <?php if ($isView || $caseId): ?>
          <a href="case-view.php?profile_id=<?= h($profileId) ?>&case_id=<?= h($caseId) ?>">← Back to Case View</a>
      <?php else: ?>
          <a href="case-drawer-select.php?profile_id=<?= h($profileId) ?>&case_id=<?= h($caseId) ?>">← Back to Drawer Selection</a>
      <?php endif; ?>
  </div>

  <div class="page-header">
    <div>
      <h1>Enter Drawer Details (<?= h($drawerType) ?>)</h1>
      <div class="subtitle">Case: <?= h($case['case_id']) ?> · Profile: <?= h($profile['profile_id']) ?></div>
    </div>
  </div>

  <div class="card-app p-0">
     <form id="<?= $drawerType === 'Institutional' ? 'unitForm' : 'applicantForm' ?>" onsubmit="return false;">
     <?php 
       if ($drawerType === 'Institutional') {
           include 'includes/applicant-institutional.php';
       } else {
           include 'includes/applicant-individual.php';
           if ($drawerType === 'Joint') {
               include 'includes/applicant-joint-holders.php';
           }
       }
     ?>
        <div class="p-4 border-top mt-4 d-flex justify-content-end gap-3" style="background-color: #f8f9fa; border-bottom-left-radius: 12px; border-bottom-right-radius: 12px;">
            <button type="button" class="btn btn-outline-secondary px-4 py-2 fw-bold" id="cancelBtn">Cancel</button>
            <button type="submit" class="btn btn-primary px-5 py-2 fw-bold shadow-sm">Save Drawer Details</button>
        </div>
     </form>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', () => {
    const formContainer = document.getElementById('applicantForm') || document.getElementById('unitForm');
    const cancelBtn = formContainer ? (formContainer.querySelector('#cancelBtn') || document.querySelector('.breadcrumb-app a')) : null;
    window.drawerFormTracker = setupFormDirtyTracker(formContainer, cancelBtn);
    
    if (cancelBtn) {
        cancelBtn.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            <?php if (!empty($caseId) || $isView || isset($_GET['edit']) || isset($_GET['action'])): ?>
                window.location.href = "case-view.php?profile_id=<?= urlencode($profileId) ?>&case_id=<?= urlencode($caseId) ?>";
            <?php else: ?>
                window.location.href = "case-drawer-select.php?profile_id=<?= urlencode($profileId) ?>&case_id=<?= urlencode($caseId) ?>";
            <?php endif; ?>
        }, { capture: true });
    }
    
    // Change the form title for clarity since we are reusing the applicant form
    const h2 = formContainer.querySelector('h2');
    if (h2) {
        h2.innerText = h2.innerText.replace('Applicant', 'Drawer').replace('Unit/Company', 'Drawer Company');
    }
    
    // Change submit button text
    const btn = formContainer.querySelector('button[type="submit"]');
    if (btn) {
        btn.innerHTML = 'Save Drawer Details';
    }
    
    if (formContainer) {
        <?php if (isset($_GET['action']) && $_GET['action'] === 'view'): ?>
        // View Mode: Disable all inputs and hide submit button
        setTimeout(() => {
            const inputs = formContainer.querySelectorAll('input, select, textarea');
            inputs.forEach(i => i.disabled = true);
            if (btn) btn.style.display = 'none';
            const addBtn = formContainer.querySelector('#addAuthorizedBtn');
            if (addBtn) addBtn.style.display = 'none';
            const searchBtn = formContainer.querySelector('a[href^="search-existing.php"]');
            if (searchBtn) searchBtn.style.display = 'none';
            
            // Change alert or title to indicate view mode
            if (h2) h2.innerText = 'Viewing Drawer Details';
        }, 100);
        <?php else: ?>
        // Edit Mode: attach submit handler
        formContainer.addEventListener('submit', async (e) => {
            e.preventDefault(); // Stop native submission
            e.stopImmediatePropagation(); // Prevent other aggressive listeners (js-individual/js-institutional) from wiping data before save
            
            // Collect all inputs, selects, textareas within this form
            const inputs = formContainer.querySelectorAll('input, select, textarea');
            let data = {
                profile_id: <?= json_encode($profileId) ?>,
                case_id: <?= json_encode($caseId) ?>,
                drawer_type: <?= json_encode($drawerType) ?>
            };
            
            inputs.forEach(inp => {
                const key = inp.id || inp.name;
                if (!key) return;
                if (inp.type === 'radio') {
                    if (inp.checked) data[key] = inp.value;
                } else if (inp.type === 'checkbox') {
                    if (inp.checked) data[key] = inp.value || 'on';
                } else {
                    data[key] = inp.value;
                }
            });

            if (typeof currentUnitAuthorized !== 'undefined' && Array.isArray(currentUnitAuthorized)) {
                data['authorizedPersons'] = currentUnitAuthorized;
            }
            if (typeof currentJointHolders !== 'undefined' && Array.isArray(currentJointHolders)) {
                data['jointHolders'] = currentJointHolders;
            }
            
            // Post to save-drawer.php
            try {
                const oldText = btn ? btn.innerHTML : "Save Drawer Details";
                if (btn) {
                    btn.innerHTML = "Saving...";
                    btn.disabled = true;
                }
                
                if (window.showLoader) window.showLoader("Saving Drawer Details...", "Updating cheque drawer information");
                
                const response = await fetch('save-drawer.php', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                const result = await response.json();
                
                if (result.success) {
                    if (window.drawerFormTracker) window.drawerFormTracker.reset();
                    <?php if ($isModal): ?>
                        if (window.parent && window.parent !== window) {
                            window.parent.postMessage({ type: 'cg-form-saved' }, '*');
                        }
                    <?php else: ?>
                        window.location.href = "case-view.php?profile_id=" + encodeURIComponent(<?= json_encode($profileId) ?>) + "&case_id=" + encodeURIComponent(<?= json_encode($caseId) ?>) + "&saved=1";
                    <?php endif; ?>
                } else {
                    if (window.hideLoader) window.hideLoader();
                    if (window.notifyError) {
                        window.notifyError(result.error || 'Unknown server error', 'Save Failed');
                    } else {
                        alert('Error saving data: ' + (result.error || 'Unknown server error'));
                    }
                    if (btn) {
                        btn.innerHTML = oldText;
                        btn.disabled = false;
                    }
                }
            } catch (err) {
                if (window.hideLoader) window.hideLoader();
                if (window.notifyError) {
                    window.notifyError('Network error while saving details.', 'Connection Error');
                } else {
                    alert('Network error while saving details.');
                }
                console.error(err);
                if (btn) {
                    btn.innerHTML = "Save Drawer Details";
                    btn.disabled = false;
                }
            }
        }, true); // Use capture phase to intercept before js-individual.php / js-institutional.php
        <?php endif; ?>
    }
});
</script>

<?php 
  if ($drawerType === 'Institutional') {
      include 'includes/js-institutional.php';
  } else {
      include 'includes/js-individual.php';
      if ($drawerType === 'Joint') {
          include 'includes/js-joint-holders.php';
      }
  }
?>

<?php if (($_GET['action'] ?? '') === 'view'): ?>
<script>
document.addEventListener('DOMContentLoaded', () => {
    // Disable all inputs
    const formContainer = document.getElementById('applicantForm') || document.getElementById('unitForm');
    if (formContainer) {
        const inputs = formContainer.querySelectorAll('input, select, textarea');
        inputs.forEach(i => i.disabled = true);
        const submitBtn = formContainer.querySelector('button[type="submit"]');
        if (submitBtn) submitBtn.style.display = 'none';
        
        const addBtn = formContainer.querySelector('#addAuthorizedBtn');
        if (addBtn) addBtn.style.display = 'none';
        const searchBtn = formContainer.querySelector('a[href^="search-existing.php"]');
        if (searchBtn) searchBtn.style.display = 'none';
    }
    
    // Update Title
    const h1 = document.querySelector('h1');
    if (h1) h1.innerText = h1.innerText.replace('Enter', 'Viewing');
    
    // Change Back button text
    const backBtn = document.querySelector('.breadcrumb-app a');
    if (backBtn) backBtn.innerText = '← Back to Case View';
});
</script>
<?php endif; ?>

<?php 
$isEdit = isset($_GET['edit']) || (isset($_GET['action']) && $_GET['action'] === 'view');
if ($isEdit && $case && !empty($case['drawer_details'])) {
    $drawerJson = json_encode($case['drawer_details']);
    echo "<script>
        window.drawerData = $drawerJson;
    </script>";
}
?>
<?php 
  // Modals
  if (file_exists('includes/search-modal.php')) {
      include 'includes/search-modal.php';
  }
?>
<?php if ($isModal): require_once 'includes/modal-footer.php'; else: require_once 'includes/footer.php'; endif; ?>
<?php if (!$isModal): ?>
</body>
</html>
<?php endif; ?>
