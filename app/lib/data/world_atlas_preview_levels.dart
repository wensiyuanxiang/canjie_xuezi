import 'world_atlas.dart';

/// 未开放世界在地图页展示的「官卡」占位，与山野真关卡列表版式一致。
class WorldAtlasPlaceholderLevel {
  const WorldAtlasPlaceholderLevel({
    required this.indexLabel,
    required this.title,
    required this.mapPosition,
    required this.mapTeaser,
    required this.kidHint,
    required this.isBoss,
  });

  final String indexLabel;
  final String title;
  final String mapPosition;
  final String mapTeaser;
  final String kidHint;
  final bool isBoss;
}

/// 各卷预告关卡（5 常关 + BOSS），文案与世界主题对齐。
List<WorldAtlasPlaceholderLevel> previewLevelsForRegion(WorldAtlasRegion region) {
  if (region.isPlayable) {
    return const <WorldAtlasPlaceholderLevel>[];
  }
  switch (region.id) {
    case 'sky':
      return _sky;
    case 'pastoral':
      return _pastoral;
    case 'home':
      return _home;
    case 'village':
      return _village;
    case 'school':
      return _school;
    case 'market':
      return _market;
    case 'observatory':
      return _observatory;
    default:
      return const <WorldAtlasPlaceholderLevel>[];
  }
}

String lockedComingSoonSnack(WorldAtlasRegion region) =>
    '「${region.volumeTitle}」还在筹备中，先去山野练笔锋吧！';

const List<WorldAtlasPlaceholderLevel> _sky = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '启明星语',
    mapPosition: 'bottom-left',
    mapTeaser: '最暗的夜空里，第一颗字在等你点亮…',
    kidHint: '星星的字常常带点、有角，像小光点在眨眼~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '云涌风起',
    mapPosition: 'center-left',
    mapTeaser: '云和风的字会飘在半空，别被它们绕晕哦。',
    kidHint: '雨字头、风字边，都是天气留给字的记号。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '雨露印记',
    mapPosition: 'center',
    mapTeaser: '雨滴落下，会在天幕上留下弯弯的笔画。',
    kidHint: '三点水常常和水有关，找找藏在哪一笔里！',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '霜雪塑型',
    mapPosition: 'center-right',
    mapTeaser: '北风把天空的字吹成六角雪花的样子。',
    kidHint: '雨、雪有时长得像一家人，比一比哪里不一样。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '岁序轮转',
    mapPosition: 'top-left',
    mapTeaser: '春夏秋冬排队路过，节气像一串小灯笼。',
    kidHint: '日和月常常出现在时令字里，像小太阳小月亮。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '辰极字灵',
    mapPosition: 'top-right',
    mapTeaser: '整片星座合成的大字灵，守着天穹最后一道光…',
    kidHint: 'BOSS 会把你学过的天气字混在一起，慢慢找，不着急~',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _pastoral = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '芽尖初绿',
    mapPosition: 'bottom-left',
    mapTeaser: '荒地裂开一条缝，小草的字探出头来。',
    kidHint: '草字头、木字旁，常常和植物是好朋友。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '虫鸣蝶影',
    mapPosition: 'center-left',
    mapTeaser: '小虫子的字爬过叶面，蝴蝶留下对称的花纹。',
    kidHint: '虫字旁的字多半和小动物有关，形状细细长长的~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '牛马牧歌',
    mapPosition: 'center',
    mapTeaser: '田埂上走来牛羊，蹄印连成一串生字。',
    kidHint: '牛字像一对牛角，马字像扬起的鬃毛。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '鱼鸟同游',
    mapPosition: 'center-right',
    mapTeaser: '水里鱼跃，天上鸟飞，两个世界的字擦肩。',
    kidHint: '鸟字常常有翅膀样的笔画，鱼字像尾巴摆呀摆。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '花木成林',
    mapPosition: 'top-left',
    mapTeaser: '花与树牵起手，田园的颜色一层层铺开。',
    kidHint: '木字叠起来有时是林、是森，数一数有几棵「树」~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '生态园灵',
    mapPosition: 'top-right',
    mapTeaser: '整片田园的生灵合成的大字灵，等待被唤醒…',
    kidHint: '把动物和植物的字分开想，就不容易切错啦！',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _home = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '手足连心',
    mapPosition: 'bottom-left',
    mapTeaser: '先认自己的手与足，身体开始有了名字。',
    kidHint: '月肉旁的字有时和身体有关，看看哪一笔像小胳膊~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '目耳口鼻',
    mapPosition: 'center-left',
    mapTeaser: '脸上的小窗户一扇扇打开，世界变得清楚。',
    kidHint: '口字方方正正，目字像竖起来的眼睛。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '灯火人家',
    mapPosition: 'center',
    mapTeaser: '空屋里亮起一盏灯，家的形状浮现出来。',
    kidHint: '户、门、家，常常和房子有关，比一比谁更「大」~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '亲情称谓',
    mapPosition: 'center-right',
    mapTeaser: '爸妈哥姐的字贴在门框上，声音也回来了。',
    kidHint: '称谓字里常有「父」「母」「兄」，像小标签。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '家常百味',
    mapPosition: 'top-left',
    mapTeaser: '厨房飘出香味，米面油盐排队登场。',
    kidHint: '米字旁、食字旁，常常和吃的有关哦。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '阖家字灵',
    mapPosition: 'top-right',
    mapTeaser: '一家人合成的大字灵，守着家园最后一盏灯…',
    kidHint: 'BOSS 会把家人和身体字混在一起，记得先看提示~',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _village = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '巷陌初开',
    mapPosition: 'bottom-left',
    mapTeaser: '石板路延伸出去，村落的轮廓一笔笔描清。',
    kidHint: '村、里、坊，常常和住的地方有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '门窗为序',
    mapPosition: 'center-left',
    mapTeaser: '门扉吱呀作响，窗棂透出暖黄的光。',
    kidHint: '门字框像门框，看看哪一笔是「门槛」~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '衣食所安',
    mapPosition: 'center',
    mapTeaser: '布衣与米袋归位，日子有了沉甸甸的质感。',
    kidHint: '衣字旁、米字旁，想想你每天摸到的东西。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '刀车舟楫',
    mapPosition: 'center-right',
    mapTeaser: '小刀、小车、小船，器物开始会自己走动。',
    kidHint: '车、舟长得像它们的样子，切的时候想一想实物~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '烟火升腾',
    mapPosition: 'top-left',
    mapTeaser: '炊烟与叫卖声升起，街巷热闹起来。',
    kidHint: '火字旁、口字旁，有时和吃喝、声音有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '百工字灵',
    mapPosition: 'top-right',
    mapTeaser: '全村器物合成的大字灵，守着人间烟火…',
    kidHint: '把「吃的」和「用的」分开想，就不容易混啦！',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _school = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '纸墨初香',
    mapPosition: 'bottom-left',
    mapTeaser: '白纸铺开，墨香像细线钻进字里。',
    kidHint: '文、书、字，常常和学堂是好朋友。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '笔锋练习',
    mapPosition: 'center-left',
    mapTeaser: '一笔一画跟着先生走，笔锋渐渐听话。',
    kidHint: '笔、墨、纸、砚，合称文房，可以背一背~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '字言成句',
    mapPosition: 'center',
    mapTeaser: '单个的字排成队，变成一句话的形状。',
    kidHint: '言字旁、口字旁，有时和说话、语言有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '读诵声声',
    mapPosition: 'center-right',
    mapTeaser: '读书声在梁间回荡，学堂有了节奏。',
    kidHint: '读、诵、诗，看看哪一笔像「声音」在跳。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '篇章初成',
    mapPosition: 'top-left',
    mapTeaser: '第一页文章钉成册，知识有了家。',
    kidHint: '篇、章、页，和书有关的字可以放在一起记。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '翰墨字灵',
    mapPosition: 'top-right',
    mapTeaser: '万卷合成的大字灵，守着文教之光…',
    kidHint: 'BOSS 会考你「文具」和「读写」字，别急，慢慢切~',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _market = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '空街待市',
    mapPosition: 'bottom-left',
    mapTeaser: '长街静静躺着，等第一块招牌挂起。',
    kidHint: '市、街、店，常常和买卖的地方有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '金工巧作',
    mapPosition: 'center-left',
    mapTeaser: '叮当声里，金银铜铁有了各自的名字。',
    kidHint: '金字旁的字常常和金属有关，闪闪发亮~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '农商百业',
    mapPosition: 'center',
    mapTeaser: '农夫与工匠擦肩，招牌一字排开。',
    kidHint: '农、工、商，想想爸爸妈妈做什么工作~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '医兵官卫',
    mapPosition: 'center-right',
    mapTeaser: '药香与盔甲的气息交织，街巷有了守护。',
    kidHint: '医、兵、官，笔画多一点的要慢慢认哦。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '万国来集',
    mapPosition: 'top-left',
    mapTeaser: '远近客商汇聚，集市终于拥挤起来。',
    kidHint: '国、王、民，常常和「大地方」的故事有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '万商字灵',
    mapPosition: 'top-right',
    mapTeaser: '百业招牌合成的大字灵，守着人间繁华…',
    kidHint: '职业字很多带偏旁，先找最像图画的那一个~',
    isBoss: true,
  ),
];

const List<WorldAtlasPlaceholderLevel> _observatory = <WorldAtlasPlaceholderLevel>[
  WorldAtlasPlaceholderLevel(
    indexLabel: '1',
    title: '一数一灯',
    mapPosition: 'bottom-left',
    mapTeaser: '暗夜里数到一，第一盏星灯被点亮。',
    kidHint: '一、二、三，像小棍子排队，注意弯和直~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '2',
    title: '百千成阵',
    mapPosition: 'center-left',
    mapTeaser: '数字牵起手，排成更大的方阵。',
    kidHint: '十、百、千，越往上笔画越多，别急~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '3',
    title: '上下左右',
    mapPosition: 'center',
    mapTeaser: '方位字像小箭头，指你去往哪里。',
    kidHint: '上小下大，左撇右捺，和身体方向对对看~',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '4',
    title: '方圆规矩',
    mapPosition: 'center-right',
    mapTeaser: '方与圆落位，天地有了尺度。',
    kidHint: '方框、圆环，有时藏在字里当偏旁。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: '5',
    title: '星图连线',
    mapPosition: 'top-left',
    mapTeaser: '星点连成图案，方向不再迷路。',
    kidHint: '星、斗、辰，常常和亮晶晶的东西有关。',
    isBoss: false,
  ),
  WorldAtlasPlaceholderLevel(
    indexLabel: 'BOSS',
    title: '周天字灵',
    mapPosition: 'top-right',
    mapTeaser: '数理与方位合成的大字灵，为星球定锚…',
    kidHint: '数字和方位混在一起的时候，先找最「简单」的那一个~',
    isBoss: true,
  ),
];
