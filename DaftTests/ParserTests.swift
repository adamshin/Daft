//
//  ParserTests.swift
//  Daft
//
//  Created by Adam Shin on 12/11/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserTests: XCTestCase {
    
    func testParseAST() {
        let testCases = [
            ParserTestCase(
                input: "foo + 42;",
                expected: ast(
                    expression(binarySeries([
                        postfix(identifier("foo")),
                        postfix(intLiteral("42")),
                    ], [
                        binaryOperator(.addition)
                    ]))
                )
            ),
            ParserTestCase(
                input: "var foo = bar(5);",
                expected: ast(
                    variableDeclaration(
                        "foo",
                        binarySeries(postfix(
                            identifier("bar"), [
                                argumentList([
                                    binarySeries(postfix(intLiteral("5")))
                                ])
                            ]
                        ))
                    )
                )
            ),
            ParserTestCase(
                input: "1 + (2 + 3) - 4;",
                expected: ast(
                    expression(
                        binarySeries([
                            postfix(intLiteral("1")),
                            postfix(parenthesized(
                                binarySeries([
                                    postfix(intLiteral("2")),
                                    postfix(intLiteral("3")),
                                ], [
                                    binaryOperator(.addition)
                                ])
                            )),
                            postfix(intLiteral("4")),
                        ], [
                            binaryOperator(.addition),
                            binaryOperator(.subtraction),
                        ])
                    )
                )
            )
        ]
        testParserCases(testCases) { try $0.parseAST() }
    }
    
}
