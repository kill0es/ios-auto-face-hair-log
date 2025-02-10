import Foundation

/// 定义支持的视频平台枚举
enum VideoPlatform: String, CaseIterable {
    case youtube = "YouTube"
    case tiktok = "TikTok"
    case instagram = "Instagram"
    // 可扩展更多平台
}

/// 跨平台视频上传管理器，支持全自动上传功能
class UploadManager {
    static let shared = UploadManager()
    
    /// 上传视频到指定平台（实际中需要调用各平台 API，本示例模拟上传延时）
    func uploadVideo(videoURL: URL, to platform: VideoPlatform, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            print("视频 \(videoURL.lastPathComponent) 已上传至 \(platform.rawValue)")
            completion(.success(()))
        }
    }
    
    /// 全自动上传，上传到所有平台并返回结果
    func autoUpload(videoURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        let platforms = VideoPlatform.allCases
        let group = DispatchGroup()
        var uploadError: Error? = nil
        
        for platform in platforms {
            group.enter()
            uploadVideo(videoURL: videoURL, to: platform) { result in
                if case .failure(let error) = result {
                    uploadError = error
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let error = uploadError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}