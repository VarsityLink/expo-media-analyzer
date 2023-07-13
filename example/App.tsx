import { StyleSheet, Text, View } from 'react-native';

import * as ExpoMediaAnalyzer from 'expo-media-analyzer';

export default function App() {
  return (
    <View style={styles.container}>
      <Text>{ExpoMediaAnalyzer.hello()}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
