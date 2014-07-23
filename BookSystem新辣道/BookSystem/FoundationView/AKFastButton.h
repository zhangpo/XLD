//
//  AKFastButton.h
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKFastButton : NSObject
//图片当背景文字当标题的普通Button
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalTitle:(NSString *)aTitle andBackgroundImage:(UIImage*)aImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction;

//图片当标题的普通Button
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction;

//图片当标题有选中不选中区别的Button
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andSelectedImage:(UIImage*)aSelectedImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction;

//图片当标题的普通Button  带tag
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction andTag:(NSInteger)aTag;
//图片当背景文字当标题的普通Button 带tag
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalTitle:(NSString *)aTitle andBackgroundImage:(UIImage*)aImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction andTag:(NSInteger)aTag;
@end
