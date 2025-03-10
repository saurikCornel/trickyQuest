import SwiftUI
import StoreKit


struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    
    var body: some View {
        GeometryReader { geometry in
            var isLandscape = geometry.size.width > geometry.size.height
            ZStack {
                
                    ZStack {
                        
                        VStack {
                            HStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .padding()
                                    .foregroundStyle(.white)
                                    .onTapGesture {
                                        AppNavigator.shared.currentScreen = .MENU
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        Image(.settingsPlate)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 350, height: 300)
                        
                        VStack(spacing: -30) {
                                
                            VStack {
                                if settings.musicEnabled {
                                    Image(.musicOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                } else {
                                    Image(.musicOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.musicEnabled.toggle()
                                        }
                                }
                            
                                
                               
                            }
                            

                                
                                if settings.soundEnabled {
                                    Image(.soundsOn)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.soundEnabled.toggle()
                                        }
                                } else {
                                    Image(.soundOff)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 130, height: 80)
                                        .onTapGesture {
                                            settings.soundEnabled.toggle()
                                        }
                                }

                            Image(.rateUs)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 70)
                                .onTapGesture {
                                    requestAppReview()
                                }
                            
                            Image(.shareUs)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 70)
                                .onTapGesture {
                                    openURLInSafari(urlString: openAppURL)
                                }
                            
                        }
                        .padding(.top, 20)
                        
                        
                        
                    }
               
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundSettings)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

extension SettingsView {
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("Не удалось открыть URL: \(urlString)")
            }
        } else {
            print("Неверный формат URL: \(urlString)")
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("Не удалось получить активную сцену для запроса отзыва.")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}


