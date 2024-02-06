//
//  Task.swift
//  TaskTimerProjct
//
//  Created by 123 on 31.01.24.
//

import Foundation

struct TaskType {
    var symbolName: String
    var typeName: String
}

struct Task {
    var taskName: String
    var taskDescription: String
    var seconds: Int
    var taskType: TaskType
    
    var timeStamp : Double
}

enum CountdownState {
    case suspended
    case running
    case paused
}
