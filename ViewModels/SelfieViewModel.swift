import Foundation
import SwiftUI

/// 管理自拍素材采集与存储的 ViewModel
class SelfieViewModel: ObservableObject {
    @Published var selfies: [Selfie] = []
    
    init() {
        loadSelfies()
    }
    
    /// 从本地持久化存储加载自拍素材（实际中可使用 Core Data、文件系统或 iCloud 同步）
    func loadSelfies() {
        selfies = []  // 示例中为空数组
    }
    
    /// 添加新自拍素材到列表中
    func addSelfie(_ selfie: Selfie) {
        selfies.append(selfie)
    }
}