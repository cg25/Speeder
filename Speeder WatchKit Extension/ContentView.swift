import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = SpeedViewModel()
    @State private var selectedWarningSpeed = 50
    @State private var isWarningSpeedSet = false

    var body: some View {
        TabView {
            VStack {
                Spacer(minLength: 20)
                
                if !isWarningSpeedSet {
                    Text("Set Warning Speed")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 20.0)

                    Picker("Warning Speed", selection: $selectedWarningSpeed) {
                        ForEach((1...99).reversed(), id: \.self) { speed in
                            Text("\(speed) km/h").tag(speed)
                        }
                    }
                    .frame(height: 65)
                    .labelsHidden()

                    Button("Set") {
                        isWarningSpeedSet = true
                        viewModel.warningSpeed = selectedWarningSpeed
                    }
                    .frame(height: 40.0)
                    .foregroundColor(.gray)
                    .padding(.vertical, 0.0)
                } else {
                    Text("Warning \(selectedWarningSpeed) km/h")
                        .padding(.vertical, 5)
                }
                
                Button(action: {
                    viewModel.isTracking.toggle()
                    if viewModel.isTracking {
                        viewModel.startTracking()
                    } else {
                        viewModel.stopTracking()
                        isWarningSpeedSet = false
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(viewModel.isTracking ? Color.red : Color.green)
                        Text(viewModel.isTracking ? "Stop" : "Start")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .frame(height: 40.0)

                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(height: 50)
                .padding(.horizontal)
                
                Spacer(minLength: 20)
            }
            .padding(0.0)
            .tag(0)
            
            VStack {
                Text("\(viewModel.speedKmH, specifier: "%.2f") km/h")
                    .font(.system(.title, design: .rounded).monospacedDigit())
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.speedKmH > Double(viewModel.warningSpeed) ? .red : .white)
            }
            .tag(1)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("Apple Watch Series 5 - 44mm")
                .previewDisplayName("Apple Watch")
        }
    }
}

