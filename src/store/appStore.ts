import { create } from "zustand";

import charactersData from "../data/characters.json";
import levelsData from "../data/levels.json";
import { audioManager } from "../lib/audio/audioManager";
import { loadProgress, saveProgress } from "../lib/progression/storage";
import {
  deriveLearnedChars,
  deriveUnlockedLevels,
  getNextLevelId,
  mergeCompletedLevel,
} from "../lib/progression/worldProgress";
import type {
  AppScreen,
  AppSettings,
  CalibrationProfile,
  CharacterEntry,
  GameResult,
  LevelConfig,
  ProgressState,
} from "../types/game";

const levels = levelsData as LevelConfig[];
const characters = charactersData as CharacterEntry[];

const defaultSettings: AppSettings = {
  inputMode: "touch",
  musicEnabled: true,
  sfxEnabled: true,
  leftHandMode: false,
  showCameraPreview: false,
  sensitivity: 0.55,
  lowPerformanceMode: false,
  assistHighlight: true,
};

const defaultCalibration: CalibrationProfile = {
  ready: false,
  normalizedX: 0.5,
  normalizedY: 0.5,
};

const defaultState: ProgressState = {
  unlockedLevels: [levels[0]?.id ?? "level-1"],
  completedLevels: [],
  learnedChars: [],
  bestCombos: {},
  settings: defaultSettings,
  calibrationProfile: defaultCalibration,
  lastResult: null,
  currentScreen: "home",
  currentLevelId: levels[0]?.id ?? "level-1",
};

const persisted = loadProgress(defaultState);

interface AppStore extends ProgressState {
  levels: LevelConfig[];
  characters: CharacterEntry[];
  navigate: (screen: AppScreen) => void;
  startLevel: (levelId: string) => void;
  completeLevel: (result: GameResult) => void;
  updateSettings: (partial: Partial<AppSettings>) => void;
  setCalibration: (profile: CalibrationProfile) => void;
  replayCurrentLevel: () => void;
}

const persistSubset = (state: AppStore): ProgressState => ({
  unlockedLevels: state.unlockedLevels,
  completedLevels: state.completedLevels,
  learnedChars: state.learnedChars,
  bestCombos: state.bestCombos,
  settings: state.settings,
  calibrationProfile: state.calibrationProfile,
  lastResult: state.lastResult,
  currentScreen: state.currentScreen,
  currentLevelId: state.currentLevelId,
});

export const useAppStore = create<AppStore>((set, get) => ({
  ...defaultState,
  ...persisted,
  levels,
  characters,
  navigate: (screen) => {
    set({ currentScreen: screen });
    saveProgress(persistSubset(get()));
  },
  startLevel: (levelId) => {
    set({ currentLevelId: levelId, currentScreen: "game" });
    saveProgress(persistSubset(get()));
  },
  completeLevel: (result) => {
    const nextCompleted = mergeCompletedLevel(get().completedLevels, result);
    const unlockedLevels = deriveUnlockedLevels(levels, nextCompleted);
    const learnedChars = deriveLearnedChars(levels, nextCompleted);
    const nextLevelId = getNextLevelId(levels, result.levelId, result.cleared) ?? result.levelId;

    const bestCombos = {
      ...get().bestCombos,
      [result.levelId]: Math.max(get().bestCombos[result.levelId] ?? 0, result.maxCombo),
    };

    set({
      completedLevels: nextCompleted,
      unlockedLevels,
      learnedChars,
      bestCombos,
      lastResult: result,
      currentLevelId: nextLevelId,
      currentScreen: "result",
    });

    if (result.cleared) {
      audioManager.playSfx("levelClear", get().settings.sfxEnabled);
    }

    saveProgress(persistSubset(get()));
  },
  updateSettings: (partial) => {
    set((state) => ({
      settings: {
        ...state.settings,
        ...partial,
      },
    }));
    saveProgress(persistSubset(get()));
  },
  setCalibration: (profile) => {
    set({ calibrationProfile: profile });
    saveProgress(persistSubset(get()));
  },
  replayCurrentLevel: () => {
    set({ currentScreen: "game" });
  },
}));
