import 'package:e_class/extensions.dart';
import 'package:flutter/foundation.dart';

import 'phonetic_data.dart';
import 'settings.dart';

/// Manages the generation of spanish syllables based on settings.
class SyllableHandler with PhoneticData {
  final SettingsController _settings;

  late final Map<String, ValueNotifier<bool>> userPrefs;

  static const minimumSyllableListLength = 10;

  SyllableHandler(this._settings);

  /// Loads user preferences for every syllable.
  Future<void> initialize() async {
    userPrefs = await _settings.getSyllablesPrefs();
  }

  /// Selects enabled vowels.
  List<String> filterVowels() {
    return vowels
        .where((vowel) => userPrefs[vowel]?.value ?? false)
        .map((vowel) => vowel.toUpperCase())
        .toList();
  }

  /// Selects simple syllables (consonant + vowel).
  List<String> filterSimpleSyllables() {
    List<String> selected = [];
    for (var consonant in consonants) {
      if (userPrefs[consonant]?.value ?? false) {
        selected.addAll(vowels.map((vowel) => consonant.toUpperCase() + vowel));
      }
    }
    return selected;
  }

  /// Selects syllables where the consonant is the last letter.
  List<String> filterEndingSyllables() {
    List<String> selected = [];
    for (var consonant in ending) {
      if (userPrefs["v$consonant"]?.value ?? false) {
        selected.addAll(vowels.map((vowel) => vowel.toUpperCase() + consonant));
      }
    }
    return selected;
  }

  /// Selects digraphs and diphthongs.
  List<String> filterDigraphsAndDiphthongs(
      Map<String, List<String>> digraphsAndDiphthongs) {
    List<String> selected = [];
    for (var key in digraphsAndDiphthongs.keys) {
      if (userPrefs[key]?.value ?? false) {
        selected.addAll(digraphsAndDiphthongs[key]!);
      }
    }
    return selected;
  }

  /// Selects consonant clusters.
  List<String> filterGroupedSyllables() {
    List<String> selected = [];
    for (var consonant in grouped) {
      if (userPrefs[consonant]?.value ?? false) {
        selected.addAll(vowels.map((vowel) => consonant.capitalize() + vowel));
      }
    }
    return selected;
  }

  /// Selects all enabled syllables.
  List<String> filterAllSyllables() {
    List<String> syllables = filterVowels() +
        filterSimpleSyllables() +
        filterEndingSyllables() +
        filterDigraphsAndDiphthongs(digraphsSyllables) +
        filterDigraphsAndDiphthongs(diphthongSyllables) +
        filterGroupedSyllables();
    syllables = syllables.sortCaseInsensitive();
    if (syllables.length < minimumSyllableListLength) {
      // Add vowels in the case that not enough syllables were enabled.
      var safeSyllables = vowels.map((vowel) => vowel.toUpperCase());
      for (var i = 0; i < 2; i++) {
        syllables.addAll(safeSyllables);
      }
    }
    return syllables;
  }
}
