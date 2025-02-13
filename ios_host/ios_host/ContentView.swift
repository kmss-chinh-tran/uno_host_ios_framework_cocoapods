import SwiftUI
import Flutter

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}

extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        self.modifier(ViewDidLoadModifier(action: action))
    }
}

struct ContentView: View {
    // Flutter dependencies are passed in an EnvironmentObject.
    @EnvironmentObject var flutterDependencies: FlutterDependencies
    
    @State private var customerName: String = ""
    @State private var mobileNumber: String = ""
    @State private var emi: String = "0"
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Hello \(customerName.isEmpty ? "Customer" : customerName)!")
                    .font(.title)
                    .bold()
                
                TextField("Customer Name", text: $customerName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                TextField("Mobile Number", text: $mobileNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: calculateEMI) {
                    Text("Calculate EMI")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Text("EMI: " + emi)
                    .font(.headline)
                    .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .onViewDidLoad {
                handleMethodChannel()
            }
        }
    
    func calculateEMI() {
        // Get RootViewController from window scene
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene,
            let window = windowScene.windows.first(where: \.isKeyWindow),
            let rootViewController = window.rootViewController
        else { return }
        
        if (flutterDependencies.flutterEngine.viewController == nil) {
            // Create a FlutterViewController from pre-warmed FlutterEngine
            let flutterViewController = FlutterViewController(
                engine: flutterDependencies.flutterEngine,
                nibName: nil,
                bundle: nil
            )
            flutterViewController.modalPresentationStyle = .overCurrentContext
            flutterViewController.isViewOpaque = false

            rootViewController.present(flutterViewController, animated: true)
        }
        else {
            rootViewController.present(flutterDependencies.flutterEngine.viewController!, animated: true)
        }
        
    }
    
    func handleMethodChannel() {
        let flutterMethodChannel = FlutterMethodChannel(name: "kms-emi-calculator-channel", binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger)
        flutterMethodChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch(call.method) {
            case "getData":
                getData(result: result)
            case "submit":
                emi = (call.arguments as? String)!
            default:
                print("Unrecognized method: \(call.method)")
            }
        })
    }
    
    func getData(result: FlutterResult) -> Void {
        let jsonData: [String: Any] = [
            "customerName": customerName,
            "mobileNumber": mobileNumber
        ]

        do {
            let jsonDataString = try JSONSerialization.data(withJSONObject: jsonData, options: [])
            if let jsonString = String(data: jsonDataString, encoding: .utf8) {
                result(jsonString) // Send JSON string to Flutter
            } else {
                result(FlutterError(code: "JSON_ENCODING_ERROR",
                                    message: "Failed to encode JSON",
                                    details: nil))
            }
        } catch {
            result(FlutterError(code: "JSON_SERIALIZATION_ERROR",
                                message: "Failed to serialize JSON",
                                details: error.localizedDescription))
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(FlutterDependencies())
    }
}
