//
//  TestUserManagement.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import SwiftUI
import FirebaseFirestore

struct TestUserManagement: View {
    @StateObject private var usersManager = UsersManager()
    
    @State private var newUserName = ""
    @State private var newUserEmail = ""
    // newUserID is not used in the `addUser` function, as Firestore auto-generates the ID.
    // It would be used if you were using `setData(from: User, merge: true)` with a custom ID.
    // @State private var newUserID = "TestLol"

    var body: some View {
        NavigationView { // Added NavigationView for better structure and title
            VStack {
                Text("Testing User Management") // More descriptive title
                    .font(.title2)
                    .padding(.bottom, 10)

                TextField("Name", text: $newUserName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Email", text: $newUserEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress) // Suggest email keyboard
                    .autocapitalization(.none) // Emails are usually lowercase
                    .padding(.horizontal)

                Button("Add User to Firestore") { // Changed button text for clarity
                    if !newUserName.isEmpty && !newUserEmail.isEmpty {
                        Task {
                            await usersManager.addUser(name: newUserName, email: newUserEmail)
                            newUserName = ""
                            newUserEmail = ""
                        }
                    } else {
                        usersManager.errorMessage = "Please enter a valid name and email."
                    }
                }
                .padding()

                // Display the list of users from Firestore
                List {
                    ForEach(usersManager.allUsers) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Name: \(user.name)")
                                Text("Email: \(user.email)")
                                Text("Groups: \(user.groupsJoined.joined(separator: ", "))") // Display groups
                            }
                            Spacer()
                        }
                    }
                    // Enable swipe-to-delete functionality
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                if let id = usersManager.allUsers[index].id {
                                    await usersManager.deleteUser(id: id)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Users") // Title for the navigation bar
                .navigationBarTitleDisplayMode(.inline)

                // Display error messages using an alert
                .alert("Error", isPresented: .constant(usersManager.errorMessage != nil)) {
                    Button("OK") { usersManager.errorMessage = nil }
                } message: {
                    Text(usersManager.errorMessage ?? "An unknown error occurred.")
                }
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    TestUserManagement()
}
