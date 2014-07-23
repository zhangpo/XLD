//
//  AKFastView.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-22.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastView.h"

@implementation AKFastView
+(UIView*)viewWithWithFrame:(CGRect)aFrame andBackgroundColor:(UIColor*)aBackgroundColor
{
    UIView *view = [[[UIView alloc]initWithFrame:aFrame] autorelease];
    view.backgroundColor = aBackgroundColor;
    return view;
}
@end
