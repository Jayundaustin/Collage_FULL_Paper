import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var stage: CollageStage = .idle
    @State private var isMeditationFinished = false
    @State private var themeSelected = false
    @State private var isAgentListening = false

    var body: some View {
        VStack {
            if stage == .idle {
                Button(action: { startPreCreation() }) {
                    Text("开始")
                        .font(.largeTitle)
                        .padding()
                }
            } else {
                Button(action: { stopAndReset() }) {
                    Image(systemName: "stop.circle")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                        .padding()
                }
            }

            switch stage {
            case .idle:
                Text("欢迎使用 Collage Making App")
            case .preCreation:
                PreCreationView(isMeditationFinished: $isMeditationFinished, themeSelected: $themeSelected, onProceed: startCreating)
            case .creating:
                CreatingView(onFinish: startPostCreation)
            case .postCreation:
                PostCreationView()
            }
        }
    }

    func handleVoiceCommand(_ text: String) {
        print("语音识别结果：\(text)")
        if stage == .preCreation && isMeditationFinished && !themeSelected && text.contains("开始") {
            themeSelected = true
            startCreating()
        } else if stage == .creating && text.contains("做完了") {
            startPostCreation()
        }
    }

    func startPreCreation() {
        stage = .preCreation
        VoiceAgentManager.shared.startListening { transcript in
            handleVoiceCommand(transcript)
        }
    }

    func startCreating() {
        stage = .creating
    }

    func startPostCreation() {
        stage = .postCreation
    }

    func stopAndReset() {
        stage = .idle
        isMeditationFinished = false
        themeSelected = false
    }
}
