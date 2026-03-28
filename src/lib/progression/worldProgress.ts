import type {
  CharacterEntry,
  CompletedLevelRecord,
  GameResult,
  LevelConfig,
} from "../../types/game";

export interface WorldProgressSummary {
  learnedCount: number;
  totalLearnable: number;
  repairPercent: number;
  currentLevelId: string;
  nextLevelId: string | null;
}

export const getLevelAccuracy = (result: GameResult): number => {
  const totalAttempts = result.targetHits + result.wrongHits + result.misses;
  if (totalAttempts === 0) {
    return 0;
  }

  return Math.round((result.targetHits / totalAttempts) * 100);
};

export const getSummaryTier = (result: GameResult): "seed" | "sprout" | "tree" => {
  const accuracy = getLevelAccuracy(result);

  if (accuracy >= 90 && result.wrongHits === 0) {
    return "tree";
  }

  if (accuracy >= 70) {
    return "sprout";
  }

  return "seed";
};

export const mergeCompletedLevel = (
  completedLevels: CompletedLevelRecord[],
  result: GameResult,
): CompletedLevelRecord[] => {
  const nextRecord: CompletedLevelRecord = {
    levelId: result.levelId,
    accuracy: getLevelAccuracy(result),
    combo: result.maxCombo,
    cleared: result.cleared,
  };

  const filtered = completedLevels.filter((entry) => entry.levelId !== result.levelId);
  return [...filtered, nextRecord].sort((a, b) => a.levelId.localeCompare(b.levelId));
};

export const getNextLevelId = (
  levels: LevelConfig[],
  currentLevelId: string,
  cleared: boolean,
): string | null => {
  const currentIndex = levels.findIndex((level) => level.id === currentLevelId);
  if (currentIndex < 0) {
    return levels[0]?.id ?? null;
  }

  if (!cleared) {
    return currentLevelId;
  }

  return levels[currentIndex + 1]?.id ?? null;
};

export const deriveUnlockedLevels = (
  levels: LevelConfig[],
  completedLevels: CompletedLevelRecord[],
): string[] => {
  const orderedIds = levels.map((level) => level.id);
  const clearedIds = new Set(
    completedLevels.filter((item) => item.cleared).map((item) => item.levelId),
  );

  const unlocked = new Set<string>(orderedIds.length > 0 ? [orderedIds[0]] : []);

  orderedIds.forEach((levelId, index) => {
    if (clearedIds.has(levelId) && orderedIds[index + 1]) {
      unlocked.add(orderedIds[index + 1]);
    }
  });

  return orderedIds.filter((levelId) => unlocked.has(levelId));
};

export const deriveLearnedChars = (
  levels: LevelConfig[],
  completedLevels: CompletedLevelRecord[],
): string[] => {
  const clearedIds = new Set(
    completedLevels.filter((item) => item.cleared).map((item) => item.levelId),
  );

  return levels
    .filter((level) => clearedIds.has(level.id))
    .flatMap((level) => level.newChars)
    .filter((char, index, collection) => collection.indexOf(char) === index);
};

export const getWorldProgressSummary = (
  levels: LevelConfig[],
  characters: CharacterEntry[],
  learnedChars: string[],
  currentLevelId: string,
): WorldProgressSummary => {
  const totalLearnable = characters.filter((entry) => entry.theme !== "干扰").length;
  const learnedCount = learnedChars.length;
  const repairPercent =
    totalLearnable === 0 ? 0 : Math.round((learnedCount / totalLearnable) * 100);

  return {
    learnedCount,
    totalLearnable,
    repairPercent,
    currentLevelId,
    nextLevelId: getNextLevelId(levels, currentLevelId, true),
  };
};
