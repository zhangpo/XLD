//
//  AKDeskMainViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import <UIKit/UIKit.h>
#import "BSTableButton.h"       //
#import "BSSwitchTableView.h"
#import "BSOpenTableView.h"
#import "AKsWaitSeat.h"
#import "AKsWaitSeatOpenTable.h"
#import "AKsNetAccessClass.h"
#import "AKschangeTableView.h"
#import "AKsYudianShow.h"
#import "AKsRemoveYudingView.h"
#import "AKsOpenSucceed.h"
#define kOpenTag    700
#define kCancelTag  701
#define kdish       702

@interface AKDeskMainViewController : UIViewController<BSTableButtonDelegate,SwitchTableViewDelegate,OpenTableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,AKsWaitSeatDelegate,AKsWaitSeatOpenTableDelegate,AKsNetAccessClassDelegate,AKschangeTableViewDelegate,AKsYudianShowDelegate,AKsRemoveYudingViewDelegate,UISearchBarDelegate,AKsOpenSucceedDelegate>
{
    MBProgressHUD *HUD;         //菊花条
    BSSwitchTableView *vSwitch; //换台及并台
    BSOpenTableView *vOpen;     //开台
    NSArray *deskClassArray;    //台位类别
    NSMutableArray *DESArray;   //台位名称
    UIScrollView *scvTables;
    int dSelectedIndex;
}
@end
