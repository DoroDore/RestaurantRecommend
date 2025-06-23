 //
//  ToolbarView.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/23/25.
//

import SwiftUI

struct ToolbarView: View {
    var body: some View {
        let onHomeTapped = {}
        let onStatsTapped = {}
        let onProfileTapped = {}
        
        HStack {
            Button(action: onStatsTapped) {
                Image("Stats")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
            Spacer()
            Button(action: onHomeTapped) {
                Image("MainMenu")
                    .resizable()
                    .scaledToFit()
                    .frame(width:50, height: 50)
            }
            Spacer()
            Button(action: onProfileTapped) {
                Image("Profile")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
        .padding()
        .padding(.horizontal, 16)
        .background(.thinMaterial)
    }
}

#Preview {
    ToolbarView()
}
