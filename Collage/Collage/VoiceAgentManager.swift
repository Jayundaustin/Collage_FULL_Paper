import Foundation
import Speech

class VoiceAgentManager: NSObject, SFSpeechRecognizerDelegate {
    static let shared = VoiceAgentManager()

    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var onResult: ((String) -> Void)?

    func startListening(onResult: @escaping (String) -> Void) {
        self.onResult = onResult
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                print("语音识别权限未授权")
                return
            }
            DispatchQueue.main.async {
                self.startRecognition()
            }
        }
    }

    private func startRecognition() {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("语音识别不可用")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }

        let inputNode = audioEngine.inputNode
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = recognizer.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let transcript = result.bestTranscription.formattedString
                self.onResult?(transcript)

                if result.isFinal {
                    self.restartRecognition()
                }
            } else if let error = error {
                print("识别错误: \(error.localizedDescription)")
                self.restartRecognition()
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
        print("🎙️ 正在监听语音...")
    }

    private func restartRecognition() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest = nil
        recognitionTask = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startRecognition()
        }
    }
}
