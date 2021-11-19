//
//  DebugPrint.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//

public final class DebugPrint {
    /// 設定データ.
    public struct Setting {
        /// 日付を出力するか否か.
        public var outputDate = false
        /// ファイル行を出力するか否か.
        public var outputLine = true
        /// 呼び出し元関数名を出力するか否か.
        public var outputFunction = true
    }

    /// 出力のカテゴリ.
    enum Category: String {
        /// デバッグ.
        case debug = "[Debug] "
        /// 警告.
        case warning = "[Warning] "
        /// エラー.
        case error = "[Error] "

        /// アイコン.
        var icon: String {
            switch self {
                case .debug: return "⚪️"
                case .warning: return "⚠️"
                case .error: return "❌"
            }
        }
    }

    /// 設定.
    public static var setting = Setting()

    /// 出力.
    /// - Parameters:
    ///   - category: ログのカテゴリ
    ///   - items: ログ内容
    ///   - filePath: ファイルパス
    ///   - fileLine: ファイルの行数
    ///   - function: 呼び出し元の関数名
    class func output(category: Category, items: [Any], filePath: String, fileLine: Int, function: String) {
        #if DEBUG
        var date = ""
        if DebugPrint.setting.outputDate {
            date = "\(DateTime.nowString(format: .standard)) "
        }

        var line = ""
        if DebugPrint.setting.outputLine {
            //line = "\(filePath.lastPathComponent):\(fileLine) "
        }

        var functionName = ""
        if DebugPrint.setting.outputFunction {
            if let index = function.firstIndex(of: "(") {
                functionName = "\(String(function[function.startIndex...index]))) "
            } else {
                functionName = "\(function) "
            }
        }

        let output = items.map { "\($0)" }.joined(separator: " ")
        Swift.print("\(category.icon)\(date)\(category.rawValue)\(line)\(functionName)\(output)", terminator: "\n")
        #endif
    }
}

// デバッグログを出力.
/// - Parameters:
///   - items: ログ内容
///   - filePath: ファイルパス
///   - fileLine: ファイルの行数
///   - function: 呼び出し元の関数名
public func printDebug(_ items: Any..., filePath: String = #filePath, fileLine: Int = #line, function: String = #function) {
    #if DEBUG
    DebugPrint.output(category: .debug, items: items, filePath: filePath, fileLine: fileLine, function: function)
    #endif
}

/// 警告ログを出力.
/// - Parameters:
///   - items: ログ内容
///   - filePath: ファイルパス
///   - fileLine: ファイルの行数
///   - function: 呼び出し元の関数名
public func printWarning(_ items: Any..., filePath: String = #filePath, fileLine: Int = #line, function: String = #function) {
    #if DEBUG
    DebugPrint.output(category: .warning, items: items, filePath: filePath, fileLine: fileLine, function: function)
    #endif
}

/// エラーログを出力.
/// - Parameters:
///   - items: ログ内容
///   - filePath: ファイルパス
///   - fileLine: ファイルの行数
///   - function: 呼び出し元の関数名
public func printError(_ items: Any..., filePath: String = #filePath, fileLine: Int = #line, function: String = #function) {
    #if DEBUG
    DebugPrint.output(category: .error, items: items, filePath: filePath, fileLine: fileLine, function: function)
    #endif
}

