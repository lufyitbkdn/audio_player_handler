import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';

class ShappeAudioCache {
  ShappeAudioCache() {
    _dio = Dio();
  }

  late final Dio _dio;
  static const maxQueues = 3;

  final _logger = Logger('AudioCacheService');
  late Directory _downloadCacheDir;
  late Directory _cacheDir;
  final List<String> _queues = List.empty(growable: true);
  final List<String> _errorUrls = List.empty(growable: true);
  final Set<String> _downloadingUrls = {};
  final Map<String, CancelToken> _cancelTokens = {};

  Future<void> init() async {
    _downloadCacheDir = await getApplicationCacheDirectory();
    final dir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${dir.path}/audios');
    if (!_cacheDir.existsSync()) {
      await _cacheDir.create();
    }
  }

  File? getCacheFile(String url) {
    final file = File('${_cacheDir.path}/${_encodeUrlToBase64(url)}.mp3');
    if (file.existsSync()) {
      return file;
    }
    _startDownload(url);
    return null;
  }

  String _encodeUrlToBase64(String url) {
    final stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(url);
  }

  Future<void> _startDownload(String url) async {
    final file = File('${_cacheDir.path}/${_encodeUrlToBase64(url)}.mp3');
    if (!file.existsSync() && !_queues.contains(url)) {
      _logger.info('AudioCache: Added $url to queue');
      _queues.add(url);
      if (_downloadingUrls.length < maxQueues) {
        _downloadNext();
      }
    }
  }

  Future<void> download(List<String> urls) async {
    for (final url in urls) {
      await _startDownload(url);
    }
  }

  Future<void> _download(String url) async {
    _downloadingUrls.add(url);
    final cancelToken = CancelToken();
    _cancelTokens[url] = cancelToken;
    try {
      _logger.info('AudioCache: Downloading $url');
      final downloadFile = File('${_downloadCacheDir.path}/${_encodeUrlToBase64(url)}.mp3');
      await _dio.download(url, downloadFile.path, cancelToken: cancelToken);
      final cachePath = '${_cacheDir.path}/${_encodeUrlToBase64(url)}.mp3';
      await downloadFile.rename(cachePath);
      _logger.info('AudioCache: Downloaded $url and cache to $cachePath');
      _errorUrls.remove(url);
      _downloadingUrls.remove(url);
      _cancelTokens.remove(url);
      _queues.remove(url);
      _downloadNext();
    } catch (e) {
      if (e is DioException && CancelToken.isCancel(e)) {
        _logger.info('AudioCache: Download cancelled for $url');
      } else {
        _errorUrls.add(url);
      }
      _downloadingUrls.remove(url);
      _cancelTokens.remove(url);
      _queues.remove(url);
      _downloadNext();
    }
  }

  void _downloadNext() {
    final url = _queues.firstWhereOrNull((e) => !_downloadingUrls.contains(e));
    if (url != null) {
      _download(url);
    }
  }

  Future<void> clearCache() async {
    for (final token in _cancelTokens.values) {
      token.cancel();
    }
    _cancelTokens.clear();
    await _cacheDir.delete(recursive: true);
    await _cacheDir.create();
    _queues.clear();
    _downloadingUrls.clear();
    _errorUrls.clear();
  }
}
