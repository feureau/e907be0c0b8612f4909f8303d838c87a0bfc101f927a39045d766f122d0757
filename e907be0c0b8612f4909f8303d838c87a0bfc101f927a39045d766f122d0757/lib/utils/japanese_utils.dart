/// Utility functions for Japanese language processing
class JapaneseUtils {
  /// Converts hiragana to katakana
  static String hiraganaToKatakana(String hiragana) {
    const hiraStart = 0x3041; // ぁ
    const hiraEnd = 0x3096; // ゖ
    const kataStart = 0x30A1; // ァ

    final result = StringBuffer();
    for (var i = 0; i < hiragana.length; i++) {
      final code = hiragana.codeUnitAt(i);
      if (code >= hiraStart && code <= hiraEnd) {
        result.writeCharCode(code - hiraStart + kataStart);
      } else {
        result.write(hiragana[i]);
      }
    }
    return result.toString();
  }

  /// Converts katakana to hiragana
  static String katakanaToHiragana(String katakana) {
    const kataStart = 0x30A1; // ァ
    const kataEnd = 0x30F6; // ヶ
    const hiraStart = 0x3041; // ぁ

    final result = StringBuffer();
    for (var i = 0; i < katakana.length; i++) {
      final code = katakana.codeUnitAt(i);
      if (code >= kataStart && code <= kataEnd) {
        result.writeCharCode(code - kataStart + hiraStart);
      } else {
        result.write(katakana[i]);
      }
    }
    return result.toString();
  }

  /// Checks if a character is hiragana
  static bool isHiragana(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0x3040 && code <= 0x309F;
  }

  /// Checks if a character is katakana
  static bool isKatakana(String char) {
    final code = char.codeUnitAt(0);
    return code >= 0x30A0 && code <= 0x30FF;
  }

  /// Checks if a character is kanji
  static bool isKanji(String char) {
    final code = char.codeUnitAt(0);
    return (code >= 0x4E00 && code <= 0x9FFF) || // CJK Unified Ideographs
        (code >= 0x3400 && code <= 0x4DBF) || // CJK Extension A
        (code >= 0x20000 && code <= 0x2A6DF) || // CJK Extension B
        (code >= 0x2A700 && code <= 0x2B73F) || // CJK Extension C
        (code >= 0x2B740 && code <= 0x2B81F) || // CJK Extension D
        (code >= 0x2B820 && code <= 0x2CEAF); // CJK Extension E
  }

  /// Counts the number of kanji in a string
  static int countKanji(String text) {
    int count = 0;
    for (var i = 0; i < text.length; i++) {
      if (isKanji(text[i])) {
        count++;
      }
    }
    return count;
  }

  /// Generates furigana ruby text for mixed kanji/hiragana text
  static List<Map<String, String>> generateFurigana(String text, String reading) {
    // This is a simplified implementation
    // A full implementation would require a dictionary and morphological analysis
    final result = <Map<String, String>>[];
    
    // For demonstration, we'll just pair characters with readings
    // In a real implementation, you would use a dictionary service
    if (text.length <= reading.length) {
      for (var i = 0; i < text.length; i++) {
        result.add({
          'character': text[i],
          'reading': reading.length > i ? reading[i] : '',
        });
      }
    } else {
      // Text is longer than reading, probably contains hiragana/katakana
      // This would require proper parsing in a real implementation
      for (var i = 0; i < text.length; i++) {
        final char = text[i];
        result.add({
          'character': char,
          'reading': isKanji(char) ? 'kanji' : char,
        });
      }
    }
    
    return result;
  }

  /// Gets the JLPT level classification for common Japanese words
  /// This is a simplified implementation with sample data
  static int getJlptLevel(String word) {
    // Sample JLPT level mappings (simplified)
    final jlptN5Words = {
      'こんにちは', 'ありがとう', 'すみません', 'はい', 'いいえ',
      '食べる', '飲む', '行く', '来る', '見る', '聞く', '話す', '読む', '書く'
    };
    
    final jlptN4Words = {
      '大きい', '小さい', '新しい', '古い', '高い', '安い', '難しい', '易しい',
      '学生', '先生', '会社', '時間', '人', '日', '年', '月'
    };
    
    if (jlptN5Words.contains(word)) {
      return 5;
    } else if (jlptN4Words.contains(word)) {
      return 4;
    } else {
      // Default to N3 for unknown words in this simplified implementation
      return 3;
    }
  }
}