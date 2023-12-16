import Foundation
import SwiftUI

@MainActor
func pointerOnHover(_ inside: Bool) {
    Task(priority: .userInitiated) {
        if inside {
            NSCursor.pointingHand.set()
        } else {
            NSCursor.arrow.set()
        }
    }
}
