//
//  AKUpdata.h
//  BookSystem
//
//  Created by chensen on 14-6-18.
//
//

#import "BSRotateView.h"

@protocol AKUpdataDelegate <NSObject>

-(void)updata:(int)tag;

@end

@interface AKUpdata : BSRotateView
@property(nonatomic,weak)__weak id<AKUpdataDelegate>delegate;
- (id)initWithFrame:(CGRect)frame withString:(NSString *)html;
@end
