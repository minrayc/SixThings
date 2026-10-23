//
//  String+Extensions.swift
//  SixThings
//
//  Created by 張閔瑞 on 2026/10/22.
//
import Foundation

extension String {
    var isBlank: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

let maxTitleLength = 15
