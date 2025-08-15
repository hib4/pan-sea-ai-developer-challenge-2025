import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/dashboard/dashboard.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class Story {
  Story({
    required this.title,
    required this.description,
    required this.themes,
    required this.scenes,
    required this.currentScene,
    required this.totalScenes,
    this.id,
    this.userId,
    this.language,
    this.status,
    this.ageGroup,
    this.createdAt,
    this.finishedAt,
    this.maximumPoint,
    this.storyFlow,
    this.characters,
    this.userStory,
    this.coverImgUrl,
    this.estimatedReadingTime,
  });

  final String? id;
  final String? userId;
  final String title;
  final String description;
  final String? coverImgUrl;
  final List<String> themes;
  final String? language;
  final String? status;
  final int? ageGroup;
  final String? createdAt;
  final String? finishedAt;
  final int? maximumPoint;
  final StoryFlow? storyFlow;
  final List<Character>? characters;
  final UserStory? userStory;
  final List<Scene> scenes;
  final int currentScene;
  final int totalScenes;
  final int? estimatedReadingTime;
}

class StoryFlow {
  StoryFlow({
    required this.totalScene,
    required this.decisionPoint,
    required this.ending,
  });

  final int totalScene;
  final List<int> decisionPoint;
  final List<int> ending;
}

class Character {
  Character({
    required this.name,
    required this.description,
  });

  final String name;
  final String description;
}

class UserStory {
  UserStory({
    required this.visitedScene,
    required this.choices,
    required this.totalPoint,
    required this.finishedTime,
  });

  final List<int> visitedScene;
  final List<String> choices;
  final int totalPoint;
  final int finishedTime;
}

class Scene {
  Scene({
    required this.sceneId,
    required this.type,
    required this.imgDescription,
    required this.content,
    this.imgUrl,
    this.voiceUrl,
    this.branch,
    this.lessonLearned,
    this.nextScene,
    this.selectedChoice,
    this.endingType,
    this.moralValue,
    this.meaning,
    this.example,
  });

  final int sceneId;
  final String type; // 'narrative', 'decision_point', 'ending'
  final String? imgUrl;
  final String imgDescription;
  final String? voiceUrl;
  final String content;
  final int? nextScene;
  final List<SceneChoice>? branch;
  final String? lessonLearned;
  final String? selectedChoice;
  final String? endingType;
  final String? moralValue;
  final String? meaning;
  final String? example;
}

class SceneChoice {
  SceneChoice({
    required this.choice,
    required this.content,
    required this.moralValue,
    required this.point,
    required this.nextScene,
  });

  final String choice; // 'baik' or 'buruk'
  final String content;
  final String moralValue;
  final int point;
  final int nextScene;
}

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  // For demo, use a static story. Replace with real data/fetching logic.
  late Story story;
  int currentSceneIndex = 0;
  int totalPoint = 0;
  List<int> visitedScenes = [];
  List<String> choices = [];
  bool started = false;

  @override
  void initState() {
    super.initState();
    story = _demoStory();
    currentSceneIndex = story.currentScene - 1;

    // Debug: Print image URLs
    debugPrint('=== Image URL Debug ===');
    debugPrint('Cover image URL: ${story.coverImgUrl}');
    for (final scene in story.scenes) {
      debugPrint('Scene ${scene.sceneId} image URL: ${scene.imgUrl}');
    }
    debugPrint('=== End Debug ===');
  }

  void _goToScene(int sceneId) {
    final idx = story.scenes.indexWhere((s) => s.sceneId == sceneId);
    if (idx != -1) {
      setState(() {
        currentSceneIndex = idx;
        visitedScenes.add(sceneId);
      });
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
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final scene = story.scenes[currentSceneIndex];
    final isDecision = scene.type == 'decision_point';
    final isEnding = scene.type == 'ending';
    final progress = (currentSceneIndex + 1) / story.totalScenes;

    // Initial: Only show Story Header and Start button
    if (!started) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
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
                32.vertical,
                Center(
                  child: ElevatedButton(
                    onPressed: _startStory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary[500],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Start Story'),
                  ),
                ),
              ],
            ),
          ),
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
        totalScenes: story.totalScenes,
        onNext: !isDecision && !isEnding ? _next : null,
        isDecision: isDecision,
        isEnding: isEnding,
      ),
    );
  }
}

class _StoryHeader extends StatelessWidget {
  const _StoryHeader({required this.story});
  final Story story;

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
                    debugPrint('Cover image load error: $e');
                    debugPrint('Cover image URL: ${story.coverImgUrl}');
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

  @override
  Widget build(BuildContext context) {
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
                    debugPrint('Scene image load error: $e');
                    debugPrint('Scene image URL: ${scene.imgUrl}');
                    debugPrint('Scene ID: ${scene.sceneId}');
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
                        child: const Text('Next'),
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
  });

  final IconData icon;
  final String content;
  final AppTextStyles textTheme;
  final AppColors colors;

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
  });

  final bool endingType;
  final String coreValue;
  final String meaning;
  final String realLifeExample;
  final VoidCallback onRestart;
  final AppTextStyles textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
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
                    'Core Value',
                    style: textTheme.h5.copyWith(
                      color: colors.secondary[900],
                    ),
                  ),
                  Text(
                    coreValue,
                    style: textTheme.h4.copyWith(
                      color: colors.primary[500],
                    ),
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
                      'Meaning',
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
                      'Real-life Example',
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
                        'Home',
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
                      child: const Text('New Story'),
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

// Demo data for preview
Story _demoStory() {
  return Story(
    id: '689e16ee04fdedcaa9fa341b',
    userId: '68720d0d6a0d2694067fd18e',
    title: 'Princess Melati and the Fair Kingdom',
    description:
        'In the prosperous Kingdom of Melati, Princess Melati must prove her honesty and fairness to her people. Help her make wise decisions to earn their trust and become a just ruler.',
    coverImgUrl:
        'https://bihackathon.blob.core.windows.net/storage/images/8eca92d0-d5e8-4a93-8e42-62ed8ade5a99.webp',
    themes: ['Honesty', 'Justice', 'Responsibility'],
    language: 'English',
    status: 'not_started',
    ageGroup: 12,
    createdAt: '2025-08-14T17:03:42.810000',
    finishedAt: null,
    maximumPoint: 100,
    currentScene: 1,
    totalScenes: 10,
    estimatedReadingTime: 360,
    storyFlow: StoryFlow(
      totalScene: 10,
      decisionPoint: [2, 4, 6],
      ending: [7, 8, 9, 10],
    ),
    characters: [
      Character(
        name: 'Princess Melati',
        description:
            'A kind-hearted princess with long dark hair and bright eyes. She wears a traditional kebaya and is known for her fairness and wisdom.',
      ),
      Character(
        name: 'King Harun',
        description:
            'The aging king with a gentle smile. He values wisdom and fairness, seeking a worthy successor to rule the kingdom.',
      ),
      Character(
        name: 'Tuan Budi',
        description:
            "The kingdom's wise advisor, always wearing a traditional batik shirt. He guides the royal family with honesty and integrity.",
      ),
      Character(
        name: 'Villager Siti',
        description:
            'A kind and honest woman who often shares her thoughts with Princess Melati. She represents the common people of the kingdom.',
      ),
    ],
    userStory: UserStory(
      visitedScene: [],
      choices: [],
      totalPoint: 0,
      finishedTime: 0,
    ),
    scenes: [
      Scene(
        sceneId: 1,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/3ae2be14-b57c-43fa-9f84-ffdf0f17291a.webp',
        imgDescription:
            'A bustling marketplace in the Kingdom of Melati, with colorful stalls and happy villagers.',
        voiceUrl: null,
        content:
            "In the lush Kingdom of Melati, King Harun ruled with kindness and fairness. With his advanced age, he sought a worthy successor among his children. Princess Melati, known for her honesty and empathy, and her brother Prince Rajah, often impulsive, were the candidates. One day, the king announced a challenge: 'Whoever solves the land dispute fairly will inherit the throne!'",
        nextScene: 2,
        branch: null,
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 2,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/3dc2f45c-4e16-48cc-a672-daf5a2b1750b.webp',
        imgDescription:
            "Princess Melati and Prince Rajah stand before a map of the kingdom's lands.",
        voiceUrl: null,
        content:
            "The king presented a map divided into unequal land portions. 'Make this fair for all villagers,' he said. Princess Melati hesitated, while Prince Rajah suggested giving more land to wealthy families. What should Melati do?",
        nextScene: null,
        branch: [
          SceneChoice(
            choice: 'good',
            content:
                'Distribute land equally among all villagers, regardless of wealth.',
            moralValue: 'Justice',
            point: 30,
            nextScene: 3,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Give more land to wealthy families to gain their favor.',
            moralValue: 'Greed',
            point: -20,
            nextScene: 5,
          ),
        ],
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 3,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/a5644183-ff5c-41df-8e78-70b0f70e46ec.webp',
        imgDescription:
            'Villagers cheer as Princess Melati hands out equal land portions.',
        voiceUrl: null,
        content:
            "Princess Melati carefully divided the land, ensuring everyone received a fair share. The villagers rejoiced, calling her 'The Just Princess.' Tuan Budi praised her, 'Your heart is as pure as the morning dew.'",
        nextScene: 4,
        branch: null,
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 4,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/c4a8aa58-7748-4a65-b614-3249c6e8a8ec.webp',
        imgDescription:
            'A merchant points accusingly at a young boy in the marketplace.',
        voiceUrl: null,
        content:
            'A merchant accused a poor boy of stealing a valuable cloth. Villager Siti defended the boy, claiming he was innocent. Should Princess Melati investigate the claim or believe the merchant?',
        nextScene: null,
        branch: [
          SceneChoice(
            choice: 'good',
            content: 'Question the merchant and the boy to find the truth.',
            moralValue: 'Responsibility',
            point: 30,
            nextScene: 7,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Trust the merchant and punish the boy immediately.',
            moralValue: 'Impatience',
            point: -20,
            nextScene: 8,
          ),
        ],
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 5,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/adacc86e-67a2-42c1-981e-89a054cfbea5.webp',
        imgDescription: 'Angry villagers protest outside the palace.',
        voiceUrl: null,
        content:
            "The villagers grew angry when they learned the wealthy received more land. 'This is not justice!' they cried. Tuan Budi warned Princess Melati, 'A ruler must serve all, not just a few.'",
        nextScene: 6,
        branch: null,
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 6,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/ff33db90-187d-4033-af59-0c383c13303b.webp',
        imgDescription:
            'Princess Melati kneels among the protesting villagers, listening to their concerns.',
        voiceUrl: null,
        content:
            'The villagers demanded fair land distribution. Should Princess Melati correct her mistake and redistribute the land, or ignore their pleas to avoid conflict?',
        nextScene: null,
        branch: [
          SceneChoice(
            choice: 'good',
            content: 'Apologize and redistribute the land fairly.',
            moralValue: 'Humility',
            point: 20,
            nextScene: 9,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Refuse to change the distribution to maintain order.',
            moralValue: 'Stubbornness',
            point: -30,
            nextScene: 10,
          ),
        ],
        lessonLearned: null,
        selectedChoice: null,
        endingType: null,
        moralValue: null,
        meaning: null,
        example: null,
      ),
      Scene(
        sceneId: 7,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/b14b6d75-9a05-4f09-8e77-8dbb46cbd33b.webp',
        imgDescription:
            'Princess Melati crowns herself queen, surrounded by cheering villagers.',
        voiceUrl: null,
        content:
            "Princess Melati discovered the merchant had mistakenly accused the boy. The villagers praised her fairness. King Harun declared, 'You are the true heir to the throne!' Princess Melati ruled with honesty and justice, earning the love of her people.",
        nextScene: null,
        branch: null,
        lessonLearned: 'Honesty and fairness earn trust and respect.',
        selectedChoice: null,
        endingType: 'good',
        moralValue: 'Justice',
        meaning:
            'Justice means treating everyone equally, regardless of their status.',
        example:
            'Sharing toys with friends even if you want to keep them shows justice.',
      ),
      Scene(
        sceneId: 8,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/f2c017a4-08df-437a-acf8-09be4551f728.webp',
        imgDescription:
            'Princess Melati, now queen, kneels to apologize to the boy and his family.',
        voiceUrl: null,
        content:
            'Princess Melati punished the boy without proof, later learning he was innocent. She apologized publicly and worked harder to be fair. King Harun still named her queen, but she vowed to never rush judgments again.',
        nextScene: null,
        branch: null,
        lessonLearned:
            'Impatience can lead to unfair consequences, but admitting mistakes is important.',
        selectedChoice: null,
        endingType: 'good',
        moralValue: 'Responsibility',
        meaning:
            'Responsibility means owning up to your actions and correcting mistakes.',
        example:
            "Saying sorry when you accidentally break a friend's toy shows responsibility.",
      ),
      Scene(
        sceneId: 9,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/0cab5144-6ac2-4c1f-a510-be40be807312.webp',
        imgDescription:
            'Princess Melati stands alone, looking out at a kingdom divided.',
        voiceUrl: null,
        content:
            'Princess Melati corrected the land distribution, but some villagers remained distrustful. Though she eventually earned their respect, her early mistake left a lasting impression. She ruled cautiously, always mindful of her actions.',
        nextScene: null,
        branch: null,
        lessonLearned:
            'Unfair decisions can damage trust, but humility can help rebuild it.',
        selectedChoice: null,
        endingType: 'bad',
        moralValue: 'Humility',
        meaning:
            'Humility means acknowledging your mistakes and learning from them.',
        example: 'Apologizing to a teacher after lying shows humility.',
      ),
      Scene(
        sceneId: 10,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/15ff642a-dfaf-45f8-bb52-1d18520b6c0f.webp',
        imgDescription:
            "The kingdom's throne stands empty as villagers walk away in disappointment.",
        voiceUrl: null,
        content:
            'Princess Melati refused to change the land distribution, causing unrest. King Harun declared her unfit to rule. The kingdom fell into disarray, and the people suffered under a new, harsh ruler. Princess Melati realized too late that greed and stubbornness had ruined her chance to lead.',
        nextScene: null,
        branch: null,
        lessonLearned:
            'Stubbornness and greed can destroy trust and opportunities.',
        selectedChoice: null,
        endingType: 'bad',
        moralValue: 'Stubbornness',
        meaning:
            "Stubbornness means refusing to listen or change, even when you're wrong.",
        example:
            "Refusing to share a toy with a friend because you don't want to shows stubbornness.",
      ),
    ],
  );
}
