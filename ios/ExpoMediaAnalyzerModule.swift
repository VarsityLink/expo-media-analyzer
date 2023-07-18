import ExpoModulesCore
import Foundation
import AVFoundation

public class ExpoMediaAnalyzerModule: Module {
  private func codecForVideoAsset(asset: AVAsset, mediaType: CMMediaType) -> String? {
    let formatDescriptions = asset.tracks.flatMap { $0.formatDescriptions }
    let mediaSubtypes = formatDescriptions
      .filter { CMFormatDescriptionGetMediaType($0 as! CMFormatDescription) == mediaType }
      .map { CMFormatDescriptionGetMediaSubType($0 as! CMFormatDescription).toString() }
    return mediaSubtypes.first
  }
  public func definition() -> ModuleDefinition {
    Name("ExpoMediaAnalyzer")

    AsyncFunction("analyze") { (uri: String, promise: Promise) -> Any in
      do {
        let mediaAssetUrl = try URL(fileURLWithPath: String(uri))
        let mediaAsset: AVAsset = AVAsset(url: mediaAssetUrl)
        let mediaAssetVideoTracks = mediaAsset.tracks(withMediaType: AVMediaType.video)
        let mediaAssetAudioTracks = mediaAsset.tracks(withMediaType: AVMediaType.audio)
        let videoInfo: NSMutableDictionary = NSMutableDictionary()
        let audioInfo: NSMutableDictionary = NSMutableDictionary()

        if(mediaAssetVideoTracks.count > 0){
          let videoTrack = mediaAssetVideoTracks[0]
          let transformedVideoSize = videoTrack.naturalSize.applying(videoTrack.preferredTransform)
          let videoIsPortrait = abs(transformedVideoSize.width) < abs(transformedVideoSize.height)
          videoInfo["codec"] = codecForVideoAsset(asset: mediaAsset, mediaType: kCMMediaType_Video)
          videoInfo["bitrate"] = videoTrack.estimatedDataRate
          videoInfo["frameRate"] = videoTrack.nominalFrameRate
          videoInfo["width"] = videoTrack.naturalSize.width
          videoInfo["height"] = videoTrack.naturalSize.height
          videoInfo["rotation"] = videoIsPortrait ? 90 : 0
          videoInfo["duration"] = mediaAsset.duration.seconds
        }

        if(mediaAssetAudioTracks.count > 0){
          let audioTrack = mediaAssetAudioTracks[0]
          let audioTrackDescriptions = audioTrack.formatDescriptions as! [CMFormatDescription]
          audioInfo["codec"] = codecForVideoAsset(asset: mediaAsset, mediaType: kCMMediaType_Audio)
          audioInfo["bitrate"] = audioTrack.estimatedDataRate
          for item in (audioTrackDescriptions) {
            let basic = CMAudioFormatDescriptionGetStreamBasicDescription(item)
            audioInfo["sampleRate"] = basic?.pointee.mSampleRate
            audioInfo["channels"] = basic?.pointee.mChannelsPerFrame
          }
        }

        let mapInfo: NSMutableDictionary = NSMutableDictionary()
        mapInfo["video"] = videoInfo
        mapInfo["audio"] = audioInfo
        return promise.resolve(mapInfo)
      } catch {
        return promise.resolve(nil)
      }
    }
  }
}

extension FourCharCode {
  // Create a string representation of a FourCC.
  func toString() -> String {
    let bytes: [CChar] = [
      CChar((self >> 24) & 0xff),
      CChar((self >> 16) & 0xff),
      CChar((self >> 8) & 0xff),
      CChar(self & 0xff),
      0
    ]
    let result = String(cString: bytes)
    let characterSet = CharacterSet.whitespaces
    return result.trimmingCharacters(in: characterSet)
  }
}
