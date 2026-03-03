import 'dart:async';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_generator/sound_generator.dart';

import 'audio_cache.dart';
import 'data/models/audio_player_item.dart';

class ShapeeMediaPlayer {
  ShapeeMediaPlayer._();

  final _AudioPlayerHandler _audioPlayerHandler = _AudioPlayerHandler();

  static final ShapeeMediaPlayer _instance = ShapeeMediaPlayer._();

  static ShapeeMediaPlayer get instance => _instance;

  /// Call once at app startup (e.g. from main() or before first playback).
  static Future<void> init({required AudioServiceConfig audioServiceConfig}) async {
    Hive.init('cacheAudioPlayerPlus');
    await ShapeeMediaPlayer.instance._audioPlayerHandler.init();
    await AudioService.init(
      builder: () => ShapeeMediaPlayer.instance._audioPlayerHandler,
      config: audioServiceConfig,
    );
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
  }

  Stream<AudioPlayerItem?> get currentItemStream => _audioPlayerHandler._currentItemSubject.asBroadcastStream();

  Stream<(Duration position, Duration duration)> get positionStream => _audioPlayerHandler._positionSubject.asBroadcastStream();

  Stream<PlaybackState> get playbackState => _audioPlayerHandler.playbackState.asBroadcastStream();

  bool get isShuffled => _audioPlayerHandler.isShuffled;

  LoopMode get loopMode => _audioPlayerHandler.loopMode;

  /// Start playing [item], or resume if [item] is null and something is current.
  Future<void> playItem(AudioPlayerItem item) => _audioPlayerHandler.playItem(item);

  Future<void> play() async => _audioPlayerHandler.play();

  Future<void> pause() => _audioPlayerHandler.pause();

  Future<void> stop() => _audioPlayerHandler.stop();

  Future<void> skipToNext() => _audioPlayerHandler.skipToNext();

  Future<void> skipToPrevious() => _audioPlayerHandler.skipToPrevious();

  Future<void> seekTo(Duration position) => _audioPlayerHandler.seekTo(position);

  Future<void> seek(Duration position) => seekTo(position);

  Future<void> setLoopMode(LoopMode mode) => _audioPlayerHandler.setLoopMode(mode);

  Future<void> setShuffled(bool shuffled) => _audioPlayerHandler.setShuffled(shuffled);

  Future<void> playQueue(List<AudioPlayerItem> queue, {int playIndex = 0}) => _audioPlayerHandler.playQueue(queue, playIndex: playIndex);

  Future<void> addToQueue(AudioPlayerItem item) => _audioPlayerHandler.addToQueue(item);

  Future<void> removeFromQueue(AudioPlayerItem item) => _audioPlayerHandler.removeFromQueue(item);

  Future<void> clearQueue() => _audioPlayerHandler.clearQueue();

  Future<void> onTaskRemoved() => _audioPlayerHandler.onTaskRemoved();
}

class _AudioPlayerHandler extends BaseAudioHandler {
  _AudioPlayerHandler() : super();

  late final _player = AudioPlayer();
  late final _audioCache = ShappeAudioCache();

  final List<AudioPlayerItem> _queue = [];
  final List<int> _playOrder = [];
  int _playOrderIndex = 0;
  static final Random _random = Random();

  bool _sessionConfigured = false;
  Timer? _timer;
  Duration? _frequencyResumePosition;
  int elapsedSeconds = 0;

  bool isShuffled = false;
  LoopMode loopMode = LoopMode.none;

  final BehaviorSubject<AudioPlayerItem?> _currentItemSubject = BehaviorSubject.seeded(null);

  final BehaviorSubject<(Duration position, Duration duration)> _positionSubject = BehaviorSubject.seeded((Duration.zero, Duration.zero));

  Future<void> init() async {
    await _audioCache.init();
    _player.onDurationChanged.listen((duration) {
      _positionSubject.add((_positionSubject.value.$1, duration));
      _updateAudioServicePlaybackState(
        playing: _player.state == PlayerState.playing,
        position: _positionSubject.value.$1,
        duration: duration,
      );
    });

    _player.onPositionChanged.listen((pos) async {
      final duration = await _player.getDuration() ?? _positionSubject.value.$2;
      _positionSubject.add((pos, duration));
      _updateAudioServicePlaybackState(
        playing: _player.state == PlayerState.playing,
        position: pos,
        duration: duration,
      );
    });

    _player.onPlayerComplete.listen((_) => _onPlaybackCompleted());
  }

  Future<void> _ensureSession() async {
    if (_sessionConfigured) return;
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    _sessionConfigured = true;
  }

  MediaItem _itemToMediaItem(AudioPlayerItem item) {
    return item.map(
      music: (m) => MediaItem(
        id: m.id,
        title: m.title,
        album: m.albumTitle,
        artist: m.albumTitle,
        artUri: m.coverImage != null ? Uri.tryParse(m.coverImage!) : null,
      ),
      frequency: (f) => MediaItem(
        id: 'frequency_${f.title}_${f.frequency}',
        title: f.title,
        artist: f.title,
        album: f.albumTitle,
        duration: Duration(seconds: f.durationInSeconds),
        artUri: f.coverImage != null ? Uri.tryParse(f.coverImage!) : null,
      ),
    );
  }

  void _updateMediaItem(AudioPlayerItem? item) {
    mediaItem.add(item != null ? _itemToMediaItem(item) : null);
  }

  void _updateAudioServicePlaybackState({
    required bool playing,
    AudioProcessingState processingState = AudioProcessingState.ready,
    Duration position = Duration.zero,
    Duration duration = Duration.zero,
  }) {
    playbackState.add(PlaybackState(
      controls: [
        MediaControl.pause,
        MediaControl.stop,
        MediaControl.skipToNext,
        MediaControl.skipToPrevious,
      ],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
      },
      playing: playing,
      processingState: processingState,
      updatePosition: position,
      bufferedPosition: duration,
    ));
  }

  void _rebuildPlayOrder() {
    _playOrder.clear();
    _playOrder.addAll(List.generate(_queue.length, (i) => i));
    if (isShuffled && _playOrder.length > 1) {
      _playOrder.shuffle(_random);
    }
    final current = _currentItemSubject.value;
    if (current != null && _queue.isNotEmpty) {
      final idx = _queue.indexOf(current);
      if (idx != -1) {
        final orderIdx = _playOrder.indexOf(idx);
        if (orderIdx != -1) _playOrderIndex = orderIdx;
      }
    } else {
      _playOrderIndex = 0;
    }
  }

  int? _getNextPlayOrderIndex() {
    if (_playOrder.isEmpty) return null;
    switch (loopMode) {
      case LoopMode.one:
        return _playOrderIndex;
      case LoopMode.all:
        return (_playOrderIndex + 1) % _playOrder.length;
      case LoopMode.none:
        final next = _playOrderIndex + 1;
        return next < _playOrder.length ? next : null;
    }
  }

  int? _getPreviousPlayOrderIndex() {
    if (_playOrder.isEmpty) return null;
    switch (loopMode) {
      case LoopMode.one:
        return _playOrderIndex;
      case LoopMode.all:
        return (_playOrderIndex - 1 + _playOrder.length) % _playOrder.length;
      case LoopMode.none:
        final prev = _playOrderIndex - 1;
        return prev >= 0 ? prev : null;
    }
  }

  Future<void> _onPlaybackCompleted() async {
    final next = _getNextPlayOrderIndex();
    if (next == null) {
      _updateAudioServicePlaybackState(
        playing: false,
        processingState: AudioProcessingState.completed,
      );
      return;
    }
    _playOrderIndex = next;
    await playItem(_queue[_playOrder[_playOrderIndex]]);
  }

  Future<void> _playItem(AudioPlayerItem item) async {
    _timer?.cancel();
    _timer = null;
    SoundGenerator.stop();
    await item.map(
      music: (m) => _playMusic(m),
      frequency: (f) {
        _player.stop();
        Future.delayed(Duration(milliseconds: 500), () => _playFrequency(f));
      },
    );
  }

  Future<void> _playMusic(AudioPlayerItemMusic item) async {
    await _player.stop();
    final cacheFile = _audioCache.getCacheFile(item.url);
    if (cacheFile != null && cacheFile.existsSync()) {
      await _player.play(DeviceFileSource(cacheFile.path));
    } else {
      _audioCache.download([item.url]);
      await _player.play(UrlSource(item.url));
    }
  }

  Future<void> _playFrequency(AudioPlayerItemFrequency item) async {
    _timer?.cancel();
    _timer = null;
    final resumePosition = _frequencyResumePosition;
    _frequencyResumePosition = null;
    await SoundGenerator.init(96000);
    SoundGenerator.setAutoUpdateOneCycleSample(true);
    SoundGenerator.refreshOneCycleData();
    SoundGenerator.setFrequency(item.frequency);
    SoundGenerator.setVolume(1);
    SoundGenerator.play();

    final duration = Duration(seconds: item.durationInSeconds);
    final startSeconds = resumePosition != null && resumePosition.inSeconds > 0 && resumePosition.inSeconds < item.durationInSeconds ? resumePosition.inSeconds : 0;
    elapsedSeconds = startSeconds;

    void onTick(Timer t) {
      elapsedSeconds++;
      final position = Duration(seconds: elapsedSeconds);
      _positionSubject.add((position, duration));
      _updateAudioServicePlaybackState(
        playing: true,
        position: position,
        duration: duration,
      );
      if (elapsedSeconds >= item.durationInSeconds) {
        _timer?.cancel();
        _timer = null;
        SoundGenerator.stop();
        _updateAudioServicePlaybackState(
          playing: false,
          processingState: AudioProcessingState.completed,
          position: duration,
          duration: duration,
        );
        _onPlaybackCompleted();
      }
    }

    final initialPosition = Duration(seconds: startSeconds);
    _positionSubject.add((initialPosition, duration));
    _updateAudioServicePlaybackState(
      playing: true,
      position: initialPosition,
      duration: duration,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  /// Start playing [item], or resume if [item] is null and something is current.
  Future<void> playItem(AudioPlayerItem? item) async {
    final toPlay = item ?? _currentItemSubject.value;
    if (toPlay == null) return;

    await _ensureSession();

    if (_queue.isNotEmpty) {
      final queueIndex = _queue.indexOf(toPlay);
      if (queueIndex != -1) {
        final orderIdx = _playOrder.indexOf(queueIndex);
        if (orderIdx != -1) _playOrderIndex = orderIdx;
      }
    }

    _currentItemSubject.add(toPlay);
    _updateMediaItem(toPlay);
    _updateAudioServicePlaybackState(playing: true);

    if (item != null) {
      toPlay.map(
        music: (_) {},
        frequency: (_) => _frequencyResumePosition = null,
      );
    }
    await _playItem(toPlay);
  }

  @override
  Future<void> play() async {
    final current = _currentItemSubject.value;
    if (current == null) return;
    await current.map(
      music: (_) async => _player.resume(),
      frequency: (f) => _playFrequency(f),
    );
    _updateAudioServicePlaybackState(playing: true);
  }

  @override
  Future<void> pause() async {
    final current = _currentItemSubject.value;
    if (current != null) {
      current.map(
        music: (_) => _player.pause(),
        frequency: (_) {
          _frequencyResumePosition = _positionSubject.value.$1;
          _timer?.cancel();
          _timer = null;
          SoundGenerator.stop();
        },
      );
    }
    _updateAudioServicePlaybackState(playing: false);
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _frequencyResumePosition = null;
    _player.stop();
    SoundGenerator.stop();
    _positionSubject.add((Duration.zero, Duration.zero));
    _updateAudioServicePlaybackState(
      playing: false,
      processingState: AudioProcessingState.idle,
    );
  }

  @override
  Future<void> skipToNext() async {
    if (_queue.isEmpty) return;
    final next = _getNextPlayOrderIndex();
    if (next == null) {
      await stop();
      return;
    }
    _playOrderIndex = next;
    await playItem(_queue[_playOrder[_playOrderIndex]]);
  }

  @override
  Future<void> skipToPrevious() async {
    if (_queue.isEmpty) return;
    final prev = _getPreviousPlayOrderIndex();
    if (prev == null) {
      await seekTo(Duration.zero);
      return;
    }
    _playOrderIndex = prev;
    await playItem(_queue[_playOrder[_playOrderIndex]]);
  }

  Future<void> seekTo(Duration position) async {
    final current = _currentItemSubject.value;
    if (current != null) {
      current.map(
        music: (_) => _player.seek(position),
        frequency: (_) {
          elapsedSeconds = position.inSeconds;
        },
      );
    }
    final duration = _positionSubject.value.$2;
    _positionSubject.add((position, duration));
    _updateAudioServicePlaybackState(
      playing: playbackState.value.playing,
      position: position,
      duration: duration,
    );
  }

  @override
  Future<void> seek(Duration position) => seekTo(position);

  Future<void> setLoopMode(LoopMode mode) async {
    loopMode = mode;
  }

  Future<void> setShuffled(bool shuffled) async {
    isShuffled = shuffled;
    _rebuildPlayOrder();
  }

  Future<void> playQueue(
    List<AudioPlayerItem> queue, {
    int playIndex = 0,
  }) async {
    _queue.clear();
    _queue.addAll(queue);
    _rebuildPlayOrder();
    if (_queue.isNotEmpty) {
      await playItem(isShuffled ? _queue[_playOrder.first] : _queue[playIndex]);
    }
  }

  Future<void> addToQueue(AudioPlayerItem item) async {
    _queue.add(item);
    _rebuildPlayOrder();
  }

  Future<void> removeFromQueue(AudioPlayerItem item) async {
    _queue.remove(item);
    _rebuildPlayOrder();
  }

  Future<void> clearQueue() async {
    _queue.clear();
    _playOrder.clear();
    _playOrderIndex = 0;
  }
}

enum LoopMode {
  none,
  one,
  all,
}
