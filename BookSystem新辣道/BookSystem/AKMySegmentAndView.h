//
//  AKMySegmentAndView.h
//  BookSystem
//
//  Created by sundaoran on 13-11-21.
//
//

#import <UIKit/UIKit.h>


@protocol AKMySegmentAndViewDelegate <NSObject>

@optional
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment;
-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage;

@end

@interface AKMySegmentAndView : UIView
{
    __weak id<AKMySegmentAndViewDelegate>_delegate;
}
@property(nonatomic,strong)UILabel *table,*CheckNum,*man,*woman;
@property(nonatomic,weak)__weak
id<AKMySegmentAndViewDelegate>delegate;

-(void)setsegmentIndex:(NSString *)index;
-(void)setTitle:(NSString *)title;


@end
