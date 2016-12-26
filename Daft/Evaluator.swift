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
    
    case invalidCondition
    case unrecognizedElseClause
    
    case invalidRedeclaration
    
    case unrecognizedExpression
    case unrecognizedPrimaryExpression
    
    case unrecognizedPostfix
    
    case invalidFunctionCall
    case invalidFunctionArguments
    
    case invalidBinarySeriesExpression
    
    case invalidBinaryOperatorParameters
    case invalidAssignment
    
    case unrecognizedIdentifier
    case invalidIntLiteral
    
    case internalError
}

class Evaluator {
    
    let input: EvaluatorInput
    let debugOutput: EvaluatorDebugOutput
    
    init(input: EvaluatorInput, debugOutput: EvaluatorDebugOutput) {
        self.input = input
        self.debugOutput = debugOutput
    }
    
    func evaluate() throws {
        let env = Environment(enclosedBy: nil)
        
        while let statement = input.nextStatement() {
            if let returnValue = try Evaluator.evaluateStatement(statement, environment: env, debugOutput: debugOutput) {
                debugOutput.print("Program returned value \(Evaluator.stringForObjectValue(returnValue))\n")
                break
            }
        }
    }
    
}
