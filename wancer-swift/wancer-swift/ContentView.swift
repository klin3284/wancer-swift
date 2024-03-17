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
