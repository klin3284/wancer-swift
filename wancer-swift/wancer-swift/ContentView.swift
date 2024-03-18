//
//  ContentView.swift
//  wancer-swift
//
//  Created by Kenny Lin on 3/16/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @State private var contacts: [CNContact] = []

    var body: some View {
        VStack {
            Button("add user") {
                addUser()
            }
            List {
                ForEach (users) { user in
                    
                    HStack{
                        Text(user.name)
                        Spacer()
                    }
                }
            }
        }
        List(contacts, id: \.identifier) { contact in
            VStack {
                Text("\(contact.givenName) \(contact.familyName) \(contact.phoneNumbers[0].value.stringValue)")
                // Additional contact information can be displayed here
            }
        }
        .onAppear {
            fetchAllContacts { fetchedContacts, error in
                if let fetchedContacts = fetchedContacts {
                    print("Obtained contacts")
                    self.contacts = fetchedContacts
                } else if let error = error {
                    print("Error fetching contacts: \(error)")
                }
            }
        }
    }

    private func addUser() {
        let user = User(id: 1, name: "Test user")
        
        modelContext.insert(user)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(users[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
