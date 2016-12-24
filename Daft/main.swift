//
//  main.swift
//  Daft
//
//  Created by Adam Shin on 12/7/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

func repl() {
    print("Daft")
    
    let lexerInput = LexerLiveInput() {
        print("  > ", terminator: "")
        return readLine() ?? ""
    }
    let lexer = Lexer(input: lexerInput)
    
    let parserInput = ParserLexerInput(lexer: lexer)
    let parser = Parser(input: parserInput)
    
    let evaluatorInput = EvaluatorParserInput(parser: parser)
    let debugOutput = EvaluatorDebugOutput() {
        print($0)
    }
    let evaluator = Evaluator(input: evaluatorInput, debugOutput: debugOutput)
    
    do {
        try evaluator.evaluate()
    }
    catch let error {
        print("Error evaluating input: \(error)")
    }
}

repl()
