import Foundation
import SwiftUI


struct RootView: View {
    @ObservedObject var nav: AppNavigator = AppNavigator.shared
    var body: some View {
        switch nav.currentScreen {
            
        case .MENU:
            MenuView()
        case .LOADING:
            LoadingScreen()
        case .SHOP:
            ShopView()
        case .SETTINGS:
            SettingsView()
        case .BONUS:
            DailyBonus()
        case .ABOUT:
            AboutScreen()
        case .GAME:
            ContentView()
        case .PLEASURE:
            if let url = URL(string: urlForValidation) {
                BrowserView(pageURL: url)
                    .onAppear {
                        print("BrowserView appeared")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                            UIViewController.attemptRotationToDeviceOrientation()
                        }
                    }
            } else {
                Text("Invalid URL")
            }
       
        }
    }
}
