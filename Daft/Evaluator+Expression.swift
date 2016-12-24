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
    
    class func evaluateExpression(_ expression: ASTExpression, stack: Stack) throws -> RValue {
        let result: ValueType
        
        switch expression {
        case let binarySeries as ASTBinarySeriesExpression:
            result = try evaluateBinarySeriesExpression(binarySeries, stack: stack)
            
        default:
            throw EvaluatorError.unrecognizedExpression
        }
        
        return RValue(value: result.value)
    }
    
    // MARK: - Postfix Expression
    
    class func evaluatePostfixExpression(_ expression: ASTPostfixExpression, stack: Stack) throws -> ValueType {
        let primaryValue = try evaluatePrimaryExpression(expression.primaryExpression, stack: stack)
        
        // TODO: evaluate postfixes if present and apply them
        
        return primaryValue
    }
    
    // MARK: - Primary Expression
    
    class func evaluatePrimaryExpression(_ expression: ASTPrimaryExpression, stack: Stack) throws -> ValueType {
        switch expression {
        case let parenthesized as ASTParenthesizedExpression:
            return try evaluateParenthesizedExpression(parenthesized, stack: stack)
            
        case let identifier as ASTIdentifierExpression:
            return try evaluateIdentifierExpression(identifier, stack: stack)
            
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
    
    class func evaluateParenthesizedExpression(_ expression: ASTParenthesizedExpression, stack: Stack) throws -> RValue {
        return try evaluateExpression(expression.expression, stack: stack)
    }
    
    class func evaluateIdentifierExpression(_ expression: ASTIdentifierExpression, stack: Stack) throws -> LValue {
        guard let variable = stack.localVariable(named: expression.name) else {
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
