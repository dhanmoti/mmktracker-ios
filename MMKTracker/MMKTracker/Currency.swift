//
//  Currency.swift
//  MMKTracker
//
//  Created by Dhan Moti on 27/3/23.
//

import Foundation
struct Currency: Identifiable {
    var id: UUID = UUID()
    var title: String
    var shortTitle: String
    var rate: String
    var timestamp: String
    var base: String
}
