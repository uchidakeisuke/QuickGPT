import Foundation

class ChatViewerStates: ObservableObject {
    @Published var userMessage: String = ""
    @Published var message: String = ""
    @Published var chats: [[String: String]] = []
}
