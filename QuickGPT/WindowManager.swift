import SwiftUI

class WindowManager {
    static let shared: WindowManager = .init()

    private var chatViewerWindowController: ChatViewerWindowController?

    @MainActor
    private func createChatViewerWindow() {
        chatViewerWindowController = ChatViewerWindowController()
    }

    @MainActor
    func showChatViewerWindow() {
        if chatViewerWindowController == nil {
            createChatViewerWindow()
        }
        if let window = chatViewerWindowController?.window {
            moveWindowToFront(window)
        }
    }

    @MainActor
    func closeChatViewerWindow() {
        chatViewerWindowController?.window?.close()
        chatViewerWindowController?.close()
        saveCurrentPosition(
            Float(chatViewerWindowController?.window?.frame.origin.x ?? 0.0),
            Float(chatViewerWindowController?.window?.frame.origin.y ?? 0.0)
        )
    }

    func saveChatViewerWindowCurrentPosition() {
        saveCurrentPosition(
            Float(chatViewerWindowController?.window?.frame.origin.x ?? 0.0),
            Float(chatViewerWindowController?.window?.frame.origin.y ?? 0.0)
        )
    }

    private func saveCurrentPosition(_ x: Float, _ y: Float) {
        UserDefaultsManager.shared.setFloatData(UserDefaultsFloatKey.ChatViewerPositionX, x)
        UserDefaultsManager.shared.setFloatData(UserDefaultsFloatKey.ChatViewerPositionY, y)
    }

    func moveChatViewerWindowToCurrentWindowCenter() {
        guard let window = chatViewerWindowController?.window else {
            return
        }
        let nsPoint = getCurrentScreenCenterNsPoint(window)
        window.setFrameOrigin(nsPoint)
    }
}
