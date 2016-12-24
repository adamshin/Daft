//
//  Evaluator.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum EvaluatorError: Error {
    case unrecognizedStatement
    
    case variableAlreadyDeclared
    
    case unrecognizedExpression
    case unrecognizedPrimaryExpression
    
    case invalidBinarySeriesExpression
    
    case invalidBinaryOperatorParameters
    case invalidAssignment
    
    case unrecognizedIdentifier
    case invalidIntLiteral
    
    case internalError
}

class Evaluator {
    
    let input: EvaluatorInput
    let debugOutput: (String) -> Void
    
    let stack: Stack
    
    init(input: EvaluatorInput, debugOutput: @escaping (String) -> Void) {
        self.input = input
        self.debugOutput = debugOutput
        
        stack = Stack()
        stack.pushFrame()
    }
    
    func evaluate() throws {
        while let statement = input.nextStatement() {
            try evaluateStatement(statement)
        }
    }
    
}
