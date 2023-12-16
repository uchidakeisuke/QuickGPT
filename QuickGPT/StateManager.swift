import Foundation

class StateManager {
    static let shared: StateManager = .init()

    var chatViewerStates: ChatViewerStates = .init()
    var currentChatId: String = ""

    @MainActor
    func initialize() {
        chatViewerStates = ChatViewerStates()
    }

    @MainActor
    func updateUserMessage(_ userMessage: String, _ chatId: String) {
        if currentChatId == chatId {
            chatViewerStates.userMessage = userMessage
        }
    }

    @MainActor
    func updateMessage(_ message: String, _ chatId: String) {
        if currentChatId == chatId {
            chatViewerStates.message = message
        }
    }

    func updateChatId(_ chatId: String) {
        currentChatId = chatId
    }
}
