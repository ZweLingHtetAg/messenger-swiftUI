//
//  Message.swift
//  messenger
//
//  Created by Zwel Linn Htet Ag on 23/08/2021.
//

import Foundation
import Firebase

enum messageType: String{
    case sent
    case received
}

struct Message: Hashable {
    let text: String
    let type: messageType
    let created: Date
}
