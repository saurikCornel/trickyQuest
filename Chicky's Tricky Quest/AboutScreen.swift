import SwiftUI
import WebKit


struct BrowserViews1: UIViewRepresentable {
    let pageURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            if uiView.url != pageURL {
                uiView.load(URLRequest(url: pageURL))
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: BrowserViews1
        let defaults = UserDefaults.standard
        let reloadKey = "hasReloadedAtFirstLaunch" // Ключ для UserDefaults
        
        init(_ parent: BrowserViews1) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("Ошибка загрузки: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Страница загружена")
            // Проверяем, была ли уже перезагрузка при первом запуске
            let hasReloaded = defaults.bool(forKey: reloadKey)
            if !hasReloaded {
                // Устанавливаем флаг в UserDefaults и перезагружаем
                defaults.set(true, forKey: reloadKey)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    webView.reload()
                }
            }
        }
    }
}


struct BrowserViews: UIViewRepresentable {
    let pageURL: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: pageURL))
    }
}

struct AboutScreen: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if let validURL = Bundle.main.url(forResource: "howtoplay", withExtension: "html") {
                    BrowserViews(pageURL: validURL)
                } else {
                    Text("howtoplay.html not found in Bundle")
                        .foregroundColor(.red)
                        .font(.headline)
                }
            }
            .overlay(
                ZStack {
                    Image(.back)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                        .position(x: geometry.size.width / 9, y: geometry.size.height / 9)
                        .onTapGesture {
                            AppNavigator.shared.currentScreen = .MENU
                        }
                }
            )
        }
    }
}

#Preview {
    AboutScreen()
}
