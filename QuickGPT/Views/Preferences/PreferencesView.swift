import SwiftUI

let PreferenceBaseWidth: CGFloat = PreferenceLayoutBaseWidth + 40
let PreferenceBaseHeight: CGFloat = PreferenceLayoutBaseHeight

struct ActualPreferencesView: View {
    @State var selection = 1
    var viewController: NSViewController? = nil // i don't know but this is needed to use makeKeyAndOrderFront

    var body: some View {
        TabView(selection: $selection) {
            GeneralPreferencesView().tabItem {
                VStack {
                    Image(systemName: "gear")
                    Text("General")
                }
            }.tag(1)
        }
        .frame(width: PreferenceBaseWidth, height: PreferenceBaseHeight)
    }
}

struct PreferencesView: NSViewControllerRepresentable {
    func makeNSViewController(context _: Context) -> PreferencesViewController {
        return PreferencesViewController()
    }

    func updateNSViewController(
        _: PreferencesViewController, context _: Context
    ) {}
}
