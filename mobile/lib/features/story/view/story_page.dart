import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';

class Story {
  Story({
    required this.title,
    required this.description,
    required this.coverImgUrl,
    required this.themes,
    required this.scenes,
    required this.currentScene,
    required this.totalScenes,
  });

  final String title;
  final String description;
  final String coverImgUrl;
  final List<String> themes;
  final List<Scene> scenes;
  final int currentScene;
  final int totalScenes;
}

class Scene {
  Scene({
    required this.sceneId,
    required this.type,
    required this.imgUrl,
    required this.imgDescription,
    required this.content,
    this.voiceUrl,
    this.branch,
    this.lessonLearned,
  });

  final int sceneId;
  final String type; // 'narrative', 'decision_point', 'ending'
  final String imgUrl;
  final String imgDescription;
  final String? voiceUrl;
  final String content;
  final List<SceneChoice>? branch;
  final String? lessonLearned;
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
        backgroundColor: colors.neutral[100],
        appBar: AppBar(
          backgroundColor: colors.primary[500],
          elevation: 0,
          title: Text(
            story.title,
            style: textTheme.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _StoryHeader(story: story),
                const SizedBox(height: 32),
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
                    child: Text(
                      'Mulai Cerita',
                      style: textTheme.body.copyWith(color: Colors.white),
                    ),
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
        backgroundColor: colors.neutral[100],
        appBar: AppBar(
          backgroundColor: colors.primary[500],
          elevation: 0,
          title: Text(
            story.title,
            style: textTheme.body.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 16),
          //     child: Center(
          //       child: Text(
          //         '${currentSceneIndex + 1}/${story.totalScenes}',
          //         style: textTheme.caption.copyWith(color: Colors.white),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: Center(
          child: _EndingCard(
            lesson: scene.lessonLearned ?? '',
            onRestart: _restart,
            textTheme: textTheme,
            colors: colors,
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: colors.neutral[100],
      appBar: AppBar(
        backgroundColor: colors.primary[500],
        elevation: 0,
        title: Text(
          story.title,
          style: textTheme.body.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 16),
        //     child: Center(
        //       child: Text(
        //         '${currentSceneIndex + 1}/${story.totalScenes}',
        //         style: textTheme.caption.copyWith(color: Colors.white),
        //       ),
        //     ),
        //   ),
        // ],
      ),
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
          child: Image.network(
            story.coverImgUrl,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
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
          child: Image.network(
            scene.imgUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            errorBuilder: (c, e, s) => Container(
              color: colors.neutral[200],
              child: Center(
                child: Icon(Icons.broken_image, color: colors.grey[400]),
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
                  Colors.white.withOpacity(0.85),
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
                        child: Text(
                          'Lanjut',
                          style: textTheme.body.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  // Align(
                  //   alignment: Alignment.bottomLeft,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 8),
                  //     child: CircleAvatar(
                  //       radius: 32,
                  //       backgroundColor: colors.primary[100],
                  //       child: Icon(
                  //         Icons.pets,
                  //         size: 40,
                  //         color: colors.primary[700],
                  //       ),
                  //     ),
                  //   ),
                  // ),
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
          margin: const EdgeInsets.only(left: 32, top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: colors.primary[100]!.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            content,
            style: textTheme.body.copyWith(
              color: colors.primary[700],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CircleAvatar(
            radius: 28,
            backgroundColor: colors.primary[50],
            child: Icon(icon, color: colors.primary[700], size: 32),
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
    required this.lesson,
    required this.onRestart,
    required this.textTheme,
    required this.colors,
  });

  final String lesson;
  final VoidCallback onRestart;
  final AppTextStyles textTheme;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colors.primary[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pelajaran yang Didapat',
              style: textTheme.h5.copyWith(color: colors.primary[700]),
            ),
            const SizedBox(height: 12),
            Text(lesson, style: textTheme.body),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onRestart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Ulangi Cerita',
                  style: textTheme.body.copyWith(color: Colors.white),
                ),
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
    title: 'Petualangan Investasi Dini di Desa Warna',
    description:
        'Cerita ini mengikuti petualangan Siti dan Budi dalam belajar tentang investasi dan menabung di Desa Warna. Mereka belajar pentingnya perencanaan keuangan dan kewirausahaan sejak dini.',
    coverImgUrl:
        'https://bihackathon.blob.core.windows.net/storage/images/18f1ee52-d729-403d-b5c9-0ccf9ed37aee.png',
    themes: ['Investasi', 'Menabung', 'Kewirausahaan'],
    currentScene: 1,
    totalScenes: 10,
    scenes: [
      Scene(
        sceneId: 1,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/a1dda1cd-872d-4a89-b86b-605cf2bc4a16.png',
        imgDescription:
            'Siti and Budi in the village square discussing their dreams.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/9376b163-bb73-42ef-956f-d7d3427f820a.wav',
        content:
            'Di Desa Warna, Siti dan Budi memulai petualangan baru. Mereka baru saja mendengar dari Pak Ulet tentang pentingnya menabung dan bagaimana investasi dapat membantu mereka mencapai mimpi. Siti bermimpi memiliki perpustakaan sendiri, sedangkan Budi ingin membuka warung es krim. Namun, mereka tahu bahwa mereka harus mulai menabung sejak dini.',
        branch: null,
        lessonLearned: null,
      ),
      Scene(
        sceneId: 2,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/ade24c01-db15-4df8-b381-aef74e4862be.png',
        imgDescription:
            'Siti and Budi holding piggy banks, deciding their next financial step.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/d9fc28bb-21f3-4e67-baca-2fed4791303a.wav',
        content:
            'Siti dan Budi berjalan-jalan di pasar desa. Mereka melihat banyak barang menarik di sana. Siti ingin membeli buku baru, sementara Budi tergoda dengan mainan robot. Namun, mereka tahu uang mereka terbatas. Apa yang harus mereka lakukan?',
        branch: [
          SceneChoice(
            choice: 'baik',
            content: 'Menyimpan uang di celengan untuk investasi masa depan.',
            moralValue:
                'Belajar menabung dan menahan godaan untuk kebutuhan masa depan.',
            point: 50,
            nextScene: 3,
          ),
          SceneChoice(
            choice: 'buruk',
            content:
                'Menghabiskan uang untuk membeli barang-barang yang diinginkan.',
            moralValue:
                'Belajar bahwa menghabiskan uang untuk keinginan bisa menghambat tujuan masa depan.',
            point: -20,
            nextScene: 5,
          ),
        ],
        lessonLearned: null,
      ),
      Scene(
        sceneId: 3,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/5dab4a61-fdfc-4d07-88a4-4e6c3c7bd443.png',
        imgDescription:
            'Siti and Budi happily putting money into their piggy banks.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/62860e73-cfb8-4190-bd58-7686f2d4dc5e.wav',
        content:
            'Siti dan Budi memutuskan untuk menyimpan uang mereka di celengan. Mereka merasa bangga karena bisa menahan godaan dan fokus pada tujuan mereka. Pak Ulet pun memuji keputusan mereka dan memberikan hadiah berupa buku tentang investasi sederhana.',
        branch: null,
        lessonLearned: null,
      ),
      Scene(
        sceneId: 4,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/cba3a113-3d32-4462-a5f0-d244efe186e0.png',
        imgDescription:
            'Siti and Budi discussing a new investment opportunity.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/30d92873-1957-4a5a-a7e2-6c0f15f155ff.wav',
        content:
            'Dengan buku di tangan, Siti dan Budi belajar tentang investasi sederhana seperti membeli bibit tanaman untuk dijual kembali. Mereka berpikir untuk menggunakan sebagian dari tabungan mereka. Apa yang harus mereka lakukan?',
        branch: [
          SceneChoice(
            choice: 'baik',
            content:
                'Menggunakan sebagian uang tabungan untuk membeli bibit dan memulai usaha kecil.',
            moralValue:
                'Belajar memulai usaha dengan modal kecil dan berani mengambil risiko yang terukur.',
            point: 30,
            nextScene: 7,
          ),
          SceneChoice(
            choice: 'buruk',
            content: 'Tetap menabung dan menunda usaha untuk sementara.',
            moralValue:
                'Belajar bahwa kadang-kadang menunda bisa membuat peluang hilang.',
            point: -10,
            nextScene: 8,
          ),
        ],
        lessonLearned: null,
      ),
      Scene(
        sceneId: 5,
        type: 'narrative',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/35de3b7e-3e20-4b61-a903-a7db5fbc9e54.png',
        imgDescription:
            'Siti and Budi feeling a bit regretful after spending their money.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/15f8a4ca-1202-4783-b68f-5fb88bdfc76d.wav',
        content:
            'Siti dan Budi menghabiskan uang mereka untuk barang-barang yang mereka inginkan. Setelah itu, mereka merasa sedikit menyesal karena tidak bisa menabung untuk tujuan mereka. Pak Ulet menasihati mereka tentang pentingnya mengelola keuangan dengan bijak.',
        branch: null,
        lessonLearned: null,
      ),
      Scene(
        sceneId: 6,
        type: 'decision_point',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/27fd25d1-17ce-4653-90f2-b6c2101e31bd.png',
        imgDescription:
            'Siti and Budi considering how to recover their savings.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/8e76e88a-60d1-4f60-a44a-50eb29e93341.wav',
        content:
            'Menyesal telah menghabiskan uang, Siti dan Budi berpikir untuk mulai mengumpulkan uang lagi. Mereka bisa mencari cara untuk mendapatkan uang tambahan. Apa yang harus mereka lakukan?',
        branch: [
          SceneChoice(
            choice: 'baik',
            content:
                'Mencari cara mendapatkan uang dengan membantu di warung Pak Ulet.',
            moralValue:
                'Belajar bahwa kerja keras bisa membantu mencapai tujuan finansial.',
            point: 20,
            nextScene: 9,
          ),
          SceneChoice(
            choice: 'buruk',
            content: 'Membiarkan saja dan berharap ada rezeki lain datang.',
            moralValue:
                'Belajar bahwa menunggu tanpa usaha bisa membuat tujuan semakin jauh.',
            point: -30,
            nextScene: 10,
          ),
        ],
        lessonLearned: null,
      ),
      Scene(
        sceneId: 7,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/6cdb06f8-9d5a-44fd-a3d4-389505065720.png',
        imgDescription:
            'Siti and Budi happily selling plants in the village market.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/60092330-fe6c-4b72-8173-7a71b33e2569.wav',
        content:
            'Siti dan Budi memulai usaha kecil mereka dengan menjual tanaman di pasar desa. Usaha mereka sukses dan mereka belajar banyak tentang investasi dan kewirausahaan. Mereka senang bisa belajar memanfaatkan uang dengan bijak.',
        branch: null,
        lessonLearned:
            'Memulai usaha dan berinvestasi sejak dini bisa membantu mencapai tujuan besar.',
      ),
      Scene(
        sceneId: 8,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/2a49e83c-7f12-4307-a8a4-e3d054302529.png',
        imgDescription:
            'Siti and Budi looking at their piggy banks with a thoughtful expression.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/38e9052d-ca42-4a0a-9fcd-e05056934d7c.wav',
        content:
            'Siti dan Budi memutuskan untuk tetap menabung dan menunda usaha. Mereka belajar bahwa peluang bisa hilang jika tidak berani mengambil langkah. Namun, mereka tetap bertekad untuk mencapai mimpi mereka di masa depan.',
        branch: null,
        lessonLearned:
            'Menunda keputusan bisa membuat kita kehilangan peluang, tetapi belajar dari pengalaman tetap penting.',
      ),
      Scene(
        sceneId: 9,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/18e54e6a-c3c6-47cf-b739-b91099908c60.png',
        imgDescription:
            'Siti and Budi helping at Pak Ulet\'s warung, earning some money.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/808a50b2-e267-46db-a2a0-701a041e2950.wav',
        content:
            'Siti dan Budi mulai bekerja di warung Pak Ulet. Mereka belajar menghargai kerja keras dan pelan-pelan mengumpulkan uang kembali. Pengalaman ini mengajarkan mereka tentang tanggung jawab dan kerja keras.',
        branch: null,
        lessonLearned:
            'Kerja keras dan tekad bisa membantu kita bangkit dari kesalahan finansial.',
      ),
      Scene(
        sceneId: 10,
        type: 'ending',
        imgUrl:
            'https://bihackathon.blob.core.windows.net/storage/images/28c3adbd-b2a2-4ed4-babd-31cdabd199e3.png',
        imgDescription:
            'Siti and Budi sitting under a tree, pondering their financial choices.',
        voiceUrl:
            'https://bihackathon.blob.core.windows.net/storage/voices/86b1cec3-49b7-42ae-b222-c915f8b0599d.wav',
        content:
            'Siti dan Budi membiarkan kesempatan untuk menambah tabungan lewat begitu saja. Mereka menyadari bahwa tanpa usaha, mimpi mereka akan sulit tercapai. Namun, mereka berjanji untuk lebih bijak di masa depan.',
        branch: null,
        lessonLearned:
            'Menunggu tanpa usaha membuat tujuan semakin jauh, tetapi kegagalan bisa menjadi pelajaran berharga.',
      ),
    ],
  );
}
