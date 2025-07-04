//
//  User.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import FirebaseFirestore

struct User: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var groupsJoined: [String]
}
