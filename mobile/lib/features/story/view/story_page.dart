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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Mulai Cerita'),
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
                  height: 180,
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
                    borderRadius: BorderRadius.circular(8),
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
                        child: const Text('Lanjut'),
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
    id: '689dedaccc3eb2600d547ede',
    userId: '689ddfa87511fa82112bcbce',
    title: 'The Magic Paintbrush Team',
    description:
        'Three friends must learn to work together to win the school art contest. Will they create something magical together or let their differences tear them apart?',
    coverImgUrl:
        'https://bihackathon.blob.core.windows.net/storage/images/0964ce18-2665-4e25-b92d-a7f6f1dcb27e.png',
    themes: ['Teamwork', 'Cooperation', 'Problem Solving'],
    language: 'English',
    status: 'not_started',
    ageGroup: 8,
    createdAt: '2025-08-14T14:07:40.873000',
    maximumPoint: 10,
    currentScene: 1,
    totalScenes: 10,
    estimatedReadingTime: 120,
    storyFlow: StoryFlow(
      totalScene: 10,
      decisionPoint: [2, 4, 6],
      ending: [7, 8, 9, 10],
    ),
    characters: [
      Character(
        name: 'Lina',
        description:
            'A kind and organized leader with curly brown hair. She loves planning and making sure everyone is happy.',
      ),
      Character(
        name: 'Ben',
        description:
            "A shy but talented artist with glasses. He's quiet but has amazing ideas when he speaks up.",
      ),
      Character(
        name: 'Mia',
        description:
            "A confident and creative girl with a big smile. She sometimes forgets to listen to others' ideas.",
      ),
      Character(
        name: 'Mrs. Green',
        description:
            'A warm and encouraging teacher with green earrings. She believes in the power of teamwork.',
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
            'https://bihackathon.blob.core.windows.net/storage/images/8de026ca-f55f-4a20-b1f5-5fcf851d34f8.png',
        imgDescription:
            'A classroom filled with colorful posters. Mrs. Green stands at the front, holding a paintbrush.',
        content:
            "The big school art contest was coming up! Mrs. Green announced that each class needed to create one special project. 'This year, we're making a mural!' she said. 'Who has ideas?'\n\nLina jumped up. 'We could paint a magical forest!' Ben whispered, 'Maybe add a rainbow?' Mia shouted, 'I want to paint a unicorn!' The class buzzed with excitement. But how would they decide what to make?",
        nextScene: 2,
      ),
      Scene(
        sceneId: 2,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/ba090920-cfea-49ae-8e6a-cf10f1085401.png',
        imgDescription: 'The class voting on ideas, with hands raised.',
        content:
            "The class voted on ideas. Lina said, 'Let's make a magical forest with everyone's ideas!' Mia said, 'I want to paint my own unicorn!' Ben whispered, 'Maybe we can combine both ideas...'\n\nWhat should they do?",
        branch: [
          SceneChoice(
            choice: 'good',
            content: "Combine everyone's ideas into one big mural!",
            moralValue: 'Teamwork',
            point: 3,
            nextScene: 3,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Let each student paint their own small picture.',
            moralValue: 'Individualism',
            point: -2,
            nextScene: 5,
          ),
        ],
      ),
      Scene(
        sceneId: 3,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/a4605fb5-8e87-41f7-b228-f5959502522f.png',
        imgDescription:
            'The class sketching a mural with a forest, rainbow, and unicorn.',
        content:
            "They decided to make one big mural! Lina organized the sections. Ben drew a beautiful rainbow. Mia painted a sparkly unicorn. But Mia started adding too many unicorns, making the forest look crowded.\n\n'Wait, Mia,' Lina said gently. 'We need space for the trees too.' Should Mia listen or keep adding unicorns?",
        nextScene: 4,
      ),
      Scene(
        sceneId: 4,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/4a8ea64a-2ccc-40f8-a1d4-0ab9e6eb1fbd.png',
        imgDescription: 'Mia holding a paintbrush, looking unsure.',
        content:
            "Mia frowned. 'But I love unicorns!' Ben suggested, 'What if we make one big unicorn with a rainbow mane?' Mia thought... Should she share her idea or keep it to herself?",
        branch: [
          SceneChoice(
            choice: 'good',
            content: 'Share her unicorn idea with Ben and Lina.',
            moralValue: 'Cooperation',
            point: 3,
            nextScene: 7,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Keep painting unicorns without asking.',
            moralValue: 'Selfishness',
            point: -2,
            nextScene: 8,
          ),
        ],
      ),
      Scene(
        sceneId: 5,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/759b8acb-3119-4538-b109-fb835f082efd.png',
        imgDescription: 'Students working alone on separate paintings.',
        content:
            "Each student painted their own small picture. Lina made a forest, Ben painted a rainbow, and Mia drew a unicorn. But when they tried to hang them together, they looked messy and didn't match.\n\nMrs. Green said, 'Maybe if you combine them...'\n\nShould they try to fix it together or give up?",
        nextScene: 6,
      ),
      Scene(
        sceneId: 6,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/0c5bdcb8-051d-4943-8d29-506cd64ee54c.png',
        imgDescription: 'Students looking at their mismatched paintings.',
        content:
            "Lina said, 'Let's try!' Ben said, 'But it's too late!' Mia said, 'I don't want to change my unicorn!' Should they try to fix it together or keep their own work?",
        branch: [
          SceneChoice(
            choice: 'good',
            content: 'Work together to combine the paintings.',
            moralValue: 'Problem Solving',
            point: 3,
            nextScene: 9,
          ),
          SceneChoice(
            choice: 'bad',
            content: 'Keep the paintings separate and hope for the best.',
            moralValue: 'Laziness',
            point: -2,
            nextScene: 10,
          ),
        ],
      ),
      Scene(
        sceneId: 7,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/f6d6e83a-0e87-47e4-b37a-1ea14114f1a1.png',
        imgDescription:
            'The class holding a first-place ribbon in front of their beautiful mural.',
        content:
            "They created a magical forest with a rainbow, a unicorn, and space for everyone's ideas! The judges loved it. 'First place!' they cheered. Mrs. Green smiled, 'See? When we work together, anything is possible!'\n\n**Lesson:** Teamwork makes dreams come true.",
        lessonLearned: 'Teamwork and sharing ideas create something amazing.',
        endingType: 'good',
        moralValue: 'Teamwork',
        meaning:
            'Teamwork means working together to achieve something greater than you could alone.',
        example:
            "Like when you and your friends build a fort together – it's stronger and more fun!",
      ),
      Scene(
        sceneId: 8,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/83995eef-03fa-40ae-9d8e-916806f5903b.png',
        imgDescription:
            'The class standing in front of a messy mural with arguing students.',
        content:
            "They argued about the mural, and it ended up looking messy. The judges said, 'Great effort, but it needs teamwork.' They didn't win, but Mrs. Green said, 'Let's try again next time, together!'\n\n**Lesson:** Teamwork is better than working alone, but it takes practice.",
        lessonLearned: "Even when teamwork is hard, it's worth trying.",
        endingType: 'bad',
        moralValue: 'Cooperation',
        meaning:
            "Cooperation means working together even when it's challenging.",
        example:
            "Like when you and your sibling clean your room together – it's faster and less messy.",
      ),
      Scene(
        sceneId: 9,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/62c4079c-32b8-4be5-b531-8b44055dc6e0.png',
        imgDescription:
            'The class holding a second-place ribbon in front of mismatched paintings.',
        content:
            "They tried to combine their paintings, but it looked patchy. They got second place. Mrs. Green said, 'Good job trying! Next time, let's plan together first.'\n\n**Lesson:** Teamwork is better than working alone, but planning helps.",
        lessonLearned: 'Planning and teamwork lead to better results.',
        endingType: 'bad',
        moralValue: 'Problem Solving',
        meaning: 'Problem Solving means finding creative ways to fix mistakes.',
        example:
            'Like when you spill glue – you clean it up instead of giving up.',
      ),
      Scene(
        sceneId: 10,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/ab622f8a-7b65-4abd-aef3-2ec42afbc27b.png',
        imgDescription:
            'The class looking disappointed in front of separate paintings.',
        content:
            "They kept their paintings separate and didn't win anything. Mrs. Green said, 'Remember, teamwork makes everything better. Let's try again next time!'\n\n**Lesson:** Teamwork is essential for success.",
        lessonLearned: 'Teamwork is necessary to achieve great things.',
        endingType: 'bad',
        moralValue: 'Teamwork',
        meaning:
            'Teamwork means everyone working together toward a common goal.',
        example:
            'Like a soccer team – each player has a role, and together they win the game.',
      ),
    ],
  );
}
