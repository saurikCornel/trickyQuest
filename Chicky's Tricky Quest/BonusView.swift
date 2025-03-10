import SwiftUI

struct DailyBonus: View {
    @AppStorage("lastSpinTime") private var lastSpinTime: Double = 0
    @State private var isSpinning = false
    @State private var rotationAngle: Double = 0
    @State private var showPrize = false
    @State private var showAlert = false
    @State private var remainingTime: String = ""
    @AppStorage("coinscore") var coinscore: Int = 10
    @State private var timer: Timer?
    
    private var canSpin: Bool {
        Date().timeIntervalSince1970 - lastSpinTime > 86400
    }
    
    private func updateRemainingTime() {
        let timePassed = Date().timeIntervalSince1970 - lastSpinTime
        let timeLeft = max(86400 - timePassed, 0)
        
        let hours = Int(timeLeft) / 3600
        let minutes = (Int(timeLeft) % 3600) / 60
        remainingTime = String(format: "%02d:%02d", hours, minutes)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack {
                    VStack {
                        HStack {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .padding(.top, 60)
                                .padding()
                                .foregroundStyle(.white)
                                .onTapGesture {
                                    AppNavigator.shared.currentScreen = .MENU
                                }
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    HStack(spacing: 90) {
                        Image(.rulet)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .rotationEffect(.degrees(rotationAngle))
                            .animation(.easeOut(duration: 12), value: rotationAngle)
                        
                        Image(.spinBtn)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 150, height: 150)
                            .opacity(canSpin && !isSpinning ? 1 : 0.5)
                            .onTapGesture {
                                if canSpin {
                                    // Блокируем кнопку сразу
                                    lastSpinTime = Date().timeIntervalSince1970
                                    
                                    isSpinning = true
                                    rotationAngle += 3600
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                                        isSpinning = false
                                        coinscore += 5
                                        showPrize = true
                                    }
                                } else {
                                    updateRemainingTime()
                                    showAlert = true
                                }
                            }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Next spin in"), message: Text(remainingTime))
                }
                .alert(isPresented: $showPrize) {
                    Alert(
                        title: Text("Congratulations!"),
                        message: Text("You won 5 coins!"),
                        dismissButton: .default(Text("OK")) {
                            AppNavigator.shared.currentScreen = .MENU
                        }
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundDaily)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
        }
        .onAppear {
            updateRemainingTime()
            timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                updateRemainingTime()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
}

#Preview {
    DailyBonus()
}
