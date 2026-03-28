import { describe, expect, it } from "vitest";

import {
  deriveUnlockedLevels,
  getLevelAccuracy,
  getSummaryTier,
} from "./worldProgress";
import type { CompletedLevelRecord, GameResult, LevelConfig } from "../../types/game";

const levels: LevelConfig[] = [
  {
    id: "level-1",
    epoch: 1,
    world: "mountain",
    level: 1,
    title: "测试一",
    mode: "recognize_shape",
    durationSec: 30,
    newChars: ["山"],
    targetChars: [{ char: "山", count: 10 }],
    distractorChars: [],
    hangTime: 2,
    maxSimultaneous: 1,
    passCondition: { type: "slice_count", count: 5, char: "山" },
    objectiveText: "",
    repairPreview: "",
  },
  {
    id: "level-2",
    epoch: 1,
    world: "mountain",
    level: 2,
    title: "测试二",
    mode: "recognize_shape",
    durationSec: 30,
    newChars: ["水"],
    targetChars: [{ char: "水", count: 10 }],
    distractorChars: [],
    hangTime: 2,
    maxSimultaneous: 1,
    passCondition: { type: "slice_count", count: 5, char: "水" },
    objectiveText: "",
    repairPreview: "",
  },
];

describe("worldProgress", () => {
  it("computes level accuracy", () => {
    const result: GameResult = {
      levelId: "level-1",
      cleared: true,
      targetHits: 8,
      wrongHits: 1,
      misses: 1,
      maxCombo: 4,
      learnedChars: ["山"],
      repairPreview: "",
    };

    expect(getLevelAccuracy(result)).toBe(80);
    expect(getSummaryTier(result)).toBe("sprout");
  });

  it("unlocks the next level after clearing", () => {
    const completed: CompletedLevelRecord[] = [
      { levelId: "level-1", accuracy: 80, combo: 4, cleared: true },
    ];

    expect(deriveUnlockedLevels(levels, completed)).toEqual(["level-1", "level-2"]);
  });
});
