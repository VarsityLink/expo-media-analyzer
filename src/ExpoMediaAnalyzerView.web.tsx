import * as React from 'react';

import { ExpoMediaAnalyzerViewProps } from './ExpoMediaAnalyzer.types';

export default function ExpoMediaAnalyzerView(props: ExpoMediaAnalyzerViewProps) {
  return (
    <div>
      <span>{props.name}</span>
    </div>
  );
}
