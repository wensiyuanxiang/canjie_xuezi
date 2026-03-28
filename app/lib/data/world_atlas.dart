import 'package:flutter/material.dart';

/// 世界观中的主题世界（GDD 4.4 八大世界）。MVP 仅开放山野，其余为预告。
class WorldAtlasRegion {
  const WorldAtlasRegion({
    required this.id,
    required this.title,
    required this.volumeNumber,
    required this.themeLabel,
    required this.teaser,
    required this.roadmapBlurb,
    required this.icon,
    required this.isPlayable,
  });

  final String id;
  final String title;
  final int volumeNumber;
  final String themeLabel;
  final String teaser;
  final String roadmapBlurb;
  final IconData icon;
  final bool isPlayable;

  String get volumeTitle {
    const List<String> digits = <String>[
      '',
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
    ];
    if (volumeNumber < 1 || volumeNumber > 8) {
      return title;
    }
    return '卷${digits[volumeNumber]} · $title';
  }
}

/// 固定顺序，与 GDD 八大世界一致。
const List<WorldAtlasRegion> kWorldAtlasRegions = <WorldAtlasRegion>[
  WorldAtlasRegion(
    id: 'wild',
    title: '山野',
    volumeNumber: 1,
    themeLabel: '自然地理',
    teaser: '山河湖海、石土火木……从墨壳里切出世界的轮廓。',
    roadmapBlurb: '灰白山野将随关卡逐一恢复色彩，终点是巨石字灵。',
    icon: Icons.terrain_rounded,
    isPlayable: true,
  ),
  WorldAtlasRegion(
    id: 'sky',
    title: '天穹',
    volumeNumber: 2,
    themeLabel: '天象时令',
    teaser: '日月星斗、风雨雪霜……天空会记住每一次正确的笔锋。',
    roadmapBlurb: '一纪点亮星辰，二纪四季流转，三纪节气如走马灯。',
    icon: Icons.nights_stay_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'pastoral',
    title: '田园',
    volumeNumber: 3,
    themeLabel: '动植物',
    teaser: '牛马鸟鱼、花草虫鱼……荒地会重新听见生命的声音。',
    roadmapBlurb: '从一粒种子到一整条食物链，字灵让田园活过来。',
    icon: Icons.grass_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'home',
    title: '家园',
    volumeNumber: 4,
    themeLabel: '身体家庭',
    teaser: '人口手足、父母兄妹……空屋里会重新亮起灯火。',
    roadmapBlurb: '先认身体，再认家人，最后让家的故事在场景里发生。',
    icon: Icons.cottage_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'village',
    title: '村落',
    volumeNumber: 5,
    themeLabel: '生活器物',
    teaser: '门窗桌椅、衣食米车……街巷里会升起炊烟与叫卖。',
    roadmapBlurb: '器物归位，村落从寂静变得热闹，字就是生活的形状。',
    icon: Icons.holiday_village_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'school',
    title: '学堂',
    volumeNumber: 6,
    themeLabel: '文教读写',
    teaser: '文书笔墨、字言读写……白纸将浮现第一行认真的字迹。',
    roadmapBlurb: '从描红到成篇，学堂世界把「表达」交还给孩子。',
    icon: Icons.menu_book_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'market',
    title: '集市',
    volumeNumber: 7,
    themeLabel: '社会职业',
    teaser: '金工商医、街坊百业……空街会挂满招牌与故事。',
    roadmapBlurb: '每个职业是一类字，集市让社会重新拥挤而温暖。',
    icon: Icons.storefront_rounded,
    isPlayable: false,
  ),
  WorldAtlasRegion(
    id: 'observatory',
    title: '星台',
    volumeNumber: 8,
    themeLabel: '数理方位',
    teaser: '一二三四、上下左右……暗星连成星座，方向不再迷失。',
    roadmapBlurb: '数与方位是世界的骨架，星台为整颗汉字星球定锚。',
    icon: Icons.auto_awesome_rounded,
    isPlayable: false,
  ),
];
