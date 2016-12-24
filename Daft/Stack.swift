//
//  Stack.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum StackError: Error {
    case variableRedeclaration
    
    case noFrames
}

class Stack {
    
    var frames = [StackFrame]()
    
    func pushFrame() {
        frames.append(StackFrame())
    }
    
    func popFrame() {
        frames.append(StackFrame())
    }
    
    func addLocalVariable(name: String, value: ObjectValue) throws {
        guard let currentFrame = frames.last else { throw StackError.noFrames }
        guard currentFrame.localVariables[name] == nil else { throw StackError.variableRedeclaration }
        
        currentFrame.localVariables[name] = LocalVariable(value: value)
    }
    
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
