//
//  PreCreationView.swift
//  Collage
//
//  Created by Austin on 2025/7/14.
//

import SwiftUI

struct PreCreationView: View {
    @Binding var isMeditationFinished: Bool
    @Binding var themeSelected: Bool
    var onProceed: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            if !isMeditationFinished {
                Text("冥想中（5分钟）...")
                // TODO: 调用LLM输出冥想引导文本或音频
                Button("完成冥想") {
                    isMeditationFinished = true
                }
            } else if !themeSelected {
                Text("与AI对话，引导用户思考主题")
                // TODO: 与LLM对话界面
                Text("请说：开始")
            }
        }.padding()
    }
}
