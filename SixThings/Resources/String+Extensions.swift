//
//  String+Extensions.swift
//  SixThings
//
import Foundation

// 任務標題的加權字數上限：ASCII 算 1、其他算 2（＝中文 15 字、英文 30 字母）
let maxTitleWeight = 30

extension String {
    // 去掉頭尾空白與換行後是否為空
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // 加權字數：ASCII 字元算 1，其他（中日韓、全形標點、emoji）算 2
    var titleWeight: Int {
        reduce(0) { total, character in
            total + character.titleWeight
        }
    }

    // 是否超過任務標題上限
    var isOverTitleLimit: Bool {
        titleWeight > maxTitleWeight
    }

    // 從頭開始保留字元，直到再加一個就會超過上限為止
    func truncatedToTitleLimit() -> String {
        var result = ""
        var weight = 0
        for character in self {
            let next = weight + character.titleWeight
            if next > maxTitleWeight { break }
            result.append(character)
            weight = next
        }
        return result
    }
}

extension Character {
    // 單一字元的權重；組合 emoji（例如 👨‍👩‍👧）在 Swift 中是一個 Character，只算 2
    var titleWeight: Int {
        isASCII ? 1 : 2
    }
}
