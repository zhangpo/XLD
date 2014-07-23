//
//  BSAddtionViewController.h
//  BookSystem
//
//  Created by Dream on 11-5-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSRotateView.h"
@protocol AdditionViewDelegate

- (void)additionSelected:(NSArray *)ary;

@end

@interface BSAddtionView : BSRotateView <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UITableView *tv;
    UIButton *btnConfirm,*btnCancel;
    UITextField *tfAddition;
    NSDictionary *dicInfo;
    UISearchBar *barAddition;
    UIView *vAddition;
    
    
}
@property (nonatomic,strong) NSDictionary *dicInfo;
@property (nonatomic,weak)__weak id<AdditionViewDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *arySelectedAddtions,*aryAdditions,*aryResult;
@property(nonatomic,strong)UITableView *tv;
- (id)initWithFrame:(CGRect)frame;

@end
