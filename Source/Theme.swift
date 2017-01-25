//
//  Theme.swift
//  DB5Demo
//

import UIKit
@objc

enum TextCaseTransform : Int8 {
    case none, upper, lower
}

func stringIsEmpty(_ s: String?) -> Bool {
    if s == nil {
        return true
    }
    return s!.characters.count == 0
}

// Picky. Crashes by design.
func colorWithHexString(_ hexString: String?) -> UIColor {
    if stringIsEmpty(hexString) {
        return UIColor.black
    }
<<<<<<< Updated upstream
    var s: NSMutableString = NSMutableString(string: hexString!)
    s.replaceOccurrencesOfString("#", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: NSMakeRange(0, hexString!.characters.count))
=======
    let s: NSMutableString = NSMutableString(string: hexString!)
    s.replaceOccurrences(of: "#", with: "", options: NSString.CompareOptions.caseInsensitive, range: NSMakeRange(0, hexString!.characters.count))
>>>>>>> Stashed changes
    CFStringTrimWhitespace(s)
    let redString = s.substring(to: 2)
    let greenString = s.substring(with: NSMakeRange(2, 2))
    let blueString = s.substring(with: NSMakeRange(4, 2))

    var r: UInt32 = 0, g: UInt32 = 0, b: UInt32 = 0
    Scanner(string: redString).scanHexInt32(&r)
    Scanner(string: greenString).scanHexInt32(&g)
    Scanner(string: blueString).scanHexInt32(&b)

    return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}

struct AnimationSpecifier {
    var delay: TimeInterval
    var duration: TimeInterval
    var curve: UIViewAnimationOptions
}

open class Theme: NSObject {
    var name: String
    var parentTheme: Theme?

    fileprivate let themeDictionary: NSDictionary
    fileprivate let colorCache: NSCache<AnyObject, AnyObject>
    fileprivate let fontCache: NSCache<AnyObject, AnyObject>

    // MARK: - Init
    init(fromDictionary themeDictionary: NSDictionary) {
        name = "Default"
        parentTheme = nil
        colorCache = NSCache()
        fontCache = NSCache()
        self.themeDictionary = themeDictionary
    }

    // MARK: - Queries
    func objectForKey(_ key: String) -> AnyObject? {
        var obj: AnyObject? = themeDictionary[key]
        if obj == nil {
            obj = parentTheme?.objectForKey(key)
        }
        return obj
    }

    func boolForKey(_ key: String) -> Bool? {
        let obj: AnyObject? = objectForKey(key)
        if obj == nil {
            return false
        }
        return obj as! Bool!
    }

    func stringForKey(_ key: String) -> String? {
        let obj: AnyObject? = objectForKey(key)
        if obj == nil {
            return nil
        }
        if obj is String {
            return obj as! String!
        }
        if obj is NSNumber {
            return (obj as! NSNumber!).stringValue
        }
        return nil
    }

    func integerForKey(_ key: String) -> Int {
        let obj: AnyObject? = objectForKey(key)
        if obj == nil {
            return 0
        }
        return obj as! Int
    }

    func floatForKey(_ key: String) -> CGFloat {
        let obj: AnyObject? = objectForKey(key)
        if obj == nil {
            return 0.0
        }
        return obj as! CGFloat
    }

    func doubleForKey(_ key: String) -> Double {
        let obj: AnyObject? = objectForKey(key)
        if obj == nil {
            return 0.0
        }
        return obj as! Double
    }

    func imageForKey(_ key: String) -> UIImage? {
        let imageName = stringForKey(key)
        if stringIsEmpty(imageName) {
            return nil
        }
        return UIImage(named: imageName!)
    }

    func colorForKey(_ key: String) -> UIColor {
        let cachedColor: UIColor? = colorCache.object(forKey: key as AnyObject) as? UIColor
        if cachedColor != nil {
            return cachedColor!
        }
        let colorString = stringForKey(key)
<<<<<<< Updated upstream
        var color = colorWithHexString(colorString)
        colorCache.setObject(color, forKey: key)
=======
        let color = colorWithHexString(colorString)
        colorCache.setObject(color, forKey: key as AnyObject)
>>>>>>> Stashed changes
        return color
    }

    func edgeInsetsForKey(_ key: String) -> UIEdgeInsets {
        let left: CGFloat = floatForKey(key + "Left")
        let top: CGFloat = floatForKey(key + "Top")
        let right: CGFloat = floatForKey(key + "Right")
        let bottom: CGFloat = floatForKey(key + "Bottom")
        return UIEdgeInsetsMake(top, left, bottom, right)
    }

    func fontForKey(_ key: String) -> UIFont {
        let cachedFont = fontCache.object(forKey: key as AnyObject) as? UIFont
        if cachedFont != nil {
            return cachedFont!
        }
        let fontName = stringForKey(key)
        var fontSize = floatForKey(key + "Size")
        if fontSize < 15.0 {
            fontSize = 15.0
        }
        var font: UIFont
        if stringIsEmpty(fontName) {
            font = UIFont.systemFont(ofSize: fontSize)
        } else {
            font = UIFont(name: fontName!, size: fontSize)!
        }
        fontCache.setObject(font, forKey: key as AnyObject)
        return font
    }

    func pointForKey(_ key: String) -> CGPoint {
        let pointX = floatForKey(key + "X")
        let pointY = floatForKey(key + "Y")
        return CGPoint(x: pointX, y: pointY)
    }

    func sizeForKey(_ key: String) -> CGSize {
        let width = floatForKey(key + "Width")
        let height = floatForKey(key + "Height")
        return CGSize(width: width, height: height)
    }

<<<<<<< Updated upstream
    func timeIntervalForKey(key: String) -> NSTimeInterval {
        var obj: AnyObject? = objectForKey(key)
=======
    func timeIntervalForKey(_ key: String) -> TimeInterval {
        let obj: AnyObject? = objectForKey(key)
>>>>>>> Stashed changes
        if obj == nil {
            return 0.0
        }
        return obj as! Double!
    }

    func curveForKey(_ key: String) -> UIViewAnimationOptions {
        var curveString = stringForKey(key)!
        if stringIsEmpty(curveString) {
            return UIViewAnimationOptions()
        }
        curveString = curveString.lowercased()
        if curveString == "easeinout" {
            return UIViewAnimationOptions()
        } else if curveString == "easeout" {
            return .curveEaseOut
        } else if curveString == "easein" {
            return .curveEaseIn
        } else if curveString == "linear" {
            return .curveLinear
        }
        return UIViewAnimationOptions()
    }

    func animationSpecifierForKey(_ key: String) -> AnimationSpecifier {
        let duration = timeIntervalForKey(key + "Duration")
        let delay = timeIntervalForKey(key + "Delay")
        let curve = curveForKey(key + "Curve")
        return AnimationSpecifier(delay: delay, duration: duration, curve: curve)
    }

<<<<<<< Updated upstream
    func textCaseForKey(key: String) -> TextCaseTransform {
        var s = stringForKey(key)
=======
    func textCaseForKey(_ key: String) -> TextCaseTransform {
        let s = stringForKey(key)
>>>>>>> Stashed changes
        if s == nil {
            return .none
        }
        if s!.caseInsensitiveCompare("lowercase") == ComparisonResult.orderedSame {
            return .lower
        } else if s!.caseInsensitiveCompare("uppercase") == ComparisonResult.orderedSame {
            return .upper
        }
        return .none
    }

    func animateWithAnimationSpecifierKey(_ animationSpecifierKey: String, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        let animationSpecifier = animationSpecifierForKey(animationSpecifierKey)
        UIView.animate(withDuration: animationSpecifier.duration,
            delay: animationSpecifier.delay,
            options: animationSpecifier.curve,
            animations: animations,
            completion: completion)
    }
}
