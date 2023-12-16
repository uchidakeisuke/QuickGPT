import Foundation

class ChatManager {
    static let shared: ChatManager = .init()

    // preprocesses for user message
    private func userMessageForConciseAnswer(_ userMessage: String) -> String {
        return "\(userMessage)\nAnswer as concisely as possible."
    }

    // process depending on command
    private func processUserMessageByCommand(_ command: String, _ userMessage: String, _ parameters: [String: Any]) -> (String, [String: Any]) {
        var message = userMessage
        var params = parameters

        switch command {
        case "chat":
            break
        default:
            break
        }

        return (message, params)
    }

    // process depending on parameters
    private func processUserMessageByParameters(_ userMessage: String, _ parameters: [String: Any]) -> String {
        var message = userMessage

        let processMap: [String: (_ userMessage: String) -> String] = [
            "concise": userMessageForConciseAnswer,
        ]

        for (key, value) in parameters {
            if value as? Bool == false {
                continue
            }
            guard let process = processMap[key] else { continue }
            message = process(message)
        }

        return message
    }

    private func preprocess(_ command: String, _ userMessage: String, _ parameters: [String: Any]) -> (String, [String: Any]) {
        var (message, params) = processUserMessageByCommand(command, userMessage, parameters)
        message = processUserMessageByParameters(message, params)
        return (message, params)
    }

    private func postprocess(_: String, _: String, _: String, _: [String: Any]) async throws {
        // no postprocesses
    }

    private func sendMessage(_ command: String, _ userMessage: String, _ parameters: [String: Any], _ callback: @escaping (_ userMessage: String, _ parameters: [String: Any]) async throws -> String) {
        Task {
            let (preprocessedUserMessage, preprocessedParameters) = self.preprocess(command, userMessage, parameters)
            let message = try await callback(preprocessedUserMessage, preprocessedParameters)
            try await self.postprocess(userMessage, preprocessedUserMessage, message, preprocessedParameters)
        }
    }

    private func updateMessage(_ userMessage: String, _ chatId: String) {
        Task(priority: .userInitiated) {
            await StateManager.shared.updateMessage(userMessage, chatId)
        }
    }

    private func updateUserMessage(_ message: String, _ chatId: String) {
        Task(priority: .userInitiated) {
            await StateManager.shared.updateUserMessage(message, chatId)
        }
    }

    func chat(_ command: String, _ userMessage: String, _ parameters: [String: Any]) async throws {
        sendMessage(command, userMessage, parameters) { preprocessedUserMessage, _ in
            let chatId = UUID().uuidString
            StateManager.shared.updateChatId(chatId)
            self.updateUserMessage(preprocessedUserMessage, chatId)
            return await OpenAIAPI().sendMessage(preprocessedUserMessage, { partialMessage in
                self.updateMessage(partialMessage, chatId)
            }, [])
        }
    }
}
