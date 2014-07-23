//
//  BSOpenTableView.h
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"

@protocol OpenTableViewDelegate

- (void)openTableWithOptions:(NSDictionary *)info;
-(void)VipClick;
@end

@interface BSOpenTableView : BSRotateView <UITextFieldDelegate>
{
    UIButton *btnConfirm,*btnCancel;
    UILabel *lblUser,*lblPeople,*lblWaiter;
    UITextField *tfUser,*tfPeople,*tfWaiter;
    __weak id<OpenTableViewDelegate>_delegate;
}
@property(nonatomic,strong)UIButton *btn;
@property (nonatomic,weak)__weak id<OpenTableViewDelegate>delegate;

@end
