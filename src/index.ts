import { NativeModulesProxy, EventEmitter, Subscription } from 'expo-modules-core';

// Import the native module. On web, it will be resolved to ExpoMediaAnalyzer.web.ts
// and on native platforms to ExpoMediaAnalyzer.ts
import ExpoMediaAnalyzerModule from './ExpoMediaAnalyzerModule';
import ExpoMediaAnalyzerView from './ExpoMediaAnalyzerView';
import { ChangeEventPayload, ExpoMediaAnalyzerViewProps } from './ExpoMediaAnalyzer.types';

// Get the native constant value.
export const PI = ExpoMediaAnalyzerModule.PI;

export function hello(): string {
  return ExpoMediaAnalyzerModule.hello();
}

export async function setValueAsync(value: string) {
  return await ExpoMediaAnalyzerModule.setValueAsync(value);
}

const emitter = new EventEmitter(ExpoMediaAnalyzerModule ?? NativeModulesProxy.ExpoMediaAnalyzer);

export function addChangeListener(listener: (event: ChangeEventPayload) => void): Subscription {
  return emitter.addListener<ChangeEventPayload>('onChange', listener);
}

export { ExpoMediaAnalyzerView, ExpoMediaAnalyzerViewProps, ChangeEventPayload };
