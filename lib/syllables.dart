import "dart:math";
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';

Future<List<String>> generateSpanishSyllables() async {
  final prefs = await SharedPreferences.getInstance();
  var vowel = "v";
  var cLetter = "c";
  var rLetter = "r";
  var vowels = "eiuoa";
  var consonants = "lrmpstndcbvfjgñyzhkwxq";
  var iv = ["Ia", "Ie", "Io", "Iu"];
  var uv = ["Ua", "Ue", "Ui", "Uo"];
  var vy = ["Ay", "Ey", "Oy", "Uy"];
  List<String> syllables = [];

  if (prefs.getBool("iv") == true) {
      syllables = syllables + iv;
    }
  if (prefs.getBool("uv") == true) {
      syllables = syllables + uv;
    }
  if (prefs.getBool("vy") == true) {
      syllables = syllables + vy;
    }

  for (var v in vowels.runes) {
    bool isVowelEnabled = prefs.getBool(String.fromCharCode(v)) ?? true;
    if (isVowelEnabled) {
      syllables.add(String.fromCharCode(v).toUpperCase());
    }
  }
  for (var c in consonants.runes) {
    bool isEnabled = prefs.getBool(String.fromCharCode(c)) ?? true;
    if (isEnabled){
      if (String.fromCharCode(c) == "q") {
      for (var v in vowels.runes.take(2)) {
        syllables.add(String.fromCharCode(c).toUpperCase() + vowels[2] + String.fromCharCode(v));
      }
      continue;
      }
      for (var v in vowels.runes) {
        syllables.add(String.fromCharCode(c).toUpperCase() + String.fromCharCode(v));
        if (String.fromCharCode(c) == "l" || String.fromCharCode(c) == "n" || String.fromCharCode(c) == "s" || String.fromCharCode(c) == "r" || String.fromCharCode(c) == "m") {
          if (prefs.getBool(vowel + String.fromCharCode(c)) == true){
          syllables.add(String.fromCharCode(v).toUpperCase() + String.fromCharCode(c));
          }
        }
        if (String.fromCharCode(c) == "r" || String.fromCharCode(c) == "l") {
          if (prefs.getBool(String.fromCharCode(c) + String.fromCharCode(c)) == true){
            syllables.add(String.fromCharCode(c) + String.fromCharCode(c) + String.fromCharCode(v));
          }
        }
        if (String.fromCharCode(c) == "h") {
          if (prefs.getBool(cLetter + String.fromCharCode(c)) == true){
            syllables.add(consonants[8].toUpperCase() + String.fromCharCode(c) + String.fromCharCode(v));
          }
        }
        if (String.fromCharCode(c) == "d") {
          if (prefs.getBool(String.fromCharCode(c) + rLetter) == true) {
            syllables.add(String.fromCharCode(c).toUpperCase() + consonants[1] + String.fromCharCode(v));
          }
        }
      }
      if (String.fromCharCode(c) == "g") {
        if (prefs.getBool(String.fromCharCode(c) + vowels[2]) == true) {
          for (var v in vowels.runes.take(2)) {
            syllables.add(String.fromCharCode(c).toUpperCase() + vowels[2] + String.fromCharCode(v));
          }
        }
      }
      if (String.fromCharCode(c) == "b" || String.fromCharCode(c) == "p" || String.fromCharCode(c) == "c" || String.fromCharCode(c) == "f" || String.fromCharCode(c) == "g" || String.fromCharCode(c) == "t") {
        for (var cs in consonants.runes.take(2)) {
          if (prefs.getBool(String.fromCharCode(c) + String.fromCharCode(cs)) == true) {
            for (var v in vowels.runes) {
              syllables.add(String.fromCharCode(c).toUpperCase() + String.fromCharCode(cs) + String.fromCharCode(v));
            }
          }
        }
      }
    }
  }

  ///syllables.addAll(diphthongs);
  syllables.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  if(syllables.isEmpty) {
    syllables.add("A");
  }

  return syllables;
}

List<String> getRandomSyllables(List<String> sounds) {
  List<String> selected = [];
  for (int i = 0; i < 10; i++) {
    selected.add(sounds[Random().nextInt(sounds.length)]);
  }
  return selected;
}