# shapee_media_player

A library using audio_service, cache_audio_player_plus, sound_generator to play the audio from url or a frequency

## Getting Started
Add in pubspec.yaml 
```xml
  media_player:
    git:
    url: https://github.com/lufyitbkdn/audio_player_handler.git
    ref: [lastRelease]
```

Follow to Android & iOS set up of audio_service: https://pub.dev/packages/audio_service

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
