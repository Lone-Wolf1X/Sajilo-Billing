/// Provides phonetic Romanized to Nepali Unicode transliteration.
/// Example: "ram" -> "राम", "namaste" -> "नमस्ते", "nepal" -> "नेपाल"
class NepaliUnicodeHelper {
  NepaliUnicodeHelper._();

  static const Map<String, String> _vowels = {
    'a': 'ा',
    'aa': 'ा',
    'i': 'ि',
    'ee': 'ी',
    'u': 'ु',
    'oo': 'ू',
    'e': 'े',
    'ai': 'ै',
    'o': 'ो',
    'au': 'ौ',
    'am': 'ं',
    'ah': 'ः',
  };

  static const Map<String, String> _initialVowels = {
    'a': 'अ',
    'aa': 'आ',
    'i': 'इ',
    'ee': 'ई',
    'u': 'उ',
    'oo': 'ऊ',
    'e': 'ए',
    'ai': 'ऐ',
    'o': 'ओ',
    'au': 'औ',
    'ri': 'ऋ',
  };

  static const Map<String, String> _consonants = {
    'k': 'क',
    'kh': 'ख',
    'g': 'ग',
    'gh': 'घ',
    'ng': 'ङ',
    'ch': 'च',
    'chh': 'छ',
    'j': 'ज',
    'jh': 'झ',
    'yn': 'ञ',
    't': 'त',
    'th': 'थ',
    'd': 'द',
    'dh': 'ध',
    'n': 'न',
    'T': 'ट',
    'Th': 'ठ',
    'D': 'ड',
    'Dh': 'ढ',
    'N': 'ण',
    'p': 'प',
    'ph': 'फ',
    'f': 'फ',
    'b': 'ब',
    'bh': 'भ',
    'm': 'म',
    'y': 'य',
    'r': 'र',
    'l': 'ल',
    'w': 'व',
    'v': 'व',
    'sh': 'श',
    'shh': 'ष',
    's': 'स',
    'h': 'ह',
    'ksha': 'क्ष',
    'tra': 'त्र',
    'gya': 'ज्ञ',
  };

  /// Common word substitutions for natural Nepali retail billing typing
  static const Map<String, String> _commonWords = {
    'namaste': 'नमस्ते',
    'pani': 'पानी',
    'dudh': 'दूध',
    'chhamal': 'चामल',
    'chamal': 'चामल',
    'chini': 'चिनी',
    'tel': 'तेल',
    'nun': 'नुन',
    'sabun': 'साबुन',
    'biskut': 'बिस्कुट',
    'dal': 'दाल',
    'ghadi': 'घडी',
    'chauchau': 'चाउचाउ',
    'chiya': 'चिया',
    'masala': 'मसाला',
    'kalam': 'कलम',
    'khata': 'खाता',
    'nagad': 'नगद',
    'udharo': 'उधारो',
    'bikkri': 'बिक्री',
    'kharid': 'खरिद',
    'grahak': 'ग्राहक',
  };

  /// Translates a single word or sentence into Nepali Unicode Devanagari.
  /// If already Devanagari, leaves unchanged.
  static String transliterate(String text) {
    if (text.isEmpty) return text;

    // Check if whole text is in common word dictionary
    final clean = text.trim().toLowerCase();
    if (_commonWords.containsKey(clean)) {
      return _commonWords[clean]!;
    }

    final words = text.split(' ');
    final convertedWords = words.map((w) {
      final wLower = w.toLowerCase();
      if (_commonWords.containsKey(wLower)) {
        return _commonWords[wLower]!;
      }
      return _transliterateWord(w);
    });

    return convertedWords.join(' ');
  }

  static String _transliterateWord(String word) {
    if (word.isEmpty) return word;

    // If word already contains Devanagari range, keep it
    if (RegExp(r'[\u0900-\u097F]').hasMatch(word)) {
      return word;
    }

    final buffer = StringBuffer();
    int i = 0;
    final len = word.length;

    while (i < len) {
      // 3-char match
      if (i + 3 <= len) {
        final sub3 = word.substring(i, i + 3).toLowerCase();
        if (_consonants.containsKey(sub3)) {
          buffer.write(_consonants[sub3]);
          i += 3;
          continue;
        }
      }

      // 2-char match
      if (i + 2 <= len) {
        final sub2 = word.substring(i, i + 2).toLowerCase();
        if (i == 0 && _initialVowels.containsKey(sub2)) {
          buffer.write(_initialVowels[sub2]);
          i += 2;
          continue;
        }
        if (_vowels.containsKey(sub2) && buffer.isNotEmpty) {
          buffer.write(_vowels[sub2]);
          i += 2;
          continue;
        }
        if (_consonants.containsKey(sub2)) {
          buffer.write(_consonants[sub2]);
          i += 2;
          continue;
        }
      }

      // 1-char match
      final char = word[i];
      final charLower = char.toLowerCase();

      if (i == 0 && _initialVowels.containsKey(charLower)) {
        buffer.write(_initialVowels[charLower]);
      } else if (_vowels.containsKey(charLower) && buffer.isNotEmpty) {
        buffer.write(_vowels[charLower]);
      } else if (_consonants.containsKey(charLower)) {
        buffer.write(_consonants[charLower]);
      } else {
        buffer.write(char);
      }
      i++;
    }

    return buffer.toString();
  }
}

