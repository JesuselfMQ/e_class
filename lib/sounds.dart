List<String> soundTypeToFilename(SfxType type) {
  switch(type) {
    case SfxType.win:
      return const [
        'win1.mp3',
        'win2.mp3'
      ];
    case SfxType.lose:
      return const [
        'lose1.mp3'
      ];
    case SfxType.shift:
      return const [
        'shift1.mp3'
      ];
    case SfxType.none:
      return [''];
  }
}

enum SfxType {
  win,
  lose,
  shift,
  none
}