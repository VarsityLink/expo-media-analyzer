import { requireNativeViewManager } from 'expo-modules-core';
import * as React from 'react';

import { ExpoMediaAnalyzerViewProps } from './ExpoMediaAnalyzer.types';

const NativeView: React.ComponentType<ExpoMediaAnalyzerViewProps> =
  requireNativeViewManager('ExpoMediaAnalyzer');

export default function ExpoMediaAnalyzerView(props: ExpoMediaAnalyzerViewProps) {
  return <NativeView {...props} />;
}
