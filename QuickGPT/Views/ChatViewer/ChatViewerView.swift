import SwiftUI

let ChatViewerViewWidth: CGFloat = 620

struct ChatViewerView: View {
    @EnvironmentObject var chatViewerStates: ChatViewerStates
    @State var screenHeight: CGFloat = 400

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(self.chatViewerStates.userMessage)
                        .font(.system(size: 14))
                        .frame(width: 560)
                }
                .frame(width: 600, height: 30)
                Divider()
                Text(self.chatViewerStates.message)
                    .padding(24)
                    .frame(width: 600, alignment: .leading)
//                    .textSelection(.enabled)
            }
            .background(.black)
            .foregroundStyle(.white)
            .cornerRadius(8.0)
            .opacity(0.8)
        }
        .onAppear {
            if let screen = getCurrentScreenWithMouseCursor() {
                screenHeight = (screen.frame.height - 52)
            }
        }
        .padding(12)
        .scrollIndicators(.hidden)
        .frame(width: ChatViewerViewWidth, height: screenHeight, alignment: .trailing)
        .font(.system(size: 16))
        .transition(.move(edge: .leading))
    }
}

#Preview {
    ChatViewerView().environmentObject(ChatViewerStates())
}
