import SwiftUI
import Flutter
import FlutterPluginRegistrant

class FlutterDependencies: ObservableObject {
    let flutterEngine = FlutterEngine(name: "kms_emi_calculator_sdk")
    init() {
        flutterEngine.run(withEntrypoint: "emiCalculatorMain")
        // If you added a plugin to Flutter module, you also need to register plugin to flutter engine
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
    }
}

@main
struct iOSCounterApp: App {
    @StateObject var flutterDependencies = FlutterDependencies()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(flutterDependencies)
        }
    }
}
