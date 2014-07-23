//
//  AKFastImageView.m
//  鲁花
//
//  Created by 凯_SKK on 13-1-21.
//  Copyright (c) 2013年 山东乐世安通通信技术有限公司. All rights reserved.
//

#import "AKFastImageView.h"

@implementation AKFastImageView
+(UIImageView*)imageViewWithFrame:(CGRect)aFrame andImage:(UIImage*)aImage
{
    UIImageView *imageView = [[[UIImageView alloc]initWithFrame:aFrame] autorelease];
    [imageView setImage:aImage];
    return imageView;
}
@end
