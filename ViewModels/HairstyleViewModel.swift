import Foundation
import SwiftUI

/// 管理发型定制与搜索的 ViewModel
class HairstyleViewModel: ObservableObject {
    @Published var searchResults: [Hairstyle] = []
    @Published var selectedHairstyle: Hairstyle?
    @Published var inferenceDetails: String = ""
    
    /// 根据查询文本进行模糊搜索，实际中可连接数据库或模型返回更多信息
    func search(query: String) {
        let allHairstyles = [
            Hairstyle(name: "短发利落"),
            Hairstyle(name: "长卷浪漫"),
            Hairstyle(name: "时尚刘海"),
            Hairstyle(name: "复古大波浪"),
            Hairstyle(name: "精致盘发")
        ]
        searchResults = allHairstyles.filter { $0.name.contains(query) }
    }
    
    /// 调用发型定制模块生成定制发型效果
    func customizeHairstyle(for image: UIImage, with description: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        HairstyleCustomizationManager.customizeHairstyle(for: image, with: description, completion: completion)
    }
    
    /// 获取文本描述对应的推理过程信息
    func getInferenceDetails(for description: String) -> String {
        return HairstyleCustomizationManager.inferenceDetails(for: description)
    }
}