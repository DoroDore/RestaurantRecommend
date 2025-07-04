//
//  Profile.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/23/25.
//

import SwiftUI

struct Profile: View {
    var body: some View {
        VStack() {
            HStack(alignment: .top) {
                VStack() {
                    Image("Profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(.gray.opacity(0.3))
                    Text("Group Code: ABCD")
                        .font(.footnote)
                }
                .padding(.trailing)
                Spacer(minLength: 16)
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.largeTitle)
                        .bold()
                    Text("Total Experiences:")
                    Text("Average Rating:")
                }
            }
            .padding()
            Text("Top Restaurant By Visit")
                .font(.title)
            //Placeholder for arraylist looped
            VStack(alignment: .leading) {
                HStack() {
                    Text("Restaurant 1")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("25")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack() {
                    Text("Restaurant 2")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("20")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack() {
                    Text("Restaurant 3")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("18")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.bottom)
            Text("Top Restaurant By Rating")
                .font(.title)
            //Placeholder for arraylist looped
            VStack(alignment: .leading) {
                HStack() {
                    Text("Restaurant A")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("4.9")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack() {
                    Text("Restaurant B")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("4.3")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack() {
                    Text("Restaurant C")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("3.9")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .padding(.bottom)
            Button(action: {
                // Action to perform when the button is tapped
            }) {
                HStack {
                    Image("Settings")
                        .resizable() // Make the image resizable if needed
                        .scaledToFit() // Adjusts the image to fit
                        .frame(width: 30, height: 30) // Set a specific size
                    Text("Settings")
                        .font(.body) // Customize the font if needed
                }
            }
        }
        .padding()
        Spacer()
        ToolbarView()
    }
}

#Preview {
    Profile()
}
