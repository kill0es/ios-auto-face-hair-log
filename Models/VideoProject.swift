import Foundation

/// 视频风格枚举，定义预设的风格化效果
enum VideoStyle: String, CaseIterable {
    case timelapse = "延时摄影"
    case fastSilver = "快银风"
    // 可继续扩展更多风格
}

/// 视频项目数据模型，包含一组自拍及选定风格
struct VideoProject: Identifiable {
    let id = UUID()
    var selfies: [Selfie]
    var style: VideoStyle
}