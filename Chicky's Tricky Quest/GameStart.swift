import SwiftUI
import WebKit


struct ContentView: View {
   
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основной фон
                Color(hex: "#364164")
                    .edgesIgnoringSafeArea(.all) // Занимает весь экран
                
                // Содержимое
                VStack {
                    if let url = URL(string: "https://chickytricky.top/game/") {
                        BrowserViews1(pageURL: url)
                    }
                }
                .overlay(
                    Image(.back)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .position(x: geometry.size.width / 9, y: geometry.size.height / 9)
                        .onTapGesture {
                            AppNavigator.shared.currentScreen = .MENU
                        }
                )
            }
        }
       
    }
}

// Упрощенное расширение для HEX
extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}


#Preview {
    ContentView()
}
