import 'package:flutter/material.dart';
import 'package:tiktok_app/constant/data_json.dart';
import 'package:tiktok_app/widgets/comment_modal.dart';
import 'package:tiktok_app/widgets/icon_widget.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  //handle the scroll behavior/pause the previous video
  late TabController _tabController;

  // Map to keep track of video controllers
  final Map<int, VideoPlayerController> _videoControllers = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RotatedBox(
            quarterTurns: 1,
            child: TabBarView(
              controller: _tabController,
              children: List.generate(items.length, (index) {
                return RotatedBox(
                  quarterTurns: -1,
                  child: VisibilityDetector(
                    key: Key(items[index]['videoUrl']),
                    onVisibilityChanged: (visibilityInfo) {
                      final visibleFraction = visibilityInfo.visibleFraction;
                      final controller = _videoControllers[index];
                      if (controller != null) {
                        if (visibleFraction > 0.5) {
                          controller.play();
                        } else {
                          controller.pause();
                        }
                      }
                    },
                    child: VideoPlayerItem(
                      name: items[index]['name'],
                      profileImg: items[index]['profileImg'],
                      videoUrl: items[index]['videoUrl'],
                      caption: items[index]['caption'],
                      likes: items[index]['likes'],
                      comments: items[index]['comments'],
                      favorites: items[index]['favorites'],
                      shares: items[index]['shares'],
                      albumImg: items[index]['albumImg'],
                      onControllerCreated: (controller) {
                        _videoControllers[index] = controller;
                      },
                      isLiked: bool.parse(items[index]['isLiked']),
                      isFavourited: bool.parse(items[index]['isFavourited']),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class VideoPlayerItem extends StatefulWidget {
  final String name;
  final String profileImg;
  final String videoUrl;
  final String caption;
  final String likes;
  final String comments;
  final String favorites;
  final String shares;
  final String albumImg;
  bool isLiked;
  bool isFavourited;
  final void Function(VideoPlayerController) onControllerCreated;

  VideoPlayerItem({
    required this.name,
    required this.profileImg,
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.favorites,
    required this.shares,
    required this.albumImg,
    required this.onControllerCreated,
    required this.isLiked,
    required this.isFavourited,
    super.key,
  });

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerController;
  bool isShowingPlaying = false;
  bool isAddToFavorites = false;
  bool isVideoLiked = false;
  bool likeVisibilityIcon = false;
  Timer? likeImageIcon;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
    _initializeVideoPlayerController = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _videoPlayerController.play();

    _initializeVideoPlayerController.then((_) {
      setState(() {
        isShowingPlaying = true;
      });
      widget.onControllerCreated(_videoPlayerController);
    });
  }

  @override
  void dispose() {
    _videoPlayerController.pause();
    _videoPlayerController.dispose();
    likeImageIcon?.cancel();
    super.dispose();
  }

  void isVideoOntap() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        //pause the video on  single tap
        _videoPlayerController.pause();
        likeVisibilityIcon = false;
        isVideoLiked = false;
      } else {
        //pause the video on  single tap
        _videoPlayerController.play();
      }
    });
  }
//handle the double tap on image 
  void isVideoDoubleTap() {
  setState(() {
    likeVisibilityIcon = true;
    isVideoLiked = true;
    _videoPlayerController.play();
    widget.isLiked = true;
  });

  // If a previous timer is already running, cancel it
  likeImageIcon?.cancel();

  // Create a new timer to hide the like icon after 2 seconds
  likeImageIcon = Timer(const Duration(seconds: 2), () {
    setState(() {
      likeVisibilityIcon = false;
      isVideoLiked = false;
    });
  });
}

//comment bottom sheet modal
    void showCommentModal() {
      showModalBottomSheet(
        isDismissible: true,
        context: context, 
        builder: (s) => CommentModalBottomSheet(
          onTap: () => Navigator.pop(context),
        )
      );
    }
    //share bottom sheet modal
    void showShareModal() {
      showModalBottomSheet(context: context, builder: (s)=> CommentModalBottomSheet(onTap: () => Navigator.pop));
    }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        SizedBox.expand(
          child: GestureDetector(
            onTap: isVideoOntap,
            onDoubleTap: isVideoDoubleTap,
            child: FutureBuilder(
              future: _initializeVideoPlayerController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return VideoPlayer(_videoPlayerController);
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        //liked image icon pop-up
        Center(
          child: isVideoLiked ? Image.asset(
            'assets/icons/heart.png',
            height: 70,
            color: Colors.red.withOpacity(0.8)
          )
          : const SizedBox.shrink(),
        ),
        ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: _videoPlayerController,
            builder: (context, value, child) {
              return !value.isPlaying
                  ? Center(
                      child: GestureDetector(
                        onTap: isVideoOntap,
                        child: Icon(
                          Icons.play_arrow,
                          size: 80,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    )
                  : Container();
            }),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: 300,
              height: 75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      widget.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    maxLines: 2,
                    widget.caption,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.2, color: Colors.white),
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            widget.profileImg,
                            fit: BoxFit.cover,
                          ))),
                ),
                RightPanelIcon(
                  imagePath: 'assets/icons/heart.png',
                  value: widget.likes,
                  activeColor: Colors.red,
                  action: widget.isLiked,
                  onTap: () => setState(() {
                    widget.isLiked = !widget.isLiked;
                  }),
                ),
                RightPanelIcon(
                  imagePath: 'assets/icons/chat-bubble.png',
                  value: widget.comments,
                  activeColor: Colors.white,
                  action: false,
                  onTap: showCommentModal,
                ),
                RightPanelIcon(
                  imagePath: 'assets/icons/favorite.png',
                  value: widget.favorites,
                  activeColor: Colors.amber,
                  action: widget.isFavourited,
                  onTap: () => setState(() {
                    widget.isFavourited = !widget.isFavourited;
                  }),
                ),
                RightPanelIcon(
                  imagePath: 'assets/icons/share.png',
                  value: widget.shares,
                  activeColor: Colors.white,
                  action: false,
                  onTap: showShareModal,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            widget.albumImg,
                            fit: BoxFit.cover,
                          ))),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}