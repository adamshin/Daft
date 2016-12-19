//
//  Value.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum ObjectValue {
    case int(Int)
    case string(String)
}

protocol ValueType {
    var value: ObjectValue { get }
}

struct LValue: ValueType {
    
    let variable: LocalVariable
    
    func assign(_ value: ObjectValue) {
        variable.value = value
    }
    
    var value: ObjectValue { return variable.value }
}

struct RValue: ValueType {
    
    let rawValue: ObjectValue
    var value: ObjectValue { return rawValue }
    
}
