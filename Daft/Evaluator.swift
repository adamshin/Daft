//
//  Evaluator.swift
//  Daft
//
//  Created by Adam Shin on 12/18/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

enum EvaluatorError: Error {
    case unrecognizedPrimaryExpression
    case invalidBinarySeriesExpression
    
    case unrecognizedIdentifier
    case invalidIntLiteral
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
    
    func evaluateExpression(_ expression: ASTExpression, stack: Stack) throws -> RValue {
        // Do something
        return RValue(rawValue: .int(0))
    }
    
    func evaluateBinarySeriesExpression(_ expression: ASTBinarySeriesExpression, stack: Stack) throws -> RValue {
        guard !expression.expressions.isEmpty, expression.operators.count == expression.expressions.count - 1 else {
            throw EvaluatorError.invalidBinarySeriesExpression
        }
        
        // Loop, combining expressions based on precedence
        
        return RValue(rawValue: .int(0))
    }
    
    // MARK: - Postfix Expression
    
    func evaluatePostfixExpression(_ expression: ASTPostfixExpression, stack: Stack) throws -> ValueType {
        let primaryValue = try evaluatePrimaryExpression(expression.primaryExpression, stack: stack)
        
        // TODO: evaluate postfixes if present and apply them
        
        return primaryValue
    }
    
    // MARK: - Primary Expression
    
    func evaluatePrimaryExpression(_ expression: ASTPrimaryExpression, stack: Stack) throws -> ValueType {
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
    
    func evaluateParenthesizedExpression(_ expression: ASTParenthesizedExpression, stack: Stack) throws -> RValue {
        return try evaluateExpression(expression.expression, stack: stack)
    }

    func evaluateIdentifierExpression(_ expression: ASTIdentifierExpression, stack: Stack) throws -> LValue {
        guard let variable = stack.localVariable(named: expression.name) else {
            throw EvaluatorError.unrecognizedIdentifier
        }
        return LValue(variable: variable)
    }
    
    func evaluateIntLiteralExpression(_ expression: ASTIntLiteralExpression) throws -> RValue {
        guard let value = Int(expression.literal) else {
            throw EvaluatorError.invalidIntLiteral
        }
        return RValue(rawValue: .int(value))
    }
    
    func evaluateStringLiteralExpression(_ expression: ASTStringLiteralExpression) -> RValue {
        return RValue(rawValue: .string(expression.literal))
    }
    
}
