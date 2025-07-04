//
//  TestGroupManagement.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import SwiftUI
import FirebaseFirestore


// Ensure your Group Model and GroupManager (GroupService) are defined as previously,
// including the addUserToGroup function.

struct TestGroupManagement: View {
    @StateObject private var groupManager = GroupManager()
    
    // For adding new groups
    @State private var newGroupName = ""
    @State private var newUserIDsString = "" // For comma-separated initial user IDs
    @State private var newRestaurantIDsString = "" // For comma-separated initial restaurant IDs

    // For adding user to existing group
    @State private var selectedGroupId: String = "" // Holds the ID of the group to modify
    @State private var userIdToAdd: String = ""    // Holds the ID of the user to add

    var body: some View {
        NavigationView {
            VStack {
                Text("Testing Group Management")
                    .font(.title2)
                    .padding(.bottom, 10)

                // MARK: - Add New Group Section
                Divider().padding(.vertical, 5)
                Text("Add New Group").font(.headline)
                TextField("Group Name", text: $newGroupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("User IDs (comma-separated)", text: $newUserIDsString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                TextField("Restaurant IDs (comma-separated)", text: $newRestaurantIDsString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)

                Button("Add Group to Firestore") {
                    if !newGroupName.isEmpty {
                        let userIDs = newUserIDsString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        let restaurantIDs = newRestaurantIDsString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
                        
                        Task {
                            await groupManager.addGroup(
                                name: newGroupName,
                                users: Array(userIDs)
                            )
                            newGroupName = ""
                            newUserIDsString = ""
                            newRestaurantIDsString = ""
                        }
                    } else {
                        groupManager.errorMessage = "Please enter a group name."
                    }
                }
                .padding()
                
                // MARK: - Add User to Existing Group Section
                Divider().padding(.vertical, 5)
                Text("Add User to Existing Group").font(.headline)
                
                // Picker to select an existing group
                Picker("Select Group", selection: $selectedGroupId) {
                    Text("Select a group").tag("") // Default empty selection
                    ForEach(groupManager.allGroups) { group in
                        Text(group.name)
                            .tag(group.id ?? "") // Use group.id as the tag value
                    }
                }
                .pickerStyle(.menu) // Or .wheel, .segmented etc.
                .padding(.horizontal)
                
                TextField("User ID to Add", text: $userIdToAdd)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding(.horizontal)
                
                Button("Add User to Selected Group") {
                    if !selectedGroupId.isEmpty && !userIdToAdd.isEmpty {
                        Task {
                            await groupManager.addUserToGroup(groupId: selectedGroupId, userId: userIdToAdd)
                            userIdToAdd = "" // Clear after adding
                        }
                    } else {
                        groupManager.errorMessage = "Please select a group and enter a User ID."
                    }
                }
                .padding()
                
                // MARK: - List of Groups
                Divider().padding(.vertical, 5)
                Text("All Groups").font(.headline)
                List {
                    ForEach(groupManager.allGroups) { group in
                        VStack(alignment: .leading) {
                            Text("Name: \(group.name)")
                                .font(.headline)
                            Text("ID: \(group.id ?? "N/A")")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Text("Users: \(group.users.joined(separator: ", "))")
                            Text("Restaurants: \(group.restaurants.joined(separator: ", "))")
                            if let createdAt = group.createdAt?.dateValue() {
                                Text("Created: \(createdAt, formatter: itemFormatter)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                if let id = groupManager.allGroups[index].id {
                                    await groupManager.deleteGroup(id: id)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Groups")
                .navigationBarTitleDisplayMode(.inline)

                .alert("Error", isPresented: .constant(groupManager.errorMessage != nil)) {
                    Button("OK") { groupManager.errorMessage = nil }
                } message: {
                    Text(groupManager.errorMessage ?? "An unknown error occurred.")
                }
            }
        }
    }
    
    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}

// MARK: - Preview Provider
#Preview {
    TestGroupManagement()
}
