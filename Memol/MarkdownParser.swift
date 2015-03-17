//
//  MarkdownParser.swift
//  Memol
//
//  Created by OCHIISHI Koichiro on 2015/03/15.
//  Copyright (c) 2015年 OCHIISHI Koichiro. All rights reserved.
//

import UIKit

enum MarkdownElement : Printable {
    case Head
    case Bold
    case List
    case Blockquote
    case Code
    case Link
    case Image
    
    var description : String {
        get {
            var prefix = "MarkdownElement."
            switch(self) {
            case Head:
                return prefix + "Head"
            case Bold:
                return prefix + "Bold"
            case List:
                return prefix + "List"
            case Blockquote:
                return prefix + "Blockquote"
            case Code:
                return prefix + "Code"
            case Link:
                return prefix + "Link"
            case Image:
                return prefix + "Image"
            }
        }
    }
}

struct Markdown {
    var element: MarkdownElement
    var range  : NSRange
    
    init (element: MarkdownElement, range: NSRange) {
        self.element = element
        self.range = range
    }
}

class MarkdownParser: NSObject {
    
    class func load(string: String) -> [Markdown] {
        var markdowns = [Markdown]()
        var markdownPatterns = [MarkdownElement : NSString]()

        // setup markdown pattern
        markdownPatterns = [
            MarkdownElement.Head : "(\\n#+.*)",
            MarkdownElement.Bold : "(\\*.+?\\*)",
            MarkdownElement.List : "(\\n[\\*|-])\\s",
            MarkdownElement.Blockquote : "(\\n\\>)\\s",
            MarkdownElement.Code : "(`.+?`)",
            MarkdownElement.Link : "(\\[[^\\]]*\\]\\([^\\)]*\\))",
            MarkdownElement.Image : "(!\\[[^\\]]*\\]\\([^\\)]*\\))",
        ]

        for (element, pattern) in markdownPatterns {
            let regex = NSRegularExpression(pattern: pattern, options: nil, error: nil)

            regex?.enumerateMatchesInString(string, options: nil, range: NSMakeRange(0, countElements(string)),
                usingBlock: {(result: NSTextCheckingResult!, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    let range = result.rangeAtIndex(1)
                    markdowns.append(Markdown(element: element, range: range))
                    // let startIndex:String.Index = advance(string.startIndex, range.location)
                    // let endIndex = advance(string.startIndex, NSMaxRange(range))
                    // let rangeString = string[startIndex..<endIndex]
                    // println("\(element) -> \(range) : \(rangeString)")
            })
        }
        
        return markdowns
    }
}
