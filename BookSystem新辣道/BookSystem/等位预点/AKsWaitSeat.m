//
//  AKsWaitSeat.m
//  BookSystem
//
//  Created by sundaoran on 13-12-25.
//
//

#import "AKsWaitSeat.h"
#import "PaymentSelect.h"
#import "SVProgressHUD.h"



@implementation AKsWaitSeat
{
    UITableView *_tableView;
    NSString    *_phoneNum;

    
    NSMutableArray *_waitSeatArray;
    AKsWaitSeat *_waitSeat;
}

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        
        [self creatView];
    }
    return self;
}
-(void)creatView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 75)];
    view.backgroundColor=[UIColor colorWithRed:26/255.0 green:76/255.0 blue:129/255.0 alpha:1];
    
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(120, 0, 110, 75)];
    lbl.backgroundColor=[UIColor clearColor];
    lbl.text=@"等位预定";
    lbl.textColor=[UIColor whiteColor];
    lbl.userInteractionEnabled=YES;
    lbl.textAlignment=NSTextAlignmentCenter;
    lbl.font=[UIFont systemFontOfSize:25];
    [view addSubview:lbl];
    
    UIButton *buttonAdd=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@"addphone.png"] forState:UIControlStateNormal];
    buttonAdd.frame=CGRectMake(350-50, 2, 35, 35);
    buttonAdd.tag=1;
    [buttonAdd addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonAdd];
    
    UIButton *buttonMiss=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonMiss setBackgroundImage:[UIImage imageNamed:@"missPhone.png"] forState:UIControlStateNormal];
    buttonMiss.frame=CGRectMake(350-50, 38, 35, 35);
    buttonMiss.tag=2;
    [buttonMiss addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonMiss];
    
    UIButton *buttonRefush=[UIButton buttonWithType:UIButtonTypeCustom];
    [buttonRefush setBackgroundImage:[UIImage imageNamed:@"refush.png"] forState:UIControlStateNormal];
    buttonRefush.frame=CGRectMake(15, 20, 35, 35);
    buttonRefush.tag=3;
    [buttonRefush addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonRefush];
    
    [self addSubview:view];
    
    _tableView=[[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.frame=CGRectMake(0, 75, 350, 900-75);
    _tableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self addSubview:_tableView];
    _waitSeatArray=[[NSMutableArray alloc]init];
    
    [NSThread detachNewThreadSelector:@selector(addshowTableView) toTarget:self withObject:nil];
    
}

-(void)addshowTableView
{
    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode", nil];
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"queryReserveTableNum"]] andPost:dict andTag:queryReserveTableNum];
}


-(void)failedFromWebServie
{
    [_delegate removeHudOnMainThread];
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                      message:@"网络连接失败，请检查网络！"
                                                     delegate:nil
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
        [alert show];
    });
}


-(void)HHTqueryReserveTableNumSuccessFormWebService:(NSDictionary *)dict
{
    
    NSArray *array= [self getArrayWithDict:dict andFunction:queryReserveTableNumName];
    NSLog(@"%@",array);
    [_waitSeatArray removeAllObjects];
    if([[array objectAtIndex:0] length]>5)
    {
        for (NSString *str in array)
        {
            NSArray *values = [str componentsSeparatedByString:@";"];
            AKsWaitSeatClass *wait=[[AKsWaitSeatClass alloc]init];
            wait.phoneNum=[values objectAtIndex:1];
            wait.zhangdan=[values objectAtIndex:2];
            wait.waitNum=[values objectAtIndex:3];
            wait.manNum=[values objectAtIndex:4];
            wait.womanNum=[values objectAtIndex:5];
            [_waitSeatArray addObject:wait];
            
        }
        [_delegate removeHudOnMainThread];
    }
    else
    {
         [_delegate removeHudOnMainThread];
        [self showAlter:[array lastObject]];
    }
    [self reloadDataMyself];
    
    
}
-(void)reloadDataMyself
{
//    _tableView.contentOffset=CGPointMake(0, [_waitSeatArray count]*80);
    [_tableView reloadData];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"刷新成功" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
    [alert show];

}


-(void)showAlter:(NSString *)string
{
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:string
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        
    });
    
}

-(NSArray *)getArrayWithDict:(NSDictionary *)dict andFunction:(NSString *)functionName
{
    NSString *str=[[[dict objectForKey:[NSString stringWithFormat:@"ns:%@Response",functionName]]objectForKey:@"ns:return"]objectForKey:@"text"];
    NSArray *array=[str componentsSeparatedByString:@"@"];
    return array;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return [_waitSeatArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellName];
    }
    cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    cell.textLabel.font=[UIFont systemFontOfSize:20];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:20];
    cell.textLabel.text=@"";
    cell.detailTextLabel.text=@"";
    
    cell.textLabel.text=[NSString stringWithFormat:@"      %@号",((AKsWaitSeatClass *)[_waitSeatArray objectAtIndex:indexPath.row]).waitNum];
    cell.textLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",((AKsWaitSeatClass *)[_waitSeatArray objectAtIndex:indexPath.row]).phoneNum];
    cell.detailTextLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 35)];
    view.backgroundColor=[UIColor colorWithRed:245/255.0 green:202/255.0 blue:0 alpha:1];
    UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fg.png"]];
    imageView.frame=CGRectMake(150, 0, 2, 35);
    [view addSubview:imageView];
    
    UILabel *phoneNum=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 150, 35)];
    phoneNum.textAlignment=NSTextAlignmentCenter;
    phoneNum.text=[NSString stringWithFormat:@"等位编号"];
    phoneNum.backgroundColor=[UIColor clearColor];
    phoneNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [view addSubview:phoneNum];
    
    UILabel *waitNum=[[UILabel alloc]initWithFrame:CGRectMake(152,0, 355/2, 35)];
    waitNum.textAlignment=NSTextAlignmentCenter;
    waitNum.text=[NSString stringWithFormat:@"手机号码"];
    waitNum.backgroundColor=[UIColor clearColor];
    waitNum.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [view addSubview:waitNum];
    
    return view;
}

-(void)buttonClick:(UIButton *)btn
{
    if(1==btn.tag)
    {
        [_delegate clickAddButton];
    }
    else
    {
        [_delegate clickMissButton];
    }
    
}
-(void)reloadDataWaitTableView
{
    _waitSeatArray=[[NSMutableArray alloc]init];

    AKsNetAccessClass *netAccess= [AKsNetAccessClass sharedNetAccess];
    netAccess.delegate=self;
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode", nil];
    [netAccess getRequestFromWebService:[NSString stringWithFormat:@"%@",[AKURLString getMainURLWithKey:@"queryReserveTableNum"]] andPost:dict andTag:queryReserveTableNum];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate clickTableViewIndexRow:[_waitSeatArray objectAtIndex:indexPath.row]];
    
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
