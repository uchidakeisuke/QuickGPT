import SwiftUI

class ChatViewerViewController: NSViewController, NSWindowDelegate {
    override func loadView() {
        let chatViewerView = ChatViewerView().environmentObject(StateManager.shared.chatViewerStates)
        view = NSHostingView(rootView: chatViewerView)
    }
}
