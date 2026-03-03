# shapee_media_player

A library using audio_service, cache_audio_player_plus, sound_generator to play the audio from url or a frequency

## Getting Started

From main:
```Dart
      await AudioPlayerHandler.init(
          audioServiceConfig: const AudioServiceConfig(
            androidNotificationChannelId: 'com.wellquantum.audio',
            androidNotificationChannelName: 'Quantum Audio',
            androidNotificationChannelDescription: 'Audio playback for Quantum Wellness',
            androidNotificationOngoing: true,
            androidShowNotificationBadge: true,
            androidNotificationIcon: 'drawable/ic_notification'
          ),
      );

```
Listen to state
```Dart
      _audioPlayerHandler.playbackState.listen((playerState) {

      });

```
