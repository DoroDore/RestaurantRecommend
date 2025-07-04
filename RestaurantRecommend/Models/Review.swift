//
//  Review.swift
//  RestaurantRecommend
//
//  Created by Theodore Zhu on 7/3/25.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var reviewerId: String
    var tasteRating: Int
    var waitTimeRating: Int
    var note: String?
    var createdAt: Timestamp?
    
    init(id: String? = nil, reviewerId: String, tasteRating: Int, waitTimeRating: Int, note: String? = nil, createdAt: Timestamp? = nil) {
        self.id = id
                self.reviewerId = reviewerId
                self.tasteRating = tasteRating
                self.waitTimeRating = waitTimeRating
                self.note = note
                self.createdAt = createdAt ?? Timestamp(date: Date())
    }
}
