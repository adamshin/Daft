//
//  AST.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol ASTNode {
    var description: String { get }
}

protocol ASTStatement: ASTNode { }
protocol ASTElseClause: ASTNode { }
protocol ASTPostfix: ASTNode { }
protocol ASTExpression: ASTNode { }
protocol ASTPrimaryExpression: ASTNode { }

// MARK: - Program

struct ASTProgram: ASTNode {
    let statements: [ASTStatement]
}

// MARK: - Code Block

struct ASTCodeBlock: ASTNode {
    let statements: [ASTStatement]
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
    let condition: ASTExpression
    let codeBlock: ASTCodeBlock
    let elseClause: ASTElseClause?
}

struct ASTElseIfClause: ASTElseClause {
    let ifStatement: ASTIfStatement
}

struct ASTFinalElseClause: ASTElseClause {
    let codeBlock: ASTCodeBlock
}

// MARK: - Expressions

struct ASTBinarySeriesExpression: ASTExpression {
    let expressions: [ASTPostfixExpression]
    let operators: [ASTBinaryOperator]
}

struct ASTBinaryOperator: ASTNode {
    let type: BinaryOperatorType
}

struct ASTPostfixExpression: ASTNode {
    let primaryExpression: ASTPrimaryExpression
    let postfixes: [ASTPostfix]
}

struct ASTArgumentList: ASTPostfix {
    let arguments: [ASTExpression]
}

// MARK: - Primary Expressions

struct ASTParenthesizedExpression: ASTPrimaryExpression {
    let expression: ASTExpression
}

struct ASTIntLiteralExpression: ASTPrimaryExpression {
    let literal: String
}

struct ASTStringLiteralExpression: ASTPrimaryExpression {
    let literal: String
}

struct ASTIdentifierExpression: ASTPrimaryExpression {
    let name: String
}
