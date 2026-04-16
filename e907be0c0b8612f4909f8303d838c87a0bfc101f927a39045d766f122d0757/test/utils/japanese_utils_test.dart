import 'package:test/test.dart';
import '../../lib/utils/japanese_utils.dart';

void main() {
  group('JapaneseUtils', () {
    group('Character Conversion', () {
      test('should convert hiragana to katakana', () {
        final result = JapaneseUtils.hiraganaToKatakana('こんにちは');
        expect(result, equals('コンニチハ'));
      });

      test('should convert katakana to hiragana', () {
        final result = JapaneseUtils.katakanaToHiragana('コンニチハ');
        expect(result, equals('こんにちは'));
      });

      test('should preserve non-japanese characters during conversion', () {
        final original = 'こんにちは world';
        final hiraToKata = JapaneseUtils.hiraganaToKatakana(original);
        expect(hiraToKata, equals('コンニチハ world'));
        
        final kataToHira = JapaneseUtils.katakanaToHiragana('コンニチハ world');
        expect(kataToHira, equals('こんにちは world'));
      });
    });

    group('Character Detection', () {
      test('should detect hiragana characters', () {
        expect(JapaneseUtils.isHiragana('あ'), isTrue);
        expect(JapaneseUtils.isHiragana('a'), isFalse);
      });

      test('should detect katakana characters', () {
        expect(JapaneseUtils.isKatakana('ア'), isTrue);
        expect(JapaneseUtils.isKatakana('a'), isFalse);
      });

      test('should detect kanji characters', () {
        expect(JapaneseUtils.isKanji('漢'), isTrue);
        expect(JapaneseUtils.isKanji('あ'), isFalse);
        expect(JapaneseUtils.isKanji('ア'), isFalse);
      });
    });

    group('Text Analysis', () {
      test('should count kanji in text', () {
        final result = JapaneseUtils.countKanji('漢字テスト');
        expect(result, equals(2));
      });

      test('should count zero kanji in hiragana text', () {
        final result = JapaneseUtils.countKanji('ひらがなテスト');
        expect(result, equals(0));
      });

      test('should generate furigana mapping', () {
        final result = JapaneseUtils.generateFurigana('漢字', 'かんじ');
        expect(result, isNotEmpty);
        expect(result.first['character'], equals('漢'));
      });
    });

    group('Educational Utilities', () {
      test('should determine JLPT level', () {
        final level = JapaneseUtils.getJlptLevel('こんにちは');
        expect(level, greaterThan(0));
      });
    });
  });
}