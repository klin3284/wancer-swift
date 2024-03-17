//
//  User.swift
//  wancer-swift
//
//  Created by Ethan Liu on 3/16/24.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}
