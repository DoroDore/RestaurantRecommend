//
//  Settings.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/23/25.
//

import SwiftUI

struct Settings: View {
    var body: some View {
        VStack() {
            Text("Settings")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                
            }) {
                HStack() {
                    Image("Profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(10)
                    Text("Profile")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                //Please add the action
            }) {
                HStack() {
                    Image("SettingsGroupIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(10)
                    Text("Group")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                //Please add action
            }) {
                HStack() {
                    Image("SettingsUIIcon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(.gray.opacity(0.3))
                        .cornerRadius(10)
                    Text("UI/Interface")
                        .font(.headline)
                        .foregroundColor(.black)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        Spacer()
        ToolbarView()
    }
}

#Preview {
    Settings()
}
