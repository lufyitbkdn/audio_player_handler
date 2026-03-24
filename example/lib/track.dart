class Track {
  Track({required this.id, required this.title, required this.trackUrl, required this.albumArtUrl, required this.albumName});

  final int id;
  final String title;
  final String trackUrl;
  final String albumArtUrl;
  final String albumName;
}

final tracks = [
  Track(id: 1, title: 'Life Force the Source of Qi 100%', trackUrl: 'https://data.smexapp.com/mp3/5952/01. Life Force the Source of Qi 100.mp3', albumArtUrl: 'https://data.smexapp.com/mp3/5952/NEW_MASTER_REGENERATE.png', albumName: 'Life Force The Source of Qi'),
  Track(id: 2, title: 'Life Force the Source of Qi 50', trackUrl: 'https://data.smexapp.com/mp3/5952/02. Life Force the Source of Qi 50.mp3', albumArtUrl: 'https://data.smexapp.com/mp3/5952/NEW_MASTER_REGENERATE.png', albumName: 'Life Force The Source of Qi'),
  Track(id: 3, title: 'Life Force the Source of Qi 25', trackUrl: 'https://data.smexapp.com/mp3/5952/03. Life Force the Source of Qi 25.mp3', albumArtUrl: 'https://data.smexapp.com/mp3/5952/NEW_MASTER_REGENERATE.png', albumName: 'Life Force The Source of Qi'),
  Track(id: 4, title: 'Life Force the Source of Qi 15', trackUrl: 'https://data.smexapp.com/mp3/5952/04. Life Force the Source of Qi 15.mp3', albumArtUrl: 'https://data.smexapp.com/mp3/5952/NEW_MASTER_REGENERATE.png', albumName: 'Life Force The Source of Qi'),
];
