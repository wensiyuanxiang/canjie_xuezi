import {
  FilesetResolver,
  HandLandmarker,
  type HandLandmarkerResult,
} from "@mediapipe/tasks-vision";

export interface HandPoint {
  normalizedX: number;
  normalizedY: number;
}

export interface HandTrackerController {
  start: (video: HTMLVideoElement, onPoint: (point: HandPoint | null) => void) => Promise<void>;
  stop: () => void;
}

let handLandmarkerPromise: Promise<HandLandmarker> | null = null;

const createHandLandmarker = async (): Promise<HandLandmarker> => {
  const vision = await FilesetResolver.forVisionTasks(
    "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.34/wasm",
  );

  return HandLandmarker.createFromOptions(vision, {
    baseOptions: {
      modelAssetPath:
        "https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task",
    },
    runningMode: "VIDEO",
    numHands: 1,
    minTrackingConfidence: 0.4,
    minHandDetectionConfidence: 0.4,
  });
};

const getHandLandmarker = (): Promise<HandLandmarker> => {
  handLandmarkerPromise ??= createHandLandmarker();
  return handLandmarkerPromise;
};

const getIndexTip = (result: HandLandmarkerResult): HandPoint | null => {
  const firstHand = result.landmarks[0];
  const point = firstHand?.[8];
  if (!point) {
    return null;
  }

  return {
    normalizedX: point.x,
    normalizedY: point.y,
  };
};

export const createHandTrackerController = (): HandTrackerController => {
  let stream: MediaStream | null = null;
  let animationFrame = 0;

  const stop = (): void => {
    if (animationFrame) {
      window.cancelAnimationFrame(animationFrame);
      animationFrame = 0;
    }

    stream?.getTracks().forEach((track) => track.stop());
    stream = null;
  };

  return {
    start: async (video, onPoint) => {
      const tracker = await getHandLandmarker();

      stream = await navigator.mediaDevices.getUserMedia({
        video: {
          facingMode: "user",
          width: { ideal: 640 },
          height: { ideal: 480 },
        },
        audio: false,
      });

      video.srcObject = stream;
      video.muted = true;
      video.playsInline = true;
      await video.play();

      const loop = (): void => {
        const result = tracker.detectForVideo(video, performance.now());
        onPoint(getIndexTip(result));
        animationFrame = window.requestAnimationFrame(loop);
      };

      loop();
    },
    stop,
  };
};
