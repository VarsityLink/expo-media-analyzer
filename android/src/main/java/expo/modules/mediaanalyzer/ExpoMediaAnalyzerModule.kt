package expo.modules.mediaanalyzer

import expo.modules.kotlin.modules.Module
import expo.modules.kotlin.modules.ModuleDefinition
import expo.modules.kotlin.Promise

import android.media.MediaExtractor
import android.media.MediaFormat
import android.media.MediaMetadataRetriever


class ExpoMediaAnalyzerModule : Module() {
  override fun definition() = ModuleDefinition {
    Name("ExpoMediaAnalyzer")

    AsyncFunction("analyze") { videoUri: String, promise: Promise ->
      analyze(videoUri, promise)
    }
  }

  private fun analyze(videoUri: String, promise: Promise): Any {
    try {
      val videoInfo = HashMap<String, Any>()
      val audioInfo = HashMap<String, Any>()
      var retriever = MediaMetadataRetriever()

      retriever.setDataSource(videoUri)
      videoInfo.put("format", retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_MIMETYPE) ?: "")
      videoInfo.put("bitrate",
              Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_BITRATE)))
      videoInfo.put("rotation",
              Integer.parseInt(retriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_VIDEO_ROTATION)))
      retriever.release()

      val extractor = MediaExtractor()
      extractor.setDataSource(videoUri)
      val numTracks: Int = extractor.getTrackCount()
      var i = 0

      repeat(numTracks) {
        val format = extractor.getTrackFormat(i)
        val mime = format.getString(MediaFormat.KEY_MIME)

        if (mime?.startsWith("video") as Boolean) {
          videoInfo.put("codec", mime.replace("video/", ""));
          videoInfo.put("width", format.getInteger(MediaFormat.KEY_WIDTH))
          videoInfo.put("height", format.getInteger(MediaFormat.KEY_HEIGHT))
          videoInfo.put("frameRate", format.getInteger(MediaFormat.KEY_FRAME_RATE))
          videoInfo.put("duration", format.getLong(MediaFormat.KEY_DURATION)/1000000);
        } else if (mime?.startsWith("audio") as Boolean) {
          audioInfo.put("codec", mime.replace("audio/", ""))
          audioInfo.put("bitrate", format.getInteger(MediaFormat.KEY_BIT_RATE))
          audioInfo.put("sampleRate", format.getInteger(MediaFormat.KEY_SAMPLE_RATE))
          audioInfo.put("channels", format.getInteger(MediaFormat.KEY_CHANNEL_COUNT))
        }

        i = i + 1
      }

      extractor.release()
      
      val infoMap = HashMap<String, Any>()
      infoMap.put("video", videoInfo)
      infoMap.put("audio", audioInfo)
      return promise.resolve(infoMap)
    }
    catch(e: Exception) {
      return promise.resolve(null)
    }
  }
}
