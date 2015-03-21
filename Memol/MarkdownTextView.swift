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
        
        self.themeFont = UIFont(name: "AvenirNext-Regular", size: 16.0)
        self.themeBoldFont = UIFont(name: "AvenirNext-Medium", size: 16.0)
        
        self.backgroundColor = self.themeBackgroundColor
        self.textColor = self.themeTextColor
        self.font = self.themeFont
        self.tintColor = self.themeTintColor

        self.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        rendarMarkdown(self.text, range: visibleRange())
    }
    
    func setTimerSchedule() {
        if let t = timer {
            t.invalidate()
            timer = nil
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "updateMarkdown", userInfo: nil, repeats: false)
    }
    
    func updateMarkdown() {
        rendarMarkdown(self.text, range: visibleRange())
    }
    
    func updateInsets(height: CGFloat) {
        var insets = UIEdgeInsetsMake(0.0, 0.0, height, 0.0)
        self.contentInset = insets
        self.scrollIndicatorInsets = insets
    }

    func visibleRange() -> NSRange {
        var bounds:CGRect = self.bounds
        var start = self.beginningOfDocument
        var end = self.endOfDocument

        var startpoint = self.characterRangeAtPoint(bounds.origin)
        if let s = startpoint {
            start = s.start
        }
        
        var endpoint = self.characterRangeAtPoint(CGPointMake(CGRectGetMaxX(bounds), CGRectGetMaxY(bounds)))
        if let e = endpoint {
            end = e.end
        }
        
        var loc = self.offsetFromPosition(self.beginningOfDocument, toPosition:start)
        var length = self.offsetFromPosition(start, toPosition: end)
        
        return NSMakeRange(loc, length)
    }
    
    // MARK: Markdown func
    
    func rendarMarkdown(string: NSString, range: NSRange) {
        // @see http://stackoverflow.com/questions/16716525/replace-uitextviews-text-with-attributed-string
        // Just disable scrolling before formatting text and enable it after formatting
        self.scrollEnabled = false

        // let attributedString = NSMutableAttributedString(string: string)
        self.textStorage.addAttributes(markdownTextAttribute(), range: range)
        
        var markdownResults = MarkdownParser.load(string);
        for result: Markdown in markdownResults {
            switch result.element {
            case .Head:
                self.textStorage.addAttributes(markdownHeadAttribute(), range: result.range)
            case .Bold:
                self.textStorage.addAttributes(markdownBoldAttribute(), range: result.range)
            case .List:
                self.textStorage.addAttributes(markdownListAttribute(), range: result.range)
            case .Blockquote:
                self.textStorage.addAttributes(markdownBlockquoteAttribute(), range: result.range)
            case .Code, .Link, .Image:
                self.textStorage.addAttributes(markdownCodeAttribute(), range: result.range)
            default:
                break
            }
        }
        
        self.scrollEnabled = true
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
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.contentOffset.y <= -50 {
            resignFirstResponder()
        }
    }

    // MARK: Keyboard Delegate
    
    func keyboardDidShow(notification: NSNotification) {
        if let rectValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardSize = rectValue.CGRectValue().size
            updateInsets(keyboardSize.height)
        }
    }
    
    func keyboardDidHide(notification: NSNotification) {
        updateInsets(0)
    }

}
