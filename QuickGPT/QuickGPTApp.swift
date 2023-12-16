import SwiftUI

@main
struct QuickGPTApp: App {
    @NSApplicationDelegateAdaptor(QuickGPTAppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra(content: {
            SettingsLink {
                Text("Preferences")
            }
            Divider()
            Button(action: {
                WindowManager.shared.moveChatViewerWindowToCurrentWindowCenter()
            }, label: { Text("Move Window To Current Screen") })
        }, label: {
            Image(nsImage: NSImage(
                byReferencingFile: Bundle.main.path(
                    forResource: "chatgpt-16", ofType: "png"
                ) ?? ""
            )!)
        })

        Settings {
            PreferencesView()
        }
    }
}
