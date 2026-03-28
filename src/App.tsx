import { useEffect } from "react";

import { audioManager } from "./lib/audio/audioManager";
import { getWorldProgressSummary } from "./lib/progression/worldProgress";
import { useAppStore } from "./store/appStore";
import { Home } from "./pages/Home";
import { WorldMap } from "./pages/WorldMap";
import { Settings } from "./pages/Settings";
import { Calibration } from "./pages/Calibration";
import { Collection } from "./pages/Collection";
import { Result } from "./pages/Result";
import { GamePage } from "./pages/GamePage";

export default function App() {
  const store = useAppStore();
  const currentLevel =
    store.levels.find((level) => level.id === store.currentLevelId) ?? store.levels[0];

  const summary = getWorldProgressSummary(
    store.levels,
    store.characters,
    store.learnedChars,
    store.currentLevelId,
  );

  useEffect(() => {
    const musicMap = {
      home: "home",
      worldMap: "worldMap",
      settings: "worldMap",
      calibration: "worldMap",
      collection: "worldMap",
      game: currentLevel.mode === "boss" ? "boss" : "mountain",
      result: "result",
    } as const;

    audioManager.playMusic(musicMap[store.currentScreen], store.settings.musicEnabled);

    return () => {
      audioManager.stopMusic();
    };
  }, [currentLevel.mode, store.currentScreen, store.settings.musicEnabled]);

  const click = () => audioManager.playSfx("buttonClick", store.settings.sfxEnabled);

  switch (store.currentScreen) {
    case "home":
      return (
        <Home
          learnedCount={summary.learnedCount}
          onCollection={() => {
            click();
            store.navigate("collection");
          }}
          onSettings={() => {
            click();
            store.navigate("settings");
          }}
          onStart={() => {
            click();
            store.navigate("worldMap");
          }}
        />
      );

    case "settings":
      return (
        <Settings
          onBack={() => {
            click();
            store.navigate("home");
          }}
          onOpenCalibration={() => {
            click();
            store.navigate("calibration");
          }}
          onUpdate={store.updateSettings}
          settings={store.settings}
        />
      );

    case "calibration":
      return (
        <Calibration
          onBack={() => {
            click();
            store.navigate("settings");
          }}
          onComplete={(profile) => {
            click();
            store.setCalibration(profile);
            store.updateSettings({ inputMode: "camera" });
            store.navigate("worldMap");
          }}
        />
      );

    case "collection":
      return (
        <Collection
          characters={store.characters}
          learnedChars={store.learnedChars}
          onBack={() => {
            click();
            store.navigate("worldMap");
          }}
        />
      );

    case "worldMap":
      return (
        <WorldMap
          completedLevels={store.completedLevels}
          currentLevelId={store.currentLevelId}
          learnedCount={summary.learnedCount}
          levels={store.levels}
          onBack={() => {
            click();
            store.navigate("home");
          }}
          onCollection={() => {
            click();
            store.navigate("collection");
          }}
          onPlayLevel={(levelId) => {
            click();
            store.startLevel(levelId);
          }}
          onSettings={() => {
            click();
            store.navigate("settings");
          }}
          repairPercent={summary.repairPercent}
          totalLearnable={summary.totalLearnable}
          unlockedLevels={store.unlockedLevels}
        />
      );

    case "game":
      return (
        <GamePage
          level={currentLevel}
          onBack={() => {
            click();
            store.navigate("worldMap");
          }}
          onComplete={(result) => store.completeLevel(result)}
          settings={store.settings}
        />
      );

    case "result":
      return store.lastResult ? (
        <Result
          characters={store.characters}
          level={
            store.levels.find((level) => level.id === store.lastResult?.levelId) ?? currentLevel
          }
          onBackToMap={() => {
            click();
            store.navigate("worldMap");
          }}
          onNext={() => {
            click();
            store.startLevel(store.currentLevelId);
          }}
          onReplay={() => {
            click();
            if (store.lastResult) {
              store.startLevel(store.lastResult.levelId);
            }
          }}
          result={store.lastResult}
        />
      ) : null;

    default:
      return null;
  }
}
