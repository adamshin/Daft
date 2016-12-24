//
//  Evaluator+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    class func evaluateStatement(_ statement: ASTStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        switch statement {
        case let ifStatement as ASTIfStatement:
            try evaluateIfStatement(ifStatement, environment: environment, debugOutput: debugOutput)
            
        // TODO: While statements
            
        case let declarationStatement as ASTVariableDeclarationStatement:
            try evaluateVariableDeclarationStatement(declarationStatement, environment: environment, debugOutput: debugOutput)
            
        case let expressionStatement as ASTExpressionStatement:
            try evaluateExpressionStatement(expressionStatement, environment: environment, debugOutput: debugOutput)
            
        default:
            throw EvaluatorError.unrecognizedStatement
        }
    }
    
    // MARK: - If
    
    class func evaluateIfStatement(_ statement: ASTIfStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        let condition = try evaluateExpression(statement.condition.expression, environment: environment)
        guard case let .bool(boolValue) = condition else {
            throw EvaluatorError.invalidCondition
        }
        
        if boolValue {
            try evaluateCodeBlock(statement.codeBlock, environment: environment, debugOutput: debugOutput)
        } else if let elseClause = statement.elseClause {
            try evaluateElseClause(elseClause, environment: environment, debugOutput: debugOutput)
        }
    }
    
    class func evaluateElseClause(_ elseClause: ASTElseClause, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        switch elseClause {
        case let elseIfClause as ASTElseIfClause:
            try evaluateIfStatement(elseIfClause.ifStatement, environment: environment, debugOutput: debugOutput)
            
        case let finalElseClause as ASTFinalElseClause:
            try evaluateCodeBlock(finalElseClause.codeBlock, environment: environment, debugOutput: debugOutput)
            
        default:
            throw EvaluatorError.unrecognizedElseClause
        }
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
    
    // MARK: - Expression
    
    class func evaluateExpressionStatement(_ statement: ASTExpressionStatement, environment: Environment, debugOutput: EvaluatorDebugOutput) throws {
        let value = try evaluateExpression(statement.expression, environment: environment)
        debugOutput.print(stringForObjectValue(value))
    }
    
}

private func stringForObjectValue(_ value: ObjectValue) -> String {
    switch value {
    case .void: return "void"
    case let .int(value): return String(value)
    case let .string(value): return "\"\(value)\""
    case let .bool(value): return String(value)
    }
}
