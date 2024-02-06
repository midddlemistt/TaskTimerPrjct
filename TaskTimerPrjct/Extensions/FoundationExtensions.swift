//
//  FoundationExtensions.swift
//  TaskTimerProject
//
//  Created by 123 on 31.01.24.
//

import Foundation
import UIKit

extension Int{
    func appendZeros() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
    
    func degreeToRadians() -> CGFloat {
       return  (CGFloat(self) * .pi) / 180
    }
}
