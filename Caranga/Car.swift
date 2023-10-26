//
//  Car.swift
//  Caranga
//
//  Created by Felipe Moreno Borges on 25/10/23.
//

import Foundation

final class Car: Codable, Identifiable {
    var _id: String?
    var brand: String
    var gasType: Int
    var name: String
    var price: Int
    
    lazy var id: String = UUID().uuidString
    
    var fuel: String {
        switch gasType {
            case 0:
                return "Flex"
            case 1:
                return "Álcool"
            default:
                return "Gasolina"
        }
    }
    
    init(_id: String? = nil,
         brand: String = "",
         gasType: Int = 0,
         name: String = "",
         price: Int = 0) {
        self._id = _id
        self.brand = brand
        self.gasType = gasType
        self.name = name
        self.price = price
    }
}

extension Car: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Car: Equatable {
    static func == (lhs: Car, rhs: Car) -> Bool {
        lhs.id == rhs.id
    }
}
