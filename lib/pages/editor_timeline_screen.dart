import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:path_provider/path_provider.dart';

class VideoEditorTimelineScreen extends StatefulWidget {
  final String videoPath;

  const VideoEditorTimelineScreen({Key? key, required this.videoPath})
      : super(key: key);

  @override
  State<VideoEditorTimelineScreen> createState() =>
      _VideoEditorTimelineScreenState();
}

class _VideoEditorTimelineScreenState extends State<VideoEditorTimelineScreen> {
  late VideoPlayerController _controller;
  double _start = 0.0;
  double _end = 1.0;
  bool _isExporting = false;
  String? _exportedPath;
  String? _ffmpegLog;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _end = _controller.value.duration.inSeconds.toDouble();
        });
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTrimStartChanged(double value) {
    setState(() {
      _start = value;
      if (_controller.value.isInitialized) {
        _controller.seekTo(Duration(seconds: value.toInt()));
      }
    });
  }

  void _onTrimEndChanged(double value) {
    setState(() {
      _end = value;
    });
  }

  Future<void> _exportTrim() async {
    setState(() {
      _isExporting = true;
      _ffmpegLog = null;
    });

    final extDir = await getTemporaryDirectory();
    final outPath = '${extDir.path}/swiftcut_trimmed_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final duration = _end - _start;
    final cmd =
        '-i "${widget.videoPath}" -ss $_start -t $duration -c copy "$outPath"';

    await FFmpegKit.executeAsync(cmd, (session) async {
      final rc = await session.getReturnCode();
      if (ReturnCode.isSuccess(rc)) {
        setState(() {
          _exportedPath = outPath;
        });
      } else {
        setState(() {
          _ffmpegLog = 'Export failed: \\${rc?.getValue()}';
        });
      }
      setState(() {
        _isExporting = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final duration = _controller.value.isInitialized
        ? _controller.value.duration.inSeconds.toDouble()
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SwiftCut Editor Timeline'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Export Trim',
            onPressed: _isExporting ? null : _exportTrim,
          ),
        ],
      ),
      body: _controller.value.isInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 62,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (context, idx) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 40,
                      color: Colors.grey[(idx % 8 + 1) * 100],
                      child: Center(
                        child: Text(
                          '${(duration * idx / 15).toStringAsFixed(1)}s',
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Trim:'),
                    Expanded(
                      child: RangeSlider(
                        min: 0,
                        max: duration,
                        values: RangeValues(_start, _end),
                        onChanged: (values) {
                          setState(() {
                            _onTrimStartChanged(values.start);
                            _onTrimEndChanged(values.end);
                          });
                        },
                        labels: RangeLabels(_start.toStringAsFixed(0),
                            _end.toStringAsFixed(0)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 10,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.content_cut),
                        label: const Text('Cut/Export'),
                        onPressed: _isExporting ? null : _exportTrim,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(_controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          _controller.value.isPlaying
                              ? _controller.pause()
                              : _controller.play();
                        });
                      },
                    ),
                    Text(
                      '${_controller.value.position.inSeconds}s / ${_controller.value.duration.inSeconds}s',
                      style: const TextStyle(fontSize: 14),
                    )
                  ],
                ),
                if (_isExporting)
                  const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(),
                  ),
                if (_exportedPath != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Exported: \\$_exportedPath',
                        style: const TextStyle(color: Colors.green)
                    ),
                  ),
                if (_ffmpegLog != null)
                  Text(
                    _ffmpegLog!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
