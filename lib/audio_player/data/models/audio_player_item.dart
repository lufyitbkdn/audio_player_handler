import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_player_item.freezed.dart';

@freezed
sealed class AudioPlayerItem with _$AudioPlayerItem {
  const factory AudioPlayerItem.music({
    required String id,
    required String title,
    required String url,

    /// The title of the album or artist.
    String? albumTitle,

    /// The cover image of the item.
    String? coverImage,
  }) = AudioPlayerItemMusic;

  const factory AudioPlayerItem.frequency({
    required String title,
    required double frequency,

    /// The title of the album or artist.
    String? albumTitle,

    /// The cover image of the item.
    String? coverImage,
    @Default(180) int durationInSeconds,
  }) = AudioPlayerItemFrequency;
}
