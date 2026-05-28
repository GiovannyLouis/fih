//
//  ShipPanelView.swift
//  fih
//
//  Created by Satriya Handha Wibowo on 23/05/26.
//

import SwiftUI

struct ObstacleInfoView: View {
    
    let closePanel: () -> Void
    @State private var activeTooltipIndex: Int? = nil
    
    
    var body: some View {
        ZStack() {
            // MARK: Overlay hitam
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { closePanel() }
            
            // MARK: Card Background
            Image("card_background_cream")
                .resizable(
                        capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                        resizingMode: .stretch
                )
                .frame(width: 1300, height: 600)
                .scaleEffect(0.5)
                .offset(y: 16)
//                .ignoresSafeArea()
            
            // MARK: Close Button
            Button(action: {
                closePanel()
            }) {
                Image("icon_close")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            .position(x: 295, y: 161)
            
            // MARK: Title
            Text("Obstacle Information")
                .font(.custom("Cause-Bold", size: 28))
                .foregroundColor(Color("color_dark_blue"))
                .padding(.horizontal, 36)
                .padding(.vertical, 2)
                .background(
                    Image("cream_button")
                        .resizable(
                                capInsets: EdgeInsets(top: 71, leading: 71, bottom: 71, trailing: 71),
                                resizingMode: .stretch
                        )
                        .frame(width: 840, height: 40)
                        .scaleEffect(0.5)
                )
                .position(x: 645, y: 170)
            
            HStack(alignment: .top) {
                // MARK: Weather Obstacle Card
                VStack() {
                    Spacer()
                    // MARK: Card Title
                    Text("Weather Obstacle")
                        .font(.custom("Cause-Bold", size: 20))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.top, 8)
                    Text("Each weather has its own obstacle")
                        .font(.custom("PatrickHand-Regular", size: 16))
                        .foregroundColor(Color("color_dark_blue"))
                        .offset(y: -4)
                    Spacer()
                    Divider()
                        .frame(height: 2)
                        .background(Color.colorDarkBlue)
                        .offset(y: -4)
                        
                    
                    // MARK: Weather Obstacle Info
                    ScrollView(showsIndicators: true) {
                        VStack(spacing: 4) {
                            // MARK: Each Weather Info
                            weather_obs_card(weather_icon: "icon_sunny", obs_icon: "obs_albatros_fish_2", title: "Sunny - Albatros", desc: "Steal 1 random fish")
                            weather_obs_card(weather_icon: "icon_rainy", obs_icon: "obs_lightning_1", title: "Rainy - Lightning", desc: "Reduce ship’s health")
                            weather_obs_card(weather_icon: "icon_windy", obs_icon: "obs_tornado", title: "Windy - Tornado", desc: "Randomly push the ship forward or backward")
                            weather_obs_card(weather_icon: "icon_snowy", obs_icon: "obs_iceberg", title: "Snowy - Iceberg", desc: "Reduce ship’s speed and health")
                        }
                    }
                    .scrollIndicators(.visible)
                    .scrollIndicatorsFlash(onAppear: true)
//                    .border(.black)
//                    .offset(y: -8)
//                    .padding(.top, 4)
                    .padding(.leading, 16)
                    .padding(.trailing, 10)
                    .padding(.bottom, 8)

                    Spacer()
                }
//                .border(.black)
                .padding(.horizontal, 6)
                .frame(maxWidth: 480)
                .background (
                    Image("card_background_cream")
                        .resizable()
                        .frame(maxWidth: .infinity)
                )
                
                // MARK: Common Obstacle Card
                VStack() {
                    Spacer()
                    Text("Common Obstacle")
                        .font(.custom("Cause-Bold", size: 20))
                        .foregroundColor(Color("color_dark_blue"))
                        .padding(.top, 8)
                    Text("Have a chance to appear in all weather")
                        .font(.custom("PatrickHand-Regular", size: 16))
                        .foregroundColor(Color("color_dark_blue"))
                        .offset(y: -4)
                    Spacer()
                    
                    Divider()
                        .frame(height: 2)
                        .background(Color.colorDarkBlue)
                        .offset(y: -4)
                    
//                    Spacer()
                    
                    HStack {
//                        Spacer()
                        EquipmentSlotView(iconName: "obs_kraken_head_smile")
                        VStack(alignment: .leading) {
                            Text("Predator")
                                .font(.custom("Cause-bold", size: 18))
                                .foregroundColor(Color("color_dark_blue"))
                            Text("Reduce ship’s health")
                                .font(.custom("PatrickHand-Regular", size: 14))
                                .foregroundColor(Color("color_dark_blue"))
                        }
                        
                        Spacer()
                    }
//                    .border(.black)
                    .frame(width: 200)
                    
                    
                    HStack {
                        EquipmentSlotView(iconName: "obs_enginefailure")
                        VStack(alignment: .leading) {
                            Text("Engine Failure")
                                .font(.custom("Cause-bold", size: 18))
                                .foregroundColor(Color("color_dark_blue"))
                            Text("Continuously reduce the speed of the ship")
                                .font(.custom("PatrickHand-Regular", size: 14))
                                .foregroundColor(Color("color_dark_blue"))
                        }
                        Spacer()
                    }
                    .offset(y: -4)
//                    .border(.black)
//                    .padding(.bottom, 8)
                    .frame(width: 200)
                    
                    Spacer()
                }
//                .border(.black)
                .padding(.horizontal, 6)
                .frame(maxWidth: 250, maxHeight: .infinity)
                .background (
                    Image("card_background_cream")
                        .resizable()
                        .frame(maxWidth: .infinity)
                )
            }
            .frame(maxWidth: 600, maxHeight: 228)
            .offset(y: 24)
            .padding(.top, 8)

        }
//        .border(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .ignoresSafeArea()
        
    }
}

// MARK: Weather Obstacle Card Struct
struct weather_obs_card: View {
    var weather_icon: String
    var obs_icon: String
    var title: String
    var desc: String
    
    var body: some View {
        HStack() {
            EquipmentSlotView(iconName: weather_icon)
            EquipmentSlotView(iconName: obs_icon)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom("Cause-bold", size: 18))
                    .foregroundColor(Color("color_dark_blue"))
                Text(desc)
                    .font(.custom("PatrickHand-Regular", size: 14))
                    .foregroundColor(Color("color_dark_blue"))
                
            }
            Spacer()
        }
        .padding(.bottom, 8)
    }
}

#Preview {
    ObstacleInfoView(
        closePanel: {
            print("Tombol close ditekan dari preview")
        }
    )
}
