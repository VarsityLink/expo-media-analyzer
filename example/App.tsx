import { Button, Text, Image, View } from "react-native";
import { useState } from "react";
import { analyze } from "expo-media-analyzer";
import * as ImagePicker from "expo-image-picker";

export default function App() {
  const [data, setData] = useState<string | null>(null);

  const pickImage = async () => {
    let result = await ImagePicker.launchImageLibraryAsync({
      mediaTypes: ImagePicker.MediaTypeOptions.All,
      quality: 1,
    });

    if (!result.canceled) {
      const analizedData = await analyze(
        result.assets[0].uri.replace("file://", "")
      );

      if (analizedData) {
        setData(analizedData);
      }
    }
  };

  return (
    <View
      style={{
        flex: 1,
        alignItems: "center",
        justifyContent: "center",
        padding: 16,
      }}
    >
      <Button title="Pick a video from camera roll" onPress={pickImage} />
      {data && <Text>{JSON.stringify(data)}</Text>}
    </View>
  );
}
