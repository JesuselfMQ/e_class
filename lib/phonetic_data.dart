import 'dart:collection';

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
  /// Ending consonants with the representation
  /// of every vowel at the begining as a "v".
  List<String> get ending => ["vl", "vn", "vs", "vr", "vm"];

  /// Consonant sequences.
  List<String> get grouped =>
      ["bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "tr"];

  List<String> get digraphs => ["ch", "ll", "rr", "qu", "gu"];

  List<String> get diphthongs => ["iv", "uv", "vy"];

  /// All spanish phonetic elements.
  List<String> get allPhoneticComponents =>
      vowels + consonants + ending + grouped + digraphs + diphthongs;

  String get vowelExtension => "-single";

  List<String> get vowelsFileNames =>
      vowels.map((i) => i + vowelExtension).toList();

  /// Phonetic Elements in Learning order. Based on books: https://online.fliphtml5.com/nltbt/juxf/#p=1
  static const phoneticLearningOrder = [
    "a",
    "e",
    "i",
    "o",
    "u",
    "m",
    "p",
    "l",
    "s",
    "t",
    "n",
    "d",
    "c",
    "qu",
    "b",
    "v",
    "r",
    "rr",
    "f",
    "j",
    "g",
    "gu",
    "ñ",
    "h",
    "ch",
    "ll",
    "w",
    "y",
    "z",
    "k",
    "pl",
    "bl",
    "cl",
    "fl",
    "gl",
    "pr",
    "br",
    "cr",
    "fr",
    "tr",
    "gr",
    "dr",
    "vl",
    "vn",
    "vs",
    "x",
    "vr",
    "vm",
    "iv",
    "uv",
    "vy"
  ];

  static const Map<String, List<String>> diphthongSyllables = {
        "iv": ["Ia", "Ie", "Io", "Iu"],
        "uv": ["Ua", "Ue", "Ui", "Uo"],
        "vy": ["Ay", "Ey", "Oy", "Uy"]
      },
      digraphsSyllables = {
        "ll": ["lla", "lle", "lli", "llo", "llu"],
        "rr": ["rra", "rre", "rri", "rro", "rru"],
        "ch": ["Cha", "Che", "Chi", "Cho", "Chu"],
        "q": ["Que", "Qui"],
        "g": ["Gue", "Gui"]
      };

  Queue<String> getPhoneticFileName(String phoneticElement) {
    List<String> display = [];
    if ((grouped + ending).contains(phoneticElement)) {
      display.addAll(vowelsFileNames);
    } else if (diphthongs.contains(phoneticElement)) {
      var single = phoneticElement.replaceAll("v", "");
      print(single);
      display.addAll(vowelsFileNames.where((i) {
        if (i[0] == "i" && single == "y") return false;
        return i[0] != single;
      }));
    } else if (phoneticElement == "gu") {
      display.addAll(["e$vowelExtension", "i$vowelExtension"]);
    }
    print(display);
    return Queue.of(display);
  }
}
