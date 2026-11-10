/**
 * Client-Side Number to Words Converter for Banking
 * Supports Nepali (South Asian Lakh/Crore) and English formatting
 */

(function (global) {
    'use strict';

    const nepaliWords = [
        '', 'एक', 'दुई', 'तीन', 'चार', 'पाँच', 'छ', 'सात', 'आठ', 'नौ', 'दस',
        'एघार', 'बाह्र', 'तेह्र', 'चौध', 'पन्ध्र', 'सोह्र', 'सत्र', 'अठार', 'उन्नाइस', 'बीस',
        'एक्काइस', 'बाइस', 'तेइस', 'चौबीस', 'पच्चिस', 'छब्बिस', 'सत्ताइस', 'अट्ठाइस', 'उनन्तिस', 'तीस',
        'एकत्तिस', 'बत्तीस', 'तेत्तीस', 'चौँतीस', 'पैँतीस', 'छत्तीस', 'सैँतीस', 'अड्तीस', 'उनन्चालीस', 'चालीस',
        'एकचालीस', 'बयालीस', 'त्रिचालीस', 'चौवालिस', 'पैँतालीस', 'छयालीस', 'सत्चालीस', 'अठचालीस', 'उनन्पचास', 'पचास',
        'एकाउन्न', 'बाउन्न', 'त्रिपन', 'चौवन', 'पचपन्न', 'छप्पन्न', 'संताउन्न', 'अन्ठाउन्न', 'उनन्साठ्ठी', 'साठ्ठी',
        'एकसाठ्ठी', 'बासाठ्ठी', 'त्रिसाठ्ठी', 'चौँसाठ्ठी', 'पैँसाठ्ठी', 'छ्यासाठ्ठी', 'सरसाठ्ठी', 'अरसाठ्ठी', 'उनन्सत्तरी', 'सत्तरी',
        'एकहत्तर', 'बहत्तर', 'त्रिहत्तर', 'चौहत्तर', 'पचहत्तर', 'छिहत्तर', 'सतहत्तर', 'अठहत्तर', 'उननासी', 'असी',
        'एकासी', 'बयासी', 'त्रिरासी', 'चौरासी', 'पचासी', 'छियासी', 'सत्तासी', 'अठासी', 'उनन्नब्बे', 'नब्बे',
        'एकानब्बे', 'बयानब्बे', 'त्रियानब्बे', 'चौरान्नब्बे', 'पञ्चानब्बे', 'छियानब्बे', 'सन्तानब्बे', 'अनठानब्बे', 'उनन्साउ'
    ];

    function numberToNepaliWords(num) {
        if (!num || isNaN(num)) return '';
        let n = Math.floor(Math.abs(Number(num)));
        if (n === 0) return 'शून्य रूपैयाँ मात्र';

        let crore = Math.floor(n / 10000000);
        let rem = n % 10000000;
        let lakh = Math.floor(rem / 100000);
        rem = rem % 100000;
        let thousand = Math.floor(rem / 1000);
        rem = rem % 1000;
        let hundred = Math.floor(rem / 100);
        rem = rem % 100;

        let out = [];
        if (crore > 0) out.push((crore <= 99 ? nepaliWords[crore] : crore) + ' करोड');
        if (lakh > 0) out.push(nepaliWords[lakh] + ' लाख');
        if (thousand > 0) out.push(nepaliWords[thousand] + ' हजार');
        if (hundred > 0) out.push(nepaliWords[hundred] + ' सय');
        if (rem > 0) out.push(nepaliWords[rem]);

        return out.join(' ') + ' रूपैयाँ मात्र';
    }

    const a = ['', 'One ', 'Two ', 'Three ', 'Four ', 'Five ', 'Six ', 'Seven ', 'Eight ', 'Nine ', 'Ten ', 'Eleven ', 'Twelve ', 'Thirteen ', 'Fourteen ', 'Fifteen ', 'Sixteen ', 'Seventeen ', 'Eighteen ', 'Nineteen '];
    const b = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    function numberToEnglishWords(num) {
        if (!num || isNaN(num)) return '';
        let n = Math.floor(Math.abs(Number(num)));
        if (n === 0) return 'Zero Rupees Only';

        function inWords(num) {
            if ((num = num.toString()).length > 9) return 'Overflow';
            let n = ('000000000' + num).substr(-9).match(/^(\d{2})(\d{2})(\d{2})(\d{1})(\d{2})$/);
            if (!n) return '';
            let str = '';
            str += (n[1] != 0) ? (a[Number(n[1])] || b[n[1][0]] + ' ' + a[n[1][1]]) + 'Crore ' : '';
            str += (n[2] != 0) ? (a[Number(n[2])] || b[n[2][0]] + ' ' + a[n[2][1]]) + 'Lakh ' : '';
            str += (n[3] != 0) ? (a[Number(n[3])] || b[n[3][0]] + ' ' + a[n[3][1]]) + 'Thousand ' : '';
            str += (n[4] != 0) ? (a[Number(n[4])] || b[n[4][0]] + ' ' + a[n[4][1]]) + 'Hundred ' : '';
            str += (n[5] != 0) ? ((str != '') ? 'and ' : '') + (a[Number(n[5])] || b[n[5][0]] + ' ' + a[n[5][1]]) : '';
            return str;
        }

        return inWords(n).trim() + ' Rupees Only';
    }

    global.NepaliAmountConverter = {
        toNepali: numberToNepaliWords,
        toEnglish: numberToEnglishWords
    };

})(typeof window !== 'undefined' ? window : this);
