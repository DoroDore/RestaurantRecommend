//
//  Group.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import FirebaseFirestore

struct Group: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var users: [String]
    var restaurants: [String]
    var createdAt: Timestamp?
}
