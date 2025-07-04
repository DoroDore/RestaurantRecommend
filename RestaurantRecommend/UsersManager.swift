//
//  UsersManager.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

// UsersManager.swift
import Foundation
import FirebaseFirestore


class UsersManager: ObservableObject {
    private var db = Firestore.firestore()

    @Published var currentUserProfile: User? // To hold the profile of a fetched user
    @Published var allUsers: [User] = [] // To hold a list of all users (for display)
    @Published var errorMessage: String?

    private var currentUserListener: ListenerRegistration?
    private var allUsersListener: ListenerRegistration?

    init() {
        // In a real app with authentication, you'd start listening for the current
        // user's profile here after they log in.
        // For this basic test, we'll fetch/add users on demand from the view.
        
        // Let's add a listener for all users here so the list updates automatically
        listenForAllUsers()
    }

    deinit {
        currentUserListener?.remove()
        allUsersListener?.remove()
    }

    // MARK: - Firestore Operations for Users

    /// Adds a new user document to the "users" collection in Firestore.
    /// Firestore will automatically generate a unique ID for the new document.
    /// - Parameters:
    ///   - name: The name of the user.
    ///   - email: The email of the user.
    func addUser(name: String, email: String) async {
        // When adding, the 'id' is nil, Firestore will auto-generate it.
        let newUser = User(name: name, email: email, groupsJoined: [])
        do {
            // Using addDocument(from:) to save the Codable struct.
            _ = try await db.collection("users").addDocument(from: newUser)
            print("Successfully added user: \(name)")
        } catch {
            errorMessage = "Error adding user: \(error.localizedDescription)"
            // Corrected typo: "Error adding user" instead of "Error adding person"
            print("Error adding user: \(error)")
        }
    }

    /// Listens for real-time updates to all documents in the "users" collection.
    /// Updates the `allUsers` published array.
    func listenForAllUsers() {
        allUsersListener?.remove() // Remove any existing listener

        allUsersListener = db.collection("users")
            .order(by: "name") // Order the results by name
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return }

                if let error = error {
                    self.errorMessage = "Error getting real-time user updates: \(error.localizedDescription)"
                    print("Error getting user documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "No documents found in 'users' collection."
                    print("No documents in 'users' collection.")
                    return
                }

                self.allUsers = documents.compactMap { queryDocumentSnapshot in
                    do {
                        // data(as:) is now part of FirebaseFirestore
                        return try queryDocumentSnapshot.data(as: User.self)
                    } catch {
                        print("Error decoding user: \(error)")
                        self.errorMessage = "Error decoding user data."
                        return nil
                    }
                }
                print("Users list updated in real-time. Total: \(self.allUsers.count)")
            }
    }

    /// Deletes a user document from the "users" collection.
    /// - Parameter id: The document ID of the user to delete.
    func deleteUser(id: String) async {
        do {
            try await db.collection("users").document(id).delete()
            print("Successfully deleted user with ID: \(id)")
        } catch {
            errorMessage = "Error deleting user: \(error.localizedDescription)"
            print("Error deleting user: \(error)")
        }
    }

    // Other methods like `listenForCurrentUserProfile` and `saveUserProfile`
    // from the previous example would also go here if you need them later.
    // For this specific test, `addUser` and `listenForAllUsers` are primary.
}
