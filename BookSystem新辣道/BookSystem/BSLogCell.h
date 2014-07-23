//
//  BSLogCell.h
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAddtionView.h"

#define kPriceTag       700
#define kCountTag       701
#define kNoPhotoOffset  60.0f
@class BSLogCell;

@protocol  BSLogCellDelegate
-(void)cell:(BSLogCell *)cell present:(BOOL)ZS;
- (void)cell:(BSLogCell *)cell countChanged:(float)count;
- (void)cell:(BSLogCell *)cell priceChanged:(float)price;
-(void)cell:(BSLogCell *)cell count:(float)count;
- (void)cell:(BSLogCell *)cell additionChanged:(NSMutableArray *)additons;
@end

@interface BSLogCell : UITableViewCell <UIAlertViewDelegate,AdditionViewDelegate
>
@property (nonatomic,weak)__weak id<BSLogCellDelegate> delegate;
@property(nonatomic,strong)UIButton *btnAdd,*btnReduce,*jia,*jian,*btnEdit;
@property (nonatomic,strong) UILabel *lblName,*lblTotalPrice,*lblAddition,*lblAdditionPrice,*lblUnit,*lblSelected,*lb;
@property (nonatomic,strong) UILabel *tfPrice,*tfCount,*lblLine;
@property (nonatomic,strong) NSMutableArray *arySelectedAdditions;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) UITableView *supTableView;
- (void)setAddition;
@end
