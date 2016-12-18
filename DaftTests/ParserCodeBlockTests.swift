//
//  ParserCodeBlockTests.swift
//  Daft
//
//  Created by Adam Shin on 12/17/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import XCTest
@testable import Daft

class ParserCodeBlockTests: XCTestCase {
    
    func testParseCodeBlock() {
        let testCases = [
            ParserTestCase(
                input: "{ }",
                expected: codeBlock([])
            ),
            ParserTestCase(
                input: "{ foo; bar; }",
                expected: codeBlock([
                    expression(binarySeries(postfix(identifier("foo")))),
                    expression(binarySeries(postfix(identifier("bar"))))
                ])
            ),
        ]
        let errorCases = [
            ParserErrorCase(input: "{", error: ParserError.endOfFile),
            ParserErrorCase(input: "{ foo;", error: ParserError.endOfFile),
            ParserErrorCase(input: "}", error: ParserError.unexpectedToken),
            ParserErrorCase(input: "foo", error: ParserError.unexpectedToken),
        ]
        testParser(testCases: testCases, errorCases: errorCases) { try $0.parseCodeBlock() }
    }
    
}
