//
//  ResultOverlayView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 23/05/26.
//

import SwiftUI
import SwiftData

struct ResultOverlayView: View {

    @Environment(AppStateManager.self) private var appState
    @Environment(\.modelContext) private var context

    let controller: InGameController
    let playerController: PlayerController

    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()

            ZStack {
                // LAYER 1: Background — scaleEffect supaya ukuran terkontrol
                Image("card_background_cream")
                    .resizable(
                        capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                        resizingMode: .stretch
                    )
                    .frame(width: 1100, height: 640)
                    .scaleEffect(0.5)
                    .frame(width: 550, height: 320)

                // LAYER 2: Konten
                VStack(spacing: 0) {

                    // Title
                    Text(resultTitle.uppercased())
                        .font(.custom("Cause-Bold", size: 22))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.top, 20)
                        .padding(.bottom, 10)

                    // Divider
                    Rectangle()
                        .fill(Color("color_dark_blue").opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 24)

                    // Fish list / pesan
                    if controller.expeditionResults != .shipDestroyed && !controller.catchLog.isEmpty {
                        ScrollView(.vertical, showsIndicators: true) {
                            let groupedFish = Dictionary(
                                grouping: controller.catchLog,
                                by: { $0.name }
                            )
                            let sortedKeys = groupedFish.keys.sorted()
                            
                            VStack(spacing: 8) {
                                ForEach(sortedKeys, id: \.self) { fishName in
                                    if let sampleFish = groupedFish[fishName]?.first,
                                       let fishCount  = groupedFish[fishName]?.count {
                                        HStack(spacing: 10) {
                                            Image(sampleFish.iconName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 28)
                                            Text(fishName)
                                                .font(.custom("Cause-Bold", size: 14))
                                                .foregroundColor(Color("color_dark_blue"))
                                            Spacer()
                                            Text("x\(fishCount)")
                                                .font(.custom("Cause-Bold", size: 14))
                                                .foregroundColor(Color("color_dark_blue"))
                                                .padding(.trailing, 4)
                                        }
                                        .padding(.horizontal, 90)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .frame(height: 170) // fixed supaya tidak overflow ke luar card

                    } else if controller.expeditionResults == .shipDestroyed {
                        Text(resultSubtitle)
                            .font(.custom("Cause-Bold", size: 14))
                            .foregroundColor(Color("color_dark_blue").opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 28)
                            .frame(height: 160)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("No fish collected.")
                            .font(.custom("Cause-Bold", size: 14))
                            .foregroundColor(Color("color_dark_blue").opacity(0.4))
                            .frame(height: 160)
                    }

                    // Button
                    Button(action: {
                        playerController.collectFish(context: context, catchFish: controller.catchLog)
                        playerController.incrementDays(context: context)
                        appState.currentScreen = .mainMenuPage
                        appState.resetForecast()
                    }) {
                        Text("Return to Home")
                            .font(.custom("Cause-Bold", size: 16))
                            .foregroundColor(Color("color_dark_blue"))
                            .padding(.horizontal, 32)
                            .padding(.vertical, 12)
                            .background(
                                Image("green_button")
                                    .resizable()
                                    .scaledToFill()
                            )
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                }
                .frame(width: 550, height: 320) // sama dengan frame scaleEffect
            }
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
    // ResultOverlayView()
}
