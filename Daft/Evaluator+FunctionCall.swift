//
//  Evaluator+FunctionCall.swift
//  Daft
//
//  Created by Adam Shin on 12/25/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateFunctionCall(value: ValueType, argumentList callArgumentList: ASTFunctionCallArgumentList, environment: Environment) throws -> ValueType {
        guard case let .function(argumentList, codeBlock, enclosingEnvironment) = value.value else {
            throw EvaluatorError.invalidFunctionCall
        }
        guard argumentList.arguments.count == callArgumentList.arguments.count else {
            throw EvaluatorError.invalidFunctionArguments
        }
        
        let functionEnvironment = Environment(enclosedBy: enclosingEnvironment)
        
        try zip(argumentList.arguments, callArgumentList.arguments).forEach {
            let name = $0.name
            let value = try evaluateExpression($1, environment: environment)
            try functionEnvironment.addLocalVariable(name: name, value: value)
        }
        
        // TODO: Proper output
        let output = EvaluatorDebugOutput() { _ in }
        if let returnValue = try evaluateCodeBlock(codeBlock, environment: functionEnvironment, debugOutput: output) {
            return RValue(value: returnValue)
        } else {
            return RValue(value: .void)
        }
    }
    
}
