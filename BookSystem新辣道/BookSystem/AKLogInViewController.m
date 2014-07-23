//
//  AKLogInViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-6.
//
//

#import "AKLogInViewController.h"
#import "AKDeskMainViewController.h"    //台位界面
#import "AKSettingUpViewController.h"   //设置界面
#import "BSDataProvider.h"              //公共类
#import "Singleton.h"                   //单例类
#import "BSSettingViewController.h"     //设置跳转界面
#import "PaymentSelect.h"
#import "NSString+Encrypt.h"
#import "AKUpdata.h"                //自动更新内容界面
#define HHTserviceMin @"7.0.16"     //hhtservice最小支持版本号
#define HHTserviceMax @"7.0.16"     //hhtservice最大支持版本号
@interface AKLogInViewController ()
{
    UILabel *lb;                    //显示当前员工号
    AKUpdata *_updata;              //自动更新界面
}
@end

@implementation AKLogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    if ([[Singleton sharedSingleton].userInfo objectForKey:@"user"]==nil) {
        lb.text=@"";
    }
    else
    {
        lb.text=[NSString stringWithFormat:@"用户名:%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
	// Do any additional setup after loading the view.
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground=YES;
    HUD.delegate=self;
    [HUD show:YES];
    HUD.labelText=@"数据请求中...";
    self.textField2.secureTextEntry = YES;
    lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, 750, 30)];
    lb.textAlignment=NSTextAlignmentRight;
    [self.view addSubview:lb];
    lb.backgroundColor=[UIColor clearColor];
    _keyboardView = [[ZenKeyboardView alloc] initWithFrame:CGRectMake(135, 1024-650, 490, 400)];
    _keyboardView.delegate = self;
    self.textField1.delegate=self;
    self.textField2.delegate=self;
    self.textField1.frame=CGRectMake(300, 270, 250, 40);
    self.textField1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    self.textField2.frame=CGRectMake(300, 325, 250, 40);
    [self.textField1 becomeFirstResponder];
    [self.view addSubview:_keyboardView];
    _keyboardView=nil;
//    [self isupdata];
}

#pragma mark ZenKeyboardViewDelegate
- (void)didNumericKeyPressed:(UIButton *)button
{
    if([button.titleLabel.text isEqualToString:@"完成"])
    {
        if ([self.textField1 isFirstResponder])
        {
            [self.textField2 becomeFirstResponder];
        }
        else
        {
            [self.textField1 becomeFirstResponder];
        }
    }
    else if ([button.titleLabel.text isEqualToString:@"删除"])
    {
        [self didBackspaceKeyPressed];
    }
    else
    {
        if ([self.textField1 isFirstResponder])
        {
            self.textField1.text = [NSString stringWithFormat:@"%@%@", self.textField1.text, button.titleLabel.text];
        }else
        {
            self.textField2.text = [NSString stringWithFormat:@"%@%@", self.textField2.text, button.titleLabel.text];
        }
    }
    
}

- (void)didBackspaceKeyPressed {
    if ([self.textField1 isFirstResponder]) {
        NSInteger length = self.textField1.text.length;
        if (length == 0) {
            self.textField1.text = @"";
            return;
        }
        self.textField1.text = [self.textField1.text substringWithRange:NSMakeRange(0, length - 1)];
    }else
    {
        NSInteger length = self.textField2.text.length;
        if (length == 0) {
            self.textField2.text = @"";
            return;
        }
        self.textField2.text = [self.textField2.text substringWithRange:NSMakeRange(0, length - 1)];
    }
    
}
-(void)zenKeychongzhiDelegate
{
    self.textField1.text=@"";
    self.textField2.text=@"";
    [self.textField1 becomeFirstResponder];
}
-(void)zenKeydengluDelegate
{
    [self logIn:nil];
}

#pragma mark 程序自动更新
-(void)isupdata
{
    BSDataProvider *bs=[[BSDataProvider alloc] init];
    NSDictionary *dict=[bs isTypUpdateWebService];      //判断是否需要更新
    if ([[dict objectForKey:@"text"] intValue]==1) {    //如果返回值为1需要更新
        NSDictionary *dict1=[bs getTypUpdateCont];      //返回更新内容
        if ([[dict1 objectForKey:@"text"] length]>3) {  //由于接口没有返回正确序号这里用长度判断
            _updata=[[AKUpdata alloc] initWithFrame:CGRectMake(0, 0, 492, 500) withString:[dict1 objectForKey:@"text"]];                 //初始化提示更新内容界面
            _updata.center = CGPointMake(384, 512);
            _updata.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
            [self.view addSubview:_updata];
            _updata.delegate=self;
            [UIView animateWithDuration:0.5f animations:^(void) {
                _updata.transform = CGAffineTransformIdentity;
            }];
            _updata=nil;
        }
        dict1=nil;
    }
    dict=nil;
    bs=nil;
}
#pragma mark AKUpdataDelegate
-(void)updata:(int)tag
{
    if (tag==1) {
        BSDataProvider *bs=[[BSDataProvider alloc] init];
        NSDictionary *dict=[bs findVersionPADWebService];               //需要更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[dict objectForKey:@"text"] substringToIndex:[[dict objectForKey:@"text"] length]-1]]]; //调用系统浏览器打开网站
        bs=nil;
        dict=nil;
    }
    [_updata removeFromSuperview];
    _updata=nil;
}

#pragma mark 登录按钮事件
- (IBAction)logIn:(UIButton *)sender {
//    [self AKOrder];
    [self.view addSubview:HUD];
    if (self.textField1.text.length&&self.textField2.text.length) {
        NSDictionary *requestDic = [NSDictionary dictionaryWithObjectsAndKeys:self.textField1.text,@"userCode",self.textField2.text,@"usePass", nil];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            NSDictionary *dict=[self loginRequest:requestDic];      //请求数据
            dispatch_async(dispatch_get_main_queue(), ^{
                // 更新界面
                if (dict) {
                    [HUD removeFromSuperview];
                    NSArray *ary = [[[dict objectForKey:@"ns:return"] objectForKey:@"text"] componentsSeparatedByString:@"@"];
                    if ([ary count]==1) {   //容错，防止hhtservice调用失败
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                       message:[ary lastObject]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil];
                        [alert show];
                        alert=nil;
                    }
                    else
                    {
                        NSString *content=[ary objectAtIndex:1];
                        if ([[ary objectAtIndex:0] isEqualToString:@"0"]) {
                            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
                            [dict1 setObject:self.textField1.text forKey:@"user"];
                            [dict1 setObject:self.textField2.text forKey:@"password"];
                            [AKsNetAccessClass sharedNetAccess].UserPass=self.textField1.text;
                            [Singleton sharedSingleton].userInfo=dict1;
                            dict1=nil;
                            [AKsNetAccessClass sharedNetAccess].baoliuXiaoshu=[ary objectAtIndex:3];
                            [Singleton sharedSingleton].Time=[ary objectAtIndex:1];
                            [AKsNetAccessClass sharedNetAccess].dataVersion=[ary objectAtIndex:4];
                            [Singleton sharedSingleton].userName=[ary objectAtIndex:6];
                            //版本号验证
                            NSString *min=HHTserviceMin;
                            NSString *max=HHTserviceMax;
                            if ([ary lastObject]) {
                                NSArray *array1=[[ary lastObject] componentsSeparatedByString:@"."];
                                NSArray *array2=[min componentsSeparatedByString:@"."];
//                                NSArray *array3=[max componentsSeparatedByString:@"."];
                                for (int i=0; i<3; i++) {
                                    if([[array1 objectAtIndex:i] intValue]<[[array2 objectAtIndex:i] intValue])
                                    {
                                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"HHTservice版本号低，请联系网管，及时更新%@以上版本的程序",min] message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                                        [alert show];
                                        alert=nil;
                                        return ;
                                    }
                                    //注释为验证高版本号，如果程序稳定，可取消注释
//                                    if([[array1 objectAtIndex:i] intValue]>[[array3 objectAtIndex:i] intValue])
//                                    {
//                                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"iPad版本不适用现在的HHTservice，请联系总部人员更新" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
//                                        [alert show];
//                                        return ;
//                                    }
                                }
                                array1=nil;
                                array2=nil;
                            }
                            if([ary objectAtIndex:4] && [ary objectAtIndex:5])
                            {
                                //判断数据版本号是否相同，在mis库里的store表里可以找到当前版本号
                                if([[ary objectAtIndex:4]isEqualToString:[ary objectAtIndex:5]])
                                {
                                    //程序登录成功进入台位界面
                                    AKDeskMainViewController *deskMainViewController = [[AKDeskMainViewController alloc]initWithNibName:nil bundle:nil];
                                    [self.navigationController pushViewController:deskMainViewController animated:YES];
                                    deskMainViewController=nil;
                                }
                                else
                                {
                                    bs_dispatch_sync_on_main_thread(^{
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                       message:@"数据版本已更新，是否FTP同步数据"
                                                                                      delegate:self
                                                                             cancelButtonTitle:@"否"
                                                                             otherButtonTitles:@"是",nil];
                                        alert.tag=4;
                                        [alert show];
                                        alert=nil;
                                    });
                                }
                            }
                            
                        }
                        else
                        {
                            //当hhtservice没有打开，或hhtservice程序挂之后会调用此方法
                            [HUD removeFromSuperview];
                            if (content==nil) {
                                content=@"HHTService未响应，请检查是否正常运行";
                            }
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                           message:content
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"确定"
                                                                 otherButtonTitles:nil];
                            [alert show];
                        }
                    }
                    ary=nil;
                }
                else
                {
                    //当程序连着不到服务器会调用此方法
                    [HUD removeFromSuperview];
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                   message:@"网络连接超时,请检验设备的IP地址是否设置正确或服务器tomcat是否运行"
                                                                  delegate:nil
                                                         cancelButtonTitle:@"确定"
                                                         otherButtonTitles:nil];
                    [alert show];
                    alert=nil;
                }
            });
            dict =nil;
        });
        requestDic = nil;
        
    }else{
        [HUD removeFromSuperview];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"请输入完整的“员工编号”和“密码”！"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        alert=nil;
    }
    
}
#pragma mark 登录请求
//登录请求
-(NSDictionary *)loginRequest:(NSDictionary *)requestDic
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp pLoginUser:requestDic];
    dp=nil;
    return dict;
}
#pragma mark 设置
- (IBAction)settingUp:(UIButton *)sender//设置
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"密码" message:@"请输入密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alertView.tag=3;
    [alertView show];
    alertView=nil;
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==4)
    {
        if(buttonIndex==1)
        {
            //直接跳转到数据更新
            bs_dispatch_sync_on_main_thread(^{
            BSSettingViewController *vcSetting = [[BSSettingViewController alloc] initWithType:BSSettingTypeUpdate];
            [self.navigationController pushViewController:vcSetting animated:YES];
            vcSetting=nil;
            });
        }
    }
    //    else if (alertView.tag==5)
    //    {
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://115.238.164.148:8070/ChoiceIpad/ChoiceApp.html"]];
    //        exit(0);
    //    }
    else if (alertView.tag==3) {
        if (buttonIndex==1) {
            NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
            NSTimeZone *zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
            NSInteger interval = [zone secondsFromGMTForDate:datenow]+60*60*24*3;//将当前的时间+3天，与公司快餐pos相同算法
            zone=nil;
            NSDate *localeDate = [datenow  dateByAddingTimeInterval: interval];
            datenow=nil;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yy"];
            //用[NSDate date]可以获取系统当前时间
            NSString *yy = [dateFormatter stringFromDate:localeDate];
            [dateFormatter setDateFormat:@"MM"];
            //用[NSDate date]可以获取系统当前时间
            NSString *MM = [dateFormatter stringFromDate:localeDate];
            [dateFormatter setDateFormat:@"dd"];
            //用[NSDate date]可以获取系统当前时间
            NSString *dd = [dateFormatter stringFromDate:localeDate];
            dateFormatter=nil;
            NSString *str=[NSString stringWithFormat:@"%@%@%@",dd,MM,yy];
            dd=nil;
            MM=nil;
            yy=nil;
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            if ([tf1.text isEqualToString:str]) {
                //跳转到台位界面
                AKSettingUpViewController *settingUpViewController = [[AKSettingUpViewController alloc]initWithNibName:nil bundle:nil];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:settingUpViewController];
                settingUpViewController=nil;
                nav.modalPresentationStyle = UIModalPresentationFormSheet;
                [self presentModalViewController:nav animated:YES];
                nav=nil;
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"密码错误，请重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                alert=nil;
            }
            
        }
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];//即使没有显示在window上，也不会自动的将self.view释放。
        lb=nil;
        _updata=nil;
    
}
#pragma arguments UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.inputView=[[UIView alloc]initWithFrame:CGRectZero];
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)Notification{
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    [tempWindow setAlpha:0];
}
@end
