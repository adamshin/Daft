//
//  EvaluatorDebugOutput.swift
//  Daft
//
//  Created by Adam Shin on 12/24/16.
//  Copyright © 2016 Adam Shin. All rights reserved.
//

import Foundation

class EvaluatorDebugOutput {
    
    let printCallback: (String) -> Void
    
    init(printCallback: @escaping (String) -> Void) {
        self.printCallback = printCallback
    }
    
    func print(_ string: String) {
        printCallback(string)
    }
    
}
