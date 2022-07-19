//
//  GestureDirection.swift
//  ShiftManager_SwiftUI
//
//  Created by Hao Yu Yeh on 2022/7/19.
//

import Foundation
import UIKit

enum Direction {
    case up
    case down
    case right
    case left
    case unknown
}

class GestureDirection {
    static let shared = GestureDirection()
    
    func getDragDirection(translation: CGSize) -> Direction {
        let angle = atan2(translation.width, translation.height)
        switch angle {
        case (-Double.pi/4..<Double.pi/4):
            return .down
        case (Double.pi/4..<Double.pi*3/4):
            return .right
        case (Double.pi*3/4...Double.pi), (-Double.pi..<(-Double.pi*3/4)):
            return .up
        case (-Double.pi*3/4..<(-Double.pi/4)):
            return .left
        default:
            return .unknown
        }
    }
}
