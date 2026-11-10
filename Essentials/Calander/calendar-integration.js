/**
 * Nepali Calendar Widget Client Integration Library
 * Provides popover toggling, dual input auto-synchronization, and server-side conversion binding
 */

function toggleNepaliDatePicker(targetId) {
    const el = document.getElementById('picker_' + targetId);
    if (!el) return;

    // Sync iframe src if an existing AD date is present
    let adInputId = targetId.endsWith('Bs') ? targetId.slice(0, -2) : targetId;
    const adInput = document.getElementById(adInputId);
    const iframe = el.querySelector('iframe');

    if (adInput && adInput.value && iframe) {
        if (/^\d{4}-\d{2}-\d{2}$/.test(adInput.value)) {
            const newSrc = 'nepali_calendar_widget.php?target=' + targetId + '&date=' + adInput.value;
            if (!iframe.src.includes('date=' + adInput.value)) {
                iframe.src = newSrc;
            }
        }
    }

    // Close any other open datepickers
    document.querySelectorAll('[id^="picker_"]').forEach(picker => {
        if (picker.id !== 'picker_' + targetId) picker.classList.remove('show');
    });

    el.classList.toggle('show');
}

// Callback invoked by nepali_calendar_widget.php inside the iframe
window.onNepaliCalendarSelect = function(adDate, bsDate, targetId) {
    let adInputId = targetId;
    let bsInputId = targetId + 'Bs';

    if (targetId.endsWith('Bs')) {
        bsInputId = targetId;
        adInputId = targetId.slice(0, -2);
    }

    const adInput = document.getElementById(adInputId);
    if (adInput) {
        adInput.value = adDate;
        adInput.dispatchEvent(new Event('input', { bubbles: true }));
        adInput.dispatchEvent(new Event('change', { bubbles: true }));
    }

    const bsInput = document.getElementById(bsInputId);
    if (bsInput) {
        bsInput.value = bsDate;
        bsInput.dispatchEvent(new Event('input', { bubbles: true }));
        bsInput.dispatchEvent(new Event('change', { bubbles: true }));
    }

    const picker = document.getElementById('picker_' + targetId);
    if (picker) picker.classList.remove('show');

    const adPicker = document.getElementById('picker_' + adInputId);
    if (adPicker) adPicker.classList.remove('show');
};

// Close picker when clicking outside
document.addEventListener('click', function(e) {
    if (!e.target.closest('[id^="picker_"]') && !e.target.matches('button') && !e.target.matches('input[onclick*="toggleNepaliDatePicker"]')) {
        document.querySelectorAll('[id^="picker_"]').forEach(picker => picker.classList.remove('show'));
    }
});

// Real-time live date conversion when user manually types in YYYY-MM-DD
document.addEventListener('input', function(e) {
    if (e.target.tagName === 'INPUT' && e.target.hasAttribute('onclick') && e.target.getAttribute('onclick').includes('toggleNepaliDatePicker')) {
        const val = e.target.value.trim();
        if (/^\d{4}-\d{2}-\d{2}$/.test(val)) {
            const targetId = e.target.id;
            let query = targetId.endsWith('Bs') ? ('?bs=' + val) : ('?ad=' + val);

            fetch('convert-date.php' + query)
                .then(res => res.json())
                .then(data => {
                    if (data.ad && data.bs) {
                        let adInputId = targetId.endsWith('Bs') ? targetId.slice(0, -2) : targetId;
                        let bsInputId = adInputId + 'Bs';

                        if (targetId.endsWith('Bs')) {
                            const adInput = document.getElementById(adInputId);
                            if (adInput && adInput.value !== data.ad) {
                                adInput.value = data.ad;
                                adInput.dispatchEvent(new Event('input', { bubbles: true }));
                            }
                        } else {
                            const bsInput = document.getElementById(bsInputId);
                            if (bsInput && bsInput.value !== data.bs) {
                                bsInput.value = data.bs;
                                bsInput.dispatchEvent(new Event('input', { bubbles: true }));
                            }
                        }
                    }
                })
                .catch(err => console.error('Date conversion error:', err));
        }
    }
});
