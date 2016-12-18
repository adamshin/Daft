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

// MARK: - Expressions

func binarySeries(_ expressions: [ASTPostfixExpression], _ operators: [ASTBinaryOperator]) -> ASTBinarySeriesExpression {
    return ASTBinarySeriesExpression(expressions: expressions, operators: operators)
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

// MARK: - Compound

func single(_ expression: ASTPostfixExpression) -> ASTExpression {
    return binarySeries([expression], [])
}

func singlePrimary(_ primaryExpression: ASTPrimaryExpression) -> ASTExpression {
    let expression = postfix(primaryExpression, [])
    return binarySeries([expression], [])
}
