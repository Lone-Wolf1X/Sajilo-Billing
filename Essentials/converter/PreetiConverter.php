<?php
/**
 * Standalone Preeti to Unicode Converter for PHP
 * Accurate character mapping and complex conjunct post-processing rules
 */

class PreetiConverter {

    private static $charMap = [
        "÷" => "/", "v" => "ख", "r" => "च", "\"" => "ू", "~" => "ञ्", "z" => "श", "ç" => "ॐ", "f" => "ा", 
        "b" => "द", "n" => "ल", "j" => "व", "×" => "×", "V" => "ख्", "R" => "च्", "ß" => "द्म", "^" => "६", 
        "Û" => "!", "Z" => "श्", "F" => "ँ", "B" => "द्य", "N" => "ल्", "Ë" => "ङ्ग", "J" => "व्", "6" => "ट", 
        "2" => "द्द", "¿" => "रू", ">" => "श्र", ":" => "स्", "§" => "ट्ट", "&" => "७", "£" => "घ्", "•" => "ड्ड", 
        "." => "।", "«" => "्र", "*" => "८", "„" => "ध्र", "w" => "ध", "s" => "क", "g" => "न", "æ" => "“", 
        "c" => "अ", "o" => "य", "k" => "प", "W" => "ध्", "Ö" => "=", "S" => "क्", "Ò" => "¨", "_" => ")", 
        "[" => "ृ", "Ú" => "’", "G" => "न्", "ˆ" => "फ्", "C" => "ऋ", "O" => "इ", "Î" => "ङ्ख", "K" => "प्", 
        "7" => "ठ", "¶" => "ठ्ठ", "3" => "घ", "9" => "ढ", "?" => "रु", ";" => "स", "'" => "ु", "#" => "३", 
        "¢" => "द्घ", "/" => "र", "+" => "ं", "ª" => "ङ", "t" => "त", "p" => "उ", "|" => "्र", "x" => "ह", 
        "å" => "द्व", "d" => "म", "`" => "ञ", "l" => "ि", "h" => "ज", "T" => "त्", "P" => "ए", "Ý" => "ट्ठ", 
        "\\" => "्", "Ù" => ";", "X" => "ह्", "Å" => "हृ", "D" => "म्", "@" => "२", "Í" => "ङ्क", "L" => "ी", 
        "H" => "ज्", "4" => "द्ध", "±" => "+", "0" => "ण्", "<" => "?", "8" => "ड", "¥" => "र्‍", "$" => "४", 
        "¡" => "ज्ञ्", "," => ",", "©" => "र", "(" => "९", "‘" => "ॅ", "u" => "ग", "q" => "त्र", "}" => "ै", 
        "y" => "थ", "e" => "भ", "a" => "ब", "i" => "ष्", "‰" => "झ्", "U" => "ग्", "Q" => "त्त", "]" => "े", 
        "˜" => "ऽ", "Y" => "थ्", "Ø" => "्य", "E" => "भ्", "A" => "ब्", "M" => "ः", "Ì" => "न्न", "I" => "क्ष्", 
        "5" => "छ", "´" => "झ", "1" => "ज्ञ", "°" => "ङ्ढ", "=" => ".", "Æ" => "”", "‹" => "ङ्घ", "%" => "५", 
        "¤" => "झ्", "!" => "१", "-" => "(", "›" => "द्र", ")" => "०", "…" => "‘", "Ü" => "%"
    ];

    private static $postRules = [
        ['्ा', ''],
        ['(त्र|त्त)([^उभप]+?)m', '$1m$2'],
        ['त्रm', 'क्र'],
        ['त्तm', 'क्त'],
        ['([^उभप]+?)m', 'm$1'],
        ['उm', 'ऊ'],
        ['भm', 'झ'],
        ['पm', 'फ'],
        ['इ{', 'ई'],
        ['ि((.्)*[^्])', '$1ि'],
        ['(.[ािीुूृेैोौंःँ]*?){', '{$1'],
        ['((.्)*){', '{$1'],
        ['{', 'र्'],
        ['([ाीुूृेैोौंःँ]+?)(्(.्)*[^्])', '$2$1'],
        ['्([ाीुूृेैोौंःँ]+?)((.्)*[^्])', '्$2$1'],
        ['([ंँ])([ािीुूृेैोौः]*)', '$2$1'],
        ['ँँ', 'ँ'],
        ['ंं', 'ं'],
        ['ेे', 'े'],
        ['ैै', 'ै'],
        ['ुु', 'ु'],
        ['ूू', 'ू'],
        ['^ः', ':'],
        ['टृ', 'ट्ट'],
        ['ेा', 'ाे'],
        ['ैा', 'ाै'],
        ['अाे', 'ओ'],
        ['अाै', 'औ'],
        ['अा', 'आ'],
        ['एे', 'ऐ'],
        ['ाे', 'ो'],
        ['ाै', 'ौ']
    ];

    /**
     * Converts a Preeti encoded text string into Unicode Devanagari
     * @param string $text
     * @return string
     */
    public static function toUnicode($text) {
        if (empty($text)) return '';

        // Decode HTML entities if text was passed through form submission
        $text = html_entity_decode($text, ENT_QUOTES | ENT_HTML5, 'UTF-8');

        // If string is already pure Devanagari Unicode without ASCII letters, return trimmed
        if (preg_match('/^[\x{0900}-\x{097F}\s\d\p{P}]+$/u', $text)) {
            return trim($text);
        }

        $output = '';
        $len = mb_strlen($text, 'UTF-8');
        for ($i = 0; $i < $len; $i++) {
            $ch = mb_substr($text, $i, 1, 'UTF-8');
            $output .= isset(self::$charMap[$ch]) ? self::$charMap[$ch] : $ch;
        }

        foreach (self::$postRules as $rule) {
            $pattern = '/' . str_replace('/', '\/', $rule[0]) . '/u';
            $output = preg_replace($pattern, $rule[1], $output);
        }

        // Strip stray Latin characters if mixed with Devanagari
        if (preg_match('/[\x{0900}-\x{097F}]/u', $output) && preg_match('/[a-zA-Z]/', $output)) {
            $output = preg_replace('/[a-zA-Z]/u', '', $output);
        }

        return trim($output);
    }
}

// Global convenience wrapper
if (!function_exists('preetiToUnicode')) {
    function preetiToUnicode($text) {
        return PreetiConverter::toUnicode($text);
    }
}
