//
//  AKFastTextView.h
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
@interface AKFastTextView : NSObject
+(UITextView*)textViewBoundaryWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor  andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont;
+(UITextView*)textViewNormalWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aColor  andKeyboardType:(UIKeyboardType)aKeyboardType andFont:(NSInteger)aFont;
@end
