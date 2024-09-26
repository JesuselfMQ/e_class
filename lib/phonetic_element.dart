import 'dart:collection';

import 'example_names.dart';
import 'phonetic_data.dart';

class PhoneticElement with PhoneticData {
  final String element;

  late final bool isDiphthong;

  late final bool isGrouped;

  late final bool isEnding;

  late final String singleLetter;

  late final String filename;

  late final Queue<List<String>> examples;

  late final Queue<String> filteredVowels;

  late final bool usingVowels;

  PhoneticElement(this.element) {
    isDiphthong = diphthongs.contains(element);
    isGrouped = grouped.contains(element);
    isEnding = ending.contains(element);
    singleLetter = element.replaceFirst('v', '');
    filename = isEnding || isDiphthong ? '$singleLetter$extension' : element;
    examples = _initExamples();
    filteredVowels = _filterVowels();
    usingVowels = filteredVowels.isNotEmpty;
  }

  Queue<List<String>> _initExamples() {
    var limit = 5;
    if (['qu', 'gu'].contains(element)) {
      limit = 2;
    } else if (isDiphthong) {
      limit = 4;
    }
    return Queue.of([
      for (var i = 0; i < limit; i++)
        [names[element]?[i] ?? '', '$element$i.png']
    ]);
  }

  Queue<String> _filterVowels() {
    List<String> vowels = [];
    if (isGrouped || isEnding) {
      vowels.addAll(vowelsFilename);
    } else if (element == 'gu') {
      vowels.addAll(['e$extension', 'i$extension']);
    } else if (isDiphthong) {
      vowels.addAll(vowelsFilename.where((v) {
        if (v[0] == 'i' && singleLetter == 'y') return false;
        return v[0] != singleLetter;
      }));
    }
    return Queue.of(vowels);
  }
}
