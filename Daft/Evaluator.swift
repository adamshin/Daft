//
//  Evaluator.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum EvaluatorError: Error {
    case unrecognizedIdentifier
    case invalidIntLiteral
    
    case invalidBinaryOperatorParameters
    case invalidAssignment
    
    case unrecognizedExpression
    case unrecognizedPrimaryExpression
    
    case invalidBinarySeriesExpression
    
    case internalError
}

class Evaluator {
    
    let input: EvaluatorInput
    
    init(input: EvaluatorInput) {
        self.input = input
    }
    
    func evaluateNextStatement() throws {
        // Do something
    }
    
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
        case let id as ASTIdentifierExpression:
            return try evaluateIdentifierExpression(id, stack: stack)
            
        case let int as ASTIntLiteralExpression:
            return try evaluateIntLiteralExpression(int)
            
        case let string as ASTStringLiteralExpression:
            return evaluateStringLiteralExpression(string)
            
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
    
}
