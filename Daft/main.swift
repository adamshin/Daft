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
    
    let lexerInput = LexerFileInput(fileName: "Daft/input.txt")
    let lexer = Lexer(input: lexerInput)
    
    let parserInput = ParserLexerInput(lexer: lexer)
    let parser = Parser(input: parserInput)
    
    let evaluatorInput = EvaluatorParserInput(parser: parser)
    let evaluator = Evaluator(input: evaluatorInput)
    
    do {
        try evaluator.evaluate()
    }
    catch let error {
        print("Error evaluating input: \(error)")
    }
}

repl()
