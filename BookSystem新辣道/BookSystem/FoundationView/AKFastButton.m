//
//  AKFastButton.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastButton.h"

@implementation AKFastButton
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalTitle:(NSString *)aTitle andBackgroundImage:(UIImage*)aImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction
{
    UIButton *button = [UIButton buttonWithType:aButtonType];
    button.frame = aFrame;
    [button setBackgroundImage:aImage forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction
{
    UIButton *button = [UIButton buttonWithType:aButtonType];
    button.frame = aFrame;
    [button setImage:aNormalImage forState:UIControlStateNormal];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andSelectedImage:(UIImage*)aSelectedImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction
{
    UIButton *button = [UIButton buttonWithType:aButtonType];
    button.frame = aFrame;
    [button setImage:aNormalImage forState:UIControlStateNormal];
    [button setImage:aSelectedImage forState:UIControlStateSelected];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalImage:(UIImage*)aNormalImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction andTag:(NSInteger)aTag
{
    UIButton *button = [UIButton buttonWithType:aButtonType];
    button.frame = aFrame;
    button.tag = aTag;
    [button setImage:aNormalImage forState:UIControlStateNormal];
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}
+(UIButton*)buttonWithType:(UIButtonType)aButtonType andFrame:(CGRect)aFrame andNormalTitle:(NSString *)aTitle andBackgroundImage:(UIImage*)aImage andTouchUpTarget:(id)aTarget andTouchUpAction:(SEL)aAction andTag:(NSInteger)aTag
{
    UIButton *button = [UIButton buttonWithType:aButtonType];
    button.frame = aFrame;
    button.tag = aTag;
    [button setBackgroundImage:aImage forState:UIControlStateNormal];
    [button setTitle:aTitle forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:12]];
//    button.titleLabel.textColor = [UIColor blackColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];;
//    button.titleLabel.textAlignment = UITextAlignmentCenter;
    [button addTarget:aTarget action:aAction forControlEvents:UIControlEventTouchUpInside];
    return button;
}
@end
