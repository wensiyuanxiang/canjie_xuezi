import type { ProgressState } from "../../types/game";

const STORAGE_KEY = "cangjie-motion-progress";

export const loadProgress = <T extends ProgressState>(fallback: T): T => {
  if (typeof window === "undefined") {
    return fallback;
  }

  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      return fallback;
    }

    return { ...fallback, ...JSON.parse(raw) } as T;
  } catch {
    return fallback;
  }
};

export const saveProgress = (progress: ProgressState): void => {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(progress));
};
