import SwiftUI

struct MenuView: View {
    @StateObject private var soundManager = CheckingSound() // Подключаем CheckingSound
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true // Флаг первого запуска
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                    ZStack {
                        VStack {
                            HStack {
                                BalanceTemplate()
                                Spacer()
                            }
                            Spacer()
                        }
                        
                        
                        VStack {
                            Spacer()
                            ButtonTemplateSmall(image: "bonusBtn", action: { AppNavigator.shared.currentScreen = .BONUS })
                        }
                        
                
                        
                        HStack {
                            Spacer()
                            VStack {
                                ButtonTemplateSmall(image: "playBtn", action: { AppNavigator.shared.currentScreen = .GAME })
                                ButtonTemplateSmall(image: "optionBtn", action: { AppNavigator.shared.currentScreen = .SETTINGS })
                                ButtonTemplateSmall(image: "shopBtn", action: { AppNavigator.shared.currentScreen = .SHOP })
                                ButtonTemplateSmall(image: "infoBtn", action: { AppNavigator.shared.currentScreen = .ABOUT })
                            }
                        }
                        
                      
                    }
                    .onAppear {
                        // Включаем музыку только при первом запуске
                        if isFirstLaunch {
                            soundManager.musicEnabled = true
                            isFirstLaunch = false // Отмечаем, что первый запуск прошёл
                        }
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundLoading)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
    }
}

struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 55, y: 35)
                    }
                )
        }
    }
}


struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void
    
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 80)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}



#Preview {
    MenuView()
}
