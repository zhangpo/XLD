//
//  BSQueryViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSQueryViewController.h"
#import "CVLocalizationSetting.h"
#import "Singleton.h"
#import "AKOrderRepastViewController.h"
#import "BSDataProvider.h"
#import "AKQueryViewController.h"
#import "MMDrawerController.h"
#import "AKOrderLeft.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "SVProgressHUD.h"
#import "AKsIsVipShowView.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"

@implementation BSQueryViewController
{
    UISearchBar *searchBar;
    NSMutableArray *_dataArray;
    NSDictionary *_dataDict;
    NSMutableArray *_selectArray;
    NSMutableArray *_dish;
    int x;
    UILabel         *lblTitle;
    AKsIsVipShowView    *showVip;
    NSString *str;
    AKMySegmentAndView  *segmen;
    NSMutableArray *_searchByName;
    NSArray *_searchArray;
    UILabel *lblCommon;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    _dataArray=nil;
    _searchArray=nil;
    _searchByName=nil;
    _selectArray=nil;
    segmen=nil;
    tvOrder=nil;
    _dish=nil;
    lblCommon=Nil;
    [super viewWillDisappear:animated];
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchByName=[[NSMutableArray alloc] init];
    _dataDict=[[NSDictionary alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    [self viewLoad1];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD showProgress:-1 status:@"数据加载中..." maskType:SVProgressHUDMaskTypeBlack];
    segmen=[[AKMySegmentAndView alloc] init];
    segmen.frame=CGRectMake(0, 0, 768, 114-60);
    segmen.delegate=self;
    _selectArray=[[NSMutableArray alloc] init];
    [[segmen.subviews objectAtIndex:1]removeFromSuperview];
    [self.view addSubview:segmen];
    tvOrder = [[UITableView alloc] initWithFrame:CGRectMake(0, 220, 768, self.view.bounds.size.height-350-35) style:UITableViewStylePlain];
    tvOrder.delegate = self;
    tvOrder.dataSource = self;
    tvOrder.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tvOrder];
    _dish=[[NSMutableArray alloc] init];
    [self updata];
}
-(void)viewLoad1
{
    
    [self searchBarInit];
    //    [Singleton sharedSingleton].Seat=@"33";
    //    [Singleton sharedSingleton].CheckNum=@"P000005";
    
    x=0;
    
    UIImageView *imgvCommon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 850, 768, 1004-850)];
    [imgvCommon setImage:[UIImage imageNamed:@"CommonCover"]];
    [self.view addSubview:imgvCommon];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]){
        segmen.man.text=[[_dataArray objectAtIndex:0] objectForKey:@"man"];
        segmen.woman.text=[[_dataArray objectAtIndex:0] objectForKey:@"woman"];
    }
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 175-60, 768, 50)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.font = [UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [self.view addSubview:lblTitle];
    lblCommon = [[UILabel alloc] initWithFrame:CGRectMake(35, 15+33, 733, 30)];
    lblCommon.textColor = [UIColor grayColor];
    lblCommon.font = [UIFont systemFontOfSize:20];
    lblCommon.backgroundColor=[UIColor clearColor];
    lblCommon.textAlignment=NSTextAlignmentCenter;
    
    [imgvCommon addSubview:lblCommon];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 170, 768, 50)];
    view.backgroundColor=[UIColor redColor];
    NSArray *array=[[NSArray alloc] initWithObjects:@"全选",@"划菜",@"品名",@"数量",@"价格",@"单位",@"小计",@"催菜", nil];
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(5, 5, 768/7-10,40);
    [btn setBackgroundColor:[UIColor whiteColor]];
    
    //    [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(AllSelect) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:[array objectAtIndex:0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
    [view addSubview:btn];
    for (int i=1; i<8; i++) {
        UILabel *lb=[[UILabel alloc] init];        lb.textColor=[UIColor whiteColor];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.text=[array objectAtIndex:i];
        lb.backgroundColor=[UIColor clearColor];
        lb.textAlignment=NSTextAlignmentCenter;
        [view addSubview:lb];
        if (i<3) {
            lb.frame=CGRectMake(768/7*i, 0, 768/7, 50);
        }else
        {
            lb.frame=CGRectMake(768/7*3+(768-768/7*3)/5*(i-3), 0, (768-768/7*3)/5, 50);
        }
    }
    [self.view addSubview:view];
    //    tvOrder.tableHeaderView=view;
    NSArray *array2=[[NSArray alloc] initWithObjects:@"台位",@"催菜",@"划菜",@"加菜",@"打印",@"预结算",@"返回", nil];
    for (int i=0; i<7; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake((768-20)/7*i, 1024-70, 130, 50);
        UILabel *lb=[[UILabel alloc] initWithFrame:CGRectMake(10,20, 120, 30)];
        lb.text=[array2 objectAtIndex:i];
        lb.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lb.backgroundColor=[UIColor clearColor];
        lb.textColor=[UIColor whiteColor];
        [btn addSubview:lb];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_normal_button.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"cv_rotation_highlight_button.png"] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        if (i==0) {
            [btn addTarget:self action:@selector(tableClicked) forControlEvents:UIControlEventTouchUpInside];
            //        }else if (i==1){
            //            [btn addTarget:self action:@selector(chuckOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if(i==1){
            [btn addTarget:self action:@selector(gogoOrder) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==2){
            [btn addTarget:self action:@selector(over) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(i==3){
            [btn addTarget:self action:@selector(addDush) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==4){
            [btn addTarget:self action:@selector(printQuery) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==5){
            [btn addTarget:self action:@selector(QueryView) forControlEvents:UIControlEventTouchUpInside];
        }else if (i==6){
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        }
        btn=nil;
    }
    
    
}
-(void)updata
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
    {
        _dataArray=[NSMutableArray arrayWithArray:[BSDataProvider tableNum:[Singleton sharedSingleton].Seat orderID:[Singleton sharedSingleton].CheckNum]];
    }
    else{
        BSDataProvider *bs=[[BSDataProvider alloc] init];
        NSDictionary *dict=[bs queryCompletely];
        _dataArray=[dict objectForKey:@"data"];
        str=[dict objectForKey:@"Common"];
        [self updateTitle];
        [tvOrder reloadData];
        
    }
    _searchArray=[[NSArray alloc] initWithArray:_dataArray];
    [[SearchCoreManager share] Reset];
    for (int i=0; i<[_dataArray count]; i++) {
        SearchBage *search=[[SearchBage alloc] init];
        search.localID = [NSNumber numberWithInt:i];
        search.name=[[_dataArray objectAtIndex:i] objectForKey:@"PCname"];
        //        NSMutableArray *ary=[[NSMutableArray alloc] init];
        //        [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"ITCODE"]];
        //        search.phoneArray=ary;
        //        [_dict setObject:search forKey:search.localID];
        [[SearchCoreManager share] AddContact:search.localID name:search.name phone:nil];
    }
    lblCommon.text=str;
    [SVProgressHUD dismiss];
}

-(void)AllSelect
{
    x=0;
    if ([_selectArray count]==0) {
        [_selectArray removeAllObjects];
        for (NSDictionary *dict in _dataArray) {
            [dict setValue:@"1" forKey:@"select"];
            [_selectArray addObject:dict];
        }
    }
    else
    {
        for (NSDictionary *dict in _dataArray) {
            [dict setValue:@"0" forKey:@"select"];
            [_selectArray addObject:dict];
        }
        [_selectArray removeAllObjects];
    }
    [tvOrder reloadData];
}
- (void)searchBarInit {
    searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 120-60, 768, 50)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeDefault;
	searchBar.backgroundColor=[UIColor clearColor];
	searchBar.translucent=YES;
	searchBar.placeholder=@"搜索";
	searchBar.delegate = self;
	searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:searchBar];
}
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    //    NSMutableArray *array=[[NSMutableArray alloc] init];
    if ([_searchByName count]>0) {
        for(int j=0;j<=[_searchByName count]-1;j++){
            for (int i=0;i<[_searchByName count]-j-1;i++){
                int k=[[_searchByName objectAtIndex:i] intValue];
                int y=[[_searchByName objectAtIndex:i+1] intValue];
                if (k>y) {
                    [_searchByName exchangeObjectAtIndex:i withObjectAtIndex:i+1];
                }
            }
        }
    }
    [_dataArray removeAllObjects];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        int j=[localID intValue];
        [_dataArray addObject:[_searchArray objectAtIndex:j]];
        if ([_searchBar.text length]>0) {
            
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
        //        for (int k=0; k<[[Singleton sharedSingleton].dishArray count]; k++) {
        //            if (j==k) {
        ////                [_searchDict objectForKey:localID];
        //
        //            }
        //        }
    }
    [tvOrder reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)addDush{
    [self AKOrder];
    //    AKOrderRepastViewController *ak=[[AKOrderRepastViewController alloc] init];
    //    [self.navigationController pushViewController:ak animated:YES];
}
-(void)AKOrder
{
    UIViewController * leftSideDrawerViewController = [[AKOrderLeft alloc] init];
    
    UIViewController * centerViewController = [[AKOrderRepastViewController alloc] init];
    
    //    UIViewController * rightSideDrawerViewController = [[RightViewController alloc] init];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsPortrait(interfaceOrientation));
}
//
//- (NSArray *)seperatedByType:(NSArray *)foods{
//    return [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:foods,@"foods",@"1",@"classid", nil]];
//
//    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
//    for (int i=0;i<foods.count;i++){
//        NSDictionary *dict = [foods objectAtIndex:i];
//        BOOL ispack = [[dict objectForKey:@"isPack"] boolValue];
//        if (ispack){
//            if (![mut objectForKey:@"pack"]){
//                [mut setObject:[NSMutableArray array] forKey:@"pack"];
//            }
//
//            [[mut objectForKey:@"pack"] addObject:dict];
//        }else{
//            NSString *classid = [[dict objectForKey:@"food"] objectForKey:@"CLASS"];
//
//            if (![mut objectForKey:classid]){
//                [mut setObject:[NSMutableArray array] forKey:classid];
//            }
//
//            [[mut objectForKey:classid] addObject:dict];
//        }
//    }
//
//    NSMutableArray *mutary = [NSMutableArray array];
//    for (NSString *key in mut.allKeys){
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[mut objectForKey:key],@"foods",key,@"classid", nil];
//        [mutary addObject:dic];
//    }
//    return [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:foods,@"foods",@"1",@"classid", nil]];
//}

#pragma mark -
#pragma mark TableView Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    BSQueryCell *cell = (BSQueryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSQueryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegete=self;
    }
    NSString *str=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"select"];
    cell.lblPrice.textAlignment=UITextAlignmentRight;
    cell.lblcui.text=@"";
    cell.lbltalPreice.text=@"";
    cell.lblstart.text=@"";
    cell.backgroundColor=[UIColor whiteColor];
    cell.lblPrice.text=@"";
    cell.lblfujia.text=@"";
    cell.lblfujia.hidden=NO;
    //    cell.lblover.text=@"";
    if ([str isEqualToString:@"1"]) {
        [cell.btn setImage:[UIImage imageNamed:@"select_yes.png"]];
        //        [cell.btn setBackgroundImage:[UIImage imageNamed:@"select_yes.png"] forState:UIControlStateNormal];
    }
    else{
        [cell.btn setImage:[UIImage imageNamed:@"select_no.png"]];
        //        [cell.btn setBackgroundImage:[UIImage imageNamed:@"select_no.png"] forState:UIControlStateNormal];
        //        cell.btn.selected=YES;
    }
    cell.dataDic=[_dataArray objectAtIndex:indexPath.row];
    NSArray *ary4=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"] componentsSeparatedByString:@"!"];
    
    if ([ary4 count]==1&&([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==NULL||[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==nil||[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"] isEqualToString:@""])) {
        cell.view.frame=CGRectMake(0, 49, 768, 2);
        cell.lblfujia.hidden=YES;
    }else
    {
        cell.view.frame=CGRectMake(0, 79, 768, 2);
    }
    NSMutableString *FujiaName =[NSMutableString stringWithFormat:@"附加项:"];
    for (NSString *str1 in ary4) {
        [FujiaName appendFormat:@"%@ ",str1];
    }
    NSArray *ary5=[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujiaprice"] componentsSeparatedByString:@"!"];
    float fujiaprice=0.0;
    for (NSString *str1 in ary5) {
        fujiaprice+=[str1 floatValue];
    }
    [FujiaName appendFormat:@"  附加项价格:%.2f",fujiaprice];
    cell.lblfujia.text=FujiaName;
    cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"];
    cell.lblPrice.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
    {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Over"] isEqualToString:@"0"]) {
            [cell.lblover setImage:[UIImage imageNamed:@"餐盘上菜1.png"]];
            cell.lblhua.hidden=NO;
        }
        else
        {
            [cell.lblover setImage:[UIImage imageNamed:@"未上餐盘1.png"]];
            cell.lblhua.hidden=YES;
        }
        cell.over.text=[NSString stringWithFormat:@"%@/%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Over"],[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"]];
    }
    else{
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"] intValue]-[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Over"] intValue]==0) {
            [cell.lblover setImage:[UIImage imageNamed:@"餐盘上菜1.png"]];
            cell.lblhua.hidden=NO;
        }
        else
        {
            [cell.lblover setImage:[UIImage imageNamed:@"未上餐盘1.png"]];
            cell.lblhua.hidden=YES;
        }
        cell.over.text=[NSString stringWithFormat:@"%d/%@",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"] intValue]-[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Over"] intValue],[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"]];
    }
    
    if([Singleton sharedSingleton].isYudian)
    {
        cell.lblstart.text=@"预";
        cell.lblstart.textColor=[UIColor orangeColor];
    }
    else if([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CLASS"] intValue]==2)
    {
        cell.lblstart.text=@"叫";
        cell.lblstart.textColor=[UIColor redColor];
    }
    else if([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CLASS"] intValue]==1)
    {
        cell.lblstart.text=@"即";
        cell.lblstart.textColor=[UIColor blueColor];
    }else
    {
        cell.lblstart.text=@"";
    }
    
    NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CLASS"]);
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Tpcode"] isEqualToString:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Pcode"]]||[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Tpcode"] isEqualToString:@""]) {
        cell.lblPrice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"promonum"] intValue]>0) {
            NSLog(@"%@",[_dataArray objectAtIndex:indexPath.row]);
            cell.lblCame.text=[NSString stringWithFormat:@"%@-赠%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"],[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"promonum"]];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]){
                cell.lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]-[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"promonum"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]];
            }else
            {
                cell.lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"talPreice"] floatValue]];
            }
            cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"];
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]){
                if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weightflg"] intValue]==2) {
                    cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weight"];
                    cell.lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weight"] floatValue]];
                }
                else
                {
                    cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"];
                    cell.lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue]*[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"] floatValue]];
                }
            }else
            {
                cell.lbltalPreice.text=[NSString stringWithFormat:@"%.2f",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"talPreice"] floatValue]];
            }
            cell.lblCame.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"];
            
        }
        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"unit"];
        NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Urge"]);
        cell.lblcui.text=[NSString stringWithFormat:@"催%d次",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Urge"] intValue]];
    }
    else
    {
        NSLog(@"%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"]);
        cell.lblCame.text=[NSString stringWithFormat:@"--%@",[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"PCname"]];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]) {
            if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weightflg"] intValue]==2) {
                cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Weight"];
            }
            else
            {
                cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"CNT"];
            }
        }else
        {
            cell.lblCount.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"pcount"];
        }
        cell.lblUnit.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"unit"];
        cell.lblcui.text=[NSString stringWithFormat:@"催%d次",[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"Urge"] intValue]];
    }
    return cell;
}
-(void)cell:(BSQueryCell *)cell hua:(NSString *)str1
{
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"预点不能划菜" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
//    [cell.dataDic setValue:str forKey:@"count"];
    if ([str1 intValue]==0) {
//        if ([[cell.dataDic objectForKey:@"Over"] intValue]!=[[cell.dataDic objectForKey:@"pcount"] intValue])
//        {
//            return;
//        }
        [cell.dataDic setValue:[cell.dataDic objectForKey:@"Over"] forKey:@"count"];
    }
    if ([str1 intValue]==1) {
        NSString *string=[NSString stringWithFormat:@"%d",[[cell.dataDic objectForKey:@"pcount"] intValue]-[[cell.dataDic objectForKey:@"Over"] intValue]];
        [cell.dataDic setValue:string forKey:@"count"];
        if ([[cell.dataDic objectForKey:@"Over"] intValue]==[[cell.dataDic objectForKey:@"pcount"] intValue])
        {
            return;
        }
    }
    [SVProgressHUD showProgress:-1 status:@"划菜中..." maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSString *dict=[dp scratch:cell.dataDic andtag:[str1 intValue]];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *ary = [dict componentsSeparatedByString:@"@"];
            if ([[ary objectAtIndex:0] intValue]!=0) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary objectAtIndex:1] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
            }
            if (dict==nil) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接断开，请稍后再试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
            }
            [self updata];
            int i=0;
            for (NSDictionary *dict in _dataArray) {
                if ([[dict objectForKey:@"Over"] intValue]!=[[dict objectForKey:@"pcount"] intValue]) {
                    i++;
                }
            }
            [_dish removeAllObjects];
            [_selectArray removeAllObjects];
            [tvOrder reloadData];
            [SVProgressHUD dismiss];
        });
    });
}
//划菜
-(void)over{
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"预点不能划菜" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSLog(@"%@",_selectArray);
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]){
        NSMutableArray *array=[NSMutableArray array];
        for (NSDictionary *dict in _selectArray) {
            int i=0;
            if ([[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Pcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]) {
                for (NSDictionary *dict1 in _selectArray) {
                    if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]&&![[dict1 objectForKey:@"Pcode"] isEqualToString:[dict1 objectForKey:@"Tpcode"]]&&[[dict1 objectForKey:@"PKID"] isEqualToString:[dict objectForKey:@"PKID"]]){
                        int k=0;
                        if ([array count]==0) {
                            [array addObject:[NSString stringWithFormat:@"%d",i]];
                        }
                        else{
                            for (int j=0;j<[array count];j++) {
                                int y=[[array objectAtIndex:j] intValue];
                                if (y==i) {
                                    k++;
                                }
                            }
                            if (k==0) {
                                [array addObject:[NSString stringWithFormat:@"%d",i]];
                            }
                        }
                    }
                    i++;
                }
            }
        }
        int k=[array count];
        for (int j=0; j<k; j++) {
            NSLog(@"[[array objectAtIndex:j] intValue]-j=%d",[[array objectAtIndex:j] intValue]-j);
            [_selectArray removeObjectAtIndex:[[array objectAtIndex:j] intValue]-j]
            ;
        }
    }
    if ([_selectArray count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择要划的菜" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        
        [alert show];
    }else
    {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]) {
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            for (NSDictionary *dict in _selectArray) {
                int i=0;
                if ([[dict objectForKey:@"Over"] intValue]>0) {
                    i=[dp updata:dict withNum:[dict objectForKey:@"pcount"] withOver:@"1"];
                }else
                {
                    i=[dp updata:dict withNum:[dict objectForKey:@"pcount"] withOver:@"0"];
                }
                if (i==[_selectArray count]-1) {
                    //                    NSString *currentState=[info objectForKey:@"currentState"];
                    //                    NSString *nextState=[info objectForKey:@"nextState"];
                    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                    [dict setObject:@"10" forKey:@"currentState"];
                    [dict setObject:@"3" forKey:@"nextState"];
                    [dp changTableState:dict];
                }
                if (i==[_selectArray count]) {
                    [dp suppProductsFinish];
                }
            }
            
            [_selectArray removeAllObjects];
            [self updata];
            [tvOrder reloadData];
        }
        else
        {
            [self selectcount];
        }
    }
    //    {
    //        NSDictionary *dict=[_selectArray objectAtIndex:x];
    //        if ([[dict objectForKey:@"pcount"] intValue]>1) {
    //            [dict setValue:[dict objectForKey:@"pcount"] forKey:@"count"];
    //            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"划菜数量" message:[dict objectForKey:@"PCname"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    //            alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
    //            UITextField *tf1 = [alert textFieldAtIndex:0];
    //            tf1.keyboardType=UIKeyboardTypeNumberPad;
    //            tf1.clearButtonMode=UITextFieldViewModeAlways;
    //            //        tf1.text=[dict objectForKey:@"pcount"];
    //            UITextField *tf2 = [alert textFieldAtIndex:1];
    //            [tf2 setSecureTextEntry:NO];
    //            tf2.keyboardType=UIKeyboardTypeNumberPad;
    //
    //            tf2.clearButtonMode=UITextFieldViewModeAlways;
    //            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
    //            {
    //                tf1.placeholder=[NSString stringWithFormat:@"划菜:%@",[dict objectForKey:@"Over"]];
    //                tf2.placeholder=[NSString stringWithFormat:@"反划菜:%d",[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]];
    //            }
    //            else
    //            {
    //                tf1.placeholder=[NSString stringWithFormat:@"划菜:%d",[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]];
    //                tf2.placeholder=[NSString stringWithFormat:@"反划菜:%@",[dict objectForKey:@"Over"]];
    //            }
    //            tf2.delegate=self;
    //            tf1.delegate=self;
    //            //            alert.alertViewStyle=UIAlertViewStyleSecureTextInput;
    //            alert.tag=2;
    //            [alert show];
    //        }else
    //        {
    //            BSDataProvider *dp=[[BSDataProvider alloc] init];
    //                            if (x==[_selectArray count]-1) {
    //                    x=0;
    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
    //                    [self updata];
    //                    [_selectArray removeAllObjects];
    //                    [tvOrder reloadData];
    //                }
    //                else
    //                {
    //                    x++;
    //                    [self over];
    //                }
    //            }else
    //            {
    //                if ([[dict objectForKey:@"pcount"] intValue]==[[dict objectForKey:@"Over"] intValue]) {
    //                    [dict setValue:@"1" forKey:@"recount"];
    //                }else
    //                {
    //                [dict setValue:@"1" forKey:@"count"];
    //                }
    //                [_dish addObject:dict];
    //                [self selectcount];
    //            }
    //        }
    //
    //    for (NSDictionary *dict in _selectArray) {
    //        NSString *str1=[dict objectForKey:@"PKID"];
    //        NSString *str2=[dict objectForKey:@"Pcode"];
    //        if ([[dict objectForKey:@"Over"] intValue]>1) {
    //
    //        }else
    //        {
    //        int i=[BSDataProvider updata:[Singleton sharedSingleton].Seat orderID:[Singleton sharedSingleton].CheckNum pkid:str1 code:str2 Over:@"0"];
    //        if (i==0) {
    //            BSDataProvider *bs=[[BSDataProvider alloc] init];
    //            [bs suppProductsFinish];
    //        }
    //        }
    //
    //    }
    //    [_selectArray removeAllObjects];
    //    _dataArray=[BSDataProvider tableNum:[Singleton sharedSingleton].Seat orderID:[Singleton sharedSingleton].CheckNum];
    //    [tvOrder reloadData];
    //[BSDataProvider]
    //    }
}
-(void)selectcount
{
    //    if ([_dish count]==[_selectArray count]) {
    [SVProgressHUD showProgress:-1 status:@"划菜中..." maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        BSDataProvider *dp=[[BSDataProvider alloc] init];
        NSString *dict=[dp scratch:[NSArray arrayWithArray:_selectArray]];
        NSArray *ary = [dict componentsSeparatedByString:@"@"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[ary objectAtIndex:0] intValue]!=0) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:dict delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
            }
            if (dict==nil) {
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接断开，请稍后再试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
            }
            
            //                }
            [self updata];
            int i=0;
            for (NSDictionary *dict in _dataArray) {
                if ([[dict objectForKey:@"Over"] intValue]!=[[dict objectForKey:@"pcount"] intValue]) {
                    i++;
                }
            }
            [_dish removeAllObjects];
            [_selectArray removeAllObjects];
            [tvOrder reloadData];
            [SVProgressHUD dismiss];
        });
    });
    //    }else
    //    {
    //        x++;
    //        [self over];
    //    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            NSDictionary *dict=[_selectArray objectAtIndex:x];
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            UITextField *tf2=[alertView textFieldAtIndex:1];
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            if ([tf1.text length]>0&&[tf2.text length]>0) {
                [_dish removeAllObjects];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不明确你需要划菜还是反划菜，请核对后再输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                return;
            }
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]) {
                if ([tf1.text intValue]>[[dict objectForKey:@"Over"] intValue]||[tf2.text intValue]>[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]) {
                    [_dish removeAllObjects];
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alert show];
                    return;
                }
                
                int i=0;
                if ([tf1.text length]>0) {
                    i=[dp updata:dict withNum:tf1.text withOver:@"0"];
                    
                }
                else
                {
                    i=[dp updata:dict withNum:tf2.text withOver:@"1"];
                    if (i==[_dataArray count]-1) {
                        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
                        [dic setObject:@"10" forKey:@"currentState"];
                        [dic setObject:@"3" forKey:@"nextState"];
                        [dp changTableState:dic];
                    }
                }
                if (i==[_dataArray count]) {
                    BSDataProvider *bs=[[BSDataProvider alloc] init];
                    [bs suppProductsFinish];
                }
                
                if (x==[_selectArray count]-1) {
                    x=0;
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
                    [_selectArray removeAllObjects];
                    [self updata];
                    [tvOrder reloadData];
                }
                else
                {
                    x++;
                    [self over];
                }
            }else
            {
                if ([tf1.text length]==0&&[tf2.text length]==0) {
                    [dict setValue:@"0" forKey:@"count"];
                    [_dish addObject:dict];
                    [self selectcount];
                }else{
                    if ([tf2.text intValue]>[[dict objectForKey:@"Over"] intValue]||[tf1.text intValue]>[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]) {
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alert show];
                        return;
                    }
                    
                    if ([tf1.text length]>0) {
                        [dict setValue:tf1.text forKey:@"count"];
                        [_dish addObject:dict];
                        [self selectcount];
                    }
                    else
                    {
                        [dict setValue:tf2.text forKey:@"recount"];
                        [_dish addObject:dict];
                        [self selectcount];
                    }
                }
            }
        }
        else
        {
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]) {
                if (x==[_selectArray count]-1) {
                    x=0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
                    
                    [_selectArray removeAllObjects];
                    [self updata];
                    [tvOrder reloadData];
                }
                else
                {
                    x++;
                    [self over];
                }
            }else
            {
                NSDictionary *dict=[_selectArray objectAtIndex:x];
                [dict setValue:@"0" forKey:@"count"];
                [_dish addObject:dict];
                [self selectcount];
            }
            
        }
        
    }
    else if(alertView.tag==3){
        NSDictionary *dict=[_selectArray objectAtIndex:x];
        if (buttonIndex==1) {
            UITextField *tf1 = [alertView textFieldAtIndex:0];
            UITextField *tf2=[alertView textFieldAtIndex:1];
            if ([tf1.text length]>0||[tf2.text length]>0) {
                if ([tf1.text length]==0) {
                    [dict setValue:@"0" forKey:@"pcount"];
                    [dict setValue:tf2.text forKey:@"Over"];
                }
                if ([tf2.text length]==0) {
                    [dict setValue:@"0" forKey:@"Over"];
                    [dict setValue:tf1.text forKey:@"pcount"];
                }
                if ([tf1.text length]>0&&[tf2.text length]>0) {
                    [dict setValue:tf1.text forKey:@"pcount"];
                    [dict setValue:tf2.text forKey:@"Over"];
                }
            }
            if ([tf1.text intValue]>[[dict objectForKey:@"pcount"] intValue]) {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"输入有误" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                return;
            }
            
            if (x==[_selectArray count]-1) {
                x=0;
                return;
            }
            else
            {
                x++;
                [self tuicai];
            }
        }
        else
        {
            if (x==[_selectArray count]-1) {
                x=0;
                return;
                //                [_selectArray removeAllObjects];
                //                _dataArray=[BSDataProvider tableNum:[Singleton sharedSingleton].Seat orderID:[Singleton sharedSingleton].CheckNum];
                //                [tvOrder reloadData];
            }
            else
            {
                x++;
                [dict setValue:@"0" forKey:@"pcount"];
                [dict setValue:@"0" forKey:@"Over"];
                [self tuicai];
            }
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    x=0;
    _dataDict=[NSDictionary dictionary];
    NSInteger i=indexPath.row;
    _dataDict=[_dataArray objectAtIndex:i];
    if ([[_dataDict objectForKey:@"select"] intValue]==1) {
        [_dataDict setValue:@"0" forKey:@"select"];
        [_selectArray removeObject:_dataDict];
    }
    else
    {
        [_dataDict setValue:@"1" forKey:@"select"];
        [_selectArray addObject:_dataDict];
    }
    NSLog(@"%@",_selectArray);
    [tvOrder reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==NULL||[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"]==nil||[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"fujianame"] isEqualToString:@""]) {
        return 50;
    }else
    {
        return 80;
    }
    
}

#pragma mark Bottom Buttons Events
-(void)tableClicked{
    NSArray *array=[self.navigationController viewControllers];
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}
- (void)printQuery{
    [SVProgressHUD showProgress:-1 status:@"预打印中..."];
    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(priPrintOrder) object:nil];
    [thread start];
    
}
-(void)priPrintOrder
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp priPrintOrder];
    [SVProgressHUD dismiss];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:priPrintOrderResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary1 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alerView show];
    }
}
-(void)QueryView
{
    if(![Singleton sharedSingleton].isYudian)
    {
        AKQueryViewController *ak=[[AKQueryViewController alloc] init];
        [self.navigationController pushViewController:ak animated:YES];
    }
    else
    {
        bs_dispatch_sync_on_main_thread(^{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"预点台位，不可执行此操作" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            
        });
    }
}

//催菜
- (void)gogoOrder{
    if ([Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"预点不能催菜" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_selectArray count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择你需要催的菜" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    //    BSDataProvider *dp=[[BSDataProvider alloc] init];
    //    NSLog(@"%@",_dataDict);
    NSMutableArray *array=[NSMutableArray array];
    for (NSDictionary *dict in _selectArray) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"])
        {
            if ([[dict objectForKey:@"Over"] intValue]==0) {
                NSString *str=[NSString stringWithFormat:@"%@已经上菜不能催",[dict objectForKey:@"PCname"]];
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
                return;
            }
        }
        else
        {
            if ([[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]==0) {
                NSString *str=[NSString stringWithFormat:@"%@已经上菜不能催",[dict objectForKey:@"PCname"]];
                UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alerView show];
                return;
            }
        }
        int i=0;
        if ([[dict objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Pcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]) {
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"Tpcode"]]&&![[dict1 objectForKey:@"Pcode"] isEqualToString:[dict1 objectForKey:@"Tpcode"]]&&[[dict1 objectForKey:@"PKID"] isEqualToString:[dict objectForKey:@"PKID"]]){
                    int k=0;
                    if ([array count]==0) {
                        [array addObject:[NSString stringWithFormat:@"%d",i]];
                    }
                    else{
                        for (int j=0;j<[array count];j++) {
                            int y=[[array objectAtIndex:j] intValue];
                            if (y==i) {
                                k++;
                            }
                        }
                        if (k==0) {
                            [array addObject:[NSString stringWithFormat:@"%d",i]];
                        }
                    }
                }
                i++;
            }
        }
    }
    int k=[array count];
    for (int j=0; j<k; j++) {
        NSLog(@"[[array objectAtIndex:j] intValue]-j=%d",[[array objectAtIndex:j] intValue]-j);
        [_selectArray removeObjectAtIndex:[[array objectAtIndex:j] intValue]-j]
        ;
    }
    
    [SVProgressHUD showProgress:-1 status:@"催菜中..."];
    NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(pGogo:) object:_selectArray];
    [thread start];
}
-(void)pGogo:(NSArray *)array
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp pGogo:_selectArray];
    [SVProgressHUD dismiss];
    NSString *result = [[[dict objectForKey:@"ns:callPubitemResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];//[[[[strValue componentsSeparatedByString:@"<oStr>"] objectAtIndex:1] componentsSeparatedByString:@"</oStr>"] objectAtIndex:0];
    NSArray *ary = [result componentsSeparatedByString:@"@"];
    NSLog(@"%@",ary);
    if ([ary count]==1) {
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary objectAtIndex:0] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alerView show];
    }
    else{
        NSLog(@"%@",[ary objectAtIndex:1]);
        if ([[ary objectAtIndex:0] intValue]==0) {
            for (NSDictionary *dict in _selectArray) {
                NSLog(@"%@",dict);
                [dp gogoOrderUpData:dict];
                //                [dp gogoOrderUpData:[dict objectForKey:@"PKID"] withCode:[dict objectForKey:@"Pcode"] withTPNUM:[dict objectForKey:@"TPNUM"]];
            }
            
        }
        UIAlertView *alerView=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary objectAtIndex:1] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alerView show];
    }
    [self updata];
    [tvOrder reloadData];
    [_selectArray removeAllObjects];
    [self updateTitle];
}

-(void)tuicai
{
    NSMutableDictionary *dict=[_selectArray objectAtIndex:x];
    if ([[dict objectForKey:@"pcount"] intValue]>1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"退菜数量" message:[dict objectForKey:@"PCname"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.alertViewStyle=UIAlertViewStyleLoginAndPasswordInput;
        UITextField *tf1 = [alert textFieldAtIndex:0];
        tf1.keyboardType=UIKeyboardTypeNumberPad;
        tf1.clearButtonMode=UITextFieldViewModeAlways;
        tf1.placeholder=[NSString stringWithFormat:@"未上菜:%@",[dict objectForKey:@"Over"]];
        //        tf1.text=[dict objectForKey:@"pcount"];
        UITextField *tf2 = [alert textFieldAtIndex:1];
        [tf2 setSecureTextEntry:NO];
        tf2.keyboardType=UIKeyboardTypeNumberPad;
        tf2.placeholder=[NSString stringWithFormat:@"已划菜:%d",[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue]];
        tf2.clearButtonMode=UITextFieldViewModeAlways;
        
        tf1.delegate=self;
        tf2.delegate=self;
        
        alert.tag=3;
        [alert show];
        
    }else
    {
        if (x==[_selectArray count]-1) {
            x=0;
            return;
            //                [_selectArray removeAllObjects];
            //                _dataArray=[BSDataProvider tableNum:[Singleton sharedSingleton].Seat orderID:[Singleton sharedSingleton].CheckNum];
            //                [tvOrder reloadData];
        }
        else
        {
            x++;
            [self tuicai];
        }
    }
    
}
- (void)back{
    //    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowButton_image"]) {//判断设置里的版本
    [self.navigationController popViewControllerAnimated:YES];
    //    }else{
    //        [self dismissViewControllerAnimated:YES completion:^{
    //        }];
    //    }
}


#pragma mark ChuckView Delegate
//退菜
- (void)chuckOrderWithOptions:(NSDictionary *)info{
    tvOrder.userInteractionEnabled=YES;
    if (info) {
        NSLog(@"%@",_selectArray);
        [SVProgressHUD showProgress:-1 status:@"退菜中..."];
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        NSArray *array=[[NSArray alloc] initWithArray:_selectArray];
        [dict setValue:array forKey:@"dataArray"];
        [dict setValue:info forKey:@"info"];
        NSLog(@"%@",dict);
        NSThread *thread=[[NSThread alloc] initWithTarget:self selector:@selector(chuckOrder:) object:dict];
        [thread start];
    }
    else
    {
        [self updata];
    }
    [tvOrder reloadData];
    [_selectArray removeAllObjects];
    [self updateTitle];
    //    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    //    [vChuck removeFromSuperview];
    //    vChuck = nil;
    //
    //    if (!info)
    //        return;
    //
    //    dChuckCount = 1;
    //
    //
    //    NSString *tab = [self.dicOrder objectForKey:@"tab"];
    //
    //    NSMutableArray *aryOrderToChuck = [NSMutableArray array];
    //    NSArray *ary = [self seperatedByType:[self.dicOrder objectForKey:@"account"]];
    //
    //    for (int i=0;i<[ary count];i++){
    //        NSArray *foods = [[ary objectAtIndex:i] objectForKey:@"foods"];
    //        for (int j=0;j<foods.count;j++){
    //            BSQueryCell *cell = (BSQueryCell *)[tvOrder cellForRowAtIndexPath:[NSIndexPath indexPathForRow:j inSection:i]];
    ////            if (cell.bSelected)
    //                [aryOrderToChuck addObject:[foods objectAtIndex:j]];
    //        }
    //
    //    }
    //
    //    if ([aryOrderToChuck count]==0){
    //        bs_dispatch_sync_on_main_thread(^{
    //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[langSetting localizedString:@"Error"] message:[langSetting localizedString:@"NoFoodToChuckAlert"] delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
    //            [alert show];
    //        });
    //
    //    }
    //    else{
    //        NSMutableDictionary *dicToChuck = [NSMutableDictionary dictionaryWithDictionary:info];
    //        [dicToChuck setObject:tab forKey:@"tab"];
    //        [dicToChuck setObject:aryOrderToChuck forKey:@"account"];
    //
    //        [NSThread detachNewThreadSelector:@selector(chuckFood:) toTarget:self withObject:dicToChuck];
    //
    //
    //    }
    
}
//退菜
//- (void)chuckFood:(NSDictionary *)info{
//    BSDataProvider *dp = [BSDataProvider sharedInstance];
//    NSDictionary *dict = [dp pChuck:info];
//    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
//
//    BOOL bSucceed = [[dict objectForKey:@"Result"] boolValue];
//
//
//    NSString *title,*msg;
//    if (bSucceed){
//        title = [langSetting localizedString:@"ChuckSucceed"];//@"退菜成功";
//        msg = nil;
//        [arySelectedFood removeAllObjects];
//    }
//    else{
//        title = [langSetting localizedString:@"ChuckFailed"];//@"退菜失败";
//        msg = [dict objectForKey:@"Message"];
//    }
//    bs_dispatch_sync_on_main_thread(^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
//        [alert show];
//    });
//
//
//
//    if (bSucceed){
//        [NSThread detachNewThreadSelector:@selector(getQueryResult:) toTarget:self withObject:dicQuery];
//    }
//
//}

-(void)chuckOrder:(NSDictionary *)info
{
    BSDataProvider *dp=[[BSDataProvider alloc] init];
    NSDictionary *dict=[dp checkAuth:[info objectForKey:@"info"]];
    
    NSLog(@"%@",dict);
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:checkAuthResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSLog(@"%@",ary1);
        if ([ary1 count]==1) {
            UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary1 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alwet show];
        }
        else
        {
            
            if ([[ary1 objectAtIndex:0] isEqualToString:@"0"]) {
                NSLog(@"%@",_selectArray);
                NSDictionary *dict1=[dp chkCode:[info objectForKey:@"dataArray"] info:[info objectForKey:@"info"]];
                [SVProgressHUD dismiss];
                NSLog(@"%@",dict1);
                NSString *result1 = [[[dict1 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
                NSArray *ary2 = [result1 componentsSeparatedByString:@"@"];
                
                if ([ary2 count]==1) {
                    UIAlertView *alwet1=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary2 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                    [alwet1 show];
                }
                else
                {
                    
                    if ([[ary2 objectAtIndex:0] isEqualToString:@"0"]) {
                        UIAlertView *alwet1=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary2 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alwet1 show];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"updata" object:nil];
                        [self updata];
                        [tvOrder reloadData];
                    }
                    else
                    {
                        UIAlertView *alwet1=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary2 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                        [alwet1 show];
                    }
                }
                
            }
            else
            {
                NSLog(@"%@",ary1);
                [SVProgressHUD dismiss];
                UIAlertView *alwet=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary1 lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alwet show];
            }
        }
    }
    
}





- (void)handlePrint:(NSNotification *)notification{
    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
    NSDictionary *userInfo = [notification userInfo];
    BOOL bSucceed = [[userInfo objectForKey:@"Result"] boolValue];
    
    
    NSString *title,*msg;
    if (bSucceed)
        title = [langSetting localizedString:@"PrintSucceed"];
    else
        title = [langSetting localizedString:@"PrintFailed"];
    msg = [userInfo objectForKey:@"Message"];
    
    bs_dispatch_sync_on_main_thread(^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:[langSetting localizedString:@"OK"] otherButtonTitles:nil];
        [alert show];
    });
    
    
    
}

#pragma mark Show Latest Price & Number
- (void)updateTitle{
    bs_dispatch_sync_on_main_thread(^{
        float count = 0;
        float fPrice = 0.0f;
        float fAdditionPrice = 0.0f;
        int i=0;
        for (NSDictionary *dic in _dataArray){
            if ([[dic objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dic objectForKey:@"Tpcode"] isEqualToString:[dic objectForKey:@"Pcode"]]||[[dic objectForKey:@"Tpcode"] isEqualToString:@""])
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userSql"]) {
                    if ([[dic objectForKey:@"promonum"] intValue]>0) {
                        float fCount = [[dic objectForKey:@"pcount"] floatValue];
                        count+=[[dic objectForKey:@"pcount"] floatValue];
                        float price = [[dic objectForKey:@"price"] floatValue];
                        float fTotal = price*fCount-[[dic objectForKey:@"promonum"] intValue]*price;
                        fPrice += fTotal;
                    }
                    else{
                        float fCount = [[dic objectForKey:@"pcount"] floatValue];
                        count+=[[dic objectForKey:@"pcount"] floatValue];
                        float price = [[dic objectForKey:@"price"] floatValue];
                        float fTotal = price*fCount;
                        fPrice += fTotal;
                    }
                }else
                {
                    if ([[dic objectForKey:@"pcount"] intValue]>0)
                    {
                        count+=[[dic objectForKey:@"pcount"] intValue];
                    }
                    float price =[[dic objectForKey:@"talPreice"] floatValue];
                    fPrice += price;
                    NSArray *ary5=[[dic objectForKey:@"fujiaprice"] componentsSeparatedByString:@"!"];
                    float fujiaprice=0.0;
                    for (NSString *str1 in ary5) {
                        fujiaprice+=[str1 floatValue];
                    }
                    fPrice+=fujiaprice;

                }
                i++;
            }else
            {
                NSArray *ary5=[[dic objectForKey:@"fujiaprice"] componentsSeparatedByString:@"!"];
                float fujiaprice=0.0;
                for (NSString *str1 in ary5) {
                    fujiaprice+=[str1 floatValue];
                }
                fPrice+=fujiaprice;
            }
        }
        
        lblTitle.text = [NSString stringWithFormat:@"共点菜品: %.1f 道     总计:￥%.2f    账单号:%@",count,fPrice,[Singleton sharedSingleton].CheckNum];
    });
    
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]{1,2}$";
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}




@end
