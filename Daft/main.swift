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
    
    while true {
        print("> ", terminator: "")
        
        let input = readLine() ?? ""
        let lexer = Lexer(input: LexerStringInput(string: input))
        
        do {
            while let token = try lexer.nextToken() {
                print(token)
            }
        } catch let error as LexerError {
            print("Error lexing input: \(error)")
        } catch {
            print("Unexpected error.")
        }
    }
}

repl()
