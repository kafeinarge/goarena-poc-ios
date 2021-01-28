//
//  Extensions.swift
//  goarena-poc
//
//  Created by serhat akalin on 28.01.2021.
//

import UIKit
// MARK: Gesture Extensions
extension UIView {
    /// http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    /// EZSwiftExtensions
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
}

extension String {
    ///
    /// This func created for tags in newPostView.Checked special char.
    /// - returns: Bool
    ///
    func checkSpecialChar() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcçdefgğhiıjklmnoöpqrsştuüvwxyzABCÇDEFGĞHIİJKLMNOÖPQRSŞTUÜVWXYZ0123456789-_")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            return false
        }
        return true
    }

    func getElapsedTime() -> String {
        var elapsedTime: String = ""
        if self.contains(".") {
            elapsedTime = Date.elapsedTime(Date._DateFormatter.date(from: self)!)
            return elapsedTime
        } else {
            elapsedTime = Date.elapsedTime(Date._DateFormatterRemoveNano.date(from: self) ?? Date())
            return elapsedTime
        }
    }
}

extension Date {

    static let _DateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxxxx"
        formatter.isLenient = true
        return formatter
    }()

    static let _DateFormatterRemoveNano: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.isLenient = true
        return formatter
    }()

    static func elapsedTime(_ date: Date) -> String {
        let now = Date()
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: date, to: now, options: [])


        if components.year! >= 1 {
            return "\(components.year!)y"
        } else if components.month! >= 1 {
            return "\(components.month!)a"
        } else if components.day! >= 1 {
            return "\(components.day!)g"
        } else if components.hour! >= 1 {
            return "\(components.hour!)sa"
        } else if components.minute! >= 1 {
            return "\(components.minute!)dk"
        } else if components.second! >= 1 {
            return "\(components.second!)sn"
        } else {
            return "Şimdi"
        }
    }
}


extension NSAttributedString {
    static func linkAttributedText(withString string: String, linkString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        let coloredLinkAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.blue.cgColor, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let range = (string as NSString).range(of: linkString)
        attributedString.addAttributes(coloredLinkAttribute, range: range)
        return attributedString
    }
    static func nameAndElapsedTimeAttributedText(withString string: String, timeString: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
            attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)])
        let coloredLinkAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor: UIColor.gray.cgColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)]

        let range = (string as NSString).range(of: timeString)
        attributedString.addAttributes(coloredLinkAttribute, range: range)
        return attributedString
    }
}

#if os(iOS) || os(tvOS)

    extension UIColor {
        /// EZSE: init method with RGB values from 0 to 255, instead of 0 to 1. With alpha(default:1)
        public convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
            self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
        }

        /// EZSE: init method with hex string and alpha(default: 1)
        public convenience init?(hexString: String, alpha: CGFloat = 1.0) {
            var formatted = hexString.replacingOccurrences(of: "0x", with: "")
            formatted = formatted.replacingOccurrences(of: "#", with: "")
            if let hex = Int(formatted, radix: 16) {
                let red = CGFloat(CGFloat((hex & 0xFF0000) >> 16) / 255.0)
                let green = CGFloat(CGFloat((hex & 0x00FF00) >> 8) / 255.0)
                let blue = CGFloat(CGFloat((hex & 0x0000FF) >> 0) / 255.0)
                self.init(red: red, green: green, blue: blue, alpha: alpha) } else {
                return nil
            }
        }
    }

#endif
