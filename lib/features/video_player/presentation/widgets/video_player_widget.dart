import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbnailUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl, required this.thumbnailUrl});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(playedColor: Colors.red, handleColor: Colors.red, backgroundColor: Colors.grey, bufferedColor: Colors.grey[300]!),
        placeholder: CachedNetworkImage(
          imageUrl: widget.thumbnailUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
          errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
        ),
      );

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _chewieController == null) {
      return Container(
        color: Colors.black,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: widget.thumbnailUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
            errorWidget: (context, url, error) => Container(color: Colors.grey[300], child: const Icon(Icons.error)),
          ),
        ),
      );
    }

    return Chewie(controller: _chewieController!);
  }
}
