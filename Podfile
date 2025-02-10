# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'  # 适用于 iOS 14.0 及以上设备

target 'SmartSelfieApp' do
  use_frameworks!

  # 人脸检测与图像处理
  pod 'SDWebImage'
  pod 'SDWebImageWebPCoder'  # 支持 WebP 格式
  pod 'VisionCamera', :git => 'https://github.com/mrousavy/react-native-vision-camera.git'

  # 机器学习与发型识别
  pod 'CoreML'
  pod 'TensorFlowLiteSwift'  # 如果需要更强大的 AI 推理
  pod 'MLKitFaceDetection'   # Google 的人脸检测 API

  # 视频处理
  pod 'AVFoundation'
  pod 'GPUImage2'  # 实时滤镜与图像处理

  # 云端存储与跨平台分享
  pod 'Firebase/Core'
  pod 'Firebase/Storage'
  pod 'Firebase/Auth'
  pod 'Firebase/Database'

  # 社交媒体分享
  pod 'FacebookShare'
  pod 'TwitterKit'

  # UI 组件
  pod 'SnapKit'  # 用于 AutoLayout 适配

  target 'SmartSelfieAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SmartSelfieAppUITests' do
    inherit! :search_paths
    # Pods for UI testing
  end

end