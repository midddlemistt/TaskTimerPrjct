//
//  Box.swift
//  TaskTimerProjct
//
//  Created by 123 on 31.01.24.
//

import Foundation


class Box<T> {
    
    typealias Listener = (T) -> ()
    
    //MARK: - Variables
    
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    //MARK: - Inits
    
    init(_ value: T) {
        self.value = value
    }
    
    //MARK: - Functions
    func bind(listener:Listener?) {
        self.listener = listener
    }
    
    func removebinding() {
        self.listener = nil
    }
    
}
