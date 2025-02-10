import Foundation
import UIKit
import AVFoundation

/// 视频合成参数设置结构体
struct RenderSettings {
    var width: CGFloat = 720
    var height: CGFloat = 1280
    var fps: Int32 = 30
    var videoFilename: String = "output"
    var videoFilenameExt: String = "mp4"
    
    /// 生成临时输出文件 URL
    var outputURL: URL {
        let tempPath = NSTemporaryDirectory() as NSString
        let outputPath = tempPath.appendingPathComponent("\(videoFilename).\(videoFilenameExt)")
        return URL(fileURLWithPath: outputPath)
    }
}

/// 利用 AVFoundation 将多张自拍合成视频（示例中每张自拍显示1秒）
class ImageAnimator {
    let renderSettings: RenderSettings
    let selfies: [Selfie]
    
    var videoWriter: AVAssetWriter!
    var videoWriterInput: AVAssetWriterInput!
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!
    
    init(renderSettings: RenderSettings, selfies: [Selfie]) {
        self.renderSettings = renderSettings
        self.selfies = selfies
    }
    
    /// 合成视频并根据预设风格应用效果
    func render(with style: VideoStyle, completion: @escaping (Result<URL, Error>) -> Void) {
        // 此处可根据 style 调整滤镜、转场，本示例不作具体风格处理
        do {
            videoWriter = try AVAssetWriter(outputURL: renderSettings.outputURL, fileType: .mp4)
        } catch {
            completion(.failure(error))
            return
        }
        
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: renderSettings.width,
            AVVideoHeightKey: renderSettings.height
        ]
        videoWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        videoWriterInput.expectsMediaDataInRealTime = false
        
        let sourceBufferAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32ARGB,
            kCVPixelBufferWidthKey as String: renderSettings.width,
            kCVPixelBufferHeightKey as String: renderSettings.height
        ]
        pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput,
                                                                  sourcePixelBufferAttributes: sourceBufferAttributes)
        
        guard videoWriter.canAdd(videoWriterInput) else {
            completion(.failure(NSError(domain: "VideoEditor", code: 0, userInfo: [NSLocalizedDescriptionKey: "无法添加视频输入"])))
            return
        }
        videoWriter.add(videoWriterInput)
        videoWriter.startWriting()
        videoWriter.startSession(atSourceTime: .zero)
        
        let frameDuration = CMTime(value: 1, timescale: renderSettings.fps)
        var frameCount: Int64 = 0
        
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        videoWriterInput.requestMediaDataWhenReady(on: mediaInputQueue) {
            for selfie in self.selfies {
                guard let cgImage = selfie.image.cgImage else { continue }
                let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameCount))
                if let pixelBuffer = self.newPixelBufferFrom(cgImage: cgImage) {
                    // 等待视频输入就绪
                    while !self.videoWriterInput.isReadyForMoreMediaData {
                        Thread.sleep(forTimeInterval: 0.1)
                    }
                    self.pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                    // 每张图片显示1秒（即 fps 帧）
                    frameCount += Int64(self.renderSettings.fps)
                }
            }
            self.videoWriterInput.markAsFinished()
            self.videoWriter.finishWriting {
                if self.videoWriter.status == .completed {
                    completion(.success(self.renderSettings.outputURL))
                } else if let error = self.videoWriter.error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    /// 将 CGImage 转换为 CVPixelBuffer
    func newPixelBufferFrom(cgImage: CGImage) -> CVPixelBuffer? {
        let options: [String: Any] = [
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true
        ]
        var pxbuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault,
                                         Int(renderSettings.width),
                                         Int(renderSettings.height),
                                         kCVPixelFormatType_32ARGB,
                                         options as CFDictionary,
                                         &pxbuffer)
        guard status == kCVReturnSuccess, let buffer = pxbuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        let pxdata = CVPixelBufferGetBaseAddress(buffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata,
                                width: Int(renderSettings.width),
                                height: Int(renderSettings.height),
                                bitsPerComponent: 8,
                                bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                space: rgbColorSpace,
                                bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: renderSettings.width, height: renderSettings.height))
        CVPixelBufferUnlockBaseAddress(buffer, [])
        return buffer
    }
}

/// 视频编辑管理器接口，供外部调用视频合成功能
class VideoEditorManager {
    static func composeVideo(with selfies: [Selfie], style: VideoStyle, completion: @escaping (Result<URL, Error>) -> Void) {
        let settings = RenderSettings()
        let animator = ImageAnimator(renderSettings: settings, selfies: selfies)
        animator.render(with: style, completion: completion)
    }
}