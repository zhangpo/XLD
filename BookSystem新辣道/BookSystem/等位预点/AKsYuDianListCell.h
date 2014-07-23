//
//  AKsYuDianListCell.h
//  BookSystem
//
//  Created by sundaoran on 13-12-29.
//
//

#import <UIKit/UIKit.h>
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"

@interface AKsYuDianListCell : UITableViewCell

-(void)setCellForArray:(AKsCanDanListClass *)caidan;
-(void)setCellForAKsYouHuiList:(AKsYouHuiListClass *)list;

@end
