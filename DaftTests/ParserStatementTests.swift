//
//  ParserStatementTests.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserStatementTests: XCTestCase {
    
    func testParseStatement() {
        let testCases = [
            ParserTestCase(
                input: "foo;",
                expected: expression(binarySeries(postfix(identifier("foo"))))
            ),
            ParserTestCase(
                input: "var a;",
                expected: variableDeclaration("a", nil)
            ),
            ParserTestCase(
                input: "var b = 0;",
                expected: variableDeclaration("b", binarySeries(postfix(intLiteral("0"))))
            ),
            ParserTestCase(
                input: "if (1) { foo; }",
                expected: ifStatement(
                    binarySeries(postfix(intLiteral("1"))),
                    codeBlock([
                        expression(binarySeries(postfix(identifier("foo"))))
                    ])
                )
            )
        ]
        let errorCases = [
            ParserErrorCase(input: "foo", error: .endOfFile),
            ParserErrorCase(input: "var x y;", error: .unexpectedToken),
            ParserErrorCase(input: "if 1 { }", error: .unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseStatement() }
    }

}
