import Foundation
import SwiftUI

func restartApp() {
    if let scriptURL = Bundle.main.url(forResource: "restart", withExtension: "sh") {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = [scriptURL.path]
        task.launch()
        NSApplication.shared.terminate(nil)
    } else {
        print("Script not found!")
    }
}
