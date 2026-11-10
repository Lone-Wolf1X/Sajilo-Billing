<?php
/**
 * South Asian Number to Words Converter (Nepali & English)
 * Converts numbers into Lakhs and Crores for Cheques, Memos, and Vouchers
 */

class NumberToNepaliWords {

    private static $nepaliWords = [
        0 => 'शून्य', 1 => 'एक', 2 => 'दुई', 3 => 'तीन', 4 => 'चार', 5 => 'पाँच',
        6 => 'छ', 7 => 'सात', 8 => 'आठ', 9 => 'नौ', 10 => 'दस',
        11 => 'एघार', 12 => 'बाह्र', 13 => 'तेह्र', 14 => 'चौध', 15 => 'पन्ध्र',
        16 => 'सोह्र', 17 => 'सत्र', 18 => 'अठार', 19 => 'उन्नाइस', 20 => 'बीस',
        21 => 'एक्काइस', 22 => 'बाइस', 23 => 'तेइस', 24 => 'चौबीस', 25 => 'पच्चिस',
        26 => 'छब्बिस', 27 => 'सत्ताइस', 28 => 'अट्ठाइस', 29 => 'उनन्तिस', 30 => 'तीस',
        31 => 'एकत्तिस', 32 => 'बत्तीस', 33 => 'तेत्तीस', 34 => 'चौँतीस', 35 => 'पैँतीस',
        36 => 'छत्तीस', 37 => 'सैँतीस', 38 => 'अड्तीस', 39 => 'उनन्चालीस', 40 => 'चालीस',
        41 => 'एकचालीस', 42 => 'बयालीस', 43 => 'त्रिचालीस', 44 => 'चौवालिस', 45 => 'पैँतालीस',
        46 => 'छयालीस', 47 => 'सत्चालीस', 48 => 'अठचालीस', 49 => 'उनन्पचास', 50 => 'पचास',
        51 => 'एकाउन्न', 52 => 'बाउन्न', 53 => 'त्रिपन', 54 => 'चौवन', 55 => 'पचपन्न',
        56 => 'छप्पन्न', 57 => 'संताउन्न', 58 => 'अन्ठाउन्न', 59 => 'उनन्साठ्ठी', 60 => 'साठ्ठी',
        61 => 'एकसाठ्ठी', 62 => 'बासाठ्ठी', 63 => 'त्रिसाठ्ठी', 64 => 'चौँसाठ्ठी', 65 => 'पैँसाठ्ठी',
        66 => 'छ्यासाठ्ठी', 67 => 'सरसाठ्ठी', 68 => 'अरसाठ्ठी', 69 => 'उनन्सत्तरी', 70 => 'सत्तरी',
        71 => 'एकहत्तर', 72 => 'बहत्तर', 73 => 'त्रिहत्तर', 74 => 'चौहत्तर', 75 => 'पचहत्तर',
        76 => 'छिहत्तर', 77 => 'सतहत्तर', 78 => 'अठहत्तर', 79 => 'उननासी', 80 => 'असी',
        81 => 'एकासी', 82 => 'बयासी', 83 => 'त्रिरासी', 84 => 'चौरासी', 85 => 'पचासी',
        86 => 'छियासी', 87 => 'सत्तासी', 88 => 'अठासी', 89 => 'उनन्नब्बे', 90 => 'नब्बे',
        91 => 'एकानब्बे', 92 => 'बयानब्बे', 93 => 'त्रियानब्बे', 94 => 'चौरान्नब्बे', 95 => 'पञ्चानब्बे',
        96 => 'छियानब्बे', 97 => 'सन्तानब्बे', 98 => 'अनठानब्बे', 99 => 'उनन्साउ'
    ];

    /**
     * Converts a monetary amount to Nepali words (e.g. "एक लाख पच्चीस हजार रूपैयाँ मात्र")
     * @param float|int|string $number
     * @return string
     */
    public static function toNepaliWords($number) {
        if ($number === null || $number === '' || !is_numeric($number)) return '';
        $num = (float)$number;
        $intPart = (int)floor(abs($num));
        $paisa = (int)round((abs($num) - $intPart) * 100);

        if ($intPart === 0 && $paisa === 0) return 'शून्य रूपैयाँ मात्र';

        $crore = (int)floor($intPart / 10000000);
        $rem = $intPart % 10000000;

        $lakh = (int)floor($rem / 100000);
        $rem = $rem % 100000;

        $thousand = (int)floor($rem / 1000);
        $rem = $rem % 1000;

        $hundred = (int)floor($rem / 100);
        $rem = $rem % 100;

        $out = [];
        if ($crore > 0) {
            $croreStr = ($crore <= 99) ? self::$nepaliWords[$crore] : self::toNepaliWordsHelper($crore);
            $out[] = $croreStr . ' करोड';
        }
        if ($lakh > 0) {
            $out[] = self::$nepaliWords[$lakh] . ' लाख';
        }
        if ($thousand > 0) {
            $out[] = self::$nepaliWords[$thousand] . ' हजार';
        }
        if ($hundred > 0) {
            $out[] = self::$nepaliWords[$hundred] . ' सय';
        }
        if ($rem > 0) {
            $out[] = self::$nepaliWords[$rem];
        }

        $res = implode(' ', $out) . ' रूपैयाँ';
        if ($paisa > 0 && isset(self::$nepaliWords[$paisa])) {
            $res .= ' ' . self::$nepaliWords[$paisa] . ' पैसा';
        }
        return trim($res) . ' मात्र';
    }

    private static function toNepaliWordsHelper($num) {
        $crore = (int)floor($num / 10000000);
        $rem = $num % 10000000;
        $lakh = (int)floor($rem / 100000);
        $rem = $rem % 100000;
        $thousand = (int)floor($rem / 1000);
        $rem = $rem % 1000;
        $hundred = (int)floor($rem / 100);
        $rem = $rem % 100;

        $out = [];
        if ($crore > 0) $out[] = ($crore <= 99 ? self::$nepaliWords[$crore] : $crore) . ' करोड';
        if ($lakh > 0) $out[] = self::$nepaliWords[$lakh] . ' लाख';
        if ($thousand > 0) $out[] = self::$nepaliWords[$thousand] . ' हजार';
        if ($hundred > 0) $out[] = self::$nepaliWords[$hundred] . ' सय';
        if ($rem > 0) $out[] = self::$nepaliWords[$rem];
        return implode(' ', $out);
    }
}

// Global convenience wrapper
if (!function_exists('numberToNepaliWords')) {
    function numberToNepaliWords($number) {
        return NumberToNepaliWords::toNepaliWords($number);
    }
}
