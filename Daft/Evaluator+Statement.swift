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
        let result = try Evaluator.evaluateExpression(statement.expression, stack: stack)
        debugOutput(String(describing: result))
    }
    
    func evaluateVariableDeclarationStatement(_ statement: ASTVariableDeclarationStatement) throws {
        debugOutput("TODO: Implement variable declaration evaluation")
    }
    
}
