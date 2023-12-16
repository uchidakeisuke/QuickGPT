import SwiftUI

class ChatViewerWindow: NSWindow {
    override func mouseDown(with event: NSEvent) {
        performDrag(with: event)
    }

    override var canBecomeKey: Bool {
        return isKeyWindow
            || (styleMask.contains(.fullSizeContentView) && !styleMask.contains(.titled))
    }

    override func makeKeyAndOrderFront(_ sender: Any?) {
        super.makeKeyAndOrderFront(sender)
        if !isWindowContainedByAvailableArea(self) {
            setFrameOrigin(getCurrentScreenCenterNsPoint(self))
        }
    }
}

class ChatViewerWindowController: NSWindowController, NSWindowDelegate {
    convenience init() {
        let x = CGFloat(UserDefaultsManager.shared.getFloatData(UserDefaultsFloatKey.ChatViewerPositionX))
        let y = CGFloat(UserDefaultsManager.shared.getFloatData(UserDefaultsFloatKey.ChatViewerPositionY))
        let chatViewerWindow = ChatViewerWindow(
            contentRect: NSRect(origin: NSPoint(x: x, y: y), size: NSSize(width: 0, height: 0)),
            styleMask: [.unifiedTitleAndToolbar, .fullSizeContentView, .closable], // .fullSizeContentView is needed to use windowDidResignKey
            backing: .buffered,
            defer: false
        )
        chatViewerWindow.titlebarAppearsTransparent = true
//        chatViewerWindow.center()
        chatViewerWindow.isOpaque = false
        chatViewerWindow.backgroundColor = .clear
        chatViewerWindow.contentViewController = ChatViewerViewController()

        self.init(window: chatViewerWindow)

        window?.delegate = self
    }

    func windowDidResignKey(_: Notification) {
        Task(priority: .userInitiated) {
//            WindowManager.shared.closeChatViewerWindow()
            WindowManager.shared.saveChatViewerWindowCurrentPosition()
        }
    }
}
