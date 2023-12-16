import SwiftUI

let PreferenceRowBaseWidth: CGFloat = 300
let PreferenceRowBaseHeight: CGFloat = 300

struct PreferenceRowView<Content>: View where Content: View {
    private var label: String
    private var view: Content
    private var labelWidth: CGFloat
    private var viewWidth: CGFloat

    init(label: String, @ViewBuilder view: () -> Content, labelWidth: CGFloat, viewWidth: CGFloat) {
        self.label = label
        self.view = view()
        self.labelWidth = labelWidth
        self.viewWidth = viewWidth
    }

    var body: some View {
        HStack {
            Text(label).frame(width: labelWidth, alignment: .trailing)
            view.frame(width: viewWidth, alignment: .leading)
        }
    }
}
