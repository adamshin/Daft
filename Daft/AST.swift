//
//  AST.swift
//  Daft
//
//  Created by Adam Shin on 12/10/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

protocol ASTStatement { }
protocol ASTPostfix { }
protocol ASTExpression { }
protocol ASTPrimaryExpression { }

// MARK: - AST

struct AST {
    let statements: [ASTStatement]
}

// MARK: - Statements

struct ASTExpressionStatement: ASTStatement {
    let expression: ASTExpression
}

// MARK: - Expressions

struct ASTBinarySeriesExpression: ASTExpression {
    let expressions: [ASTPostfixExpression]
    let operators: [BinaryOperatorType]
}

struct ASTPostfixExpression {
    let primaryExpression: ASTPrimaryExpression
    let postfixes: [ASTPostfix]
}

struct ASTFunctionArgumentList: ASTPostfix {
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
