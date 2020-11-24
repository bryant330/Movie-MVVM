//
//  Util.swift
//  Movie MVVM
//
//  Created by Lai Min Hou on 23/11/2020.
//  Copyright © 2020 IngLab. All rights reserved.
//

import UIKit

class Util: NSObject {

}

enum AppError {
    case network(type: Enums.NetworkError)
    case file(type: Enums.FileError)
    case custom(errorDescription: String?)

    class Enums { }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .network(let type): return type.localizedDescription
            case .file(let type): return type.localizedDescription
            case .custom(let errorDescription): return errorDescription
        }
    }
}

// MARK: - Network Errors

extension AppError.Enums {
    enum NetworkError {
        case parsing
        case notFound
        case custom(errorCode: Int?, errorDescription: String?)
    }
}

extension AppError.Enums.NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .parsing: return "Parsing error"
            case .notFound: return "URL Not Found"
            case .custom(_, let errorDescription): return errorDescription
        }
    }

    var errorCode: Int? {
        switch self {
            case .parsing: return nil
            case .notFound: return 404
            case .custom(let errorCode, _): return errorCode
        }
    }
}

// MARK: - FIle Errors

extension AppError.Enums {
    enum FileError {
        case read(path: String)
        case write(path: String, value: Any)
        case custom(errorDescription: String?)
    }
}

extension AppError.Enums.FileError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .read(let path): return "Could not read file from \"\(path)\""
            case .write(let path, let value): return "Could not write value \"\(value)\" file from \"\(path)\""
            case .custom(let errorDescription): return errorDescription
        }
    }
}

extension UIImageView {
    func load(urlString: String) {
        let url = URL(string: urlString)
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

extension Int {
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    static func minutesToHoursAndMinutes (_ minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "Helvetica-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17) }
    var normalFont:UIFont { return UIFont(name: "Helvetica-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}

    func bold(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }

    func normal(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    func underlined(_ value:String) -> NSMutableAttributedString {

        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue

        ]

        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
