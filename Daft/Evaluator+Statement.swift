//
//  Evaluator+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateStatement(_ statement: ASTStatement, environment: Environment) throws -> Value? {
        switch statement {
        case let returnStatement as ASTReturnStatement:
            return try evaluateReturnStatement(returnStatement, environment: environment)
            
        case let ifStatement as ASTIfStatement:
            return try evaluateIfStatement(ifStatement, environment: environment)
            
        case let whileStatement as ASTWhileStatement:
            return try evaluateWhileStatement(whileStatement, environment: environment)
            
        case let declarationStatement as ASTVariableDeclarationStatement:
            try evaluateVariableDeclarationStatement(declarationStatement, environment: environment)
            return nil
            
        case let expressionStatement as ASTExpressionStatement:
            try evaluateExpressionStatement(expressionStatement, environment: environment)
            return nil
            
        default:
            throw EvaluatorError.unrecognizedStatement
        }
    }
    
    // MARK: - If
    
    class func evaluateIfStatement(_ statement: ASTIfStatement, environment: Environment) throws -> Value? {
        let condition = try evaluateExpression(statement.condition.expression, environment: environment)
        guard case let .bool(boolValue) = condition else {
            throw EvaluatorError.invalidCondition
        }
        
        if boolValue {
            return try evaluateCodeBlock(statement.codeBlock, environment: environment)
        } else if let elseClause = statement.elseClause {
            return try evaluateElseClause(elseClause, environment: environment)
        }
        return nil
    }
    
    class func evaluateElseClause(_ elseClause: ASTElseClause, environment: Environment) throws -> Value? {
        switch elseClause {
        case let elseIfClause as ASTElseIfClause:
            return try evaluateIfStatement(elseIfClause.ifStatement, environment: environment)
            
        case let finalElseClause as ASTFinalElseClause:
            return try evaluateCodeBlock(finalElseClause.codeBlock, environment: environment)
            
        default:
            throw EvaluatorError.unrecognizedElseClause
        }
    }
    
    // MARK: - While
    
    class func evaluateWhileStatement(_ statement: ASTWhileStatement, environment: Environment) throws -> Value? {
        while true {
            let condition = try evaluateExpression(statement.condition.expression, environment: environment)
            guard case let .bool(boolValue) = condition else {
                throw EvaluatorError.invalidCondition
            }
            
            if boolValue {
                if let returnValue = try evaluateCodeBlock(statement.codeBlock, environment: environment) {
                    return returnValue
                }
            } else {
                break
            }
        }
        return nil
    }
    
    // MARK: - Variable Declaration
    
    class func evaluateVariableDeclarationStatement(_ statement: ASTVariableDeclarationStatement, environment: Environment) throws {
        try environment.addLocalVariable(name: statement.name, value: .void)
        
        let initialValue: Value
        if let expression = statement.expression {
            initialValue = try Evaluator.evaluateExpression(expression, environment: environment)
        } else {
            initialValue = .void
        }
        
        environment.localVariable(named: statement.name)?.value = initialValue
        print("\(statement.name) = \(stringForValue(initialValue))")
    }
    
    // MARK: - Return
    
    class func evaluateReturnStatement(_ statement: ASTReturnStatement, environment: Environment) throws -> Value {
        if let expression = statement.expression {
            return try evaluateExpression(expression, environment: environment)
        } else {
            return .void
        }
    }
    
    // MARK: - Expression
    
    class func evaluateExpressionStatement(_ statement: ASTExpressionStatement, environment: Environment) throws {
        let value = try evaluateExpression(statement.expression, environment: environment)
        print(stringForValue(value))
    }
    
    // MARK: - Helpers

    class func stringForValue(_ value: Value) -> String {
        switch value {
        case .void: return "void"
        case let .int(value): return String(value)
        case let .string(value): return "\"\(value)\""
        case let .bool(value): return String(value)
            
        case let .function(argumentList, _, _):
            let argumentCount = argumentList.arguments.count
            return "function (\(argumentCount) \(argumentCount == 1 ? "argument" : "arguments"))"
        }
    }

}
