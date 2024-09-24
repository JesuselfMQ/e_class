import 'phonetic_data.dart';

class PhoneticElement with PhoneticData {
  final String element;

  late final bool isVowel;

  late final bool isConsonant;

  late final bool isDiphthong;

  late final bool isGrouped;

  late final bool isEnding;

  late final bool isDigraph;

  late final String singleLetter;

  late final String filename;

  PhoneticElement(this.element) {
    isVowel = vowels.contains(element);
    isConsonant = consonants.contains(element);
    isDiphthong = diphthongs.contains(element);
    isGrouped = grouped.contains(element);
    isEnding = ending.contains(element);
    isDigraph = digraphs.sublist(1).contains(element);
    singleLetter = element.replaceFirst("v", "");
    filename = isEnding || isDiphthong ? "$singleLetter$extension" : element;
  }
}
