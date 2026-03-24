import 'package:audio_service/audio_service.dart';
import 'package:example/rife.dart';
import 'package:example/track.dart';
import 'package:flutter/material.dart';
import 'package:media_player/media_player.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShapeeMediaPlayer.init(
    audioServiceConfig: const AudioServiceConfig(androidNotificationChannelId: 'com.example.audio_player', androidNotificationChannelName: 'Music playback'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ShapeeMediaPlayer _player = ShapeeMediaPlayer.instance;

  bool _isShuffled = false;
  LoopMode _loopMode = LoopMode.none;
  double _volume = 1.0;

  @override
  void initState() {
    super.initState();
    _isShuffled = _player.isShuffled;
    _loopMode = _player.loopMode;
    _volume = _player.getVolume();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return StreamBuilder(
      stream: _player.currentItemStream,
      builder: (context, currentItem) => StreamBuilder(
        stream: _player.playbackState,
        builder: (context, state) {
          final playingItem = currentItem.data;
          final playing = state.data?.playing ?? false;

          return Scaffold(
            appBar: AppBar(
              // TRY THIS: Try changing the color here to a specific color (to
              // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
              // change color while the other colors stay the same.
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: const Text('Example player'),
            ),
            body: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  sliver: SliverToBoxAdapter(child: Text('Tracks', style: textTheme.titleSmall)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  sliver: SliverList.separated(
                    itemCount: tracks.length,
                    itemBuilder: (context, index) {
                      final track = tracks[index];
                      return Card(
                        child: ListTile(title: Text(track.title), subtitle: Text(track.albumName), trailing: playing && playingItem is AudioPlayerItemMusic && playingItem.id == '${track.id}' ? const Icon(Icons.play_arrow) : null, onTap: () => _playTracks(tracks, index)),
                      );
                    },
                    separatorBuilder: (_, index) => const SizedBox(height: 16),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  sliver: SliverToBoxAdapter(child: Text('Rifes', style: textTheme.titleSmall)),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                  sliver: SliverList.separated(
                    itemCount: rifes.frequencies.length,
                    itemBuilder: (context, index) {
                      final rife = rifes.frequencies[index];
                      return Card(
                        child: ListTile(title: Text('${rife.toInt()}Hz'), subtitle: Text(rifes.title), trailing: playing && playingItem is AudioPlayerItemFrequency && playingItem.frequency == rife ? const Icon(Icons.play_arrow) : null, onTap: () => _playRifes(rifes, index)),
                      );
                    },
                    separatorBuilder: (_, index) => const SizedBox(height: 16),
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom)),
              ],
            ),

            bottomNavigationBar: playingItem == null
                ? null
                : StreamBuilder(
                    stream: _player.positionStream,
                    builder: (context, position) => Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 16),
                      color: Theme.of(context).colorScheme.primary,
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(value: position.data == null || position.data!.$2.inMilliseconds == 0 ? 0.0 : position.data!.$1.inMilliseconds / position.data!.$2.inMilliseconds, backgroundColor: Colors.transparent, valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.onPrimary)),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Now Playing', style: textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                                        Text(playingItem.title, style: textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                                        Text(playingItem.albumTitle ?? '', style: textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimary)),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final newShuffle = !_isShuffled;
                                      _player.setShuffled(newShuffle);
                                      setState(() => _isShuffled = newShuffle);
                                    },
                                    icon: Icon(Icons.shuffle, color: _isShuffled ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5)),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (playing) {
                                        _player.pause();
                                      } else {
                                        _player.play();
                                      }
                                    },
                                    icon: Icon(playing ? Icons.pause : Icons.play_arrow, color: Theme.of(context).colorScheme.onPrimary),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      final newMode = _loopMode == LoopMode.none ? LoopMode.all : (_loopMode == LoopMode.all ? LoopMode.one : LoopMode.none);
                                      _player.setLoopMode(newMode);
                                      setState(() => _loopMode = newMode);
                                    },
                                    icon: Icon(
                                      _loopMode == LoopMode.one
                                          ? Icons
                                                .repeat_one //
                                          : Icons.repeat,
                                      color: _loopMode != LoopMode.none ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                children: [
                                  Icon(Icons.volume_down, color: Theme.of(context).colorScheme.onPrimary),
                                  Expanded(
                                    child: Slider(
                                      value: _volume,
                                      activeColor: Theme.of(context).colorScheme.onPrimary,
                                      inactiveColor: Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.3),
                                      onChanged: (val) {
                                        setState(() => _volume = val);
                                        _player.setVolume(val);
                                      },
                                    ),
                                  ),
                                  Icon(Icons.volume_up, color: Theme.of(context).colorScheme.onPrimary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _playRifes(Rife rife, int index) async {
    await _player.playQueue(
      rife.frequencies.map((e) => AudioPlayerItem.frequency(title: '${e.toInt()}Hz', frequency: e, albumTitle: rife.title)).toList(),
      playIndex: index,
    );
  }

  Future<void> _playTracks(List<Track> tracks, int index) async {
    await _player.playQueue(
      tracks.map((e) => AudioPlayerItem.music(id: '${e.id}', title: e.title, url: e.trackUrl, albumTitle: e.albumName, coverImage: e.albumArtUrl)).toList(),
      playIndex: index,
    );
  }
}
