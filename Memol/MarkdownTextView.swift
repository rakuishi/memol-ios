//
//  MarkdownTextView.swift
//  Memol
//
//  Created by OCHIISHI Koichiro on 2015/03/15.
//  Copyright (c) 2015年 OCHIISHI Koichiro. All rights reserved.
//

import UIKit

class MarkdownTextView: UITextView, UITextViewDelegate, UIScrollViewDelegate {
    
    var themeTextColor: UIColor!
    var themeBackgroundColor: UIColor!
    var themeHeadColor: UIColor!
    var themeTintColor: UIColor!
    var themeCodeColor: UIColor!
    var themeFont: UIFont!
    var themeBoldFont: UIFont!
    var timer: NSTimer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // default set color & font
        self.themeTextColor = UIColor(rgb: "#464646")
        self.themeBackgroundColor = UIColor(rgb: "#FBFBFB")
        self.themeHeadColor = UIColor(rgb: "#92A5A6")
        self.themeTintColor = UIColor(rgb: "#EFB944")
        self.themeCodeColor = UIColor(rgb: "#92A5A6")
        
        self.themeFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        self.themeBoldFont = UIFont(name: "AvenirNext-DemiBold", size: 16.0)
        
        self.backgroundColor = self.themeBackgroundColor;
        self.textColor = self.themeTextColor;
        self.font = self.themeFont;
        self.tintColor = self.themeTintColor;

        self.delegate = self;
        
        var string = markdownAttributedString(self.text, range: NSRange(location: 0, length: countElements(self.text)))
        self.textStorage.setAttributedString(string)
    }
    
    func setTimerSchedule() {
        if let t = timer {
            t.invalidate()
            timer = nil
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "updateMarkdown", userInfo: nil, repeats: false)
    }
    
    func updateMarkdown() {
        var string = markdownAttributedString(self.text, range: NSRange(location: 0, length: countElements(self.text)))
        self.textStorage.setAttributedString(string)
    }
    
    // MARK: Markdown func
    
    func markdownAttributedString(string: NSString, range: NSRange) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.setAttributes(markdownTextAttribute(), range: range)
        
        var markdownResults = MarkdownParser.load(string);
        for result: Markdown in markdownResults {
            switch result.element {
            case .Head:
                attributedString.addAttributes(markdownHeadAttribute(), range: result.range)
            case .Bold:
                attributedString.addAttributes(markdownBoldAttribute(), range: result.range)
            case .List:
                attributedString.addAttributes(markdownListAttribute(), range: result.range)
            case .Blockquote:
                attributedString.addAttributes(markdownBlockquoteAttribute(), range: result.range)
            case .Code, .Link, .Image:
                attributedString.addAttributes(markdownCodeAttribute(), range: result.range)
            default:
                break
            }
        }
        
        return attributedString;
    }
    
    func markdownTextAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeFont,
            NSForegroundColorAttributeName: self.themeTextColor
        ]
    }
    
    func markdownHeadAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeBoldFont,
            NSForegroundColorAttributeName: self.themeHeadColor
        ]
    }

    func markdownBoldAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeBoldFont,
            NSForegroundColorAttributeName: self.themeTextColor
        ]
    }

    func markdownListAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeFont,
            NSForegroundColorAttributeName: self.themeTintColor
        ]
    }

    func markdownBlockquoteAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeBoldFont,
            NSForegroundColorAttributeName: self.themeTextColor
        ]
    }
    
    func markdownCodeAttribute() -> [NSObject: AnyObject] {
        return [
            NSFontAttributeName: self.themeFont,
            NSForegroundColorAttributeName: self.themeCodeColor
        ];
    }
    
    // MARK: UITextViewDelegate
    
    func textViewDidChange(textView: UITextView) {
        setTimerSchedule()
    }

    // MARK: UIScrollViewDelegate

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        setTimerSchedule()
    }
}
