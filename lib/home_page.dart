import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:sharp_stream/toolbar.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const graphql = "https://gql.twitch.tv/gql";
  static const clientID = "kimne78kx3ncx6brgo4mv6wki5h1ko";

  final usernameController = TextEditingController();
  VideoPlayerController? vidController;
  final apiClient = Dio();
  bool showToolbar = true;
  bool showOverlay = false;
  bool hoverOverlay = false;

  @override
  void initState() {
    super.initState();

    // usernameController.addListener(getStreamLink);
    // vidController.initialize().then((_) => setState(() {}));
    usernameController.addListener(getStreamLinkDebounced);
  }

  void getStreamLinkDebounced() {
    EasyDebounce.debounce("get stream link", const Duration(milliseconds: 1000),
        () => getStreamLink());
  }

  Future<void> getStreamLink() async {
    final username = usernameController.text;
    final body = {
      'operationName': 'PlaybackAccessToken',
      'extensions': {
        'persistedQuery': {
          'version': 1,
          'sha256Hash':
              "0828119ded1c13477966434e15800ff57ddacf13ba1911c129dc2200705b0712"
        }
      },
      'variables': {
        'isLive': true,
        'login': username,
        'isVod': false,
        'vodID': '',
        'playerType': "embed"
      }
    };

    final tokenResp = await apiClient.post(
      graphql,
      data: body,
      options: Options(
        headers: {'Client-id': clientID},
      ),
    );
    // kuskusracinghttps://www.twitch.tv/kuskusrace
    final token = tokenResp.data['data']['streamPlaybackAccessToken'];
    if (token == null) return;

    final value = token['value'] as String? ?? '';
    final sig = token['signature'] as String? ?? '';

    final resp = await apiClient.get(
      'https://usher.ttvnw.net/api/channel/hls/$username.m3u8?allow_source=true',
      queryParameters: {
        'token': value,
        'sig': sig,
      },
    );

    final streams = (resp.data as String? ?? '')
        .split('\n')
        .where((l) => l.startsWith('https'));

    if (streams.isEmpty) return;

    vidController = VideoPlayerController.networkUrl(Uri.parse(streams.first));
    vidController?.initialize().then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    Widget? floatingButton;

    if (vidController case final vidController?) {
      floatingButton = FloatingActionButton(
        onPressed: () {
          setState(() {
            vidController.value.isPlaying
                ? vidController.pause()
                : vidController.play();
          });
        },
        child: Icon(
          vidController.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) => AnimatedBuilder(
                  animation: animation,
                  builder: (_, child) => ClipRect(
                    child: Align(
                      heightFactor: animation.value,
                      child: child,
                    ),
                  ),
                  child: child,
                ),
                child: showToolbar
                    ? Toolbar(
                        usernameController: usernameController,
                        onHide: () => setState(() => showToolbar = false),
                      )
                    : const SizedBox.shrink(),
              ),
              if (vidController case final vidController?)
                vidController.value.isInitialized
                    ? Expanded(
                        child: AspectRatio(
                          aspectRatio: vidController.value.aspectRatio,
                          child: VideoPlayer(vidController),
                        ),
                      )
                    : Text('loading...')
            ],
          ),
          if (!showToolbar)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: showOverlay
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 8.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Material(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            color: Theme.of(context).colorScheme.surfaceBright,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              onTap: () => setState(() => showToolbar = true),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.fullscreen_exit_rounded,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          MouseRegion(
            hitTestBehavior: HitTestBehavior.translucent,
            onExit: (_) {
              hoverOverlay = false;
              Future.delayed(const Duration(seconds: 1), () {
                if (hoverOverlay) return;
                //todo cancel previous futures
                setState(() => showOverlay = false);
              });
            },
            onEnter: (_) {
              hoverOverlay = true;
              setState(() => showOverlay = true);
            },
            child: SizedBox(
              height: 100,
              width: double.infinity,
            ),
          ),
        ],
      ),
      floatingActionButton: floatingButton,
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    vidController?.dispose();
    super.dispose();
  }
}
