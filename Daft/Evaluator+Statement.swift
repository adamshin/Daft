//
//  Evaluator+Statement.swift
//  Daft
//
//  Created by Adam Shin on 12/23/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Evaluator {
    
    func evaluateStatement(_ statement: ASTStatement) throws {
        switch statement {
        case let expressionStatement as ASTExpressionStatement:
            try evaluateExpressionStatement(expressionStatement)
            
        case let declarationStatement as ASTVariableDeclarationStatement:
            try evaluateVariableDeclarationStatement(declarationStatement)
            
        default:
            throw EvaluatorError.unrecognizedStatement
        }
    }
    
    func evaluateExpressionStatement(_ statement: ASTExpressionStatement) throws {
        let value = try Evaluator.evaluateExpression(statement.expression, stack: stack)
        debugOutput(stringForObjectValue(value.value))
    }
    
    func evaluateVariableDeclarationStatement(_ statement: ASTVariableDeclarationStatement) throws {
        let initialValue: ObjectValue
        if let expression = statement.expression {
            initialValue = try Evaluator.evaluateExpression(expression, stack: stack).value
        } else {
            initialValue = .void
        }
        
        try stack.addLocalVariable(name: statement.name, value: initialValue)
        debugOutput("\(statement.name) = \(stringForObjectValue(initialValue))")
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
