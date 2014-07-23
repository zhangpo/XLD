//
//  AKFastTextField.h
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKFastTextField : NSObject
+(UITextField*)textFieldWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor andBorderStyle:(UITextBorderStyle)aBorderStyle andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont;
@end
