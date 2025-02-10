import Foundation

/// 管理视频编辑项目的 ViewModel
class VideoProjectViewModel: ObservableObject {
    @Published var currentProject: VideoProject?
    
    /// 根据自拍数组和预设风格创建新项目
    func createProject(with selfies: [Selfie], style: VideoStyle) {
        currentProject = VideoProject(selfies: selfies, style: style)
    }
}