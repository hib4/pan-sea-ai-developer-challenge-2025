import 'package:flutter/material.dart';
import 'package:kanca/core/core.dart';
import 'package:kanca/features/story/story.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/utils/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                            '78',
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
              child: GridView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.45,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const StoryCard();
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
  const StoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
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
                  child: Assets.images.kimo2.image(
                    fit: BoxFit.cover,
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
            'Kimo and Friends Mini Adventure',
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
            'Learn how to save money with Kimo the Fox',
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
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: colors.primary[500],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Assets.icons.play.svg(
                      width: 16,
                      height: 16,
                    ),
                    8.horizontal,
                    Text(
                      'Play',
                      style: textTheme.lexendCaption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
