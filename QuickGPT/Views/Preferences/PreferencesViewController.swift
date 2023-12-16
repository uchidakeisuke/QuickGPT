import SwiftUI

class PreferencesViewController: NSViewController, NSWindowDelegate {
    private var preferencesView = ActualPreferencesView()
    var viewControllerRepresentable: (any NSViewControllerRepresentable)? = nil

    override func loadView() {
        view = NSHostingView(rootView: preferencesView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        view.window?.delegate = self
        NSApp.activate(ignoringOtherApps: true)
        view.window?.makeKeyAndOrderFront(nil)
    }

    func windowDidResignKey(_: Notification) {
        Task(priority: .userInitiated) { @MainActor in
            self.view.window?.close()
        }
    }
}
