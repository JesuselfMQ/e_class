/// Stores file names of sound effects and songs.
mixin SoundFileNames {
  List<String> get songs => [
        'quiet-guitar-loop-relaxing-loop',
        'quiet-guitar-melody-delicate-loop',
        'taylorswift-x-hozier-forest-gtr-by-prorefx-loop',
        'relax-lofi-guitar-loop-sample-pack',
        'relax-lofi-guitar-loop-sample-pack_2'
      ];
  Map<String, List<String>> get sfx => {
        'win': [
          'win-1-sfx',
          'win-2-sfx',
          'win-3-sfx',
          'win-4-sfx',
          'win-5-sfx'
        ],
        'lose': ['lose-1-sfx', 'lose-2-sfx'],
        'shift': ['shift-1-sfx'],
        'greetings': ['greetings-1-sfx'],
        'celebration': ['celebration-1-sfx']
      };
}
