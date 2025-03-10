import Foundation


enum AvailableScreens {
    case MENU
    case LOADING
    case SHOP
    case SETTINGS
    case ABOUT
    case GAME
    case BONUS
    case PLEASURE
}

class AppNavigator: ObservableObject {
    @Published var currentScreen: AvailableScreens = .LOADING
    static var shared: AppNavigator = .init()
}
