import 'dart:math';

/// Gets a specified number of random list elements.
extension ListItemsExtension<E> on List<E> {
  List<E> randomItems(int count) => (this..shuffle()).take(count).toList();
}

/// Get a single random item.
extension FirstItem<E> on List<E> {
  E get randomItem => this[Random().nextInt(length)];
}

/// Makes uppercase the first letter of a string and lowercase all the rest.
extension StringCasingExtension on String {
  String capitalize() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

/// Sorts alphabetically lists of strings.
extension SortingListExtension on List<String> {
  List<String> sortCaseInsensitive() =>
      toList()..sort((a, b) => a.toUpperCase().compareTo(b.toUpperCase()));
}

/// Whether this variable is null.
extension Variable<T> on T {
  bool get isNull => this == null;
}