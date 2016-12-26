//
//  Evaluator+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateStatement(_ statement: ASTStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue? {
        switch statement {
        case let returnStatement as ASTReturnStatement:
            return try evaluateReturnStatement(returnStatement, environment: environment, debugOutput: debugOutput)
            
        case let ifStatement as ASTIfStatement:
            return try evaluateIfStatement(ifStatement, environment: environment, debugOutput: debugOutput)
            
        case let whileStatement as ASTWhileStatement:
            return try evaluateWhileStatement(whileStatement, environment: environment, debugOutput: debugOutput)
            
        case let declarationStatement as ASTVariableDeclarationStatement:
            try evaluateVariableDeclarationStatement(declarationStatement, environment: environment, debugOutput: debugOutput)
            return nil
            
        case let expressionStatement as ASTExpressionStatement:
            try evaluateExpressionStatement(expressionStatement, environment: environment, debugOutput: debugOutput)
            return nil
            
        default:
            throw EvaluatorError.unrecognizedStatement
        }
    }
    
    // MARK: - If
    
    class func evaluateIfStatement(_ statement: ASTIfStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue? {
        let condition = try evaluateExpression(statement.condition.expression, environment: environment)
        guard case let .bool(boolValue) = condition else {
            throw EvaluatorError.invalidCondition
        }
        
        if boolValue {
            return try evaluateCodeBlock(statement.codeBlock, environment: environment, debugOutput: debugOutput)
        } else if let elseClause = statement.elseClause {
            return try evaluateElseClause(elseClause, environment: environment, debugOutput: debugOutput)
        }
        return nil
    }
    
    class func evaluateElseClause(_ elseClause: ASTElseClause, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue? {
        switch elseClause {
        case let elseIfClause as ASTElseIfClause:
            return try evaluateIfStatement(elseIfClause.ifStatement, environment: environment, debugOutput: debugOutput)
            
        case let finalElseClause as ASTFinalElseClause:
            return try evaluateCodeBlock(finalElseClause.codeBlock, environment: environment, debugOutput: debugOutput)
            
        default:
            throw EvaluatorError.unrecognizedElseClause
        }
    }
    
    // MARK: - While
    
    class func evaluateWhileStatement(_ statement: ASTWhileStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue? {
        while true {
            let condition = try evaluateExpression(statement.condition.expression, environment: environment)
            guard case let .bool(boolValue) = condition else {
                throw EvaluatorError.invalidCondition
            }
            
            if boolValue {
                if let returnValue = try evaluateCodeBlock(statement.codeBlock, environment: environment, debugOutput: debugOutput) {
                    return returnValue
                }
            } else {
                break
            }
        }
        return nil
    }
    
    // MARK: - Variable Declaration
    
    class func evaluateVariableDeclarationStatement(_ statement: ASTVariableDeclarationStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        let initialValue: ObjectValue
        if let expression = statement.expression {
            initialValue = try Evaluator.evaluateExpression(expression, environment: environment)
        } else {
            initialValue = .void
        }
        
        try environment.addLocalVariable(name: statement.name, value: initialValue)
        debugOutput.print("\(statement.name) = \(stringForObjectValue(initialValue))")
    }
    
    // MARK: - Return
    
    class func evaluateReturnStatement(_ statement: ASTReturnStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws -> ObjectValue {
        return try evaluateExpression(statement.expression, environment: environment)
    }
    
    // MARK: - Expression
    
    class func evaluateExpressionStatement(_ statement: ASTExpressionStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        let value = try evaluateExpression(statement.expression, environment: environment)
        debugOutput.print(stringForObjectValue(value))
    }
    
    // MARK: - Helpers

    class func stringForObjectValue(_ value: ObjectValue) -> String {
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
