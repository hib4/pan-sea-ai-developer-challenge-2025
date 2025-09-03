import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/data/data.dart';
import 'package:kanca/features/story/bloc/story_bloc.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/l10n/l10n.dart';
import 'package:kanca/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<StoryBloc>().add(const StoryEvent.getStories());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: 24,
          top: MediaQuery.of(context).padding.top,
          right: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colors.primary[500]!.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Assets.icons.card.svg(
                        width: 32,
                        height: 32,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colors.primary[500]!.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Assets.icons.flash.svg(
                            width: 24,
                            height: 24,
                          ),
                          4.horizontal,
                          Text(
                            '12',
                            style: textTheme.largeBody.copyWith(
                              color: colors.primary[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48,
                  child: Center(
                    child: Assets.icons.kancaText.image(
                      width: 125,
                      height: 32,
                    ),
                  ),
                ),
              ],
            ),
            16.vertical,
            Expanded(
              child: BlocBuilder<StoryBloc, StoryState>(
                builder: (context, state) {
                  return state.storyPreviews.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => Center(
                      child: Assets.lottie.loading.lottie(
                        width: 200,
                        height: 200,
                      ),
                    ),
                    data: (data) {
                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.45,
                              crossAxisSpacing: 24,
                              mainAxisSpacing: 24,
                            ),
                        itemCount: data.data.length,
                        itemBuilder: (context, index) {
                          final story = data.data[index];
                          return StoryCard(story: story);
                        },
                      );
                    },
                    error: (error) {
                      return Center(
                        child: Text(
                          'Failed to load stories: $error',
                          style: textTheme.body,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(const GenerateStoryPage());
        },
        shape: const CircleBorder(),
        backgroundColor: colors.primary[500],
        child: Assets.icons.generate.image(
          width: 47,
          height: 47,
        ),
      ),
    );
  }
}

class StoryCard extends StatelessWidget {
  const StoryCard({required this.story, super.key});

  final Data story;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final l10n = context.l10n;

    return SizedBox(
      width: 181,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                width: 181,
                height: 242,
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 177,
                height: 242,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    story.coverImgUrl,
                    fit: BoxFit.cover,
                    webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not available',
                          style: textTheme.body.copyWith(
                            color: colors.grey[500],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Container(
                width: 8,
                height: 242,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(55, 55, 55, 0.24),
                      Color.fromRGBO(55, 55, 55, 0.80),
                    ],
                    stops: [0.5455, 1.0],
                  ),
                ),
              ),
            ],
          ),
          10.vertical,
          Container(
            width: 181,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0XFFF2F2F2), // Background color
              borderRadius: BorderRadius.circular(17),
            ),
            child: Stack(
              children: [
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colors.darkAccent[500], // Progress color
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '60%',
                    style: textTheme.micro.copyWith(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          10.vertical,
          Text(
            story.title,
            style: textTheme.body.copyWith(
              color: colors.grey[500],
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          4.vertical,
          Text(
            story.description,
            style: textTheme.caption.copyWith(
              color: colors.grey[400],
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          12.vertical,
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Assets.icons.share.svg(
                    width: 12,
                    height: 12,
                  ),
                ),
              ),
              8.horizontal,
              Material(
                color: colors.primary[500],
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () {
                    context.read<StoryBloc>().add(
                      StoryEvent.getStoryById(story.id),
                    );
                    context.push(const StoryLoadingPage());
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Assets.icons.play.svg(
                          width: 16,
                          height: 16,
                        ),
                        8.horizontal,
                        Text(
                          l10n.playButton,
                          style: textTheme.lexendCaption.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
