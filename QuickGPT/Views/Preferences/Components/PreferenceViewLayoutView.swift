import SwiftUI

let PreferenceLayoutBaseWidth: CGFloat = 400
let PreferenceLayoutBaseHeight: CGFloat = 400

struct PreferenceLayoutView: View {
    var view: AnyView = .init(EmptyView())

    var body: some View {
        VStack {
            Spacer()
            view
            Spacer()
            Divider()
            HStack {
                Button("Restart To Apply") {
                    restartApp()
                }.buttonStyle(.borderedProminent).tint(.blue)
                    .onHover { inside in
                        pointerOnHover(inside)
                    }
            }.frame(width: PreferenceLayoutBaseWidth, alignment: .trailing).padding()
        }.frame(width: PreferenceLayoutBaseWidth)
    }
}
