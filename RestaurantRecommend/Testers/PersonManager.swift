//
//  PersonManager.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//


// MARK: - PersonManager.swift
// This file will contain the logic for interacting with Firestore.

import Foundation
import FirebaseFirestore // FirebaseFirestore now includes FirebaseFirestoreSwift functionality

class PersonManager: ObservableObject {
    // Firestore instance
    private var db = Firestore.firestore()

    // Published property to hold our list of people,
    // which SwiftUI views can observe for real-time updates.
    @Published var people: [Person] = []

    // Optional: A published property to show any errors
    @Published var errorMessage: String?

    // Listener registration to manage real-time updates.
    // We store it so we can remove it when the manager is no longer needed.
    private var listenerRegistration: ListenerRegistration?

    init() {
        // Start listening for real-time updates when the manager is initialized.
        startListeningForPeopleUpdates()
    }

    deinit {
        // Important: Remove the listener when the manager is deallocated
        // to prevent memory leaks and unnecessary data fetching.
        listenerRegistration?.remove()
    }

    // MARK: - Data Model
    // This struct represents the data structure for a 'person' document in Firestore.
    // It conforms to Codable for easy conversion to/from Firestore data.
    // Identifiable is needed for SwiftUI's ForEach to uniquely identify items.
    // Hashable is added for convenience if you use it in sets or dictionaries.
    struct Person: Codable, Identifiable, Hashable {
        // @DocumentID automatically maps the Firestore document ID to this property.
        // It's optional because when creating a new document, the ID isn't known yet.
        @DocumentID var id: String?
        var name: String
        var age: Int
    }

    // MARK: - Firestore Operations

    /// Starts a real-time listener for the "people" collection in Firestore.
    /// Any changes (additions, modifications, deletions) will update the `people` array.
    func startListeningForPeopleUpdates() {
        // Remove any existing listener before adding a new one to prevent duplicates.
        listenerRegistration?.remove()

        // Create a listener for the "people" collection.
        // We order by name for a consistent display.
        listenerRegistration = db.collection("people")
            .order(by: "name") // Order the results by name
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let self = self else { return } // Safely unwrap self

                if let error = error {
                    self.errorMessage = "Error getting real-time updates: \(error.localizedDescription)"
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    self.errorMessage = "No documents found in 'people' collection."
                    print("No documents in 'people' collection.")
                    return
                }

                // Map the Firestore documents to our `Person` struct.
                // `compactMap` handles potential decoding errors by discarding nil results.
                self.people = documents.compactMap { queryDocumentSnapshot in
                    do {
                        // data(as:) is now part of FirebaseFirestore
                        return try queryDocumentSnapshot.data(as: Person.self)
                    } catch {
                        print("Error decoding person: \(error)")
                        self.errorMessage = "Error decoding person data."
                        return nil
                    }
                }
                print("People list updated in real-time. Total: \(self.people.count)")
            }
    }

    /// Adds a new person document to the "people" collection in Firestore.
    /// Firestore will automatically generate a unique ID for the new document.
    /// - Parameters:
    ///   - name: The name of the person.
    ///   - age: The age of the person.
    func addPerson(name: String, age: Int) async {
        let newPerson = Person(name: name, age: age) // Create a new Person instance

        do {
            // Use `addDocument(from:)` to save the Codable struct directly.
            // This will create a new document with an auto-generated ID.
            // addDocument(from:) is now part of FirebaseFirestore
            _ = try await db.collection("people").addDocument(from: newPerson)
            print("Successfully added person: \(name), \(age)")
        } catch {
            errorMessage = "Error adding person: \(error.localizedDescription)"
            print("Error adding person: \(error)")
        }
    }

    /// Deletes a person document from the "people" collection.
    /// - Parameter id: The document ID of the person to delete.
    func deletePerson(id: String) async {
        do {
            try await db.collection("people").document(id).delete()
            print("Successfully deleted person with ID: \(id)")
        } catch {
            errorMessage = "Error deleting person: \(error.localizedDescription)"
            print("Error deleting person: \(error)")
        }
    }
}
