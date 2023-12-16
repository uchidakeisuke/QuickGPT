import Foundation

class OpenAIAPI {
    private var model = UserDefaultsManager.shared.getStringData(UserDefaultsStringKey.ChatGptModel)
    private var apiKey = UserDefaultsManager.shared.getStringData(UserDefaultsStringKey.OpenAIAPIKey)
    private var userMessage: String = ""
    private var assistantMessage: String = ""

    func sendMessage(_ message: String, _ onGetPartialMessage: @escaping (_ partialMessage: String) -> Void, _ messages: [[String: String]]?) async -> String {
        await WindowManager.shared.showChatViewerWindow()
        return await request(message, { partialMessage in
            onGetPartialMessage(partialMessage)
        }, messages)
    }

    private func request(_ message: String, _ onGetPartialMessage: (_ partialMessage: String) -> Void, _ messageHistory: [[String: String]]?) async -> String {
        userMessage = message

        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            return ""
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.allHTTPHeaderFields = [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json",
        ]
        var messages: [[String: String]] = []
        messages.append(contentsOf: messageHistory ?? [])
        messages.append(["role": "user", "content": message])
        let requestBody: [String: Any] = [
            "model": model,
            "stream": true,
            "messages": messages,
        ]

        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            let (stream, _) = try await URLSession.shared.bytes(for: req)

            for try await line in stream.lines {
                guard let message = parse(line) else { continue }

                assistantMessage += message
                onGetPartialMessage(assistantMessage)
            }
            return assistantMessage
        } catch {
            print("Error: \(error)")
            return ""
        }
    }

    private func parse(_ line: String) -> String? {
        let components = line.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
        guard components.count == 2, components[0] == "data" else { return nil }

        let message = components[1].trimmingCharacters(in: .whitespacesAndNewlines)

        if message == "[DONE]" {
            return "\n"
        } else {
            let chunk = try? JSONDecoder().decode(Chunk.self, from: message.data(using: .utf8)!)
            return chunk?.choices.first?.delta.content
        }
    }
}

struct Message: Codable {
    let role: String?
    let content: String?
}

struct Chunk: Decodable {
    struct Choice: Decodable {
        struct Delta: Decodable {
            let role: String?
            let content: String?
        }

        let delta: Delta
    }

    let choices: [Choice]
}
