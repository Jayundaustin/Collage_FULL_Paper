//
//  LLMService.swift
//  Collage
//
//  Created by Austin on 2025/7/15.
//

import Foundation

class LLMService {
    static let shared = LLMService()

    func sendPromptToQwen(prompt: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://10.200.20.255:11434/api/generate") else {
            print("❌ 无法创建 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "qwen3:30b",
            "prompt": prompt,
            "stream": false
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ 网络错误: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let reply = json["response"] as? String else {
                print("❌ 无法解析返回数据")
                return
            }

            DispatchQueue.main.async {
                completion(reply)
            }
        }.resume()
    }
}
