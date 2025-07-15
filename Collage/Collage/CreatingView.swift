//
//  CreatingView.swift
//  Collage
//
//  Created by Austin on 2025/7/14.
//

import SwiftUI

struct CreatingView: View {
    var onFinish: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("创作中...唤醒词后AI才响应")
            // TODO: 麦克风监听 + 唤醒词识别
            // TODO: 摄像头监控 + 元素识别 + 音效播放（叠加）
            Text("说“做完了”即可进入下一阶段")
        }.padding()
    }
}
