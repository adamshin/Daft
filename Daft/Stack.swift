//
//  Stack.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

class Stack {
    
    var frames = [StackFrame]()
    
    func localVariable(named name: String) -> LocalVariable? {
        for frame in frames.reversed() {
            if let variable = frame.localVariables[name] {
                return variable
            }
        }
        return nil
    }
    
}

class StackFrame {
    
    var localVariables = [String: LocalVariable]()
    
}

class LocalVariable {
    
    var value: ObjectValue
    
    init(value: ObjectValue) {
        self.value = value
    }
    
}
