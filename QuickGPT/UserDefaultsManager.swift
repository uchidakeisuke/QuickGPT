import Foundation

enum UserDefaultsKey {
    case stringKey(UserDefaultsStringKey)
}

enum UserDefaultsStringKey: String {
    case ChatGptModel
    case OpenAIAPIKey
}

enum UserDefaultsFloatKey: String {
    case ChatViewerPositionX
    case ChatViewerPositionY
}

class UserDefaultsManager {
    static let shared: UserDefaultsManager = .init()

    func initialize() {
        let chatGptModel = getStringData(UserDefaultsStringKey.ChatGptModel)
        if chatGptModel == "" {
            setStringData(UserDefaultsStringKey.ChatGptModel, "gpt-3.5-turbo")
        }
    }

    func setStringData(_ key: UserDefaultsStringKey, _ value: String) {
        Task(priority: .userInitiated) {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
    }

    func getStringData(_ key: UserDefaultsStringKey) -> String {
        return UserDefaults.standard.string(forKey: key.rawValue) ?? ""
    }

    func setFloatData(_ key: UserDefaultsFloatKey, _ value: Float) {
        Task(priority: .userInitiated) {
            UserDefaults.standard.set(value, forKey: key.rawValue)
        }
    }

    func getFloatData(_ key: UserDefaultsFloatKey) -> Float {
        return UserDefaults.standard.float(forKey: key.rawValue)
    }
}
