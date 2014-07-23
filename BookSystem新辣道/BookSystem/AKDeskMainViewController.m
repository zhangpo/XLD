//
//  AKDeskMainViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//
#import "AKsNetAccessClass.h"           //数据类
#import "AKDeskMainViewController.h"
#import "BSDataProvider.h"              //数据类
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "BSDataProvider.h"
#import "BSQueryViewController.h"
#import "AKURLString.h"
#import "AKsVipViewController.h"
#import "AKsNetAccessClass.h"
#import "AKSelectCheck.h"
#import "PaymentSelect.h"
#import "Singleton.h"
#import "AKsCanDanListClass.h"
#import "AKOrderLeft.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "BSAllCheakRight.h"
#import "SVProgressHUD.h"
#import "PaymentSelect.h"
#import "AKsNewVipViewController.h"
//#import "AKMySegmentAndView.h"          

//#import "CVLocalizationSetting.h"
@interface AKDeskMainViewController ()

@end

@implementation AKDeskMainViewController
{
//    UIControl               *control;
    UISegmentedControl      *segment;           //台位类型
    AKsWaitSeat             *_waitView;         //等位预定
    AKsWaitSeatOpenTable    *_waitOpenView;     //等位开台
    NSMutableArray          *_dataArray;        //等位预定菜品
    NSMutableArray          *_youmianShowArray;
    AKschangeTableView      *_akschangeTable;
    AKsYudianShow           *_yuDianView;
    NSString                *_oldTableNum;
    NSString                *_newTableNum;
    AKsRemoveYudingView     *_removeYudianView;
    NSMutableDictionary     *_tabledict;        //当前选择的台位
    NSArray                 *_aryTables;        //台位列表
    AKsOpenSucceed          *_openSucceed;      //开台成功界面
    UIPanGestureRecognizer  *_pan;              //视图可被拖动
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Custom initialization
        }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Singleton sharedSingleton].CheckNum=nil;
    [Singleton sharedSingleton].man=nil;
    [Singleton sharedSingleton].woman=nil;
    [Singleton sharedSingleton].SELEVIP=NO;

    self.navigationController.navigationBarHidden = YES;
    
    bs_dispatch_sync_on_main_thread(^{
         [self updataTable];
    });
   
    AKsNetAccessClass *netAccess=[AKsNetAccessClass sharedNetAccess];
    netAccess.zhangdanId=NULL;
    [Singleton sharedSingleton].isYudian=NO;
    netAccess.PeopleManNum=NULL;
    netAccess.PeopleWomanNum=NULL;
    netAccess.phoneNum=NULL;
    netAccess.SettlemenVip=NO;
    netAccess.showVipMessageDict=nil;
    netAccess.yingfuMoney=NULL;
    netAccess.isVipShow=NO;
    [self dismissViews];
    if(_waitOpenView && _waitOpenView.superview)
    {
        [_waitOpenView removeFromSuperview];
        _waitOpenView=nil;
    }
    if (_waitView &&_waitView.superview)
    {
        [_waitView removeFromSuperview];
        _waitView = nil;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    for (UIView *view in scvTables.subviews) {
        [view removeFromSuperview];
    }
    [_dataArray removeAllObjects];
    [_tabledict removeAllObjects];
    _aryTables=nil;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSArray *array2=[dp getArea];
    dp=nil;
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    //查询状态
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"区域"]) {
        for (NSDictionary *dict in array2) {
            NSString *str=[dict objectForKey:@"TBLNAME"];
            [array1 addObject:str];
        }
        array2=nil;
        deskClassArray = [[NSArray alloc]initWithArray:array1];
        array1=nil;
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"楼层"]){
        deskClassArray = [[NSArray alloc]initWithArray:[dp getFloor]];
    }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"状态"]){
        deskClassArray = [[NSArray alloc]initWithArray:[dp getStatus]];
    }
    DESArray = [[NSMutableArray alloc]init];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"状态"]) {
        [DESArray setArray:deskClassArray];
    }else{
        for (NSString *str in deskClassArray) {
            [DESArray addObject:str];
        }
    }

    _tabledict=[NSMutableDictionary dictionary];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    segment = [[UISegmentedControl alloc] initWithItems:DESArray];
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"ArialRoundedMTBold"size:20],UITextAttributeFont ,[UIColor whiteColor],UITextAttributeTextShadowColor ,nil];
    [segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    dic=nil;
    segment.frame = CGRectMake(0, 0, 768, 40);
    
    [segment setBackgroundImage:[UIImage imageNamed:@"title.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segment];
    segment.selectedSegmentIndex = 0;
    scvTables = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 100, 718, 850)];
    [self.view addSubview:scvTables];
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    [HUD show:YES];
    HUD.labelText = @"数据加载中...";
    NSArray *array=[[NSArray alloc] initWithObjects:@"注销",@"等位预点",@"并台",@"换台",@"会员查询",@"查询账单",@"刷新", nil];
    for (int i=0; i<7; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/7*i, 1024-70, 130, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
        lb.text=[array objectAtIndex:i];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        //        [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
        //        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        btn.tintColor=[UIColor whiteColor];
        btn.tag=i+1;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn=nil;
    }
    array=nil;
    [self searchBarInit];
    _pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tuodongView:)];
    _pan.delaysTouchesBegan=YES;
}



//按钮的点击事件
-(void)btnClick:(UIButton *)btn
{
    //@"注销",@"等位预点",@"并台",@"换台",@"会员查询",@"查询账单",@"刷新"
    if (btn.tag==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"注销" message:@"你确认注销登陆吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag=2;
        [alert show];
        alert=nil;
    }else if (btn.tag==2){
        [self dismissViews];
        if (!_waitView){
            _waitView=[[AKsWaitSeat alloc]initWithFrame:CGRectMake(768-350, 50, 350, 895)];
            _waitView.delegate=self;
            [self.view addSubview:_waitView];
            [self.view addSubview:HUD];
        }
        else
        {
            scvTables.userInteractionEnabled=YES;
            [_waitView removeFromSuperview];
            _waitView = nil;
        }
        
        if (_waitOpenView)
        {
            [_waitOpenView removeFromSuperview];
            _waitOpenView=nil;
            
        }
    }else if(btn.tag==3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"multiple" forKey:@"DeskMainButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        scvTables.userInteractionEnabled=NO;
        if (!vSwitch){
            [self dismissViews];
            vSwitch = [[BSSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            vSwitch.delegate = self;
            [vSwitch addGestureRecognizer:_pan];
            //        vSwitch.center = btnSwitch.center;
            vSwitch.center = CGPointMake(384, 1004-27);
            [self.view addSubview:vSwitch];
            [vSwitch firstAnimation];
        }
        else{
            scvTables.userInteractionEnabled=YES;
            [vSwitch removeFromSuperview];
            vSwitch = nil;
        }
    }else if (btn.tag==4)
    {
        vSwitch.tfOldTable.userInteractionEnabled = YES;
        vSwitch.tfNewTable.userInteractionEnabled = YES;
        scvTables.userInteractionEnabled=NO;
        [[NSUserDefaults standardUserDefaults] setObject:@"switchTable" forKey:@"DeskMainButton"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (!vSwitch){
            [self dismissViews];
            vSwitch = [[BSSwitchTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            vSwitch.delegate = self;
            [vSwitch addGestureRecognizer:_pan];
            //        vSwitch.center = btnSwitch.center;
            vSwitch.center = CGPointMake(384, 1004-27);
            [self.view addSubview:vSwitch];
            [vSwitch firstAnimation];
        }
        else{
             scvTables.userInteractionEnabled=YES;
            [vSwitch removeFromSuperview];
            vSwitch = nil;
        }
    }else if (btn.tag==5){
        //        [AKsNetAccessClass sharedNetAccess].isVipShow=@"3";
        [Singleton sharedSingleton].SELEVIP=YES;
        AKsNewVipViewController *aks=[[AKsNewVipViewController alloc] init];
        [self.navigationController pushViewController:aks animated:YES];
        aks=nil;
    }else if (btn.tag==6){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"查询台位" message:@"请输入台位号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alertView.tag = 4;
        [alertView show];
        alertView=nil;
    }else
    {
        if (_waitView) {
            [_waitView addshowTableView];
        }else
        {
        [self updataTable];
        }
    }
}

//界面可拖动
-(void)tuodongView:(UIPanGestureRecognizer *)pan
{
    
    UIView *piece = [pan view];
    if ([pan state] == UIGestureRecognizerStateBegan || [pan state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [pan translationInView:[piece superview]];
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y+ translation.y)];
        
        [pan setTranslation:CGPointZero inView:self.view];
    }
    
}

-(void)viewClick
{
    [self dismissViews];
}
- (void)searchBarInit {
    UISearchBar *searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 45, 768, 50)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeDefault;
	searchBar.backgroundColor=[UIColor clearColor];
	searchBar.translucent=YES;
	searchBar.placeholder=@"搜索";
	searchBar.delegate = self;
	searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:searchBar];
    searchBar=nil;
    
}
#pragma mark UISearchBarDelegate
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *info=[[NSDictionary alloc]initWithObjectsAndKeys:@"",@"area",@"",@"floor",@"",@"state",_searchBar.text,@"tableNum", nil];
    _tabledict=info;
    [self getTableList:_tabledict];
    
    //    area=%@&floor=%@&state=
}
#pragma mark  AKsWaitSeatDelegate
-(void)clickMissButton
{
    [self dismissViews];
    if (!_removeYudianView)
    {
        if(_removeYudianView && _removeYudianView.superview)
        {
            [_removeYudianView removeFromSuperview];
            _removeYudianView=nil;
        }
        _removeYudianView=[[AKsRemoveYudingView alloc]initWithFrame:CGRectMake(0, 0, 492, 354)];
        _removeYudianView.delegate=self;
        [_removeYudianView addGestureRecognizer:_pan];
        [self.view addSubview:_removeYudianView];
    }
    else
    {
        [_removeYudianView removeFromSuperview];
        _removeYudianView = nil;
    }
    
}

-(void)clickAddButton
{
    //+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
    [self dismissViews];
    //+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
    if (!_waitOpenView)
    {
        if(_waitOpenView && _waitOpenView.superview)
        {
            [_waitOpenView removeFromSuperview];
            _waitOpenView=nil;
        }
        _waitOpenView=[[AKsWaitSeatOpenTable alloc]initWithFrame:CGRectMake(0, 0, 492, 354)];
        _waitOpenView.delegate=self;
        [_waitOpenView addGestureRecognizer:_pan];
        [self.view addSubview:_waitOpenView];
    }
    else
    {
        [_waitOpenView removeFromSuperview];
        _waitOpenView = nil;
    }
}
-(void)removeHudOnMainThread
{
    [HUD removeFromSuperview];
}

-(void)clickTableViewIndexRow:(AKsWaitSeatClass *)waitSeatPeople
{
    //+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
    [self dismissViews];
    //+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
    
    
    
    [Singleton sharedSingleton].man=waitSeatPeople.manNum;
    [Singleton sharedSingleton].woman=waitSeatPeople.womanNum;
    [Singleton sharedSingleton].Seat=waitSeatPeople.phoneNum;
    [Singleton sharedSingleton].CheckNum=waitSeatPeople.zhangdan;
    [Singleton sharedSingleton].WaitNum=waitSeatPeople.waitNum;
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSArray *array=[dp selectCache];
    NSLog(@"%@%d",array,[array count]);
    if([array count])
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该预点台位已缓存菜品，确定继续点菜"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            alert.tag=1005;
            [alert show];
            
        });
    }
    else
    {
        //    [Singleton sharedSingleton].Seat=waitSeatPeople.waitNum;
        
        
        [AKsNetAccessClass sharedNetAccess].PeopleManNum=waitSeatPeople.manNum;
        [AKsNetAccessClass sharedNetAccess].PeopleWomanNum=waitSeatPeople.womanNum;
        [AKsNetAccessClass sharedNetAccess].TableNum=waitSeatPeople.waitNum;
        [AKsNetAccessClass sharedNetAccess].zhangdanId=waitSeatPeople.zhangdan;
        [AKsNetAccessClass sharedNetAccess].phoneNum=waitSeatPeople.phoneNum;
        
        
        //    判断数据库是否有以手机号未台位的账单
        /*
         如果有
         ：直接从数据库里面读出改账单的点菜详情并列出详情
         如果没有
         ：保存当前的单例数据，跳入到点餐页面
         */
        
        AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
        netAccess.delegate=self;
        [self.view addSubview:HUD];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",netAccess.TableNum,@"tableNum",netAccess.zhangdanId,@"orderId", nil];
        [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"queryWholeProducts"]] andPost:dict andTag:queryWholeProducts];
    }
    
}

#pragma mark  --AKschangeTableViewDelegate

-(void)AkschangtableSure:(NSString *)phoneNum and:(NSString *)tableNum
{
    _newTableNum=tableNum;
    _oldTableNum=phoneNum;
    
    [self dismissViews];
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    [self.view addSubview:HUD];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",phoneNum,@"tablenumSource",tableNum,@"tablenumDest",netAccess.zhangdanId,@"orderId", nil];
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"changeTableNum"]] andPost:dict andTag:changeTableNum];
    
}

-(void)Akschangtablecancle
{
    [_akschangeTable removeFromSuperview];
    _akschangeTable=nil;
}

//预定台位转换
-(void)HHTchangeTableNumSuccessFormWebService:(NSDictionary *)dict
{
    [HUD removeFromSuperview];
    NSArray *array= [self getArrayWithDict:dict andFunction:changeTableNumName];
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        if(_waitView)
        {
            [_waitView removeFromSuperview];
            _waitView=nil;
        }
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userSql"]boolValue])
        {
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [Singleton sharedSingleton].Seat=_newTableNum;
            [dp reserveCache:_dataArray];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:_oldTableNum,@"oldtable",_newTableNum,@"newtable", nil];
            [dp updateChangTable:dict :[AKsNetAccessClass sharedNetAccess].zhangdanId];
        }
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"转台成功\n进入台位操作\n"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            alert.tag=1003;
            [alert show];
            
        });
        
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[array lastObject]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定",nil];
            [alert show];
            
        });
        
    }
}
//查询账单
-(void)HHTqueryWholeProductsFormWebService:(NSDictionary *)dict
{
    [HUD removeFromSuperview];
    
    _dataArray=[[NSMutableArray alloc]init];
    _youmianShowArray=[[NSMutableArray alloc]init];
    NSString *Content=[[[dict objectForKey:@"ns:queryWholeProductsResponse"]objectForKey:@"ns:return" ]objectForKey:@"text"];
    
    NSArray *array=[Content componentsSeparatedByString:@"#"];
    NSMutableArray  *caivalueArray=[[NSMutableArray alloc]init];
    NSMutableArray  *payValueArray=[[NSMutableArray alloc]init];
    
    if([array count]==1)
    {
        NSArray *result=[Content componentsSeparatedByString:@"@"];
        if([[result firstObject]isEqualToString:@"-1"])   //NULL服务器返回，如果相等则没有菜品
        {
            if([[result lastObject]isEqualToString:@"NULL"])
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"该账单没有预点菜品\n请选择操作"
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"转正式台",@"取消等位",@"点 菜",nil];
                    alert.tag=1002;
                    [alert show];
                    
                });
                
            }
            else
            {
                bs_dispatch_sync_on_main_thread(^{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[result lastObject]
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                });
                
            }
            
        }
        else
        {
            NSArray *caivalues=[[array firstObject]componentsSeparatedByString:@";"];
            for (int i=0; i<[caivalues count]; i++)
            {
                //    菜品key
                NSArray *caiarrykey=[[NSArray alloc]initWithObjects:Sisok,Sorderid,Spkid,Spcode,Spcname,Stpcode,Stpname,Stpnum,Spcount,Spromonum,Sfujiacode,Sfujianame,Sprice,Sfujiaprice,Sweight,Sweightflag,Sunit,Sistc,SrushCount,SpullCount,SIsQuit,SQuitCause,SrushOrCall,SeachPrice ,nil];
                
                if(![[caivalues objectAtIndex:i]isEqualToString:@""])
                {
                    
                    NSArray *result=[[caivalues objectAtIndex:i] componentsSeparatedByString:@"@"];
                    NSDictionary *dictData=[[NSDictionary alloc]initWithObjects:result forKeys:caiarrykey];
                    [caivalueArray addObject:dictData];
                }
                else
                {
                    break;
                }
            }
        }
    }
    else
    {
        //         菜品列表
        NSArray *caivalues=[[array firstObject]componentsSeparatedByString:@";"];
        for (int i=0; i<[caivalues count]; i++)
        {
            //    菜品key
            NSArray *caiarrykey=[[NSArray alloc]initWithObjects:Sisok,Sorderid,Spkid,Spcode,Spcname,Stpcode,Stpname,Stpnum,Spcount,Spromonum,Sfujiacode,Sfujianame,Sprice,Sfujiaprice,Sweight,Sweightflag,Sunit,Sistc,SrushCount,SpullCount,SIsQuit,SQuitCause,SrushOrCall,SeachPrice ,nil];
            
            if(![[caivalues objectAtIndex:i]isEqualToString:@""])
            {
                NSArray *result=[[caivalues objectAtIndex:i] componentsSeparatedByString:@"@"];
                NSDictionary *dictData=[[NSDictionary alloc]initWithObjects:result forKeys:caiarrykey];
                [caivalueArray addObject:dictData];
            }
            else
            {
                break;
            }
        }
        
        NSArray *payvalues=[[array objectAtIndex:1]componentsSeparatedByString:@";"];
        for (int i=0; i<[payvalues count]; i++)
        {
            //    支付key
            NSArray *payArraykey=[[NSArray alloc]initWithObjects:@"chenggong",@"zhangdan",@"Payname",@"Payprice", nil];
            //            支付方式列表
            if(![[payvalues objectAtIndex:i]isEqualToString:@""])
            {
                
                NSArray *result=[[payvalues objectAtIndex:i] componentsSeparatedByString:@"@"];
                NSDictionary *dictData=[[NSDictionary alloc]initWithObjects:result forKeys:payArraykey];
                [payValueArray addObject:dictData];
            }
            else
            {
                break;
            }
        }
        [AKsNetAccessClass sharedNetAccess].quandanbeizhu=[NSString stringWithFormat:@"%@",[array lastObject]];
    }
    if([caivalueArray count])
    {
        for (int i=0;i<[caivalueArray count] ; i++)
        {
            AKsCanDanListClass *caiList=[[AKsCanDanListClass alloc]init];
            
            caiList.isok=[[caivalueArray objectAtIndex:i]objectForKey:@"isok"];
            caiList.istc=[[caivalueArray objectAtIndex:i]objectForKey:@"istc"];
            caiList.fujiacode=[[caivalueArray objectAtIndex:i]objectForKey:@"fujiacode"];
            caiList.fujianame=[[caivalueArray objectAtIndex:i]objectForKey:@"fujianame"];
            caiList.fujiaprice=[[caivalueArray objectAtIndex:i]objectForKey:@"fujiaprice"];
            caiList.orderid=[[caivalueArray objectAtIndex:i]objectForKey:@"orderid"];
            caiList.pcname=[[caivalueArray objectAtIndex:i]objectForKey:@"pcname"];
            caiList.pcode=[[caivalueArray objectAtIndex:i]objectForKey:@"pcode"];
            caiList.pcount=[[caivalueArray objectAtIndex:i]objectForKey:@"pcount"];
            caiList.pkid=[[caivalueArray objectAtIndex:i]objectForKey:@"pkid"];
            caiList.price=[[caivalueArray objectAtIndex:i]objectForKey:@"price"];
            caiList.promonum=[[caivalueArray objectAtIndex:i]objectForKey:@"promonum"];
            caiList.tpcode=[[caivalueArray objectAtIndex:i]objectForKey:@"tpcode"];
            caiList.tpname=[[caivalueArray objectAtIndex:i]objectForKey:@"tpname"];
            caiList.tpnum=[[caivalueArray objectAtIndex:i]objectForKey:@"tpnum"];
            caiList.unit=[[caivalueArray objectAtIndex:i]objectForKey:@"unit"];
            caiList.weight=[[caivalueArray objectAtIndex:i]objectForKey:@"weight"];
            caiList.weightflag=[[caivalueArray objectAtIndex:i]objectForKey:@"weightflag"];
            caiList.pullCount=[[caivalueArray objectAtIndex:i]objectForKey:SpullCount];
            caiList.rushCount=[[caivalueArray objectAtIndex:i]objectForKey:SrushCount];
            caiList.rushOrCall=[[caivalueArray objectAtIndex:i]objectForKey:SrushOrCall];
            caiList.IsQuit=[[caivalueArray objectAtIndex:i]objectForKey:SIsQuit];
            caiList.QuitCause=[[caivalueArray objectAtIndex:i]objectForKey:SQuitCause];
            caiList.eachPrice=[[caivalueArray objectAtIndex:i]objectForKey:SeachPrice];
            
            [_dataArray addObject:caiList];
        }
        if([payValueArray count])
        {
            for (int i=0;i<[payValueArray count] ; i++)
            {
                AKsYouHuiListClass *youhui=[[AKsYouHuiListClass alloc]init];
                youhui.youMoney=[[payValueArray objectAtIndex:i]objectForKey:@"Payprice"];
                youhui.youName=[[payValueArray objectAtIndex:i]objectForKey:@"Payname"];
                
                [_youmianShowArray addObject:youhui];
            }
        }
        
        if (!_yuDianView)
        {
            if(_yuDianView && _yuDianView.superview)
            {
                [_yuDianView removeFromSuperview];
                _yuDianView=nil;
            }
            _yuDianView=[[AKsYudianShow alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width-350, 902)  andArray:_dataArray andPayArray:_youmianShowArray];
            _yuDianView.delegate=self;
            [self.view addSubview:_yuDianView];
        }
        
        
    }
    
    //+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
}

//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++
#pragma mark AKsRemoveYudingViewDelegate

-(void)sureAKsRemoveYudingView:(NSString *)phoneNum andMisNum:(NSString *)MisNum
{
    [self dismissViews];
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    [self.view addSubview:HUD];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",phoneNum,@"tableNum",MisNum,@"misOrderId", nil];
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"cancelReserveTableNum"]] andPost:dict andTag:cancelReserveTableNum];
}

-(void)HHTcancelReserveTableNumSuccessFormWebService:(NSDictionary *)dict
{
    [HUD removeFromSuperview];
    NSLog(@"%@",dict);
    NSArray *array=[self getArrayWithDict:dict andFunction:cancelReserveTableNumName];
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[array lastObject]
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            alert.tag=1004;
            [alert show];
            
        });
        
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[array lastObject]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            
        });
    }
    
}

-(void)cancleAKsRemoveYudingView
{
    if(_removeYudianView && _removeYudianView.superview)
    {
        [_removeYudianView removeFromSuperview];
        _removeYudianView=nil;
    }
}

//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++//+++++++++++++


#pragma mark AKsYudianShowDelegate
-(void)AKsYudianShowCancle
{
    if(_yuDianView && _yuDianView.superview)
    {
        [_yuDianView removeFromSuperview];
        _yuDianView=nil;
    }
}

-(void)AKsYudianShowSure
{
    [self dismissViews];
    _akschangeTable=[[AKschangeTableView alloc]initWithFrame:CGRectMake(0, 0, 492, 354) andPhoneNum:[AKsNetAccessClass sharedNetAccess].phoneNum];
    _akschangeTable.delegate=self;
    [_akschangeTable addGestureRecognizer:_pan];
    [self.view addSubview:_akschangeTable];
}
-(void)AKsYudianShowAddDish
{
    [Singleton sharedSingleton].isYudian=YES;
    [self AKOrder];
}
-(void)AKsYudianDismiss
{
    [self dismissViews];
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    [self.view addSubview:HUD];
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",[AKsNetAccessClass sharedNetAccess].phoneNum,@"tableNum",[Singleton sharedSingleton].WaitNum,@"misOrderId", nil];
    
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"cancelReserveTableNum"]] andPost:dict andTag:cancelReserveTableNum];
}

#pragma mark AKsWaitSeatOpenTableDelegate

-(void)openWaitTableWithOptions:(NSDictionary *)info
{
    if (info){
        if(_waitOpenView)
        {
            [_waitOpenView removeFromSuperview];
            _waitOpenView=nil;
        }
        
        AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
        
        netAccess.delegate=self;
        [self.view addSubview:HUD];
        NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",[Singleton sharedSingleton].Seat,@"tableNum",[info objectForKey:@"man"],@"manCounts",[info objectForKey:@"woman"],@"womanCounts", nil];
        [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"reserveTableNum"]] andPost:dict andTag:reserveTableNum];
    }
    
}

-(void)cancleAKsWaitSeat
{
    if(_waitOpenView && _waitOpenView.superview)
    {
        [_waitOpenView removeFromSuperview];
        _waitOpenView=nil;
    }
}

-(void)VipClickWait
{
    //    AKsNewVipViewController *newVip=[[AKsNewVipViewController alloc]init];
    //    [self.navigationController pushViewController:newVip animated:YES];
    [AKsNetAccessClass sharedNetAccess].showVipMessageDict=nil;
    AKsVipViewController *vip=[[AKsVipViewController alloc] init];
    [self.navigationController pushViewController:vip animated:YES];
}

#pragma mark AksNetAccessDelegate

-(void)failedFromWebServie
{
    [HUD removeFromSuperview];
    bs_dispatch_sync_on_main_thread(^{
        
        
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"网络连接失败，请检查网络！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    });
}

#pragma mark AKsNetAccessClassDelegate
-(void)HHTreserveTableNumSuccessFormWebService:(NSDictionary *)dict
{
    [HUD removeFromSuperview];
    NSArray *array= [self getArrayWithDict:dict andFunction:reserveTableNumName];
    if([[array objectAtIndex:0]isEqualToString:@"0"])
    {
        //        [self showAlter:[NSString stringWithFormat:@"预定成功\n 等位序号：%@号\n是否预点餐",[array objectAtIndex:2]]];
        [self dismissViews];
        [Singleton sharedSingleton].CheckNum=[array objectAtIndex:1];
        [Singleton sharedSingleton].WaitNum=[array objectAtIndex:2];
        [AKsNetAccessClass sharedNetAccess].zhangdanId=[array objectAtIndex:1];
        if (!_openSucceed){
            _openSucceed=[[AKsOpenSucceed alloc]initWithFrame:CGRectMake(0, 0, 492, 354)];
            _openSucceed.delegate=self;
            [self.view addSubview:_openSucceed];
            //            [self.view addSubview:HUD];
        }
        else
        {
            [_openSucceed removeFromSuperview];
            _openSucceed = nil;
        }
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[array lastObject]
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
            
        });
    }
    
}
#pragma mark AKsOpenSucceedDelegate
-(void)OpenSucceed:(int)tag
{
    if (tag==101) {
        [Singleton sharedSingleton].isYudian=YES;
        if([AKsNetAccessClass sharedNetAccess].isVipShow)
        {
            [self VipClickWait];
        }
        else
        {
            
            [self AKOrder];
        }
    }
    else if(tag==102)
    {
        [_waitView reloadDataWaitTableView];
    }
    [_openSucceed removeFromSuperview];
    _openSucceed=nil;
}
-(void)showAlter:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是",nil];
        alert.tag=1001;
        [alert show];
        
    });
}



-(NSArray *)getArrayWithDict:(NSDictionary *)dict andFunction:(NSString *)functionName
{
    NSString *str=[[[dict objectForKey:[NSString stringWithFormat:@"ns:%@Response",functionName]]objectForKey:@"ns:return"]objectForKey:@"text"];
    NSArray *array=[str componentsSeparatedByString:@"@"];
    return array;
}



//    ==========================================================================================


//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

-(void)updataTable
{
    [SVProgressHUD showProgress:-1 status:@"刷新台位中..." maskType:SVProgressHUDMaskTypeBlack];
    [NSThread detachNewThreadSelector:@selector(getTableList:) toTarget:self withObject:_tabledict];
}
#pragma mark UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 耗时的操作
                BSDataProvider *dp=[[BSDataProvider alloc] init];
                NSArray *array=[dp logout];
                [Singleton sharedSingleton].userInfo=nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([[array objectAtIndex:0] intValue]==0) {
                        [Singleton sharedSingleton].userInfo=nil;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:@"提示" message:[array objectAtIndex:1] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alwet show];
                    }
                });
            });
        }
    }else if (alertView.tag==4) {
        if (buttonIndex==1) {
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            [Singleton sharedSingleton].Seat=tf1.text;
            AKSelectCheck *select=[[AKSelectCheck alloc] init];
            [self.navigationController pushViewController:select animated:YES];
        }
    }
    else if(alertView.tag==3){
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else if(alertView.tag==1001)
    {
        if(buttonIndex==0)
        {
            [_waitView reloadDataWaitTableView];
        }
        else
        {
            if(_waitView)
            {
                [_waitView removeFromSuperview];
                _waitView=nil;
            }
            [self AKOrder];
            [Singleton sharedSingleton].isYudian=YES;
        }
    }
    else if (alertView.tag==1002)
    {
        if(buttonIndex==1)
        {
            [self dismissViews];
            _akschangeTable=[[AKschangeTableView alloc]initWithFrame:CGRectMake(0, 0, 492, 354) andPhoneNum:[AKsNetAccessClass sharedNetAccess].phoneNum];
            _akschangeTable.delegate=self;
            [_akschangeTable addGestureRecognizer:_pan];
            [self.view addSubview:_akschangeTable];
        }else if(buttonIndex==2)
        {
            AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
            netAccess.delegate=self;
            [self.view addSubview:HUD];
            NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",[AKsNetAccessClass sharedNetAccess].phoneNum,@"tableNum",[Singleton sharedSingleton].WaitNum,@"misOrderId", nil];
    
            [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"cancelReserveTableNum"]] andPost:dict andTag:cancelReserveTableNum];
        }else if(buttonIndex==3)
        {
            [Singleton sharedSingleton].isYudian=YES;
            [self AKOrder];
        }
    }
    else if (alertView.tag==1003)
    {
        [self getTableList:_tabledict];
    }
    else if(alertView.tag==1004)
    {
        [_waitView reloadDataWaitTableView];
    }
    else if(alertView.tag==1005)
    {
        [Singleton sharedSingleton].isYudian=YES;
        [self AKOrder];
    }
    alertView=nil;
}

#pragma mark  SwitchTableViewDelegate
//并台代理事件
-(void)multipleTableWithOptions:(NSDictionary *)info{
    scvTables.userInteractionEnabled=YES;
    if (info){
        [SVProgressHUD showProgress:-1 status:@"并台中..." maskType:SVProgressHUDMaskTypeBlack];
        //        [SVProgressHUD showProgress:-1 status:@"并台中..."];
        [NSThread detachNewThreadSelector:@selector(multiple:) toTarget:self withObject:info];
    }
    [self dismissViews];
}
//换台代理事件
- (void)switchTableWithOptions:(NSDictionary *)info{
    scvTables.userInteractionEnabled=YES;
    
    if (info){
        [SVProgressHUD showProgress:-1 status:@"换台中..." maskType:SVProgressHUDMaskTypeBlack];
        //        [SVProgressHUD showProgress:-1 status:@"换台中..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // 耗时的操作
            BSDataProvider *dp = [[BSDataProvider alloc] init];
            NSArray *dic=[NSArray array];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
            {
                dic=[dp getOrdersBytabNum1:[info objectForKey:@"oldtable"]];
            }
            NSDictionary *dict= [dp pChangeTable:info];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSString *msg,*title;
                if (dict) {
                    NSString *result = [[[dict objectForKey:@"ns:changeTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
                    NSArray *ary=[result componentsSeparatedByString:@"@"];
                    
                    if ([[ary objectAtIndex:0] intValue]==0) {
                        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
                        {
                            [dp updateChangTable:info :[dic objectAtIndex:0]];
                        }
                    }
                    title=[ary objectAtIndex:1];
                }
                [self getTableList:_tabledict];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alert show];
            });
        });
    }
    
    [self dismissViews];
}

//换台请求
- (void)switchTable:(NSDictionary *)info{
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSArray *dic=[dp getOrdersBytabNum1:[info objectForKey:@"oldtable"]];
    NSDictionary *dict= [dp pChangeTable:info];
    NSString *msg,*title;
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:changeTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        
        if ([[ary objectAtIndex:0] intValue]==0) {
            NSLog(@"%@",[dic objectAtIndex:0]);
            [dp updateChangTable:info :[dic objectAtIndex:0]];
        }
        title=[ary objectAtIndex:1];
    }
    [self getTableList:_tabledict];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
}
//并台请求
-(void)multiple:(NSDictionary *)info
{
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp combineTable:info];
    [SVProgressHUD dismiss];
    NSString *msg,*title;
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:combineTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            title = @"成功";
            [dp updatecombineTable:info :[ary objectAtIndex:1]];
            segment.selectedSegmentIndex=[Singleton sharedSingleton].segment;
            [self segmentClick:segment];
            msg=[ary objectAtIndex:1];
        }
        else
        {
            title = @"失败";
            msg=[ary objectAtIndex:1];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];
    
}
//查询台位代理
- (void)getTableList:(NSDictionary *)info{
    _tabledict=info;
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp pListTable:info];  //查询台位
    dp=nil;
    //    [SVProgressHUD dismiss];
    
    NSMutableArray *mutTables = [NSMutableArray array];
    if (dict){
        NSString *result = [[[dict objectForKey:@"ns:listTablesResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        
        NSArray *ary = [result componentsSeparatedByString:@";"];
        
        for (NSString *str in ary) {
            NSArray *aryTableInfo = [str componentsSeparatedByString:@"@"];
            NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
            if ([aryTableInfo count]>=4){
                [mutTable setObject:[aryTableInfo objectAtIndex:1] forKey:@"code"]; //编码
                [mutTable setObject:[aryTableInfo objectAtIndex:2] forKey:@"short"];//简码
                [mutTable setObject:[aryTableInfo objectAtIndex:3] forKey:@"name"]; //名称
                [mutTable setObject:[aryTableInfo objectAtIndex:4] forKey:@"status"];//状态
                [mutTable setObject:[aryTableInfo objectAtIndex:5] forKey:@"num"];   //台位号
                [mutTable setObject:[aryTableInfo objectAtIndex:6] forKey:@"man"];   //人数
                [mutTables addObject:[NSDictionary dictionaryWithDictionary:mutTable]];
                mutTable=nil;
            } else{
                //[mut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
                //                [mut setObject:@"查询失败" forKey:@"Message"];
                [SVProgressHUD dismiss];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[aryTableInfo objectAtIndex:1] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                return;
            }
            aryTableInfo=nil;
        }
    }
    else{
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询失败" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    _aryTables = mutTables;
    [self showTables:mutTables];
    mutTables=nil;
}
- (void)segmentClick:(UISegmentedControl*)sender
{
    for (UIView *v in scvTables.subviews){
        if ([v isKindOfClass:[BSTableButton class]])
            [v removeFromSuperview];
    }
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSArray *array=[dp getArea];
    NSString *DESStr = [DESArray objectAtIndex:segment.selectedSegmentIndex];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"区域"]) {
        [_tabledict  setValue:[[array objectAtIndex:sender.selectedSegmentIndex] objectForKey:@"AREARID"] forKey:@"area"];
    }else
        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"楼层"]){
            [_tabledict setObject:DESStr forKey:@"Floor"];
        }else if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"desk"]isEqualToString:@"状态"]){
            for(int i=0;i<9;i++)
            {
                if (i<5) {
                    if (i==segment.selectedSegmentIndex) {
                        [_tabledict setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"state"];
                    }
                }
                else
                {
                    if (i==segment.selectedSegmentIndex) {
                        [_tabledict setObject:[NSString stringWithFormat:@"%d",i+2] forKey:@"state"];
                    }
                }
                
            }
        }
    [Singleton sharedSingleton].segment=segment.selectedSegmentIndex;
    [self getTableList:_tabledict];
}
//显示台位
- (void)showTables:(NSArray *)ary{
    int count = [ary count];
    
    for (UIView *v in scvTables.subviews){
        if ([v isKindOfClass:[BSTableButton class]])
            [v removeFromSuperview];
    }
    
    for (int i=0;i<count;i++){
        int row = i/5;
        int column = i%5;
        NSDictionary *dic = [ary objectAtIndex:i];
        
        BSTableButton *btnTable = [BSTableButton buttonWithType:UIButtonTypeCustom];
        btnTable.delegate = self;
        btnTable.tag = i;
        btnTable.frame = CGRectMake(145*column, 5+85*row, 135, 75);
        [btnTable addTarget:self action:@selector(tableClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnTable.tableTitle =[NSString stringWithFormat:@"%@",[dic objectForKey:@"num"]];
        btnTable.manTitle.text=[dic objectForKey:@"man"];
        btnTable.tableType = [[dic objectForKey:@"status"] intValue];
        [scvTables addSubview:btnTable];
        [scvTables setContentSize:CGSizeMake(141*column, 83*row+100)];
        btnTable=nil;
    }
    [SVProgressHUD dismiss];
    
}
#pragma mark Handle TableButton Click Event
//台位点击事件
- (void)tableClicked:(BSTableButton *)btn{
    [self dismissViews];
    [AKsNetAccessClass sharedNetAccess].showVipMessageDict=nil;
    [Singleton sharedSingleton].isYudian=NO;
    [Singleton sharedSingleton].Seat=@"";
    [AKsNetAccessClass sharedNetAccess].TableNum=NULL;
    
    dSelectedIndex = btn.tag;
    [Singleton sharedSingleton].dishArray=nil;
    NSDictionary *info = [_aryTables objectAtIndex:dSelectedIndex];
    BSTableType type = [[info objectForKey:@"status"] intValue];
    UIAlertView *alert;
    segment.selectedSegmentIndex=[Singleton sharedSingleton].segment;
    if (type==BSTableTypeEmpty) {
        [AKsNetAccessClass sharedNetAccess].TableNum=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
        if (vOpen){
            [vOpen removeFromSuperview];
            vOpen = nil;
        }
        vOpen = [[BSOpenTableView alloc] initWithFrame:CGRectMake(0, 0, 492, 500)];
        vOpen.delegate = self;
        vOpen.center = CGPointMake(384, 512);
        vOpen.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
        [vOpen addGestureRecognizer:_pan];
        [self.view addSubview:vOpen];
        scvTables.userInteractionEnabled=NO;
        [UIView animateWithDuration:0.5f animations:^(void) {
            vOpen.transform = CGAffineTransformIdentity;
        }];
    }else if (type==BSTableTypeOpen)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"选择" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"点菜",@"清台", nil];
        alert.tag=kdish;
        [alert show];
    }else if (type==BSTableTypeCheck){
        alert = [[UIAlertView alloc] initWithTitle:@"结帐台" message:@"此台位是已经结账台，是否清台？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = kCancelTag;
        [alert show];
    }
    else if (type==BSTableTypeSeal){
        alert = [[UIAlertView alloc] initWithTitle:@"封台" message:@"该台位已封帐，请到收银台结账" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else
    {
        [SVProgressHUD showProgress:-1 status:@"查询台位信息中..." maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(getOrdersBytale:) toTarget:self withObject:@"2"];
    }
}
//根据台位查询账单号
-(void)getOrdersBytale:(NSString *)tag
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSArray *array=[dp getOrdersBytabNum1:[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"]];
    
    if (array>0) {
        [AKsNetAccessClass sharedNetAccess].TableNum=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
        [Singleton sharedSingleton].Seat=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
        [Singleton sharedSingleton].CheckNum=[array objectAtIndex:0];
        [Singleton sharedSingleton].man=[array objectAtIndex:1];
        [Singleton sharedSingleton].woman=[[[array objectAtIndex:2]componentsSeparatedByString:@"#"] firstObject];
        
        if ([tag intValue]==1) {
            bs_dispatch_sync_on_main_thread(^{
            [SVProgressHUD dismiss];
            [self AKOrder];
            });
        }
        else
        {
            bs_dispatch_sync_on_main_thread(^{
                [SVProgressHUD dismiss];
                [self quertView];
            });
        }
    }
    else
    {
        [SVProgressHUD dismiss];
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你没有权限对此台位进行操作" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        alert=nil;
    }
}

- (void)dismissViews{
    if (vOpen && vOpen.superview){
        [vOpen removeFromSuperview];
        vOpen = nil;
    }
    if (vSwitch && vSwitch.superview){
        [vSwitch removeFromSuperview];
        vSwitch = nil;
    }
    if(_akschangeTable && _akschangeTable.subviews)
    {
        [_akschangeTable removeFromSuperview];
        _akschangeTable=nil;
    }
    if(_yuDianView && _yuDianView.superview)
    {
        [_yuDianView removeFromSuperview];
        _yuDianView=nil;
    }
    if(_removeYudianView && _removeYudianView.superview)
    {
        [_removeYudianView removeFromSuperview];
        _removeYudianView=nil;
    }
}
//开台的代理事件
#pragma mark OpenTableViewDelegate
- (void)openTableWithOptions:(NSDictionary *)info{
    scvTables.userInteractionEnabled=YES;
    if (info){
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:info];
        [dic setObject:[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"] forKey:@"table"];
        [SVProgressHUD showProgress:-1 status:@"开台中..." maskType:SVProgressHUDMaskTypeBlack];
        [NSThread detachNewThreadSelector:@selector(openTable:) toTarget:self withObject:dic];
    }
    [self dismissViews];
    vOpen=nil;
}

//开台的请求

- (void)openTable:(NSDictionary *)info{
    
    BSDataProvider *dp = [[BSDataProvider alloc] init];
    NSDictionary *dict = [dp pStart:info];
    [SVProgressHUD dismiss];
    if (dict) {
        NSString *result = [[dict objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if ([ary count]<2) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSString *STR=[ary objectAtIndex:1];
            if ([[ary objectAtIndex:0] intValue]==0) {
                [AKsNetAccessClass sharedNetAccess].TableNum=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
                [AKsNetAccessClass sharedNetAccess].PeopleManNum=[info objectForKey:@"man"];
                [AKsNetAccessClass sharedNetAccess].PeopleWomanNum=[info objectForKey:@"woman"];
                [Singleton sharedSingleton].Seat=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
                [Singleton sharedSingleton].CheckNum=STR;
                [AKsNetAccessClass sharedNetAccess].zhangdanId=STR;
                if([AKsNetAccessClass sharedNetAccess].isVipShow)
                {
                    
                    bs_dispatch_sync_on_main_thread(^{
                        AKsVipViewController *vipView=[[AKsVipViewController alloc]init];
                        [self.navigationController pushViewController:vipView animated:YES];
                    });
                    
                }
                else
                {
                    [self AKOrder];
                }
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:STR message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                alert=nil;
            }
        }
        
    }
}

#pragma mark AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(kdish==alertView.tag){
        if (2==buttonIndex) {
            [SVProgressHUD showProgress:-1 status:@"清台中..." maskType:SVProgressHUDMaskTypeBlack];
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self
                                                          selector:@selector(changTableState)
                                                            object:nil];
            [myThread1 start];
            myThread1=nil;
        }
        else if (1==buttonIndex){
            [SVProgressHUD showProgress:-1 status:@"查询台位信息中..." maskType:SVProgressHUDMaskTypeBlack];
            [NSThread detachNewThreadSelector:@selector(getOrdersBytale:) toTarget:self withObject:@"1"];
        }
    }
    else if(alertView.tag==kCancelTag)
    {
        if (1==buttonIndex) {
            [SVProgressHUD showProgress:-1 status:@"清台中..." maskType:SVProgressHUDMaskTypeBlack];
            NSThread* myThread1 = [[NSThread alloc] initWithTarget:self
                                                          selector:@selector(changTableState)
                                                            object:nil];
            [myThread1 start];
        }
    }
}
//清台请求
-(void)changTableState
{
    [SVProgressHUD dismiss];
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [Singleton sharedSingleton].Seat=[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"];
    [dict setObject:[[_aryTables objectAtIndex:dSelectedIndex] objectForKey:@"name"] forKey:@"tableNum"];
    [dict setObject:@"6" forKey:@"currentState"];
    [dict setObject:@"1" forKey:@"nextState"];
    NSDictionary *dict1=[dp changTableState:dict];
    if (dict1){
        NSArray *ary=[[[[dict1 objectForKey:@"ns:changTableStateResponse"] objectForKey:@"ns:return"] objectForKey:@"text"] componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                         selector:@selector(getTableList:)
                                                           object:_tabledict];
            [myThread start];
            myThread=nil;
            [AKsNetAccessClass sharedNetAccess].VipCardNum=@"";
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary lastObject] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            alert=nil;
        }
        ary=nil;
    }
    dict1=nil;
}
//手势换台的代理事件
- (void)replaceOldTable:(int)oldIndex withNewTable:(int)newIndex{
    //    [self switchTable];
    NSDictionary *oldDic = [_aryTables objectAtIndex:oldIndex];
    NSDictionary *newDic = [_aryTables objectAtIndex:newIndex];
    vSwitch.tfOldTable.text = [oldDic objectForKey:@"name"];
    vSwitch.tfNewTable.text = [newDic objectForKey:@"name"];
    
    vSwitch.tfOldTable.userInteractionEnabled = NO;
    vSwitch.tfNewTable.userInteractionEnabled = NO;
}
//跳转到点菜界面
-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[AKOrderRepastViewController alloc] init];
    MMDrawerController *drawerController=[[MMDrawerController alloc] initWithCenterViewController:centerViewController rightDrawerViewController:leftSideDrawerViewController];
    [drawerController setMaximumRightDrawerWidth:280.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    [self.navigationController pushViewController:drawerController animated:YES];
    
}

//跳转全单
-(void)quertView
{
    BSQueryViewController *bsq=[[BSQueryViewController alloc] init];
    [self.navigationController pushViewController:bsq animated:YES];
}

@end
