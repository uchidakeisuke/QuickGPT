import AVFoundation
import SwiftUI

struct GeneralPreferencesView: View {
    @State private var model: String = "gpt-3.5-turbo"
    @State private var apiKey: String = ""

    var body: some View {
        PreferenceLayoutView(
            view: AnyView(
                VStack {
                    PreferenceRowView(
                        label: "ChatGPT model",
                        view: {
                            Picker(selection: self.$model) {
                                Text("gpt-3.5-turbo").tag("gpt-3.5-turbo")
                                Text("gpt-4").tag("gpt-4")
                            } label: {
                                Text("")
                            }.onChange(of: self.model) {
                                UserDefaultsManager.shared.setStringData(
                                    UserDefaultsStringKey.ChatGptModel, self.model
                                )
                            }
                        }, labelWidth: PreferenceRowBaseHeight, viewWidth: PreferenceRowBaseWidth
                    )
                    PreferenceRowView(
                        label: "OpenAI API Key",
                        view: {
                            TextField("", text: self.$apiKey)
                                .onSubmit {
                                    UserDefaultsManager.shared.setStringData(
                                        UserDefaultsStringKey.OpenAIAPIKey, self.apiKey
                                    )
                                }
                        }, labelWidth: PreferenceRowBaseHeight, viewWidth: PreferenceRowBaseWidth
                    )
                }
            )
        )
        .onAppear {
            self.model = UserDefaultsManager.shared.getStringData(
                UserDefaultsStringKey.ChatGptModel)
            self.apiKey = UserDefaultsManager.shared.getStringData(
                UserDefaultsStringKey.OpenAIAPIKey)
        }
    }
}
