//
//  StatsPageView.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/2/25.
//

import SwiftUI

struct StatsPageView: View {
    @State private var showingFamilyStats = false
    private var temporaryStats:
    var body: some View {
        VStack() {
            Text("Settings")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity)
            Button(action: {
                showingFamilyStats.toggle()
            }) {
                Text(showingFamilyStats ? "Show Personal Stats" : "Show Family Stats")
            }
            .buttonStyle(.borderedProminent)
            
        }
    }
}

#Preview {
    StatsPageView()
}
