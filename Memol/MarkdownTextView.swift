//
//  MarkdownTextView.swift
//  Memol
//
//  Created by OCHIISHI Koichiro on 2015/03/15.
//  Copyright (c) 2015年 OCHIISHI Koichiro. All rights reserved.
//

import UIKit

class MarkdownTextView: UITextView {
    
    var themeTextColor: UIColor!
    var themeBackgroundColor: UIColor!
    var themeHeadColor: UIColor!    // Head
    var themeTintColor: UIColor!    // Bold, List
    var themeCodeColor: UIColor!    // Code, CodeBlock, Link, Image
    var themeFont: UIFont!
    var themeBoldFont: UIFont!
    
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
        
        self.themeFont = UIFont(name: "AvenirNext-Medium", size: 15.0)
        self.themeBoldFont = UIFont(name: "AvenirNext-DemiBold", size: 15.0)
        
        self.backgroundColor = self.themeBackgroundColor;
        self.textColor = self.themeTextColor;
        self.font = self.themeFont;
        self.tintColor = self.themeTintColor;

        self.attributedText = rendarMarkdown(self.text)
    }
    
    func rendarMarkdown(string: NSString) -> NSMutableAttributedString {
        
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.setAttributes(textAttribute(), range: NSRange(location: 0, length: string.length))
        
        var markdownResults = MarkdownParser.load(string);
        for result: Markdown in markdownResults {
            switch result.element {
            case .Head:
                attributedString.addAttributes(headAttribute(), range: result.range)
            default:
                break
            }
        }
        
        return attributedString;
    }
    
    func textAttribute() -> [NSObject: AnyObject] {
        return [NSFontAttributeName: self.themeFont, NSForegroundColorAttributeName: self.themeTextColor]
    }
    
    func headAttribute() -> [NSObject: AnyObject] {
        return [NSFontAttributeName: self.themeBoldFont, NSForegroundColorAttributeName: self.themeHeadColor]
    }
}
