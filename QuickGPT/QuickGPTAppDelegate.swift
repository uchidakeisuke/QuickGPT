import SwiftUI

class QuickGPTAppDelegate: NSObject, NSApplicationDelegate {
    func application(_: NSApplication, open urls: [URL]) {
        Task(priority: .userInitiated) {
            try await self.handleUrlScheme(urls: urls, self.switchAction)
        }
    }

    func applicationDidFinishLaunching(_: Notification) {
        UserDefaultsManager.shared.initialize()
        StateManager.shared.initialize()
    }

    func applicationWillTerminate(_: Notification) {
        WindowManager.shared.saveChatViewerWindowCurrentPosition()
    }

    private func handleUrlScheme(urls: [URL], _ callback: (_ path: String, _ message: String, _ parameters: [String: Any]) async throws -> Void) async throws {
        for url in urls {
            guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let host = urlComponents.host else {
                continue
            }

            var pathComponents = [host]
            pathComponents += urlComponents.path.split(separator: "/").map { String($0) }

            var firstPath: String = ""
            var userMessage: String = ""
            var parametersString: String?

            if pathComponents.count > 0 {
                firstPath = pathComponents[0]
            }

            if pathComponents.count > 1 {
                let messageComponents = pathComponents[1].split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                userMessage = String(messageComponents[0])
                if messageComponents.count > 1 {
                    parametersString = String(messageComponents[1])
                }
            }

            var parameters = [String: Any]()
            if let parametersString = parametersString {
                let parametersComponents = parametersString.split(separator: "&")
                parametersComponents.forEach {
                    let nameAndValue = $0.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: true)
                    if nameAndValue.count == 2 {
                        let key = String(nameAndValue[0]).trimmingCharacters(in: CharacterSet(charactersIn: "?&"))
                        parameters[key] = convertToBoolOrString(String(nameAndValue[1]))
                    }
                }
            }

            try await callback(firstPath, userMessage, parameters)
        }
    }

    private func switchAction(_ path: String, _ message: String, _ parameters: [String: Any]) async throws {
        try await ChatManager.shared.chat(path, message, parameters)
    }
}
