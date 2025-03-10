import SwiftUI

@main
struct Chicky_s_Tricky_QuestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let currentScreen = AppNavigator.shared.currentScreen
        if currentScreen == .PLEASURE {
            return .allButUpsideDown
        } else {
            return .landscape
        }
    }
}
