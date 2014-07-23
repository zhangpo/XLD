//
//  AKOrderRepastViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//

#import <UIKit/UIKit.h>
#import "BSDataProvider.h"
#import "AKMySegmentAndView.h"
#import "BSAddtionView.h"
@interface AKOrderRepastViewController : UIViewController<UISearchBarDelegate,AKMySegmentAndViewDelegate,AdditionViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *classArray;
    IBOutlet UIScrollView *aScrollView;
}
@end
