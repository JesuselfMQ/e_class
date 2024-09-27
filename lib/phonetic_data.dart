/// Holds lists of basic spanish phonetic elements.
mixin PhoneticData {
  List<String> get vowels => ['a', 'e', 'i', 'o', 'u'];
  List<String> get consonants => [
        'l',
        'r',
        'n',
        's',
        'm',
        'p',
        't',
        'd',
        'c',
        'b',
        'v',
        'f',
        'j',
        'g',
        'ñ',
        'y',
        'z',
        'h',
        'k',
        'w',
        'x',
      ];

  /// Consonants that can go at the end of the syllable.
  /// Ending consonants with the representation
  /// of every vowel at the begining as a "v".
  List<String> get ending => ['vl', 'vn', 'vs', 'vr', 'vm'];

  /// Consonant sequences.
  List<String> get grouped =>
      ['pl', 'bl', 'cl', 'fl', 'gl', 'pr', 'br', 'cr', 'fr', 'tr', 'gr', 'dr'];

  List<String> get digraphs => ['gu', 'ch', 'll', 'rr', 'qu'];

  List<String> get diphthongs => ['iv', 'uv', 'vy'];

  String get extension => '-lower';

  List<String> get vowelsFilename => vowels.map((v) => v + extension).toList();

  /// Phonetic Elements in Learning order. Based on books: https://online.fliphtml5.com/nltbt/juxf/#p=1
  List<String> get phoneticComponents =>
      vowels +
      [
        'm',
        'p',
        'l',
        's',
        't',
        'n',
        'd',
        'c',
        'qu',
        'b',
        'v',
        'r',
        'rr',
        'f',
        'j',
        'g',
        'gu',
        'ñ',
        'h',
        'ch',
        'll',
        'w',
        'y',
        'z',
        'k',
        'x'
      ] +
      grouped +
      ending +
      diphthongs;

  Map<String, List<String>> get diphthongSyllables => {
        'iv': ['Ia', 'Ie', 'Io', 'Iu'],
        'uv': ['Ua', 'Ue', 'Ui', 'Uo'],
        'vy': ['Ay', 'Ey', 'Oy', 'Uy']
      };
  Map<String, List<String>> get digraphsSyllables => {
        'll': ['lla', 'lle', 'lli', 'llo', 'llu'],
        'rr': ['rra', 'rre', 'rri', 'rro', 'rru'],
        'ch': ['Cha', 'Che', 'Chi', 'Cho', 'Chu'],
        'q': ['Que', 'Qui'],
        'g': ['Gue', 'Gui']
      };
}
