//
//  DateTime.swift
//  WioTerminal
//
//  Created by nguyen.van.quangf on 18/11/2021.
//


import Foundation

/// Dateをラップした日時データ.
///
/// エンコード・デコードのフォーマットは"yyyy-MM-dd'T'HH:mm:ss.SSSXXX".
/// ```
/// (例) "2021-01-01T12:30:24.123+09:00"
/// ```
///
/// 対応するModelの記述方法.
/// ```
/// // JSON
/// {
///   "id": 1,
///   "updated_at": "2021-09-29T11:30:24.123+09:00"
/// }
///
/// // Model
/// struct Object: Codable {
///     var id: Int
///     var updated_at: DateTime
/// }
/// ```
///
/// 現在日時で生成.
/// ```
/// let date = DateTime()
/// ```
///
/// Dateで生成.
/// ```
/// let date = DateTime(date: Date())
/// ```
///
/// TimeIntervalで生成.
/// ```
/// // 現時刻から10分後.
/// let date = DateTime(timeIntervalSinceNow: 600)
/// // 1970/01/01 00:00:00から1632965142秒後.
/// let date = DateTime(timeIntervalSince1970: 1632965142)
/// // 2021/09/30 10:00:00から1日後.
/// let date = DateTime(timeInterval: 86400, since: DateTime(string: "2021-09-30T10:00:00.000+09:00")!)
/// ```
///
/// 文字列で生成.
/// ```
/// let date = DateTime(string: "2021-09-29T11:30:24.123+09:00")
/// let date = DateTime(string: "2021/09/29", format: .ymd)
/// ```
///
/// Stringに変換.
/// ```
/// printDebug(date.string) // "2021-09-29T12:30:24.123+09:00"
/// printDebug(date.toString(format: .ymdhis)) // "2021/09/29 12:30:24"
/// printDebug(date.toString(format: .his)) // "12:30:24"
/// ```
public struct DateTime: Codable, Equatable, Comparable, CustomStringConvertible {
    /// 実際の日時データ.
    private var rawDate: Date

    // MARK: - フォーマット.

    /// フォーマット.
    public enum Format: String, CaseIterable {
        /// サーバから取得される日時フォーマット.
        case raw
        /// タイムゾーン表記を除いた標準フォーマット.
        case standard
        /// 月日、時間を2桁表記しないymdhis.
        case shortFull
        /// 年月日.
        case ymd
        /// 年月日時分.
        case ymdhi
        /// 年月日時分秒.
        case ymdhis
        /// 時分秒.
        case his
        /// 時分.
        case hi
        /// スタンプで使用.
        case stamp
        /// 和暦(年月日).
        case warekiYmd
        /// ファイルパスとして使う場合.
        case filePath
        /// ファイル名で使う場合.
        case fileName
        /// ISO8601標準フォーマット(UTC).
        case iso8601
        /// ISO8601日付のみフォーマット(UTC).
        case iso8601FullDate
        /// ISO8601時間のみフォーマット(UTC).
        case iso8601FullTime
        /// GPS日付フォーマット.
        case gpsDate
        /// GPSタイムスタンプフォーマット.
        case gpsTime
        /// EXIF用.
        case exif

        // swiftlint:disable cyclomatic_complexity

        /// フォーマット用の文字列に変換.
        /// - Returns: フォーマット用文字列
        func formatString() -> String {
            switch self {
                case .raw: return "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
                case .standard: return "yyyy-MM-dd HH:mm:ss.SSS"
                case .shortFull: return "yyyy-M-d H:m:s"

                // 以下、UIなどクライアントで主に表示する用.
                case .ymd: return "yyyy/MM/dd"
                case .ymdhi: return "yyyy/MM/dd HH:mm"
                case .ymdhis: return "yyyy/MM/dd HH:mm:ss"
                case .his: return "HH:mm:ss"
                case .hi: return "HH:mm"
                case .stamp: return "yy.MM.dd"
                case .warekiYmd: return "Strings.DateFormat.warekiYmd"
                case .filePath: return "yyyyMMddHHmmss"
                case .fileName: return "Strings.DateFormat.fileName"

                // 以下、ISO8601用.
                // ISO8601DateFormatterを使用するので、この書式を変更しても意味ないが念のため定義.
                case .iso8601: return "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
                case .iso8601FullDate: return "yyyy-MM-dd"
                case .iso8601FullTime: return "HH:mm:ss.SSSXXX"

                // 以下、GPS用.
                case .gpsDate: return "yyyy:MM:dd"
                case .gpsTime: return "HH:mm:ss.SSSSSS"

                // 以下、EXIF用.
                case .exif: return "yyyy:MM:dd HH:mm:ss"
            }
        }

        // swiftlint:enable cyclomatic_complexity

        /// 和暦か否かを判定.
        var isWareki: Bool {
            self == .warekiYmd
        }

        /// ISO8601フォーマットか否か.
        var isISO8601Format: Bool {
            self == .iso8601 || self == .iso8601FullDate || self == .iso8601FullTime
        }

        /// タイムゾーンをUTCとして使用するか否か.
        var isUTC: Bool {
            self == .iso8601 || self == .iso8601FullDate || self == .iso8601FullTime || self == .gpsDate || self == .gpsTime
        }
    }

    // MARK: - 初期化.

    /// 現時刻で初期化.
    public init() {
        self.rawDate = Date()
    }

    /// Dateを指定して初期化.
    /// - Parameter date: Date
    public init(date: Date) {
        self.rawDate = date
    }

    /// 1970年1月1日からの経過時間(秒)で初期化.
    /// - Parameter timeIntervalSince1970: 経過時間(秒)
    public init(timeIntervalSince1970: TimeInterval) {
        self.rawDate = Date(timeIntervalSince1970: timeIntervalSince1970)
    }

    /// 現時刻からの経過時間(秒)で初期化.
    /// - Parameter timeIntervalSinceNow: 経過時間(秒)
    public init(timeIntervalSinceNow: TimeInterval) {
        self.rawDate = Date(timeIntervalSinceNow: timeIntervalSinceNow)
    }

    /// 指定した日時からの経過時間(秒)で初期化.
    /// - Parameters:
    ///   - timeInterval: 経過時間(秒)
    ///   - dateTime: 基準となる日時
    public init(timeInterval: TimeInterval, since dateTime: DateTime) {
        self.rawDate = Date(timeInterval: timeInterval, since: dateTime.date)
    }

    /// 文字列で初期化.
    /// - Parameters:
    ///   - string: 日時文字列
    ///   - format: 日時文字列のフォーマット
    public init?(string: String, format: Format = .raw) {
        guard let date = DateTimeUtil.dateFromString(string, format: format) else {
            // printError("DateTime(string: \"\(string)\", format: \(format)) invalid string format")
            return nil
        }

        self.rawDate = date
    }

    // MARK: - static 関数.

    /// 現在日時を文字列として取得.
    /// - Parameter format: 日時文字列のフォーマット
    /// - Returns: 日時文字列
    public static func nowString(format: Format = .ymdhis) -> String {
        DateTime().toString(format: format)
    }

    /// 現在日時のTimeIntervalを取得.
    /// - Returns: TimeInterval
    public static func nowTime() -> TimeInterval {
        DateTime().timeInterval
    }

    // MARK: - Date操作.

    /// Dateを取得.
    public var date: Date {
        rawDate
    }

    /// 現在日時で更新.
    public mutating func updateNow() {
        rawDate = Date()
    }

    /// 経過時間(秒)を加算.
    /// - Parameter timeInterval: 経過時間(秒)
    public mutating func add(timeInterval: TimeInterval) {
        rawDate = Date(timeInterval: timeInterval, since: rawDate)
    }

    /// 分を加算.
    /// - Parameter minute 分
    public mutating func add(minute: Int) {
        rawDate = Date(timeInterval: TimeInterval(minute * 60), since: rawDate)
    }

    /// 時間を加算.
    /// - Parameter hour 時間
    public mutating func add(hour: Int) {
        rawDate = Date(timeInterval: TimeInterval(hour * 3600), since: rawDate)
    }

    /// 日数を加算.
    /// - Parameter day 日数
    public mutating func add(day: Int) {
        rawDate = Date(timeInterval: TimeInterval(day * 86400), since: rawDate)
    }

    // MARK: - 文字列として取得.

    /// Stringを取得.
    public var string: String {
        toString(format: .raw)
    }

    /// フォーマットを指定してStringを取得.
    public func toString(format: Format) -> String {
        DateTimeUtil.stringFromDate(rawDate, format: format)
    }

    // MARK: - 秒数取得.

    /// 1970年1月1日からの経過時間(秒)を取得.
    public var timeInterval: TimeInterval {
        rawDate.timeIntervalSince1970
    }

    /// 現時刻からの経過時間(秒)を取得.
    public var timeIntervalSinceNow: TimeInterval {
        rawDate.timeIntervalSinceNow
    }

    /// 指定した日時との経過時間(秒)取得.
    /// - Parameter since: 基準となる日時
    /// - Returns: 経過時間(秒)
    public func timeInterval(since: DateTime) -> TimeInterval {
        rawDate.timeIntervalSince(since.date)
    }

    // MARK: - Decodable

    public init(from decoder: Decoder) throws {
        guard let container = try? decoder.singleValueContainer(), let value = try? container.decode(String.self) else {
            // printError("DateTime decode error")
            self.init(timeIntervalSince1970: 0.0)
            return
        }

        guard DateTimeUtil.dateFromString(value, format: .raw) != nil else {
            // printError("value: \"\(value)\" is not raw format")
            self.init(timeIntervalSince1970: 0.0)
            return
        }

        self.init(string: value)!
    }

    // MARK: - Encodable

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }

    // MARK: - Comparable

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.timeInterval < rhs.timeInterval
    }

    // MARK: - Equatable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        Int(lhs.timeInterval) == Int(rhs.timeInterval)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        string
    }
}

/// DateTime用のユーティリティ.
private enum DateTimeUtil {
    /// StringからDateに変換.
    /// - Parameters:
    ///   - string: 日時文字列
    ///   - format: 日時フォーマット
    /// - Returns: Date
    static func dateFromString(_ string: String, format: DateTime.Format) -> Date? {
        if format.isISO8601Format {
            let formatter = createISO8601DateFormatter(format: format)
            return formatter.date(from: string)
        }

        let formatter = createDateFormatter(format: format)
        return formatter.date(from: string)
    }

    /// DateからStringに変換.
    /// - Parameters:
    ///   - date: 日時
    ///   - format: 日時フォーマット
    /// - Returns: String
    static func stringFromDate(_ date: Date, format: DateTime.Format) -> String {
        if format.isISO8601Format {
            let formatter = createISO8601DateFormatter(format: format)
            return formatter.string(from: date)
        }

        let formatter = createDateFormatter(format: format)
        return formatter.string(from: date)
    }

    /// DateFormatterの作成.
    /// - Parameter format: 日時フォーマット
    /// - Returns: DateFormatter
    static func createDateFormatter(format: DateTime.Format) -> DateFormatter {
        let formatter = DateFormatter()

        if format.isWareki {
            formatter.calendar = Calendar(identifier: .japanese)
        } else {
            formatter.calendar = Calendar(identifier: .gregorian)
        }

        if format.isUTC {
            formatter.timeZone = TimeZone(abbreviation: "UTC")
        } else {
            formatter.timeZone = TimeZone.current
        }

        if (NSLocale.preferredLanguages.first?.starts(with: "ja")) != nil {
            // 和暦や２４時間表示オフのときに正しく時間が取得できない（日本限定対応）
            formatter.locale = Locale(identifier: "ja_JP")
        } else {
            formatter.locale = Locale(identifier: "en_US")
        }

        formatter.dateFormat = format.formatString()
        return formatter
    }

    /// ISO8601DateFormatterの作成.
    /// - Parameter format: 日時フォーマット
    /// - Returns: ISO8601DateFormatter
    static func createISO8601DateFormatter(format: DateTime.Format) -> ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()

        if format == .iso8601FullDate {
            formatter.formatOptions = [.withFullDate]
        } else if format == .iso8601FullTime {
            formatter.formatOptions = [.withFullTime, .withFractionalSeconds]
        } else {
            formatter.formatOptions.insert(.withFractionalSeconds)
        }

        return formatter
    }
}

