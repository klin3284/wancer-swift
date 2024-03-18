import SQLite
import SwiftUI
import ContactsUI
import Foundation
import Contacts

func fetchAllContacts(completion: @escaping ([CNContact]?, Error?) -> Void) {
    let store = CNContactStore()
    
    // Request access to the user's contacts
    store.requestAccess(for: .contacts) { granted, error in
        guard granted else {
            completion(nil, error ?? NSError(domain: "AccessDenied", code: 0, userInfo: nil))
            return
        }
        
        let keysToFetch: [CNKeyDescriptor] = [
            CNContactGivenNameKey as CNKeyDescriptor,
            CNContactFamilyNameKey as CNKeyDescriptor,
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var contacts = [CNContact]()
        
        do {
            try store.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }
            completion(contacts, nil)
        } catch {
            completion(nil, error)
        }
    }
}

func insertContactsIntoDatabase(_ contacts: [CNContact]) {
    // Database connection setup
    let db: Connection
    do {
        db = try Connection("/Users/ankitamonkar/Downloads/WANcerDBWork/WANcerDBWork/WANcer.db")
    } catch {
        // Handle error if unable to establish connection
        print("Error opening database: \(error)")
        return
    }
    
    // Define the table structure
    let contactsTable = Table("Contacts")
    let firstName = Expression<String>("firstName")
    let lastName = Expression<String>("lastName")
    let phoneNumber = Expression<String>("phoneNumber")
    
    // Insert fetched contacts into SQLite database
    for contact in contacts {
        let insert = contactsTable.insert(
            firstName <- contact.givenName,
            lastName <- contact.familyName,
            phoneNumber <- contact.phoneNumbers.first?.value.stringValue ?? ""
        )
        do {
            let rowId = try db.run(insert)
            print("Inserted contact with ID: \(rowId)")
        } catch {
            // Handle error if unable to insert contact
            print("Error inserting contact: \(error)")
        }
    }
}

func fetchAllContactsAndInsertIntoDatabase() {
    fetchAllContacts { fetchedContacts, error in
        if let fetchedContacts = fetchedContacts {
            print("Obtained contacts")
            // Perform database insertion here
            insertContactsIntoDatabase(fetchedContacts)
        } else if let error = error {
            print("Error fetching contacts: \(error)")
        }
    }
}
