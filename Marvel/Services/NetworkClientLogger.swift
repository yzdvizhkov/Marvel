//
//  NetworkLogger.swift
//  Marvel
//
//  Created by Юрій Здвіжков on 22.05.2023.
//

import UIKit

final class NetworkClientLogger {
    // MARK: - Methods

    // MARK: Internal

    func log(request: URLRequest?, response: URLResponse?, data: Data?, error: Error?, startTime: Date) {
        guard let request = request else { return }
        var messages = [String]()

        let emoji: String = .emoji(for: response?.httpStatusCode)

        messages.append("[NetworkClientLogger] \(emoji) Begin")
        messages.append("🗓 StartTime: \(DateFormatter.networkClientLogger.string(from: startTime))")

        messages.append("🗓 EndTime: \(DateFormatter.networkClientLogger.string(from: Date()))")

        if let method = request.httpMethod, let url = request.url {
            messages.append("🌎 URL: \(method) \(url.absoluteString)")
        }

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            messages.append("📖 Headers: \(headers)")
        }

        if let requestBody = request.httpBody, let requestBodyString = requestBody.jsonString, !requestBodyString.isEmpty {
            messages.append("➡️ Request Body:")
            messages.append(requestBodyString)
        }

        if let responseCode = response?.httpStatusCode {
            messages.append("📪 Response Code: \(responseCode.description)")
        }

        if let responseBody = data, let responseBodyString = responseBody.jsonString, !responseBodyString.isEmpty {
            messages.append("⬅️ Response Body:")
            messages.append(responseBodyString)
        }

        if let error = error {
            messages.append("🛑 Error: \(error.localizedDescription)")
        }

        messages.append("[NetworkClientLogger] \(emoji) End")

        print(messages.joined(separator: "\n"))
    }
}

private extension URLResponse {
    // MARK: - Properties

    // MARK: Internal

    var httpStatusCode: Int? {
        guard let httpResponse = self as? HTTPURLResponse else {
            return nil
        }

        return httpResponse.statusCode
    }
}

private extension Data {
    // MARK: - Properties

    // MARK: Internal

    var jsonString: String? {
        guard
            let object = try? JSONSerialization.jsonObject(with: self),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted])
        else {
            return String(data: self, encoding: .utf8)
        }

        return String(data: data, encoding: .utf8)
    }
}

private extension String {
    // MARK: - Methods

    // MARK: Internal

    static func emoji(for statusCode: Int?) -> String {
        if let statusCode = statusCode, 200 ..< 300 ~= statusCode {
            return "✅"
        } else {
            return "⚠️"
        }
    }
}

private extension DateFormatter {
    // MARK: - Properties

    // MARK: Internal

    static let networkClientLogger: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"

        return formatter
    }()
}
