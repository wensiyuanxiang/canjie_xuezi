import type { AssetEntry } from "../types/game";

type BackgroundKey =
  | "home"
  | "worldMap"
  | "mountainGray"
  | "mountainColor"
  | "result"
  | "calibration"
  | "settings"
  | "collection"
  | "bossMountain";

type MusicKey = "home" | "worldMap" | "mountain" | "result" | "boss";

type SfxKey =
  | "slashCorrect"
  | "slashWrong"
  | "comboUp"
  | "levelClear"
  | "buttonClick"
  | "unlock"
  | "worldReveal"
  | "charCard"
  | "bossComplete";

export interface ManagedAssetEntry extends AssetEntry {
  relativePath: string;
  status: "placeholder" | "ready";
}

const makeEntry = (
  key: string,
  expectedFileName: string,
  relativePath: string,
  fallbackClassName: string,
): ManagedAssetEntry => ({
  key,
  expectedFileName,
  relativePath,
  fallbackClassName,
  status: "placeholder",
});

export const backgroundAssets: Record<BackgroundKey, ManagedAssetEntry> = {
  home: makeEntry(
    "home",
    "bg-home.png",
    "src/assets/images/bg/bg-home.png",
    "bg-scene-home",
  ),
  worldMap: makeEntry(
    "worldMap",
    "bg-worldmap.png",
    "src/assets/images/bg/bg-worldmap.png",
    "bg-scene-map",
  ),
  mountainGray: makeEntry(
    "mountainGray",
    "bg-mountain-gray.png",
    "src/assets/images/bg/bg-mountain-gray.png",
    "bg-scene-mountain-gray",
  ),
  mountainColor: makeEntry(
    "mountainColor",
    "bg-mountain-color.png",
    "src/assets/images/bg/bg-mountain-color.png",
    "bg-scene-mountain-color",
  ),
  result: makeEntry(
    "result",
    "bg-result.png",
    "src/assets/images/bg/bg-result.png",
    "bg-scene-result",
  ),
  calibration: makeEntry(
    "calibration",
    "bg-calibration.png",
    "src/assets/images/bg/bg-calibration.png",
    "bg-scene-calibration",
  ),
  settings: makeEntry(
    "settings",
    "bg-settings.png",
    "src/assets/images/bg/bg-settings.png",
    "bg-scene-settings",
  ),
  collection: makeEntry(
    "collection",
    "bg-collection.png",
    "src/assets/images/bg/bg-collection.png",
    "bg-scene-collection",
  ),
  bossMountain: makeEntry(
    "bossMountain",
    "bg-boss-mountain.png",
    "src/assets/images/bg/bg-boss-mountain.png",
    "bg-scene-boss",
  ),
};

export const musicAssets: Record<MusicKey, ManagedAssetEntry> = {
  home: makeEntry("home", "bgm-home.mp3", "src/assets/audio/bgm/bgm-home.mp3", ""),
  worldMap: makeEntry(
    "worldMap",
    "bgm-worldmap.mp3",
    "src/assets/audio/bgm/bgm-worldmap.mp3",
    "",
  ),
  mountain: makeEntry(
    "mountain",
    "bgm-mountain.mp3",
    "src/assets/audio/bgm/bgm-mountain.mp3",
    "",
  ),
  result: makeEntry(
    "result",
    "bgm-result.mp3",
    "src/assets/audio/bgm/bgm-result.mp3",
    "",
  ),
  boss: makeEntry("boss", "bgm-boss.mp3", "src/assets/audio/bgm/bgm-boss.mp3", ""),
};

export const sfxAssets: Record<SfxKey, ManagedAssetEntry> = {
  slashCorrect: makeEntry(
    "slashCorrect",
    "sfx-slash-correct.mp3",
    "src/assets/audio/sfx/sfx-slash-correct.mp3",
    "",
  ),
  slashWrong: makeEntry(
    "slashWrong",
    "sfx-slash-wrong.mp3",
    "src/assets/audio/sfx/sfx-slash-wrong.mp3",
    "",
  ),
  comboUp: makeEntry(
    "comboUp",
    "sfx-combo-up.mp3",
    "src/assets/audio/sfx/sfx-combo-up.mp3",
    "",
  ),
  levelClear: makeEntry(
    "levelClear",
    "sfx-level-clear.mp3",
    "src/assets/audio/sfx/sfx-level-clear.mp3",
    "",
  ),
  buttonClick: makeEntry(
    "buttonClick",
    "sfx-btn-click.mp3",
    "src/assets/audio/sfx/sfx-btn-click.mp3",
    "",
  ),
  unlock: makeEntry(
    "unlock",
    "sfx-unlock.mp3",
    "src/assets/audio/sfx/sfx-unlock.mp3",
    "",
  ),
  worldReveal: makeEntry(
    "worldReveal",
    "sfx-world-reveal.mp3",
    "src/assets/audio/sfx/sfx-world-reveal.mp3",
    "",
  ),
  charCard: makeEntry(
    "charCard",
    "sfx-char-card.mp3",
    "src/assets/audio/sfx/sfx-char-card.mp3",
    "",
  ),
  bossComplete: makeEntry(
    "bossComplete",
    "sfx-boss-complete.mp3",
    "src/assets/audio/sfx/sfx-boss-complete.mp3",
    "",
  ),
};

export const getAssetLabel = (entry: ManagedAssetEntry): string =>
  `${entry.expectedFileName} · ${entry.status === "ready" ? "已接入" : "待素材交付"}`;
