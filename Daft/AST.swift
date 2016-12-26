//
//  AST.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol ASTStatement { }
protocol ASTElseClause { }
protocol ASTPostfix { }
protocol ASTExpression { }
protocol ASTPrimaryExpression { }

// MARK: - Structure

struct ASTCodeBlock {
    let statements: [ASTStatement]
}

struct ASTConditionClause {
    let expression: ASTExpression
}

// MARK: - Statements

struct ASTExpressionStatement: ASTStatement {
    let expression: ASTExpression
}

struct ASTVariableDeclarationStatement: ASTStatement {
    let name: String
    let expression: ASTExpression?
}

struct ASTIfStatement: ASTStatement {
    let condition: ASTConditionClause
    let codeBlock: ASTCodeBlock
    let elseClause: ASTElseClause?
}

struct ASTElseIfClause: ASTElseClause {
    let ifStatement: ASTIfStatement
}

struct ASTFinalElseClause: ASTElseClause {
    let codeBlock: ASTCodeBlock
}

struct ASTWhileStatement: ASTStatement {
    let condition: ASTConditionClause
    let codeBlock: ASTCodeBlock
}

struct ASTReturnStatement: ASTStatement {
    let expression: ASTExpression
}

// MARK: - Expressions

struct ASTBinarySeriesExpression: ASTExpression {
    let expressions: [ASTPostfixExpression]
    let operators: [ASTBinaryOperator]
}

struct ASTBinaryOperator {
    let type: BinaryOperator
}

struct ASTPostfixExpression {
    let primaryExpression: ASTPrimaryExpression
    let postfixes: [ASTPostfix]
}

struct ASTFunctionCallArgumentList: ASTPostfix {
    let arguments: [ASTExpression]
}

// MARK: - Primary Expressions

struct ASTParenthesizedExpression: ASTPrimaryExpression {
    let expression: ASTExpression
}

struct ASTFunctionExpression: ASTPrimaryExpression {
    let argumentList: ASTArgumentList
    let codeBlock: ASTCodeBlock
}

struct ASTArgumentList {
    let arguments: [ASTIdentifierExpression]
}

struct ASTIntLiteralExpression: ASTPrimaryExpression {
    let literal: String
}

struct ASTStringLiteralExpression: ASTPrimaryExpression {
    let literal: String
}

struct ASTBoolLiteralExpression: ASTPrimaryExpression {
    let value: Bool
}

struct ASTIdentifierExpression: ASTPrimaryExpression {
    let name: String
}
