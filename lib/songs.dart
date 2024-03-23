const Set<Song> songs = {
  Song('quiet-guitar-loop-relaxing-loop.mp3'),
  Song('quiet-guitar-melody-delicate-loop.mp3'),
  Song('taylorswift-x-hozier-forest-gtr-by-prorefx.mp3')
};

class Song {
  final String filename;

  const Song(this.filename);

  @override
  String toString() => 'Song<$filename>';
}