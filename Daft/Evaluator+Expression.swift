//
//  Evaluator+Expression.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    // MARK: - Expression
    
    class func evaluateExpression(_ expression: ASTExpression, environment: Environment) throws -> ObjectValue {
        let result: ValueType
        
        switch expression {
        case let binarySeries as ASTBinarySeriesExpression:
            result = try evaluateBinarySeriesExpression(binarySeries, environment: environment)
            
        default:
            throw EvaluatorError.unrecognizedExpression
        }
        
        return result.value
    }
    
    // MARK: - Postfix Expression
    
    class func evaluatePostfixExpression(_ expression: ASTPostfixExpression, environment: Environment) throws -> ValueType {
        let primaryValue = try evaluatePrimaryExpression(expression.primaryExpression, environment: environment)
        
        return try expression.postfixes.reduce(primaryValue) { value, postfix in
            switch postfix {
            case let functionCallArgumentList as ASTFunctionCallArgumentList:
                return try evaluateFunctionCall(value: value, argumentList: functionCallArgumentList, environment: environment)
                
            default:
                throw EvaluatorError.unrecognizedPostfix
            }
        }
    }
    
    // MARK: - Primary Expression
    
    class func evaluatePrimaryExpression(_ expression: ASTPrimaryExpression, environment: Environment) throws -> ValueType {
        switch expression {
        case let parenthesized as ASTParenthesizedExpression:
            return try evaluateParenthesizedExpression(parenthesized, environment: environment)
            
        case let function as ASTFunctionExpression:
            return try evaluateFunctionExpression(function, environment: environment)
            
        case let identifier as ASTIdentifierExpression:
            return try evaluateIdentifierExpression(identifier, environment: environment)
            
        case let int as ASTIntLiteralExpression:
            return try evaluateIntLiteralExpression(int)
            
        case let string as ASTStringLiteralExpression:
            return evaluateStringLiteralExpression(string)
            
        case let bool as ASTBoolLiteralExpression:
            return evaluateBoolLiteralExpression(bool)
            
        default:
            throw EvaluatorError.unrecognizedPrimaryExpression
        }
    }
    
    class func evaluateParenthesizedExpression(_ expression: ASTParenthesizedExpression, environment: Environment) throws -> RValue {
        return try RValue(value: evaluateExpression(expression.expression, environment: environment))
    }
    
    class func evaluateFunctionExpression(_ expression: ASTFunctionExpression, environment: Environment) throws -> RValue {
        return RValue(value: .function(argumentList: expression.argumentList, codeBlock: expression.codeBlock, enclosingEnvironment: environment))
    }
    
    class func evaluateIdentifierExpression(_ expression: ASTIdentifierExpression, environment: Environment) throws -> LValue {
        guard let variable = environment.localVariable(named: expression.name) else {
            throw EvaluatorError.unrecognizedIdentifier
        }
        return LValue(variable: variable)
    }
    
    class func evaluateIntLiteralExpression(_ expression: ASTIntLiteralExpression) throws -> RValue {
        guard let value = Int(expression.literal) else {
            throw EvaluatorError.invalidIntLiteral
        }
        return RValue(value: .int(value))
    }
    
    class func evaluateStringLiteralExpression(_ expression: ASTStringLiteralExpression) -> RValue {
        return RValue(value: .string(expression.literal))
    }
    
    class func evaluateBoolLiteralExpression(_ expression: ASTBoolLiteralExpression) -> RValue {
        return RValue(value: .bool(expression.value))
    }

}
