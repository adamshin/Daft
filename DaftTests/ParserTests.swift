//
//  ParserTests.swift
//  Daft
//
//  Created by Adam Shin on 12/11/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

// MARK: - Test Cases

private let testCases: [(input: [Token], expected: AST)] = [
    (
        input: [
            .identifier("foo"),
            .binaryOperator(.addition),
            .intLiteral("42")
        ],
        expected: AST(
            statements: [
                ASTExpressionStatement(
                    expression: ASTBinarySeriesExpression(
                        expressions: [
                            ASTIdentifierExpression(name: "foo"),
                            ASTIntLiteralExpression(literal: "42")
                        ],
                        operators: [
                            .addition
                        ]
                    )
                )
            ]
        )
    )
]

class ParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
//    func testParser() {
//        testCases.forEach { testCase in
//            let tokens = testCase.input
//            let parser = Parser(input: ParserArrayInput(tokens: []))
//            let ast = try! parser.parse()
//        }
//    }
    
}
