//
//  AST+Description.swift
//  Daft
//
//  Created by Adam Shin on 12/11/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

extension Array where Element: ASTNode {
    var description: String {
        return "[\(map { $0.description }.joined(separator: ", "))]"
    }
}

extension BinaryOperatorType: ASTNode {
    var description: String { return rawValue }
}

// MARK: - AST

extension AST {
    var description: String {
        return "AST { statements: [\(statements.map { $0.description }.joined(separator: ", "))]}"
    }
}

extension ASTExpressionStatement {
    var description: String {
        return "ASTExpressionStatement { expression: \(expression.description) }"
    }
}

extension ASTBinarySeriesExpression {
    var description: String {
        return "ASTBinarySeriesExpression { expressions: [\(expressions.map { $0.description }.joined(separator: ", "))], operators: [\(operators.map { $0.description }.joined(separator: ","))] }"
    }
}

extension ASTPostfixExpression {
    var description: String {
        return "ASTPostfixExpression { primaryExpression: \(primaryExpression.description), postfixes: \(postfixes.description) }"
    }
}

extension ASTFunctionArgumentList {
    var description: String {
        return "ASTFunctionArgumentList { arguments: [\(arguments.map { $0.description }.joined(separator: ", "))] }"
    }
}

extension ASTParenthesizedExpression {
    var description: String {
        return "ASTParenthesizedExpression { expression: \(expression.description) }"
    }
}

extension ASTIntLiteralExpression {
    var description: String {
        return "ASTIntLiteralExpression { literal: \(literal) }"
    }
}

extension ASTStringLiteralExpression {
    var description: String {
        return "ASTStringLiteralExpression { literal: \(literal) }"
    }
}

extension ASTIdentifierExpression {
    var description: String {
        return "ASTIdentifierExpression { name: \(name) }"
    }
}
