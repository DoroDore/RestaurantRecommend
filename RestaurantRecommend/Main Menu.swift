//
//  Main Menu.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/23/25.
//

import SwiftUI

struct Main_Menu: View {
    var body: some View {
        
        VStack {
            ZStack {
                //Logo is overlaid behind the text
                Image("Logo")
                    .resizable()
                    .frame(width: 500, height: 500)
                    .opacity(0.5)
                VStack() {
                    Text("What Should We Eat Today?")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button("Enter Voting") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                    Button("Register a Restaurant") {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.title)
                    Spacer()
                }
            }
            ToolbarView()
        }
    }
}

#Preview {
    Main_Menu()
}
