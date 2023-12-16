import SwiftUI

@MainActor
func moveWindowToFront(_ window: NSWindow) {
    Task(priority: .userInitiated) {
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }
}

func getCurrentScreenWithMouseCursor() -> NSScreen? {
    let currentMousePoint = NSEvent.mouseLocation
    for screen in NSScreen.screens {
        if screen.frame.contains(currentMousePoint) {
            return screen
        }
    }
    return nil
}

func getCurrentScreenCenterNsPoint(_ window: NSWindow) -> NSPoint {
    guard let visibleFrame = getCurrentScreenWithMouseCursor()?.visibleFrame else {
        return NSPoint(x: 0, y: 0)
    }
    let pointX = (visibleFrame.width - window.frame.width) / 2
    let pointY = (visibleFrame.height - window.frame.height) / 4
    return NSPoint(x: pointX + visibleFrame.origin.x, y: pointY * 3 + visibleFrame.origin.y)
}

func getCurrentScreenTopRightNsPoint(_ window: NSWindow) -> NSPoint {
    guard let visibleFrame = getCurrentScreenWithMouseCursor()?.visibleFrame else {
        return NSPoint(x: 0, y: 0)
    }
    let padding = CGFloat(12)
    let pointX = visibleFrame.origin.x + visibleFrame.width - window.frame.width - padding
    let pointY = visibleFrame.origin.y + visibleFrame.height - window.frame.height - padding
    return NSPoint(x: pointX, y: pointY)
}

func isWindowContainedByAvailableArea(_ window: NSWindow) -> Bool {
    let windowFrame = window.frame
    let screens = NSScreen.screens
    let isWindowInScreen = screens.contains { $0.frame.intersects(windowFrame) }
    return isWindowInScreen
}
