import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rest_assignment/model/channel_model.dart';
import 'package:rest_assignment/model/video_model.dart';

class VideoController {
  VideoController._instantiate();

  static final VideoController instance = VideoController._instantiate();

  final String _baseUrl = 'www.googleapis.com';
  String _nextPageToken = '';

  Future<ChannelModel> fetchChannel({String channelId}) async {
    Map<String, String> parameters = {
      'part': 'snippet, contentDetails, statistics',
      'id': channelId,
      'key': "AIzaSyDOaaHQpUGLqZNef_kyhARPmxBYYYwb_3s",
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/channels', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body)['items'][0];
      ChannelModel channel = ChannelModel.fromMap(data);
      channel.videos = await fetchVideosFromPlaylist(
        playlistId: channel.uploadPlaylistId,
      );
      return channel;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }

  Future<List<VideoModel>> fetchVideosFromPlaylist({String playlistId}) async {
    Map<String, String> parameters = {
      'part': 'snippet',
      'playlistId': playlistId,
      'maxResults': '8',
      'pageToken': _nextPageToken,
      'key': "AIzaSyDOaaHQpUGLqZNef_kyhARPmxBYYYwb_3s",
    };
    Uri uri = Uri.https(_baseUrl, '/youtube/v3/playlistItems', parameters);
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
    };

    var response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      _nextPageToken = data['nextPageToken'] ?? '';
      List<dynamic> videosJson = data['items'];

      List<VideoModel> videos = [];
      videosJson
          .forEach((json) => videos.add(VideoModel.fromMap(json['snippet'])));
      return videos;
    } else {
      throw json.decode(response.body)['error']['message'];
    }
  }
}
