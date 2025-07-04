//
//  Restaurant.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import FirebaseFirestore

struct Restaurant: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var photoUrl: String?
    var address: String
    var avgTasteRating: Double
    var avgWaitTimeRating: Double
    var consistencyRating: Double
    var totalReviews: Int
    var totalVisits: Int
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    //Please add constructors if you have time thanks :)
    init(id: String? = nil, name: String, photoUrl: String? = nil, address: String,
             avgTasteRating: Double = 0.0, avgWaitTimeRating: Double = 0.0, consistencyRating: Double = 0.0,
             totalReviews: Int = 0, totalVisits: Int = 0, createdAt: Timestamp? = nil, updatedAt: Timestamp? = nil) {
            self.id = id
            self.name = name
            self.photoUrl = photoUrl
            self.address = address
            self.avgTasteRating = avgTasteRating
            self.avgWaitTimeRating = avgWaitTimeRating
            self.consistencyRating = consistencyRating
            self.totalReviews = totalReviews
            self.totalVisits = totalVisits
            self.createdAt = createdAt ?? Timestamp(date: Date())
            self.updatedAt = updatedAt ?? Timestamp(date: Date())
        }
}
