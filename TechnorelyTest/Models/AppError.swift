//
//  AppError.swift
//  TechnorelyTest
//
//  Created by Valeriia Tarasenko on 29.07.2020.
//  Copyright © 2020 Valeriia Tarasenko. All rights reserved.
//

import Foundation

enum AppError: Error {
    case unknown, failed, custom(String)
    
    var localizedDescription: String {
        switch self {
        case .unknown: return "Unknown error!"
        case .failed: return "Error!"
        case .custom(let text): return text
        }
    }
}
