export type AppScreen =
  | "home"
  | "settings"
  | "calibration"
  | "worldMap"
  | "game"
  | "result"
  | "collection";

export type InputMode = "touch" | "camera";

export type LevelMode = "recognize_shape" | "listen" | "boss" | "radical";

export interface CharacterEntry {
  id: string;
  char: string;
  pinyin: string;
  world: "mountain";
  theme: string;
  words: string[];
  hint: string;
  repairLabel: string;
  radical?: string;
}

export interface PassCondition {
  type: "slice_count" | "boss_charge";
  char?: string;
  total?: number;
  count: number;
}

export interface LevelTarget {
  char: string;
  count: number;
}

export interface LevelConfig {
  id: string;
  epoch: number;
  world: "mountain";
  level: number;
  title: string;
  mode: LevelMode;
  durationSec: number;
  newChars: string[];
  targetChars: LevelTarget[];
  distractorChars: LevelTarget[];
  hangTime: number;
  maxSimultaneous: number;
  passCondition: PassCondition;
  objectiveText: string;
  repairPreview: string;
  bossChar?: string;
  bossParts?: string[];
}

export interface CompletedLevelRecord {
  levelId: string;
  accuracy: number;
  combo: number;
  cleared: boolean;
}

export interface GameResult {
  levelId: string;
  cleared: boolean;
  targetHits: number;
  wrongHits: number;
  misses: number;
  maxCombo: number;
  learnedChars: string[];
  repairPreview: string;
}

export interface CalibrationProfile {
  ready: boolean;
  normalizedX: number;
  normalizedY: number;
}

export interface AppSettings {
  inputMode: InputMode;
  musicEnabled: boolean;
  sfxEnabled: boolean;
  leftHandMode: boolean;
  showCameraPreview: boolean;
  sensitivity: number;
  lowPerformanceMode: boolean;
  assistHighlight: boolean;
}

export interface ProgressState {
  unlockedLevels: string[];
  completedLevels: CompletedLevelRecord[];
  learnedChars: string[];
  bestCombos: Record<string, number>;
  settings: AppSettings;
  calibrationProfile: CalibrationProfile;
  lastResult: GameResult | null;
  currentScreen: AppScreen;
  currentLevelId: string;
}

export interface AssetEntry {
  key: string;
  expectedFileName: string;
  url?: string;
  fallbackClassName?: string;
}
