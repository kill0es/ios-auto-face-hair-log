import Foundation

/// 发型数据模型，可扩展保存样式图片、特征向量等信息
struct Hairstyle: Identifiable {
    let id = UUID()
    let name: String
}