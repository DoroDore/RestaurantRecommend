//
//  GroupManager.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import FirebaseFirestore

class GroupManager: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var allGroups: [Group] = []
    @Published var userGroups: [Group] = []
    @Published var currentGroup: Group?
    @Published var errorMessage: String?
    
    private var allGroupsListener: ListenerRegistration?
    private var userGroupsListener: ListenerRegistration?
    private var specificGroupListener: ListenerRegistration?
    
    init () {
        //Add some stuff lol
        startListeningForAllGroups()
    }
    deinit {
        allGroupsListener?.remove()
                userGroupsListener?.remove()
                specificGroupListener?.remove()
                print("GroupService deinitialized and Firestore listeners removed.")
    }
    
    func addGroup(name: String, users: [String]) async {
        let newGroup = Group(name: name, users: users, restaurants: [])
        do {
            _ = try await
                db.collection("groups")
                .addDocument(from: newGroup)
            print("Successfully added group \(name)")
        } catch {
            errorMessage = "Error adding group: \(error.localizedDescription)"
                        print("Error adding group: \(error)")
        }
    }
    
    func deleteGroup(id: String) async {
        do {
            try await
            db.collection("group").document(id).delete()
            print("Successfully deleted group with ID: \(id)")
        } catch {
            errorMessage = "Error deleting user: \(error.localizedDescription)"
            print("Error deleting user: \(error)")
        }
    }
    
    func addUserToGroup(groupId: String, userId: String) async {
        let groupDocumentRef = db.collection("groups").document(groupId)
        do {
            try await groupDocumentRef.updateData([
                "users": FieldValue.arrayUnion([userId])
            ])
            print("Successfully added user \(userId) to group \(groupId).")
            errorMessage = nil
            } catch {
                errorMessage = "Error adding user \(userId) to group \(groupId): \(error.localizedDescription)"
                print("Error adding user to group: \(error)")
            }
    }
    
    
    func startListeningForAllGroups() {
            allGroupsListener?.remove()
            allGroupsListener = db.collection("groups")
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error fetching all groups: \(error.localizedDescription)")
                        return
                    }

                    self.allGroups = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Group.self)
                    } ?? []
                }
        }

        func startListeningForUserGroups(userId: String) {
            userGroupsListener?.remove()

            userGroupsListener = db.collection("groups")
                .whereField("members", arrayContains: userId) // Example: groups where the user is a member
                .addSnapshotListener { [weak self] querySnapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error fetching user groups: \(error.localizedDescription)")
                        return
                    }

                    self.userGroups = querySnapshot?.documents.compactMap { document in
                        try? document.data(as: Group.self)
                    } ?? []
                }
        }
        
        func startListeningForSpecificGroup(groupId: String) {
            specificGroupListener?.remove() // Ensure only one specific group is listened to at a time

            specificGroupListener = db.collection("groups").document(groupId)
                .addSnapshotListener { [weak self] documentSnapshot, error in
                    guard let self = self else { return }
                    if let error = error {
                        print("Error fetching specific group: \(error.localizedDescription)")
                        return
                    }

                    self.currentGroup = try? documentSnapshot?.data(as: Group.self)
                }
        }
}
