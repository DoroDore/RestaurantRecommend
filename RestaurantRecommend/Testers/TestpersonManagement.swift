//
//  ContentView.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 6/22/25.
//

import SwiftUI
import FirebaseFirestore // This import is sufficient now

struct ContentView: View {
    // Create a StateObject for our PersonManager.
    // This ensures the manager persists across view updates and observes changes.
    @StateObject private var personManager = PersonManager()

    // State variables for the input fields
    @State private var newPersonName: String = ""
    @State private var newPersonAge: String = "" // Use String for TextField input

    var body: some View {
        NavigationView { // Embed in NavigationView for title and list styling
            VStack {
                Text("Add New Person")
                    .font(.title2)
                    .padding(.bottom, 10)

                // Input field for name
                TextField("Name", text: $newPersonName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Input field for age (using keyboard type for numbers)
                TextField("Age", text: $newPersonAge)
                    .keyboardType(.numberPad) // Suggests a number pad keyboard
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                // Button to add the person to Firestore
                Button("Add Person to Firestore") {
                    // Ensure name is not empty and age is a valid integer
                    if !newPersonName.isEmpty, let age = Int(newPersonAge) {
                        Task {
                            await personManager.addPerson(name: newPersonName, age: age)
                            // Clear input fields after adding
                            newPersonName = ""
                            newPersonAge = ""
                        }
                    } else {
                        personManager.errorMessage = "Please enter a valid name and age."
                    }
                }
                .padding()

                // Display the list of people from Firestore
                List {
                    ForEach(personManager.people) { person in
                        HStack {
                            Text("Name: \(person.name)")
                            Spacer()
                            Text("Age: \(person.age)")
                        }
                    }
                    // Enable swipe-to-delete functionality for the list items
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                if let id = personManager.people[index].id {
                                    await personManager.deletePerson(id: id)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("People List") // Title for the navigation bar
                .navigationBarTitleDisplayMode(.inline) // Keep the title compact

                // Display error messages using an alert
                .alert("Error", isPresented: .constant(personManager.errorMessage != nil)) {
                    Button("OK") { personManager.errorMessage = nil } // Clear error on OK
                } message: {
                    Text(personManager.errorMessage ?? "An unknown error occurred.")
                }
            }
        }
    }
}

// MARK: - Preview Provider
#Preview {
    ContentView()
}
