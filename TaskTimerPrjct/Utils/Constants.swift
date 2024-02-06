//
//  Constants.swift
//  TaskTimerProject
//
//  Created by 123 on 31.01.24.
//

import Foundation
import UIKit

struct Constants {
    
    //MARK:  Variables
    static var hasTopNotch: Bool {
        guard #available(iOS 11, *), let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {return false}
        return window.safeAreaInsets.top >= 44
    }
}
