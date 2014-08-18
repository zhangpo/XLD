//
//  AKSelectCheck.m
//  BookSystem
//
//  Created by chensen on 13-12-22.
//
//

#import "AKSelectCheck.h"
#import "BSDataProvider.h"
#import "Singleton.h"
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"
#import "AKSelectCheckCell.h"
#import "AKsIsVipShowView.h"
#import "SVProgressHUD.h"
@interface AKSelectCheck ()
//20111121
@end

@implementation AKSelectCheck
{
    NSMutableArray *_dataArray;
    UITableView *table;
    AKMySegmentAndView *akv;
    AKsIsVipShowView    *showVip;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _dataArray=nil;
    table=nil;
    akv=nil;
    showVip=nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    _dataArray=[[NSMutableArray alloc] init];
    [SVProgressHUD showProgress:-1 status:@"数据加载中..." maskType:SVProgressHUDMaskTypeBlack];
    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(queryProduct) object:nil];
    [thread start];
    
    [AKsNetAccessClass sharedNetAccess].showVipMessageDict=nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *view=[[UIImageView alloc] initWithFrame:CGRectMake(0, 120-60, 164, 1024-114+60)];
    view.image=[UIImage imageNamed:@"logo.jpg"];
    [self.view addSubview:view];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame=CGRectMake((768-164)/2+60,1004-54, 135, 54);
    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
    lb.text=@"返 回";
    lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:25];
    lb.backgroundColor=[UIColor clearColor];
    lb.textColor=[UIColor whiteColor];
    [btn addSubview:lb];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:btn];
    
//    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame=CGRectMake((768-164)/2+60,940, 120, 60);
//    [btn setTitle: forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
//
//    [self.view addSubview:btn];
}
-(void)queryProduct
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    _dataArray=[dp queryProduct:[Singleton sharedSingleton].Seat];
    [SVProgressHUD dismiss];
    if ([_dataArray count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询结果为空或连接超时，请稍后重试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }else
    {
        if ([[_dataArray objectAtIndex:0] count]==0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"查询结果为空" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
        else {
            table=[[UITableView alloc] initWithFrame:CGRectMake(164,120-60, 768-164, 1024-220+60) style:UITableViewStylePlain];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            table.delegate=self;
            table.dataSource=self;
            [self.view addSubview:table];
        }
    }
    akv=[[AKMySegmentAndView alloc]init];
    akv.delegate=self;
    akv.frame=CGRectMake(0, 0, 768, 114);
    NSLog(@"%@",[akv subviews]);
    //    for (int i=1; i<[akv.subviews count]; i++)
    //    {
    //        [[akv.subviews lastObject]removeFromSuperview];
    //    }
    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    [self.view addSubview:akv];
    //    [akv removeFromSuperview];
    //    akv=nil;
    //    akv= [[AKMySegmentAndView alloc] init];
    //    akv.delegate=self;
    //    akv.frame=CGRectMake(0, 0, 768, 114);
    //    [[akv.subviews objectAtIndex:1]removeFromSuperview];
    //    [self.view addSubview:akv];
}
-(void)btnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 60)];
//    UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768, 30)];
//    UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0,30, 768, 30)];
//    [view addSubview:lb1];
//    [view addSubview:lb];
//    if (section==0) {
//        lb.text=@"已点菜品";
//        NSArray *array=[_dataArray objectAtIndex:0];
//        int i=0;
//        int j=0;
//        for (AKsCanDanListClass *caidan in array) {
//            if (![caidan.tpname isEqualToString:caidan.pcname]) {
//
//            }else
//            {
//                i+=[caidan.pcount intValue];
//                j+=[caidan.price intValue];
//            }
//        }
//        lb1.text=[NSString stringWithFormat:@"共点菜品%d道,总计%d元",i,j];
//        return view;
//    }
//    else
//    {
//        view.frame=CGRectMake(0, 0, 768, 30);
//        lb1.text=@"结算方式";
//        return view;
//    }
//}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"已点菜品";
    }else if (section==1){
        return @"全单附加项";
    }
    else
    {
        return @"结算方式";
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 70;
    }else
    {
        return 40;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768-164, 70)];
    view.backgroundColor=[UIColor lightGrayColor];
    if (section==0) {
        float i=0.0;
        float j=0.0;
        float k=0.0;
        NSArray *array=[_dataArray objectAtIndex:0];
        for (AKsCanDanListClass *caidan in array) {
            if (![caidan.tpname isEqualToString:caidan.pcname]&&[caidan.istc intValue]==1) {
                k+=[caidan.fujiaprice floatValue];
            }else
            {
                i+=[caidan.pcount floatValue];
                j+=[caidan.price floatValue];
                k+=[caidan.fujiaprice floatValue];
            }
        }
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 768-164, 30)];
        lb.text=[NSString stringWithFormat:@"共点菜品%.1f道,总计%.2f元,附加项价格:%.2f",i,j,k];
        lb.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb];
        UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 30,100, 40)];
        lb1.text=@"菜品名";
        lb1.backgroundColor=[UIColor clearColor];
        lb1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb1];
        UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(100, 30,59, 40)];
        lb2.text=@"数量";
        lb2.backgroundColor=[UIColor clearColor];
        
        lb2.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb2];
        UILabel *lb3=[[UILabel alloc] initWithFrame:CGRectMake(159, 30, 59, 40)];
        lb3.text=@"价格";
        lb3.backgroundColor=[UIColor clearColor];
        
        lb3.textAlignment=NSTextAlignmentRight;
        [view addSubview:lb3];
        UILabel *lb4=[[UILabel alloc] initWithFrame:CGRectMake(100+59*2, 30, 59, 40)];
        lb4.text=@"单位";
        lb4.backgroundColor=[UIColor clearColor];
        
        lb4.textAlignment=NSTextAlignmentRight;
        [view addSubview:lb4];
        UILabel *lb5=[[UILabel alloc] initWithFrame:CGRectMake(100+59*3, 30, 300, 40)];
        lb5.backgroundColor=[UIColor clearColor];
        
        lb5.textAlignment=NSTextAlignmentCenter;
        lb5.text=@"附加项";
        [view addSubview:lb5];
    }
    else if(section==2)
    {
        view.frame=CGRectMake(0, 0, 768-164, 40);
        UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        lb1.text=@"结算方式";
        lb1.backgroundColor=[UIColor clearColor];
        lb1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb1];
        UILabel *lb2=[[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 40)];
        lb2.text=@"结算金额";
        lb2.backgroundColor=[UIColor clearColor];
        lb2.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb2];
    }
    else
    {
        view.frame=CGRectMake(0, 0, 768-164, 40);
        UILabel *lb1=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
        lb1.text=@"全单附加项";
        lb1.backgroundColor=[UIColor clearColor];
        lb1.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb1];
        
    }
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName=@"cell";
    AKSelectCheckCell *cell=[table dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell=[[AKSelectCheckCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    cell.name.text=@"";
    cell.count1.text=@"";
    cell.price.text=@"";
    cell.unit.text=@"";
    cell.textLabel.text=@"";
    cell.addition.text=@"";
    if (indexPath.section==0) {
        cell.name.frame=CGRectMake(0, 0,100, 60);
        cell.count1.frame=CGRectMake(100, 0,59, 60);
        cell.price.frame=CGRectMake(159, 0, 59, 60);
        cell.unit.frame=CGRectMake(100+59*2, 0, 59, 60);
        
        cell.name.text=((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).pcname;
        cell.count1.text=((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).pcount;
        cell.price.text=[NSString stringWithFormat:@"%.2f",[((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).price floatValue]];
        cell.price.textAlignment=NSTextAlignmentRight;
        cell.unit.text=((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).unit;
        cell.addition.text=[NSString stringWithFormat:@"%@    附加项价格:%@",((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).fujianame,((AKsCanDanListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).fujiaprice];
    }
    else if(indexPath.section==1){
        NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        cell.textLabel.text=[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else if(indexPath.section==2){
        cell.count1.frame=CGRectMake(0, 0, 0, 0);
        cell.unit.frame=CGRectMake(0, 0, 0, 0);
        cell.addition.frame=CGRectMake(0, 0, 0, 0);
        //        cell.lb.frame=CGRectMake(0, 0, 0, 0);
        cell.name.frame=CGRectMake(0, 0, 250, 60);
        cell.price.frame=CGRectMake(250, 0, 100, 60);
        cell.name.text=((AKsYouHuiListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).youName;
        cell.price.text=[NSString stringWithFormat:@"%.2f",[((AKsYouHuiListClass *)[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]).youMoney floatValue]];
        
    }
    return cell;
}

#pragma mark  AKMySegmentAndViewDelegate
-(void)showVipMessageView:(NSArray *)array andisShowVipMessage:(BOOL)isShowVipMessage
{
    if(isShowVipMessage)
    {
        [showVip removeFromSuperview];
        showVip=nil;
    }
    else
    {
        showVip=[[AKsIsVipShowView alloc]initWithArray:array];
        [self.view addSubview:showVip];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
