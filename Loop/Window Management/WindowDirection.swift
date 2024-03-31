//
//  WindowDirection.swift
//  Loop
//
//  Created by Kai Azim on 2023-06-14.
//

import SwiftUI
import Defaults

// Enum that stores all possible resizing options
// swiftlint:disable:next type_body_length
enum WindowDirection: String, CaseIterable, Identifiable, Codable {
    var id: Self { self }

    case noAction = "NoAction"

    // General
    case maximize = "Maximize"
    case almostMaximize = "AlmostMaximize"
    case fullscreen = "Fullscreen"
    case undo = "Undo"
    case initialFrame = "InitialFrame"
    case hide = "Hide"
    case minimize = "Minimize"
    case macOSCenter = "macOSCenter"
    case center = "Center"

    // Halves
    case topHalf = "TopHalf"
    case rightHalf = "RightHalf"
    case bottomHalf = "BottomHalf"
    case leftHalf = "LeftHalf"

    // Quarters
    case topLeftQuarter = "TopLeftQuarter"
    case topRightQuarter = "TopRightQuarter"
    case bottomRightQuarter = "BottomRightQuarter"
    case bottomLeftQuarter = "BottomLeftQuarter"

    // Horizontal Thirds
    case rightThird = "RightThird"
    case rightTwoThirds = "RightTwoThirds"
    case horizontalCenterThird = "HorizontalCenterThird"
    case leftThird = "LeftThird"
    case leftTwoThirds = "LeftTwoThirds"

    // Vertical Thirds
    case topThird = "TopThird"
    case topTwoThirds = "TopTwoThirds"
    case verticalCenterThird = "VerticalCenterThird"
    case bottomThird = "BottomThird"
    case bottomTwoThirds = "BottomTwoThirds"

    // Screens
    case nextScreen = "NextScreen"
    case previousScreen = "PreviousScreen"

    // Size
    case larger = "Larger"
    case smaller = "Smaller"

    // Shrink
    case shrinkTop = "ShrinkTop"
    case shrinkBottom = "ShrinkBottom"
    case shrinkRight = "ShrinkRight"
    case shrinkLeft = "ShrinkLeft"

    // Grow
    case growTop = "GrowTop"
    case growBottom = "GrowBottom"
    case growRight = "GrowRight"
    case growLeft = "GrowLeft"

    case custom = "Custom"
    case cycle = "Cycle"

    // These are used in the menubar resize submenu & keybind configuration
    static var general: [WindowDirection] {
        [.fullscreen, .maximize, .almostMaximize, .center, .macOSCenter, .minimize, .hide]
    }
    static var halves: [WindowDirection] {
        [.topHalf, .bottomHalf, .leftHalf, .rightHalf]
    }
    static var quarters: [WindowDirection] {
        [.topLeftQuarter, .topRightQuarter, .bottomLeftQuarter, .bottomRightQuarter]
    }
    static var horizontalThirds: [WindowDirection] {
        [.rightThird, .rightTwoThirds, .horizontalCenterThird, .leftTwoThirds, .leftThird]
    }
    static var verticalThirds: [WindowDirection] {
        [.topThird, .topTwoThirds, .verticalCenterThird, .bottomTwoThirds, .bottomThird]
    }
    static var screenSwitching: [WindowDirection] {
        [.nextScreen, .previousScreen]
    }
    static var sizeAdjustment: [WindowDirection] {
        [.larger, .smaller]
    }
    static var shrink: [WindowDirection] {
        [.shrinkTop, .shrinkBottom, .shrinkRight, .shrinkLeft]
    }
    static var grow: [WindowDirection] {
        [.growTop, .growBottom, .growRight, .growLeft]
    }
    static var more: [WindowDirection] {
        [.initialFrame, .undo, .custom, .cycle]
    }

    var willChangeScreen: Bool {
        WindowDirection.screenSwitching.contains(self)
    }

    var willAdjustSize: Bool {
        WindowDirection.sizeAdjustment.contains(self)
    }

    var willShrink: Bool {
        WindowDirection.shrink.contains(self)
    }

    var willGrow: Bool {
        WindowDirection.grow.contains(self)
    }

    // Used in the settings window to loop over the possible combinations
    var nextPreviewDirection: WindowDirection {
        switch self {
        case .topHalf:              .topRightQuarter
        case .topRightQuarter:      .rightHalf
        case .rightHalf:            .bottomRightQuarter
        case .bottomRightQuarter:   .bottomHalf
        case .bottomHalf:           .bottomLeftQuarter
        case .bottomLeftQuarter:    .leftHalf
        case .leftHalf:             .topLeftQuarter
        case .topLeftQuarter:       .maximize
        default:                    .topHalf
        }
    }

    var radialMenuAngle: Double? {
        switch self {
        case .topHalf:              0
        case .topRightQuarter:      45
        case .rightHalf:            90
        case .bottomRightQuarter:   135
        case .bottomHalf:           180
        case .bottomLeftQuarter:    225
        case .leftHalf:             270
        case .topLeftQuarter:       315
        case .maximize:             0
        default:                    nil
        }
    }

    var hasRadialMenuAngle: Bool {
        let noAngleActions: [WindowDirection] = [
            .noAction,
            .maximize,
            .center,
            .macOSCenter,
            .almostMaximize,
            .fullscreen,
            .minimize,
            .hide,
            .initialFrame,
            .undo,
            .cycle
        ]

        if noAngleActions.contains(self) ||
           self.willChangeScreen ||
           self.willAdjustSize ||
           self.willShrink ||
           self.willGrow {
            return false
        }
        return true
    }

    var shouldFillRadialMenu: Bool {
        let fillActions: [WindowDirection] = [
            .maximize,
            .center,
            .macOSCenter,
            .almostMaximize,
            .fullscreen
        ]

        return fillActions.contains(self)
    }

    /*
    var name: String {
        var result = ""
        for (idx, char) in self.rawValue.enumerated() {
            if idx > 0,
               char.isUppercase,
               let next = self.rawValue.index(
                self.rawValue.startIndex,
                offsetBy: idx + 1,
                limitedBy: self.rawValue.endIndex
               ) {
                if self.rawValue[next].isLowercase {
                    result.append(" ")
                }
            }
            result.append(char)
        }

        return result
    }
     */

    var moreInformation: String? {
        var result: String?

        if self == .macOSCenter {
            result = .init(localized: .init("Window Direction/More Information: macOS Center", defaultValue: """
\(self.name) places windows slightly above the absolute center, which can be found more ergnonomic.
"""))
        }

        return result
    }

    var icon: Image? {
        switch self {
        case .maximize:                 Image(systemName: "rectangle.inset.filled")
        case .almostMaximize:           Image(systemName: "rectangle.center.inset.filled")
        case .fullscreen:               Image(systemName: "rectangle.fill")
        case .undo:                     Image("custom.arrow.uturn.backward.rectangle")
        case .initialFrame:             Image("custom.backward.end.alt.fill.2.rectangle")
        case .hide:                     Image("custom.rectangle.slash")
        case .minimize:                 Image("custom.arrow.down.right.and.arrow.up.left.rectangle")
        case .center:                   Image("custom.rectangle.center.inset.inset.filled")
        case .macOSCenter:              Image("custom.rectangle.center.inset.inset.filled")

        case .topHalf:                  Image(systemName: "rectangle.tophalf.inset.filled")
        case .rightHalf:                Image(systemName: "rectangle.righthalf.inset.filled")
        case .bottomHalf:               Image(systemName: "rectangle.bottomhalf.inset.filled")
        case .leftHalf:                 Image(systemName: "rectangle.lefthalf.inset.filled")

        case .topLeftQuarter:           Image(systemName: "rectangle.inset.topleft.filled")
        case .topRightQuarter:          Image(systemName: "rectangle.inset.topright.filled")
        case .bottomRightQuarter:       Image(systemName: "rectangle.inset.bottomright.filled")
        case .bottomLeftQuarter:        Image(systemName: "rectangle.inset.bottomleft.filled")

        case .rightThird:               Image(systemName: "rectangle.rightthird.inset.filled")
        case .rightTwoThirds:           Image("custom.rectangle.righttwothirds.inset.filled")
        case .horizontalCenterThird:    Image("custom.rectangle.horizontalcenterthird.inset.filled")
        case .leftThird:                Image(systemName: "rectangle.leftthird.inset.filled")
        case .leftTwoThirds:            Image("custom.rectangle.lefttwothirds.inset.filled")

        case .topThird:                 Image(systemName: "rectangle.topthird.inset.filled")
        case .topTwoThirds:             Image("custom.rectangle.toptwothirds.inset.filled")
        case .verticalCenterThird:      Image("custom.rectangle.verticalcenterthird.inset.filled")
        case .bottomThird:              Image(systemName: "rectangle.bottomthird.inset.filled")
        case .bottomTwoThirds:          Image("custom.rectangle.bottomtwothirds.inset.filled")

        case .nextScreen:               Image("custom.forward.rectangle")
        case .previousScreen:           Image("custom.backward.rectangle")

        case .larger:                   Image(systemName: "plus.rectangle")
        case .smaller:                  Image(systemName: "minus.rectangle")

        case .shrinkTop:                Image("custom.arrow.down.shrink.rectangle")
        case .shrinkBottom:             Image("custom.arrow.up.shrink.rectangle")
        case .shrinkRight:              Image("custom.arrow.left.shrink.rectangle")
        case .shrinkLeft:               Image("custom.arrow.right.shrink.rectangle")

        case .growTop:                  Image("custom.arrow.up.grow.rectangle")
        case .growBottom:               Image("custom.arrow.down.grow.rectangle")
        case .growRight:                Image("custom.arrow.right.grow.rectangle")
        case .growLeft:                 Image("custom.arrow.left.grow.rectangle")

        case .custom:                   Image(systemName: "rectangle.dashed")
        case .cycle:                    Image("custom.arrow.2.squarepath.rectangle")
        default:                        nil
        }
    }
    
    var name: String {
        switch self {
        case .noAction:
                .init(localized: .init("Window Direction/Name: No Action", defaultValue: "No Action"))
        case .maximize:
                .init(localized: .init("Window Direction/Name: Maximize", defaultValue: "Maximize"))
        case .almostMaximize:
                .init(localized: .init("Window Direction/Name: Almost Maximize", defaultValue: "Almost Maximize"))
        case .fullscreen:
                .init(localized: .init("Window Direction/Name: Fullscreen", defaultValue: "Fullscreen"))
        case .undo:
                .init(localized: .init("Window Direction/Name: Undo", defaultValue: "Undo"))
        case .initialFrame:
                .init(localized: .init("Window Direction/Name: Intiial Frame", defaultValue: "Intiial Frame"))
        case .hide:
                .init(localized: .init("Window Direction/Name: Hide", defaultValue: "Hide"))
        case .minimize:
                .init(localized: .init("Window Direction/Name: Minimize", defaultValue: "Minimize"))
        case .macOSCenter:
                .init(localized: .init("Window Direction/Name: macOS Center", defaultValue: "macOS Center"))
        case .center:
                .init(localized: .init("Window Direction/Name: Center", defaultValue: "Center"))
        case .topHalf:
                .init(localized: .init("Window Direction/Name: Top Half", defaultValue: "Top Half"))
        case .rightHalf:
                .init(localized: .init("Window Direction/Name: Right Half", defaultValue: "Right Half"))
        case .bottomHalf:
                .init(localized: .init("Window Direction/Name: Bottom Half", defaultValue: "Bottom Half"))
        case .leftHalf:
                .init(localized: .init("Window Direction/Name: Left Hald", defaultValue: "Left Hald"))
        case .topLeftQuarter:
                .init(localized: .init("Window Direction/Name: Top Left Quarter", defaultValue: "Top Left Quarter"))
        case .topRightQuarter:
                .init(localized: .init("Window Direction/Name: Top Right Quarter", defaultValue: "Top Right Quarter"))
        case .bottomRightQuarter:
                .init(localized: .init("Window Direction/Name: Bottom Right Quarter", defaultValue: "Bottom Right Quarter"))
        case .bottomLeftQuarter:
                .init(localized: .init("Window Direction/Name: Bottom Left Quarter", defaultValue: "Bottom Left Quarter"))
        case .rightThird:
                .init(localized: .init("Window Direction/Name: Right Third", defaultValue: "Right Third"))
        case .rightTwoThirds:
                .init(localized: .init("Window Direction/Name: Right Two Thirds", defaultValue: "Right Two Thirds"))
        case .horizontalCenterThird:
                .init(localized: .init("Window Direction/Name: Horizontal Center Third", defaultValue: "Horizontal Center Third"))
        case .leftThird:
                .init(localized: .init("Window Direction/Name: Left Third", defaultValue: "Left Third"))
        case .leftTwoThirds:
                .init(localized: .init("Window Direction/Name: Left Two Thirds", defaultValue: "Left Two Thirds"))
        case .topThird:
                .init(localized: .init("Window Direction/Name: Top Third", defaultValue: "Top Third"))
        case .topTwoThirds:
                .init(localized: .init("Window Direction/Name: Top Two Thirds", defaultValue: "Top Two Thirds"))
        case .verticalCenterThird:
                .init(localized: .init("Window Direction/Name: Vertical Center Third", defaultValue: "Vertical Center Third"))
        case .bottomThird:
                .init(localized: .init("Window Direction/Name: Bottom THird", defaultValue: "Bottom THird"))
        case .bottomTwoThirds:
                .init(localized: .init("Window Direction/Name: Bottom Two Thirds", defaultValue: "Bottom Two Thirds"))
        case .nextScreen:
                .init(localized: .init("Window Direction/Name: Next Screen", defaultValue: "Next Screen"))
        case .previousScreen:
                .init(localized: .init("Window Direction/Name: Previous Screen", defaultValue: "Previous Screen"))
        case .larger:
                .init(localized: .init("Window Direction/Name: Larger", defaultValue: "Larger"))
        case .smaller:
                .init(localized: .init("Window Direction/Name: Smaller", defaultValue: "Smaller"))
        case .shrinkTop:
                .init(localized: .init("Window Direction/Name: Shrink Top", defaultValue: "Shrink Top"))
        case .shrinkBottom:
                .init(localized: .init("Window Direction/Name: Shrink Bottom", defaultValue: "Shrink Bottom"))
        case .shrinkRight:
                .init(localized: .init("Window Direction/Name: Shrink Right", defaultValue: "Shrink Right"))
        case .shrinkLeft:
                .init(localized: .init("Window Direction/Name: Shrink Left", defaultValue: "Shrink Left"))
        case .growTop:
                .init(localized: .init("Window Direction/Name: Grow Top", defaultValue: "Grow Top"))
        case .growBottom:
                .init(localized: .init("Window Direction/Name: Grow Bottom", defaultValue: "Grow Bottom"))
        case .growRight:
                .init(localized: .init("Window Direction/Name: Grow Right", defaultValue: "Grow Right"))
        case .growLeft:
                .init(localized: .init("Window Direction/Name: Grow Left", defaultValue: "Grow Left"))
        case .custom:
                .init(localized: .init("Window Direction/Name: Custom", defaultValue: "Custom"))
        case .cycle:
                .init(localized: .init("Window Direction/Name: Cycle", defaultValue: "Cycle"))
        }
    }

    var radialMenuImage: Image? {
        switch self {
        case .hide:                     Image("custom.rectangle.slash")
        case .minimize:                 Image("custom.arrow.down.right.and.arrow.up.left.rectangle")
        default:                        nil
        }
    }

    static func processSnap(
        mouseLocation: CGPoint,
        currentDirection: WindowDirection,
        screenFrame: CGRect,
        ignoredFrame: CGRect
    ) -> WindowDirection {
        var newDirection: WindowDirection = .noAction

        if mouseLocation.x < ignoredFrame.minX {
            newDirection = WindowDirection.processLeftSnap(mouseLocation, screenFrame)
        } else if mouseLocation.x > ignoredFrame.maxX {
            newDirection = WindowDirection.processRightSnap(mouseLocation, screenFrame)
        } else if mouseLocation.y < ignoredFrame.minY {
            newDirection = WindowDirection.processTopSnap(mouseLocation, screenFrame)
        } else if mouseLocation.y > ignoredFrame.maxY {
            newDirection = WindowDirection.processBottomSnap(mouseLocation, screenFrame, currentDirection)
        }

        return newDirection
    }

    static func processLeftSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect
    ) -> WindowDirection {
        let mouseY = mouseLocation.y
        let maxY = screenFrame.maxY
        let height = screenFrame.height

        if mouseY < maxY - (height  * 7/8) {
            return .topLeftQuarter
        } else if mouseY > maxY - (height  * 1/8) {
            return .bottomLeftQuarter
        } else {
            return .leftHalf
        }
    }

    static func processRightSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect
    ) -> WindowDirection {
        let mouseY = mouseLocation.y
        let maxY = screenFrame.maxY
        let height = screenFrame.height

        if mouseY < maxY - (height  * 7/8) {
            return .topRightQuarter
        } else if mouseY > maxY - (height  * 1/8) {
            return .bottomRightQuarter
        } else {
            return .rightHalf
        }
    }

    static func processTopSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect
    ) -> WindowDirection {
        let mouseX = mouseLocation.x
        let maxX = screenFrame.maxX
        let width = screenFrame.width

        if mouseX < maxX - (width * 4/5) || mouseX > maxX - (width * 1/5) {
            return .topHalf
        } else {
            return .maximize
        }
    }

    static func processBottomSnap(
        _ mouseLocation: CGPoint,
        _ screenFrame: CGRect,
        _ currentDirection: WindowDirection
    ) -> WindowDirection {
        var newDirection: WindowDirection

        let mouseX = mouseLocation.x
        let maxX = screenFrame.maxX
        let width = screenFrame.width

        if mouseX < maxX - (width * 2/3) {
            newDirection = .leftThird
        } else if mouseX > maxX - (width * 1/3) {
            newDirection = .rightThird
        } else {
            // mouse is within 1/3 and 2/3 of the screen's width
            newDirection = .bottomHalf

            if currentDirection == .leftThird || currentDirection == .leftTwoThirds {
                newDirection = .leftTwoThirds
            } else if currentDirection == .rightThird || currentDirection == .rightTwoThirds {
                newDirection = .rightTwoThirds
            }
        }

        return newDirection
    }

    var frameMultiplyValues: CGRect? {
        switch self {
        case .maximize:                 CGRect(x: 0, y: 0, width: 1.0, height: 1.0)
        case .almostMaximize:           CGRect(x: 0.5/10.0, y: 0.5/10.0, width: 9.0/10.0, height: 9.0/10.0)
        case .fullscreen:               CGRect(x: 0, y: 0, width: 1.0, height: 1.0)

        // Halves
        case .topHalf:                  CGRect(x: 0, y: 0, width: 1.0, height: 1.0/2.0)
        case .rightHalf:                CGRect(x: 1.0/2.0, y: 0, width: 1.0/2.0, height: 1.0)
        case .bottomHalf:               CGRect(x: 0, y: 1.0/2.0, width: 1.0, height: 1.0/2.0)
        case .leftHalf:                 CGRect(x: 0, y: 0, width: 1.0/2.0, height: 1.0)

        // Quarters
        case .topLeftQuarter:           CGRect(x: 0, y: 0, width: 1.0/2.0, height: 1.0/2.0)
        case .topRightQuarter:          CGRect(x: 1.0/2.0, y: 0, width: 1.0/2.0, height: 1.0/2.0)
        case .bottomRightQuarter:       CGRect(x: 1.0/2.0, y: 1.0/2.0, width: 1.0/2.0, height: 1.0/2.0)
        case .bottomLeftQuarter:        CGRect(x: 0, y: 1.0/2.0, width: 1.0/2.0, height: 1.0/2.0)

        // Thirds (Horizontal)
        case .rightThird:               CGRect(x: 2.0/3.0, y: 0, width: 1.0/3.0, height: 1.0)
        case .rightTwoThirds:           CGRect(x: 1.0/3.0, y: 0, width: 2.0/3.0, height: 1.0)
        case .horizontalCenterThird:    CGRect(x: 1.0/3.0, y: 0, width: 1.0/3.0, height: 1.0)
        case .leftThird:                CGRect(x: 0, y: 0, width: 1.0/3.0, height: 1.0)
        case .leftTwoThirds:            CGRect(x: 0, y: 0, width: 2.0/3.0, height: 1.0)

        // Thirds (Vertical)
        case .topThird:                 CGRect(x: 0, y: 0, width: 1.0, height: 1.0/3.0)
        case .topTwoThirds:             CGRect(x: 0, y: 0, width: 1.0, height: 2.0/3.0)
        case .verticalCenterThird:      CGRect(x: 0, y: 1.0/3.0, width: 1.0, height: 1.0/3.0)
        case .bottomThird:              CGRect(x: 0, y: 2.0/3.0, width: 1.0, height: 1.0/3.0)
        case .bottomTwoThirds:          CGRect(x: 0, y: 1.0/3.0, width: 1.0, height: 2.0/3.0)
        default:                        nil
        }
    }
}
