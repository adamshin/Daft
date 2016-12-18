//
//  ParserTestHelpers.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

// MARK: - Test Cases

struct ParserTestCase {
    let input: String
    let expected: ASTNode
}

func testParserCases(_ testCases: [ParserTestCase], test: (Parser) throws -> ASTNode) {
    testCases.forEach {
        let tokens = try! Lexer(input: LexerStringInput(string: $0.input)).lex()
        let parser = Parser(input: ParserArrayInput(tokens: tokens))
        
        do {
            let result = try test(parser)
            XCTAssertEqual(result.description, $0.expected.description)
        }
        catch let error {
            XCTFail("Parser threw error on valid input: \(error)")
        }
    }
}

// MARK: - AST

func ast(_ statement: ASTStatement) -> AST {
    return AST(statements: [statement])
}

func ast(_ statements: [ASTStatement]) -> AST {
    return AST(statements: statements)
}

// MARK: - Statements

func expression(_ expression: ASTExpression) -> ASTExpressionStatement {
    return ASTExpressionStatement(expression: expression)
}

func variableDeclaration(_ name: String, _ expression: ASTExpression?) -> ASTVariableDeclarationStatement {
    return ASTVariableDeclarationStatement(name: name, expression: expression)
}

// MARK: - Expressions

func binarySeries(_ expression: ASTPostfixExpression) -> ASTExpression {
    return ASTBinarySeriesExpression(expressions: [expression], operators: [])
}

func binarySeries(_ expressions: [ASTPostfixExpression], _ operators: [ASTBinaryOperator]) -> ASTBinarySeriesExpression {
    return ASTBinarySeriesExpression(expressions: expressions, operators: operators)
}

func binaryOperator(_ type: BinaryOperatorType) -> ASTBinaryOperator {
    return ASTBinaryOperator(type: type)
}

func postfix(_ primaryExpression: ASTPrimaryExpression) -> ASTPostfixExpression {
    return ASTPostfixExpression(primaryExpression: primaryExpression, postfixes: [])
}

func postfix(_ primaryExpression: ASTPrimaryExpression, _ postfixes: [ASTPostfix]) -> ASTPostfixExpression {
    return ASTPostfixExpression(primaryExpression: primaryExpression, postfixes: postfixes)
}

func argumentList(_ arguments: [ASTExpression]) -> ASTArgumentList {
    return ASTArgumentList(arguments: arguments)
}

// MARK: - Primary expressions

func parenthesized(_ expression: ASTExpression) -> ASTParenthesizedExpression {
    return ASTParenthesizedExpression(expression: expression)
}

func intLiteral(_ literal: String) -> ASTIntLiteralExpression {
    return ASTIntLiteralExpression(literal: literal)
}

func stringLiteral(_ literal: String) -> ASTStringLiteralExpression {
    return ASTStringLiteralExpression(literal: literal)
}

func identifier(_ name: String) -> ASTIdentifierExpression {
    return ASTIdentifierExpression(name: name)
}
