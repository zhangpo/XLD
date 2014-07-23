//
//  AKLogInViewController.h
//  BookSystem
//
//  Created by chensen on 13-11-6.
//
//
/*
    该程序由2个人完成，有的方法可能写2次，预结算+等位一个人完成，剩余一个人完成
    本程序可能有很大的内存问题，由中餐程序修改而成，将非arc转成arc
    本程序的请求方法有asi和自己封装的BSDataProvider
 */
#import "MBProgressHUD.h"
#import <UIKit/UIKit.h>
#import "AKsNetAccessClass.h"
#import "ZenKeyboardView.h"
#import "AKUpdata.h"
@interface AKLogInViewController : UIViewController<MBProgressHUDDelegate,UITextFieldDelegate,AKsNetAccessClassDelegate,ZenKeyboardViewDelegate,AKUpdataDelegate>
{
    MBProgressHUD *HUD;
}
@property (retain, nonatomic) IBOutlet UITextField *textField1; //账号
@property (retain, nonatomic) IBOutlet UITextField *textField2; //密码
@property (nonatomic, retain) ZenKeyboardView *keyboardView;    //键盘
@end
