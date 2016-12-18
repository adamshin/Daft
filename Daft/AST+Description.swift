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

// MARK: - AST

extension ASTProgram {
    var description: String {
        return "AST { statements: [\(statements.map { $0.description }.joined(separator: ", "))]}"
    }
}

extension ASTCodeBlock {
    var description: String {
        return "ASTCodeBlock { statements: [\(statements.map { $0.description }.joined(separator: ", "))]}"
    }
}

extension ASTConditionClause {
    var description: String {
        return "ASTConditionClause { expression: \(expression.description)}"
    }
}

extension ASTExpressionStatement {
    var description: String {
        return "ASTExpressionStatement { expression: \(expression.description) }"
    }
}

extension ASTVariableDeclarationStatement {
    var description: String {
        return "ASTVariableDeclarationStatement { name: \(name), expression: \(expression?.description ?? "nil") }"
    }
}

extension ASTIfStatement {
    var description: String {
        return "ASTIfStatement { condition: \(condition.description), codeBlock: \(codeBlock.description), elseClause: \(elseClause?.description ?? "nil") }"
    }
}

extension ASTElseIfClause {
    var description: String {
        return "ASTIfStatement { ifStatement: \(ifStatement.description) }"
    }
}

extension ASTFinalElseClause {
    var description: String {
        return "ASTElse { codeBlock: \(codeBlock.description) }"
    }
}

extension ASTWhileStatement {
    var description: String {
        return "ASTWhileStatement { condition: \(condition.description), codeBlock: \(codeBlock.description) }"
    }
}

extension ASTBinarySeriesExpression {
    var description: String {
        return "ASTBinarySeriesExpression { expressions: [\(expressions.map { $0.description }.joined(separator: ", "))], operators: [\(operators.map { $0.description }.joined(separator: ","))] }"
    }
}

extension ASTBinaryOperator {
    var description: String {
        return type.rawValue
    }
}

extension ASTPostfixExpression {
    var description: String {
        return "ASTPostfixExpression { primaryExpression: \(primaryExpression.description), postfixes: \(postfixes.description) }"
    }
}

extension ASTArgumentList {
    var description: String {
        return "ASTArgumentList { arguments: [\(arguments.map { $0.description }.joined(separator: ", "))] }"
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
