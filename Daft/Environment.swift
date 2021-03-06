//
//  Environment.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum EnvironmentError: Error {
    case invalidRedeclaration
}

class Environment {
    
    let enclosingEnvironment: Environment?
    var localVariables = [String: LocalVariable]()
    
    init(enclosedBy enclosingEnvironment: Environment?) {
        self.enclosingEnvironment = enclosingEnvironment
    }
    
    func addLocalVariable(name: String, value: Value) throws {
        guard localVariables[name] == nil else {
            throw EnvironmentError.invalidRedeclaration
        }
        localVariables[name] = LocalVariable(value: value)
    }
    
    func localVariable(named name: String) -> LocalVariable? {
        return localVariables[name] ?? enclosingEnvironment?.localVariable(named: name)
    }
    
}

class LocalVariable {
    
    var value: Value
    
    init(value: Value) {
        self.value = value
    }
    
}
