import 'dart:math';

final random = Random();

extension ListItemsExtension<E> on List<E> {
  /// Gets a specified number of random list elements.
  List<E> randomItems(int count) => (this..shuffle()).take(count).toList();
}

extension FirstItem<E> on List<E> {
  /// Gets a single random item from a list.
  E get randomItem => this[random.nextInt(length)];
}

extension StringCasingExtension on String {
  /// Makes uppercase the first letter of a string and lowercase all the rest.
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

extension SortingListExtension on List<String> {
  /// Sorts alphabetically lists of strings.
  List<String> sortCaseInsensitive() =>
      toList()..sort((a, b) => a.toUpperCase().compareTo(b.toUpperCase()));
}
