# Banking Essentials - Converters Suite

This directory contains standalone, highly optimized converters for Nepali banking software:
1. **Font Converters**: Preeti, Kantipur, PCS Nepali to Devanagari Unicode (and reverse).
2. **Date Converters**: Gregorian (AD) ↔ Bikram Sambat (BS) date conversion in JavaScript and PHP.
3. **Number to Words Converters**: Monetary figures to South Asian Lakhs and Crores in Nepali and English.

---

## 📁 Files Included

| File | Purpose | Environment |
| :--- | :--- | :--- |
| `preeti-converter-core.js` | Full bi-directional Preeti, Kantipur, PCS Nepali to Unicode converter engine. | JavaScript (Browser / Node) |
| `bidirectional-converter.html` | Interactive web UI for testing and live conversion between Preeti and Unicode. | HTML / Browser |
| `PreetiConverter.php` | Server-side PHP conversion class `PreetiConverter::toUnicode($str)`. | PHP (>= 7.4) |
| `date-converter-core.js` | AD ↔ BS conversion engine covering years 1970 BS to 2100 BS. | JavaScript (Browser) |
| `date-converter-ui.html` | Standalone UI tool to convert dates between AD and BS interactively. | HTML / Browser |
| `NepaliDateConverter.php` | PHP class & function for AD ↔ BS conversion based on anchor tables. | PHP (>= 7.4) |
| `number-to-words.js` | Converts monetary numeric values to words in Nepali (Lakh/Crore) & English. | JavaScript (Browser) |
| `NumberToNepaliWords.php` | Server-side PHP converter for cheques, vouchers, and legal memos. | PHP (>= 7.4) |
| `fonts/` | Contains `preeti.ttf` and `Preeti Normal.otf` for native typing. | Fonts |

---

## 💡 Code Examples

### 1. Preeti to Unicode in PHP
```php
require_once 'PreetiConverter.php';

$rawPreeti = "s7df8f}+"; // Represents "काठमाडौँ" in Preeti font
$unicodeText = PreetiConverter::toUnicode($rawPreeti);
echo $unicodeText; // Output: काठमाडौँ
```

### 2. Preeti to Unicode in JavaScript
```html
<script src="preeti-converter-core.js"></script>
<script>
    const unicode = PreetiConverterCore.toUnicode("s7df8f}+", "preeti");
    console.log(unicode); // Output: काठमाडौँ
</script>
```

### 3. AD to BS Date Conversion in JavaScript
```html
<script src="date-converter-core.js"></script>
<script>
    // Convert AD to BS
    const converter = new DateConverter(2026, 10, 11);
    const bsDate = converter.convertToBS().toBSString(); // e.g. "2083-6-25"
    
    // Convert BS to AD
    const adDate = new DateConverter(2083, 6, 25).convertToAD().toADString();
</script>
```

### 4. Cheque Amount to Words in PHP & JS
```php
require_once 'NumberToNepaliWords.php';

echo NumberToNepaliWords::toNepaliWords(1525000);
// Output: पन्ध्र लाख पच्चीस हजार रूपैयाँ मात्र
```

```javascript
// In browser:
const wordsNp = NepaliAmountConverter.toNepali(2500000);
// Output: "पच्चीस लाख रूपैयाँ मात्र"
const wordsEn = NepaliAmountConverter.toEnglish(2500000);
// Output: "Twenty Five Lakh Rupees Only"
```
