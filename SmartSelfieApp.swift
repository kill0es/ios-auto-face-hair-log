import SwiftUI

/// 应用入口，设置环境对象供各界面共享数据
@main
struct SmartSelfieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                // 注入各个 ViewModel，方便跨界面共享数据
                .environmentObject(SelfieViewModel())
                .environmentObject(VideoProjectViewModel())
                .environmentObject(HairstyleViewModel())
        }
    }
}