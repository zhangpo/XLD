//
//  AKFastTextView.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastTextView.h"

@implementation AKFastTextView
+(UITextView*)textViewBoundaryWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor  andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont
{
    UITextView *textView = [[UITextView alloc]initWithFrame:aFrame];
    [textView setBackgroundColor:aColor];
    textView.textAlignment = UITextAlignmentLeft;
    textView.textColor = [UIColor blackColor];
    textView.keyboardType = aKeyboardType;
    [textView setFont:[UIFont systemFontOfSize:aFont]];
    
    textView.layer.borderWidth = 1;
    [textView.layer setCornerRadius:5];
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    
    return textView;
}
+(UITextView*)textViewNormalWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor  andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont
{
    UITextView *textView = [[UITextView alloc]initWithFrame:aFrame];
    [textView setBackgroundColor:aColor];
    textView.textAlignment = UITextAlignmentLeft;
    textView.textColor = [UIColor blackColor];
    textView.keyboardType = aKeyboardType;
    [textView setFont:[UIFont systemFontOfSize:aFont]];
    return textView;
}
@end
