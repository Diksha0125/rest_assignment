class VideoModel {
  final String id;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  VideoModel({
    this.id,
    this.title,
    this.thumbnailUrl,
    this.channelTitle,
  });

  factory VideoModel.fromMap(Map<String, dynamic> snippet) {
    return VideoModel(
      id: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
    );
  }
}