/// Holds lists of basic spanish phonetic elements.
mixin PhoneticData {
  List<String> get vowels => ["a", "e", "i", "o", "u"];
  List<String> get consonants => [
        "l",
        "r",
        "n",
        "s",
        "m",
        "p",
        "t",
        "d",
        "c",
        "b",
        "v",
        "f",
        "j",
        "g",
        "ñ",
        "y",
        "z",
        "h",
        "k",
        "w",
        "x",
      ];

  /// Consonants that can go at the end of the syllable.
  List<String> get endingSingle => ["l", "r", "n", "s", "m"];

  /// Ending consonants with the representation
  /// of every vowel at the begining as a "v".
  List<String> get ending => ["vl", "vn", "vs", "vr", "vm"];

  /// Consonant sequences.
  List<String> get grouped =>
      ["bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "tr"];

  /// Spanish digraphs and some diphthongs.
  List<String> get digraphsAndDiphthongs =>
      ["ch", "ll", "rr", "qu", "gu", "iv", "uv", "vy"];

  /// All spanish phonetic elements.
  List<String> get allPhoneticComponents =>
      vowels + consonants + ending + grouped + digraphsAndDiphthongs;
}
