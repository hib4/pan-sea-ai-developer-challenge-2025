import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/data.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/l10n/l10n.dart';
import 'package:kanca/utils/utils.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({required this.story, super.key});

  final StoryModel story;

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  // For demo, use a static story. Replace with real data/fetching logic.
  late StoryModel story;
  int currentSceneIndex = 0;
  int totalPoint = 0;
  List<int> visitedScenes = [];
  List<String> choices = [];
  bool started = false;

  // Audio player instance
  late AudioPlayer _audioPlayer;
  bool _isAudioPlaying = false;
  String? _currentAudioUrl;

  @override
  void initState() {
    super.initState();
    // story = _demoStory();
    story = widget.story;
    currentSceneIndex = story.currentScene - 1;

    // Initialize audio player
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((PlayerState state) {
      setState(() {
        _isAudioPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Audio control methods
  Future<void> _playAudio(String? voiceUrl) async {
    if (voiceUrl != null && voiceUrl.isNotEmpty) {
      try {
        // Always stop current audio and load new one for scene changes
        await _audioPlayer.stop();
        await _audioPlayer.setUrl(voiceUrl);
        _currentAudioUrl = voiceUrl;
        await _audioPlayer.play();
      } catch (e) {
        // Handle audio play error silently
      }
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      _currentAudioUrl = null;
    } catch (e) {
      // Handle audio stop error silently
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      // Handle audio pause error silently
    }
  }

  Future<void> _resumeAudio() async {
    try {
      // Only resume if we have the same audio loaded
      final scene = story.scenes[currentSceneIndex];
      if (_currentAudioUrl == scene.voiceUrl) {
        await _audioPlayer.play();
      } else {
        // If different audio, load and play the current scene's audio
        await _playAudio(scene.voiceUrl);
      }
    } catch (e) {
      // Handle audio resume error silently
    }
  }

  // Manual audio control for play/pause button
  Future<void> _toggleAudio() async {
    if (_isAudioPlaying) {
      await _pauseAudio();
    } else {
      await _resumeAudio();
    }
  }

  void _goToScene(int sceneId) {
    final idx = story.scenes.indexWhere((s) => s.sceneId == sceneId);
    if (idx != -1) {
      // Stop current audio before changing scene
      _stopAudio();

      setState(() {
        currentSceneIndex = idx;
        visitedScenes.add(sceneId);
      });

      // Check if this is an ending scene - if so, don't auto-play audio
      final newScene = story.scenes[currentSceneIndex];
      if (newScene.type == 'ending') {
        // For ending scenes, ensure audio is completely stopped
        _stopAudio();
      } else {
        // Auto-play audio for non-ending scenes after a brief delay
        Future.delayed(const Duration(milliseconds: 100), () {
          if (newScene.voiceUrl != null && newScene.voiceUrl!.isNotEmpty) {
            _playAudio(newScene.voiceUrl);
          }
        });
      }
    }
  }

  void _choose(SceneChoice choice) {
    setState(() {
      totalPoint += choice.point;
      choices.add(choice.choice);
      _goToScene(choice.nextScene);
    });
  }

  void _next() {
    final nextId = story.scenes[currentSceneIndex].sceneId + 1;
    _goToScene(nextId);
  }

  void _restart() {
    // Stop any playing audio
    _stopAudio();

    setState(() {
      currentSceneIndex = 0;
      totalPoint = 0;
      visitedScenes.clear();
      choices.clear();
      started = false;
    });
  }

  void _startStory() {
    setState(() {
      started = true;
    });

    // Auto-play audio for the first scene after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      final scene = story.scenes[currentSceneIndex];
      if (scene.voiceUrl != null && scene.voiceUrl!.isNotEmpty) {
        _playAudio(scene.voiceUrl);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    final scene = story.scenes[currentSceneIndex];
    final isDecision = scene.type == 'decision_point';
    final isEnding = scene.type == 'ending';
    final progress = (currentSceneIndex + 1) / story.scenes.length;

    // Initial: Only show Story Header and Start button
    if (!started) {
      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 24,
                top: MediaQuery.of(context).padding.top,
                right: 24,
                bottom: 110,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        context.pop();
                      },
                      borderRadius: BorderRadius.circular(28),
                      child: Assets.icons.back.image(
                        width: 56,
                        height: 56,
                      ),
                    ),
                  ),
                  32.vertical,
                  _StoryHeader(story: story),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                  color: colors.neutral[500],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _startStory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary[500],
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    l10n.startAdventureButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // After start: Show Scene Card and Progress
    if (isEnding) {
      return Scaffold(
        body: Center(
          child: _EndingCard(
            endingType: scene.endingType == 'good',
            coreValue: scene.moralValue ?? '',
            meaning: scene.meaning ?? '',
            realLifeExample: scene.example ?? '',
            onRestart: _restart,
            onStopAudio: _stopAudio,
            textTheme: textTheme,
            colors: colors,
          ),
        ),
      );
    }

    return Scaffold(
      body: _SceneCard(
        scene: scene,
        onChoice: isDecision ? _choose : null,
        textTheme: textTheme,
        colors: colors,
        progress: progress,
        sceneIndex: currentSceneIndex,
        totalScenes: story.scenes.length,
        onNext: !isDecision && !isEnding ? _next : null,
        isDecision: isDecision,
        isEnding: isEnding,
        audioPlayer: _audioPlayer,
        isAudioPlaying: _isAudioPlaying,
        onToggleAudio: _toggleAudio,
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.story});
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: story.coverImgUrl != null
              ? Image.network(
                  story.coverImgUrl!,
                  height: 350,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: colors.primary[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: colors.primary[500],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (c, e, s) {
                    return Container(
                      height: 180,
                      width: double.infinity,
                      color: colors.neutral[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: colors.grey[400],
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Image failed to load',
                              style: TextStyle(
                                color: colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  height: 180,
                  width: double.infinity,
                  color: colors.primary[100],
                  child: Center(
                    child: Icon(
                      Icons.auto_stories,
                      size: 64,
                      color: colors.primary[400],
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        Text(story.title, style: textTheme.h4),
        const SizedBox(height: 8),
        Text(story.description, style: textTheme.body),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: story.themes
              .map(
                (theme) => Chip(
                  label: Text(
                    theme,
                    style: textTheme.caption.copyWith(
                      color: colors.primary[700],
                    ),
                  ),
                  backgroundColor: colors.primary[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    required this.scene,
    required this.textTheme,
    required this.colors,
    this.onChoice,
    this.progress,
    this.sceneIndex = 0,
    this.totalScenes = 1,
    this.onNext,
    this.isDecision = false,
    this.isEnding = false,
    this.audioPlayer,
    this.isAudioPlaying = false,
    this.onToggleAudio,
  });

  final Scene scene;
  final void Function(SceneChoice)? onChoice;
  final AppTextStyles textTheme;
  final AppColors colors;
  final double? progress;
  final int sceneIndex;
  final int totalScenes;
  final VoidCallback? onNext;
  final bool isDecision;
  final bool isEnding;
  final AudioPlayer? audioPlayer;
  final bool isAudioPlaying;
  final VoidCallback? onToggleAudio;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Stack(
      children: [
        // Full background image
        Positioned.fill(
          child: scene.imgUrl != null
              ? Image.network(
                  scene.imgUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: colors.primary[50],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: colors.primary[500],
                        ),
                      ),
                    );
                  },
                  errorBuilder: (c, e, s) {
                    return Container(
                      color: colors.neutral[200],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image,
                              color: colors.grey[400],
                              size: 48,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Scene image failed to load',
                              style: TextStyle(
                                color: colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: colors.primary[50],
                  child: Center(
                    child: Icon(
                      Icons.nature,
                      size: 100,
                      color: colors.primary[200],
                    ),
                  ),
                ),
        ),
        // Full gradient overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.08),
                  Colors.white.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),
        // Content overlay
        Positioned.fill(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  _StoryProgressBar(
                    current: sceneIndex + 1,
                    total: totalScenes,
                    colors: colors,
                  ),
                  const SizedBox(height: 24),
                  _SpeechBubble(
                    icon: Icons.stars_rounded,
                    content: scene.content,
                    textTheme: textTheme,
                    colors: colors,
                    hasAudio:
                        scene.voiceUrl != null && scene.voiceUrl!.isNotEmpty,
                    isAudioPlaying: isAudioPlaying,
                    onToggleAudio: onToggleAudio,
                  ),
                  const Spacer(),
                  if (scene.branch != null && onChoice != null)
                    Column(
                      children: [
                        ...scene.branch!.map(
                          (choice) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ElevatedButton(
                              onPressed: () => onChoice!(choice),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: colors.primary[700],
                                minimumSize: const Size(double.infinity, 56),
                                elevation: 4,
                                shadowColor: colors.primary[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                  side: BorderSide(color: colors.primary[200]!),
                                ),
                              ),
                              child: Text(
                                choice.content,
                                style: textTheme.body.copyWith(
                                  color: colors.primary[700],
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!isDecision && !isEnding && onNext != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(l10n.nextButton),
                      ),
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpeechBubble extends StatelessWidget {
  const _SpeechBubble({
    required this.icon,
    required this.content,
    required this.textTheme,
    required this.colors,
    this.hasAudio = false,
    this.isAudioPlaying = false,
    this.onToggleAudio,
  });

  final IconData icon;
  final String content;
  final AppTextStyles textTheme;
  final AppColors colors;
  final bool hasAudio;
  final bool isAudioPlaying;
  final VoidCallback? onToggleAudio;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 16, right: 40),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            content,
            style: GoogleFonts.fredoka(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              height: 1.2,
              shadows: [
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
                const Shadow(
                  blurRadius: 8,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        // Audio control button
        // if (hasAudio)
        //   Positioned(
        //     top: 8,
        //     right: 8,
        //     child: GestureDetector(
        //       onTap: () {
        //         onToggleAudio?.call();
        //       },
        //       child: Container(
        //         padding: const EdgeInsets.all(8),
        //         decoration: BoxDecoration(
        //           color: colors.primary[500]?.withOpacity(0.8),
        //           borderRadius: BorderRadius.circular(20),
        //           boxShadow: [
        //             BoxShadow(
        //               color: Colors.black.withOpacity(0.2),
        //               blurRadius: 4,
        //               offset: const Offset(0, 2),
        //             ),
        //           ],
        //         ),
        //         child: Icon(
        //           isAudioPlaying ? Icons.pause : Icons.play_arrow,
        //           color: Colors.white,
        //           size: 20,
        //         ),
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}

class _StoryProgressBar extends StatelessWidget {
  const _StoryProgressBar({
    required this.current,
    required this.total,
    required this.colors,
  });

  final int current;
  final int total;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= total; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i < total ? 4 : 0),
              height: 6,
              decoration: BoxDecoration(
                color: i <= current ? colors.primary[500] : colors.primary[100],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
      ],
    );
  }
}

class _EndingCard extends StatelessWidget {
  const _EndingCard({
    required this.endingType,
    required this.coreValue,
    required this.meaning,
    required this.realLifeExample,
    required this.onRestart,
    required this.textTheme,
    required this.colors,
    this.onStopAudio,
  });

  final bool endingType;
  final String coreValue;
  final String meaning;
  final String realLifeExample;
  final VoidCallback onRestart;
  final VoidCallback? onStopAudio;
  final AppTextStyles textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    // Ensure audio is stopped when ending card is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onStopAudio?.call();
    });

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.mascots.hooray.image(
                    width: 150,
                    height: 150,
                  ),
                  16.vertical,
                  Text(
                    l10n.coreValueTitle,
                    style: textTheme.h5.copyWith(
                      color: colors.secondary[900],
                    ),
                  ),
                  Text(
                    coreValue,
                    style: textTheme.h4.copyWith(
                      color: colors.primary[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  24.vertical,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary[900],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      l10n.meaningTitle,
                      style: GoogleFonts.fredoka(
                        color: colors.primary[50],
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                  12.vertical,
                  Text(
                    meaning,
                    style: textTheme.lexendBody.copyWith(
                      color: colors.secondary[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  24.vertical,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.secondary[900],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      l10n.reallifeTitle,
                      style: GoogleFonts.fredoka(
                        color: colors.primary[50],
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                    ),
                  ),
                  12.vertical,
                  Text(
                    realLifeExample,
                    style: textTheme.lexendBody.copyWith(
                      color: colors.secondary[900],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  60.vertical,
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushAndRemoveUntil(
                          const DashboardPage(),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.neutral[500],
                        side: BorderSide(
                          color: colors.primary[500]!,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        l10n.homeButton,
                        style: GoogleFonts.lexend(
                          color: colors.primary[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  12.horizontal,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.pushReplacement(const GenerateStoryPage());
                      },
                      child: Text(l10n.newStoryButton),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
