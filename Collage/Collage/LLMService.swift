//
//  LLMService.swift
//  Collage
//
//  Created by Austin on 2025/7/15.
//

import Foundation

class LLMService {
    static let shared = LLMService()

    private let apiKey = "sk-b217fea14e9b48818e63be0bbdceb66e"  // 替换成你的阿里云密钥
    private let endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1/chat/completions"

    func sendPromptToQwen(prompt: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: endpoint) else {
            print("❌ 无法创建 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "qwen-plus",  // 或 qwen-plus、qwen-turbo，视你开通的模型而定
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 网络错误: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let message = choices.first?["message"] as? [String: Any],
                  let reply = message["content"] as? String else {
                print("❌ 无法解析返回数据")
                print("📦 原始返回：\(String(data: data ?? Data(), encoding: .utf8) ?? "无")")
                return
            }

            DispatchQueue.main.async {
                completion(reply)
            }
        }.resume()
    }
}
