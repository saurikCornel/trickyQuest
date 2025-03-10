import SwiftUI
import WebKit
import GCDWebServers

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false // Включаем прозрачность
        webView.backgroundColor = UIColor.clear // Прозрачный фон
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct ContentView: View {
    @StateObject private var serverManager = ServerManager()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Основной фон
                Color(hex: "#364164")
                    .edgesIgnoringSafeArea(.all) // Занимает весь экран
                
                // Содержимое
                VStack {
                    if let url = serverManager.serverURL {
                        WebView(url: url)
                            .frame(maxWidth: .infinity, maxHeight: .infinity) // Заполняем экран
                            .background(Color.clear) // Прозрачный контейнер
                    } else {
                        Text("Starting server...")
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
        .onAppear(perform: serverManager.startServer)
        .onDisappear(perform: serverManager.stopServer)
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


class ServerManager: ObservableObject {
    @Published var serverURL: URL?
    private let server = GCDWebServer()
    
    func startServer() {
        guard let resourcePath = Bundle.main.resourcePath else { return }
        
        server.addGETHandler(
            forBasePath: "/",
            directoryPath: resourcePath,
            indexFilename: "index.html",
            cacheAge: 3600,
            allowRangeRequests: true
        )
        
        do {
            try server.start(options: [
                GCDWebServerOption_Port: 3005,
                GCDWebServerOption_BindToLocalhost: true
            ])
            serverURL = URL(string: "http://localhost:3005")!
        } catch {
            print("Server start error: \(error)")
        }
    }
    
    func stopServer() {
        server.stop()
        serverURL = nil
        print("Server stopped")
    }
}

#Preview {
    ContentView()
}
