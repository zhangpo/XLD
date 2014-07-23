//
//  BSLogViewController.h
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataProvider.h"
#import "BSCommonView.h"
#import "BSLogCell.h"
#import "BSChuckView.h"
#import "AKMySegmentAndView.h"
#import "AKsNetAccessClass.h"
#import "BSChuckView.h"
#import "BSAddtionView.h"
#import "MBProgressHUD.h"


@interface BSLogViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,BSLogCellDelegate,CommonViewDelegate,UISearchBarDelegate,UIActionSheetDelegate,AKMySegmentAndViewDelegate,AKsNetAccessClassDelegate,ChuckViewDelegate,AdditionViewDelegate,MBProgressHUDDelegate>{
    UITableView *tvOrder;
    UILabel *lblTitle;
    BSChuckView *vChuck;
    BSCommonView *vCommon;
    UILabel *lblCommon;
    NSArray *aryCommon;
}
@end
