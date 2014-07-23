//
//  AKMySegmentAndView.m
//  BookSystem
//
//  Created by sundaoran on 13-11-21.
//
//

#import "AKMySegmentAndView.h"
#import "Singleton.h"
#import "BSDataProvider.h"
#import "AKDataQueryClass.h"
@implementation AKMySegmentAndView
{
    UISegmentedControl *segment;
    BOOL isShowVipMessage;
    NSArray     *_vipmessage;
    BOOL isvip;
    
}
@synthesize delegate=_delegate;
@synthesize table=_table,CheckNum=_CheckNum,man=_man,woman=_woman;

- (id)init
{
    self = [super init];
    [AKsNetAccessClass sharedNetAccess].SettlemenVip=NO;
    if (self) {
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"userSql"]boolValue])
        {
            AKDataQueryClass *data=[[AKDataQueryClass alloc]init];
            
            _vipmessage=[[NSArray alloc]initWithArray:[data selectDataFromSqlite:[NSString stringWithFormat:@"SELECT * FROM PhoneNumSave WHERE zhangdanId='%@'and dateTime='%@'",[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time]]];
        }
        else if([AKsNetAccessClass sharedNetAccess].showVipMessageDict)
        {
            _vipmessage=[[NSArray alloc]initWithObjects:[AKsNetAccessClass sharedNetAccess].showVipMessageDict, nil];
        }
        
        if([_vipmessage count]!=0)
        {
            [AKsNetAccessClass sharedNetAccess].SettlemenVip=YES;
        }
        [self creatview];
    }
    return self;
}
-(void)creatview
{
    UIImageView *titleImageView=[[UIImageView alloc]init];
    titleImageView.frame=CGRectMake(0,0,768,44);
    [titleImageView setImage:[UIImage imageNamed:@"title.png"]];
    titleImageView.userInteractionEnabled=YES;
    [self addSubview:titleImageView];
    
    UIButton *Vipbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    [Vipbutton setBackgroundImage:[UIImage imageNamed:@"vip.png"] forState:UIControlStateNormal];
    Vipbutton.frame=CGRectMake(768-80, 5, 40, 34);
    [Vipbutton addTarget:self action:@selector(showVip) forControlEvents:UIControlEventTouchUpInside];
    if([AKsNetAccessClass sharedNetAccess].SettlemenVip)
    {
        [titleImageView addSubview:Vipbutton];
    }
    
    
    segment=[[UISegmentedControl alloc]init];
    segment.frame=CGRectMake(4, 54, 760, 60);
    //    segment.tintColor=[UIColor blackColor];
    
    
    NSDictionary *dicSelect = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,[UIColor blueColor],UITextAttributeTextShadowColor ,nil];
    
    NSDictionary *dicnomal = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor],UITextAttributeTextColor,  [UIFont fontWithName:@"Helvetica" size:20],UITextAttributeFont ,nil];
    
    [segment setTitleTextAttributes:dicSelect forState:UIControlStateSelected];
    [segment setTitleTextAttributes:dicnomal forState:UIControlStateNormal];
    
    for (int i=0; i<=8; i++)
    {
        [segment insertSegmentWithTitle:[NSString stringWithFormat:@"%d",i+1] atIndex:i animated:NO];
    }
    [segment insertSegmentWithTitle:@"0" atIndex:10 animated:NO];
    [segment insertSegmentWithTitle:@"X" atIndex:11 animated:NO];
    [segment insertSegmentWithTitle:@"1" atIndex:12 animated:NO];
    segment.selectedSegmentIndex=11;
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segment];
    if ([[Singleton sharedSingleton].man isEqualToString:@""]||[[Singleton sharedSingleton].man isEqualToString:NULL]||[[Singleton sharedSingleton].man isEqualToString:nil]||[[Singleton sharedSingleton].man isEqualToString:@"(null)"])
    {
        _man.text=@"0";
    }
    else
    {
        _man.text=[Singleton sharedSingleton].man;
    }
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(20, 0, 700, 40)];
    if([[Singleton sharedSingleton].CheckNum  isEqualToString:@""])
    {
        [Singleton sharedSingleton].CheckNum=@"暂无账单";
    }
    if ([Singleton sharedSingleton].isYudian) {
        lb.text=[NSString stringWithFormat:@"手机号:%@    账单号:%@    先生:%@    女士:%@    操作员:%@",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,[Singleton sharedSingleton].userName];
    }else
    {
    lb.text=[NSString stringWithFormat:@"台位号:%@        账单号:%@        先生:%@        女士:%@        操作员:%@",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,[Singleton sharedSingleton].userName];
    }
    lb.backgroundColor=[UIColor clearColor];
    lb.textColor=[UIColor whiteColor];
    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self addSubview:lb];
    //    NSArray *array=[[NSArray alloc] initWithObjects:@"台位号:",@"账单号:",@"先生:",@"女士:",@"操作员:", nil];
    //    for (int i=0; i<5; i++) {
    //        switch (i)
    //        {
    //                UILabel *lb1;
    //            case 0:
    //                lb1=[[UILabel alloc] initWithFrame:CGRectMake(5,0,75, 44)];
    //                lb1.backgroundColor=[UIColor clearColor];
    //                lb1.text=[array objectAtIndex:i];
    //                lb1.textColor=[UIColor whiteColor];
    //                lb1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:18];
    //                [self addSubview:lb1];
    //                [lb1 release];
    //                break;
    //
    //            case 1:
    //                lb1=[[UILabel alloc] initWithFrame:CGRectMake(200, 0,60, 44)];
    //                lb1.backgroundColor=[UIColor clearColor];
    //                lb1.text=[array objectAtIndex:i];
    //                lb1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:18];
    //
    //                lb1.textColor=[UIColor whiteColor];
    //                [self addSubview:lb1];
    //                [lb1 release];
    //
    //                break;
    //
    //            case 2:
    //                lb1=[[UILabel alloc] initWithFrame:CGRectMake(365, 0,45, 44)];
    //                lb1.backgroundColor=[UIColor clearColor];
    //                lb1.text=[array objectAtIndex:i];
    //                lb1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:18];
    //
    //                lb1.textColor=[UIColor whiteColor];
    //                [self addSubview:lb1];
    //                [lb1 release];
    //
    //                break;
    //
    //            case 3:
    //                lb1=[[UILabel alloc] initWithFrame:CGRectMake(445, 0,45, 44)];
    //                lb1.backgroundColor=[UIColor clearColor];
    //                lb1.text=[array objectAtIndex:i];
    //                lb1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:18];
    //
    //                lb1.textColor=[UIColor whiteColor];
    //                [self addSubview:lb1];
    //                [lb1 release];
    //
    //                break;
    //
    //            case 4:
    //                lb1=[[UILabel alloc] initWithFrame:CGRectMake(545, 0,75, 44)];
    //                lb1.backgroundColor=[UIColor clearColor];
    //                lb1.text=[array objectAtIndex:i];
    //                lb1.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:18];
    //                lb1.textColor=[UIColor whiteColor];
    //                [self addSubview:lb1];
    //                [lb1 release];
    //
    //                break;
    //
    //
    //            default:
    //                break;
    //        }
    //    }
    //    [array release];
    //    _table=[[UILabel alloc] initWithFrame:CGRectMake(60, 0, 130, 44)];
    //    _table.textColor=[UIColor whiteColor];
    //
    //    _table.textAlignment=UITextAlignmentCenter;
    //    _table.backgroundColor=[UIColor clearColor];
    //    _table.text=[Singleton sharedSingleton].Seat;
    //    [self addSubview:_table];
    //    _CheckNum=[[UILabel alloc] initWithFrame:CGRectMake(270, 0, 90, 44)];
    //    _CheckNum.backgroundColor=[UIColor clearColor];
    //    _CheckNum.text=[Singleton sharedSingleton].CheckNum;
    //    _CheckNum.textColor=[UIColor whiteColor];
    //    [self addSubview:_CheckNum];
    //    _man=[[UILabel alloc] initWithFrame:CGRectMake(420, 0, 35, 44)];
    //    _man.textColor=[UIColor whiteColor];
    //    _man.backgroundColor=[UIColor clearColor];
    //    if ([[Singleton sharedSingleton].man isEqualToString:@""]||[[Singleton sharedSingleton].man isEqualToString:NULL]||[[Singleton sharedSingleton].man isEqualToString:nil]||[[Singleton sharedSingleton].man isEqualToString:@"(null)"])
    //    {
    //        _man.text=@"0";
    //    }
    //    else
    //    {
    //        _man.text=[Singleton sharedSingleton].man;
    //    }
    //
    //    [self addSubview:_man];
    //    _woman=[[UILabel alloc] initWithFrame:CGRectMake(530-30, 0, 35, 44)];
    //    _woman.backgroundColor=[UIColor clearColor];
    //    if ([[Singleton sharedSingleton].woman isEqualToString:@""]||[[Singleton sharedSingleton].woman isEqualToString:NULL]||[[Singleton sharedSingleton].woman isEqualToString:nil]||[[Singleton sharedSingleton].woman isEqualToString:@"(null)"])
    //    {
    //        _woman.text=@"0";
    //    }
    //    else
    //    {
    //        _woman.text=[Singleton sharedSingleton].woman;
    //    }
    //
    //
    //    _woman.textColor=[UIColor whiteColor];
    //    [self addSubview:_woman];
    //    UILabel *user=[[UILabel alloc] initWithFrame:CGRectMake(620, 0, 45, 44)];
    //    user.backgroundColor=[UIColor clearColor];
    //    user.text=[[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    //    user.textColor=[UIColor whiteColor];
    //    [self addSubview:user];
    
    
    
}

-(void)showVip
{
    if(isShowVipMessage)
    {
        [_delegate showVipMessageView:_vipmessage andisShowVipMessage:isShowVipMessage];
        isShowVipMessage=NO;
    }
    else
    {
        [_delegate showVipMessageView:_vipmessage andisShowVipMessage:isShowVipMessage];
        isShowVipMessage=YES;
    }
    
    
}
-(void)segmentClick:(UISegmentedControl *)segment1
{
    if(segment1.selectedSegmentIndex!=10)
    {
        if(segment1.selectedSegmentIndex==9)
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",0] andSegment:segment1];
        }
        else
        {
            [_delegate selectSegmentIndex:[NSString stringWithFormat:@"%d",segment.selectedSegmentIndex+1] andSegment:segment1];
        }
    }
    else
    {
        [_delegate selectSegmentIndex:@"X" andSegment:segment1];
    }
}
-(void)setsegmentIndex:(NSString *)index
{
    segment.selectedSegmentIndex=11;
}
-(void)setTitle:(NSString *)title
{
    [segment setTitle:title forSegmentAtIndex:11];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
