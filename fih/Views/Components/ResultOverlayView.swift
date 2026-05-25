//
//  ResultOverlayView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 23/05/26.
//

import SwiftUI
import SwiftData 

/// untuk menampilkan alert saat waktu habis, pulang lebih awal, dan kapal hancur
struct ResultOverlayView: View {
    
    @Environment(AppStateManager.self) private var appState
    @Environment(\.modelContext) private var context

    let controller: InGameController
    let playerController: PlayerController
    
    
    var body: some View {
        ZStack {
            // Background blur/dim
            Color.black.opacity(0.55).ignoresSafeArea()
            // Card
            VStack(spacing: 0) {

                // MARK: - Title
                Text(resultTitle.uppercased())
                    .font(.custom("Cause-Bold", size: 28))
                    .foregroundColor(Color("color_dark_blue"))
                    .padding(.top, 28)
                    .padding(.bottom, 20)

                // MARK: - Divider
                Rectangle()
                    .fill(Color("color_dark_blue").opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 24)

                // MARK: - Fish List
                if controller.expeditionResults != .shipDestroyed && !controller.catchLog.isEmpty {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(Array(controller.catchLog.enumerated()), id: \.offset) { _, fish in
                                HStack(spacing: 12) {
                                    Image(fish.iconName)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 44, height: 30)
                                    Text(fish.name)
                                        .font(.custom("Cause-Bold", size: 16))
                                        .foregroundColor(Color("color_dark_blue"))
                                    Spacer()
                                }
                                .padding(.horizontal, 28)
                            }
                        }
                        .padding(.vertical, 16)
                    }
                    .frame(height: 200)

                } else if controller.expeditionResults == .shipDestroyed {
                    // Ship destroyed — tampilkan pesan
                    VStack(spacing: 8) {
                        Text(resultSubtitle)
                            .font(.custom("Cause-Bold", size: 16))
                            .foregroundColor(Color("color_dark_blue").opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)

                } else {
                    // No fish
                    Text("No fish collected.")
                        .font(.custom("Cause-Bold", size: 16))
                        .foregroundColor(Color("color_dark_blue").opacity(0.4))
                        .frame(height: 200)
                }

                // MARK: - Return to Home Button
                Button(action: {
                    playerController.collectFish(context: context, catchFish: controller.catchLog)
                    playerController.incrementDays(context: context)
                    appState.currentScreen = .mainMenuPage
                    appState.resetForecast()
                }) {
                    Text("Return to Home")
                        .font(.custom("Cause-Bold", size: 18))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(
                            Image("green_button")
                                .resizable()
                                .scaledToFill()
                        )
                }
                .padding(.top, 30)
                .padding(.bottom, 28)
            }
            .frame(width: 560)
            .background(
                Image("card_background_cream")
                    .resizable()
                    .scaledToFill()
            )
            .cornerRadius(16)
            .padding(.bottom, 50)
            .padding(.top, 70)
        }
        .transition(.opacity)
        .animation(.easeIn(duration: 0.3), value: controller.isExpeditionOver)
    }
    
    private var resultTitle: String {
        switch controller.expeditionResults {
        case .shipDestroyed: return "Shipwrecked!"
        case .safeReturn:    return "Safe Return!"
        case .timeUp:        return "Time's Up!"
        case .inProgress:    return ""
        }
    }
    
    private var resultSubtitle: String {
        switch controller.expeditionResults {
        case .shipDestroyed: return "Your ship sank.\nAll fish were lost."
        case .safeReturn:    return "You returned safely with your catch."
        case .timeUp:        return "The fishing day is over."
        case .inProgress:    return ""
        }
    }
}

#Preview {
    //ResultOverlayView()
}
