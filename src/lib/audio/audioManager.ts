import { musicAssets } from "../../config/assets";

type SfxName =
  | "slashCorrect"
  | "slashWrong"
  | "comboUp"
  | "levelClear"
  | "buttonClick"
  | "unlock"
  | "worldReveal"
  | "charCard"
  | "bossComplete";

type MusicName = keyof typeof musicAssets;

class AudioManager {
  private currentMusic: HTMLAudioElement | null = null;

  private audioContext: AudioContext | null = null;

  private ensureContext(): AudioContext | null {
    if (typeof window === "undefined") {
      return null;
    }

    if (!this.audioContext) {
      const Context = window.AudioContext ?? (window as typeof window & {
        webkitAudioContext?: typeof AudioContext;
      }).webkitAudioContext;

      if (!Context) {
        return null;
      }

      this.audioContext = new Context();
    }

    return this.audioContext;
  }

  playMusic(name: MusicName, enabled: boolean): void {
    this.stopMusic();

    if (!enabled) {
      return;
    }

    const asset = musicAssets[name];
    if (!asset.url) {
      return;
    }

    const audio = new Audio(asset.url);
    audio.loop = true;
    audio.volume = 0.42;
    void audio.play().catch(() => undefined);
    this.currentMusic = audio;
  }

  stopMusic(): void {
    if (!this.currentMusic) {
      return;
    }

    this.currentMusic.pause();
    this.currentMusic.currentTime = 0;
    this.currentMusic = null;
  }

  playSfx(name: SfxName, enabled: boolean): void {
    if (!enabled) {
      return;
    }

    const context = this.ensureContext();
    if (!context) {
      return;
    }

    if (context.state === "suspended") {
      void context.resume();
    }

    const oscillator = context.createOscillator();
    const gain = context.createGain();
    oscillator.connect(gain);
    gain.connect(context.destination);

    const now = context.currentTime;
    const preset = this.getSynthPreset(name);
    oscillator.type = preset.type;
    oscillator.frequency.setValueAtTime(preset.start, now);
    oscillator.frequency.exponentialRampToValueAtTime(preset.end, now + preset.duration);

    gain.gain.setValueAtTime(0.0001, now);
    gain.gain.exponentialRampToValueAtTime(preset.peak, now + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + preset.duration);

    oscillator.start(now);
    oscillator.stop(now + preset.duration + 0.02);
  }

  private getSynthPreset(name: SfxName): {
    start: number;
    end: number;
    duration: number;
    peak: number;
    type: OscillatorType;
  } {
    switch (name) {
      case "slashCorrect":
        return { start: 510, end: 760, duration: 0.18, peak: 0.05, type: "triangle" };
      case "slashWrong":
        return { start: 220, end: 160, duration: 0.16, peak: 0.03, type: "sawtooth" };
      case "comboUp":
        return { start: 420, end: 860, duration: 0.26, peak: 0.05, type: "triangle" };
      case "levelClear":
        return { start: 480, end: 920, duration: 0.44, peak: 0.06, type: "sine" };
      case "buttonClick":
        return { start: 320, end: 420, duration: 0.08, peak: 0.02, type: "triangle" };
      case "unlock":
        return { start: 380, end: 980, duration: 0.3, peak: 0.05, type: "sine" };
      case "worldReveal":
        return { start: 220, end: 720, duration: 0.56, peak: 0.04, type: "triangle" };
      case "charCard":
        return { start: 280, end: 560, duration: 0.2, peak: 0.03, type: "triangle" };
      case "bossComplete":
        return { start: 260, end: 840, duration: 0.62, peak: 0.06, type: "sine" };
      default:
        return { start: 320, end: 420, duration: 0.08, peak: 0.02, type: "triangle" };
    }
  }
}

export const audioManager = new AudioManager();
