//
//  Value.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum Value {
    case void
    case int(Int)
    case bool(Bool)
    case string(String)
    
    case function(argumentList: ASTArgumentList, codeBlock: ASTCodeBlock, enclosingEnvironment: Environment)
}

protocol ValueType {
    var value: Value { get }
}

struct LValue: ValueType {
    
    let variable: LocalVariable
    
    func assign(_ value: Value) {
        variable.value = value
    }
    
    var value: Value { return variable.value }
}

struct RValue: ValueType {
    
    let value: Value
    
}
