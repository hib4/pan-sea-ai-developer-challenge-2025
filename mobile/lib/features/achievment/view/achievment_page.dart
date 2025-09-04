import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanca/core/theme/app_theme.dart';
import 'package:kanca/features/achievment/widgets/mission_item_widget.dart';
import 'package:kanca/gen/assets.gen.dart';
import 'package:kanca/l10n/l10n.dart';
import 'package:kanca/utils/utils.dart';

class AchievmentPage extends StatefulWidget {
  const AchievmentPage({super.key});

  @override
  State<AchievmentPage> createState() => _AchievmentPageState();
}

class _AchievmentPageState extends State<AchievmentPage> {
  // Sample mission data
  final List<Map<String, dynamic>> missions = const [
    {
      'title': 'Make a story',
      'xpReward': '+50 XP',
      'currentProgress': 1,
      'totalProgress': 1,
      'isCompleted': true,
    },
    {
      'title': 'Read 3 books',
      'xpReward': '+30 XP',
      'currentProgress': 2,
      'totalProgress': 3,
      'isCompleted': false,
    },
    {
      'title': 'Complete daily quiz',
      'xpReward': '+20 XP',
      'currentProgress': 0,
      'totalProgress': 1,
      'isCompleted': false,
    },
    {
      'title': 'Share a story',
      'xpReward': '+40 XP',
      'currentProgress': 1,
      'totalProgress': 1,
      'isCompleted': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.neutral[500],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 150),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).viewPadding.top + 24,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: colors.neutral[500],
                border: Border(
                  bottom: BorderSide(
                    color: colors.secondary[800]!,
                    width: 4,
                  ),
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Assets.icons.throphyBronze.image(
                          width: 94,
                          height: 94,
                        ),
                        Assets.icons.throphySilver.image(
                          width: 72,
                          height: 72,
                        ),
                        Assets.icons.throphyGold.image(
                          width: 72,
                          height: 72,
                        ),
                        Assets.icons.throphyPlatinum.image(
                          width: 72,
                          height: 72,
                        ),
                      ],
                    ),
                  ),
                  32.vertical,
                  Divider(
                    color: colors.primary[100],
                    thickness: 1,
                    height: 1,
                  ),
                  24.vertical,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0XFFC45F19),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.achievementBeginner,
                              style: GoogleFonts.fredoka(
                                color: const Color(0XFFC45F19),
                                fontSize: 21,
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Text(
                            l10n.achievementLevel(1),
                            style: GoogleFonts.fredoka(
                              color: const Color(0XFFC45F19),
                              fontSize: 47,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          8.vertical,
                          Container(
                            width: 247,
                            height: 20,
                            decoration: BoxDecoration(
                              color: colors.grey[50],
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.6,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0XFFC45F19),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          8.vertical,
                          Text(
                            l10n.achievementXP(110, 400),
                            style: GoogleFonts.fredoka(
                              color: const Color(0XFFC45F19),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      4.horizontal,
                      Assets.icons.kanca.image(
                        width: 140,
                        height: 140,
                      ),
                    ],
                  ).withPadding(left: 24),
                ],
              ),
            ),
            24.vertical,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.achievementDailyMission,
                  style: GoogleFonts.fredoka(
                    color: Colors.black,
                    fontSize: 27,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                Row(
                  children: [
                    Assets.icons.clock.svg(
                      width: 16,
                      height: 16,
                    ),
                    4.horizontal,
                    Text(
                      l10n.achievementTimeRemaining(10),
                      style: GoogleFonts.fredoka(
                        color: colors.primary[500],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ).withPadding(horizontal: 24),
            16.vertical,
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: missions.length,
              itemBuilder: (context, index) {
                final mission = missions[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: missions.length - 1 == index ? 0 : 8,
                  ),
                  child: MissionItemWidget(
                    title: mission['title'] as String,
                    xpReward: mission['xpReward'] as String,
                    currentProgress: mission['currentProgress'] as int,
                    totalProgress: mission['totalProgress'] as int,
                    isCompleted: mission['isCompleted'] as bool,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
