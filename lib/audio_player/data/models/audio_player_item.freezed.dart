// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_player_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioPlayerItem {
  String get title;

  /// The title of the album or artist.
  String? get albumTitle;

  /// The cover image of the item.
  String? get coverImage;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioPlayerItemCopyWith<AudioPlayerItem> get copyWith =>
      _$AudioPlayerItemCopyWithImpl<AudioPlayerItem>(
          this as AudioPlayerItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioPlayerItem &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.albumTitle, albumTitle) ||
                other.albumTitle == albumTitle) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, albumTitle, coverImage);

  @override
  String toString() {
    return 'AudioPlayerItem(title: $title, albumTitle: $albumTitle, coverImage: $coverImage)';
  }
}

/// @nodoc
abstract mixin class $AudioPlayerItemCopyWith<$Res> {
  factory $AudioPlayerItemCopyWith(
          AudioPlayerItem value, $Res Function(AudioPlayerItem) _then) =
      _$AudioPlayerItemCopyWithImpl;
  @useResult
  $Res call({String title, String? albumTitle, String? coverImage});
}

/// @nodoc
class _$AudioPlayerItemCopyWithImpl<$Res>
    implements $AudioPlayerItemCopyWith<$Res> {
  _$AudioPlayerItemCopyWithImpl(this._self, this._then);

  final AudioPlayerItem _self;
  final $Res Function(AudioPlayerItem) _then;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? albumTitle = freezed,
    Object? coverImage = freezed,
  }) {
    return _then(_self.copyWith(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      albumTitle: freezed == albumTitle
          ? _self.albumTitle
          : albumTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _self.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// Adds pattern-matching-related methods to [AudioPlayerItem].
extension AudioPlayerItemPatterns on AudioPlayerItem {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AudioPlayerItemMusic value)? music,
    TResult Function(AudioPlayerItemFrequency value)? frequency,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic() when music != null:
        return music(_that);
      case AudioPlayerItemFrequency() when frequency != null:
        return frequency(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AudioPlayerItemMusic value) music,
    required TResult Function(AudioPlayerItemFrequency value) frequency,
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic():
        return music(_that);
      case AudioPlayerItemFrequency():
        return frequency(_that);
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AudioPlayerItemMusic value)? music,
    TResult? Function(AudioPlayerItemFrequency value)? frequency,
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic() when music != null:
        return music(_that);
      case AudioPlayerItemFrequency() when frequency != null:
        return frequency(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String id, String title, String url, String? albumTitle,
            String? coverImage)?
        music,
    TResult Function(String title, double frequency, String? albumTitle,
            String? coverImage, int durationInSeconds)?
        frequency,
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic() when music != null:
        return music(_that.id, _that.title, _that.url, _that.albumTitle,
            _that.coverImage);
      case AudioPlayerItemFrequency() when frequency != null:
        return frequency(_that.title, _that.frequency, _that.albumTitle,
            _that.coverImage, _that.durationInSeconds);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String id, String title, String url,
            String? albumTitle, String? coverImage)
        music,
    required TResult Function(String title, double frequency,
            String? albumTitle, String? coverImage, int durationInSeconds)
        frequency,
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic():
        return music(_that.id, _that.title, _that.url, _that.albumTitle,
            _that.coverImage);
      case AudioPlayerItemFrequency():
        return frequency(_that.title, _that.frequency, _that.albumTitle,
            _that.coverImage, _that.durationInSeconds);
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String id, String title, String url, String? albumTitle,
            String? coverImage)?
        music,
    TResult? Function(String title, double frequency, String? albumTitle,
            String? coverImage, int durationInSeconds)?
        frequency,
  }) {
    final _that = this;
    switch (_that) {
      case AudioPlayerItemMusic() when music != null:
        return music(_that.id, _that.title, _that.url, _that.albumTitle,
            _that.coverImage);
      case AudioPlayerItemFrequency() when frequency != null:
        return frequency(_that.title, _that.frequency, _that.albumTitle,
            _that.coverImage, _that.durationInSeconds);
      case _:
        return null;
    }
  }
}

/// @nodoc

class AudioPlayerItemMusic implements AudioPlayerItem {
  const AudioPlayerItemMusic(
      {required this.id,
      required this.title,
      required this.url,
      this.albumTitle,
      this.coverImage});

  final String id;
  @override
  final String title;
  final String url;

  /// The title of the album or artist.
  @override
  final String? albumTitle;

  /// The cover image of the item.
  @override
  final String? coverImage;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioPlayerItemMusicCopyWith<AudioPlayerItemMusic> get copyWith =>
      _$AudioPlayerItemMusicCopyWithImpl<AudioPlayerItemMusic>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioPlayerItemMusic &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.albumTitle, albumTitle) ||
                other.albumTitle == albumTitle) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, id, title, url, albumTitle, coverImage);

  @override
  String toString() {
    return 'AudioPlayerItem.music(id: $id, title: $title, url: $url, albumTitle: $albumTitle, coverImage: $coverImage)';
  }
}

/// @nodoc
abstract mixin class $AudioPlayerItemMusicCopyWith<$Res>
    implements $AudioPlayerItemCopyWith<$Res> {
  factory $AudioPlayerItemMusicCopyWith(AudioPlayerItemMusic value,
          $Res Function(AudioPlayerItemMusic) _then) =
      _$AudioPlayerItemMusicCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String url,
      String? albumTitle,
      String? coverImage});
}

/// @nodoc
class _$AudioPlayerItemMusicCopyWithImpl<$Res>
    implements $AudioPlayerItemMusicCopyWith<$Res> {
  _$AudioPlayerItemMusicCopyWithImpl(this._self, this._then);

  final AudioPlayerItemMusic _self;
  final $Res Function(AudioPlayerItemMusic) _then;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? url = null,
    Object? albumTitle = freezed,
    Object? coverImage = freezed,
  }) {
    return _then(AudioPlayerItemMusic(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _self.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      albumTitle: freezed == albumTitle
          ? _self.albumTitle
          : albumTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _self.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class AudioPlayerItemFrequency implements AudioPlayerItem {
  const AudioPlayerItemFrequency(
      {required this.title,
      required this.frequency,
      this.albumTitle,
      this.coverImage,
      this.durationInSeconds = 180});

  @override
  final String title;
  final double frequency;

  /// The title of the album or artist.
  @override
  final String? albumTitle;

  /// The cover image of the item.
  @override
  final String? coverImage;
  @JsonKey()
  final int durationInSeconds;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AudioPlayerItemFrequencyCopyWith<AudioPlayerItemFrequency> get copyWith =>
      _$AudioPlayerItemFrequencyCopyWithImpl<AudioPlayerItemFrequency>(
          this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AudioPlayerItemFrequency &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.albumTitle, albumTitle) ||
                other.albumTitle == albumTitle) &&
            (identical(other.coverImage, coverImage) ||
                other.coverImage == coverImage) &&
            (identical(other.durationInSeconds, durationInSeconds) ||
                other.durationInSeconds == durationInSeconds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, title, frequency, albumTitle, coverImage, durationInSeconds);

  @override
  String toString() {
    return 'AudioPlayerItem.frequency(title: $title, frequency: $frequency, albumTitle: $albumTitle, coverImage: $coverImage, durationInSeconds: $durationInSeconds)';
  }
}

/// @nodoc
abstract mixin class $AudioPlayerItemFrequencyCopyWith<$Res>
    implements $AudioPlayerItemCopyWith<$Res> {
  factory $AudioPlayerItemFrequencyCopyWith(AudioPlayerItemFrequency value,
          $Res Function(AudioPlayerItemFrequency) _then) =
      _$AudioPlayerItemFrequencyCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String title,
      double frequency,
      String? albumTitle,
      String? coverImage,
      int durationInSeconds});
}

/// @nodoc
class _$AudioPlayerItemFrequencyCopyWithImpl<$Res>
    implements $AudioPlayerItemFrequencyCopyWith<$Res> {
  _$AudioPlayerItemFrequencyCopyWithImpl(this._self, this._then);

  final AudioPlayerItemFrequency _self;
  final $Res Function(AudioPlayerItemFrequency) _then;

  /// Create a copy of AudioPlayerItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? title = null,
    Object? frequency = null,
    Object? albumTitle = freezed,
    Object? coverImage = freezed,
    Object? durationInSeconds = null,
  }) {
    return _then(AudioPlayerItemFrequency(
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _self.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as double,
      albumTitle: freezed == albumTitle
          ? _self.albumTitle
          : albumTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      coverImage: freezed == coverImage
          ? _self.coverImage
          : coverImage // ignore: cast_nullable_to_non_nullable
              as String?,
      durationInSeconds: null == durationInSeconds
          ? _self.durationInSeconds
          : durationInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
