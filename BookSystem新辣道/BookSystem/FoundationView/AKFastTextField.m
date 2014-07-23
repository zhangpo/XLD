//
//  AKFastTextField.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastTextField.h"

@implementation AKFastTextField
+(UITextField*)textFieldWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor andBorderStyle:(UITextBorderStyle)aBorderStyle andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont
{
    UITextField *textField = [[[UITextField alloc]initWithFrame:aFrame] autorelease];
    textField.textAlignment = UITextAlignmentLeft;
    textField.backgroundColor = aColor;
    textField.textColor = [UIColor blackColor];
    textField.borderStyle = aBorderStyle;
    textField.keyboardType = aKeyboardType;
    [textField setFont:[UIFont systemFontOfSize:aFont]];
    return textField;
}
@end
