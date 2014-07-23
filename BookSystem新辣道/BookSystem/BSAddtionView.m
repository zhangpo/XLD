//
//  BSAddtionViewController.m
//  BookSystem
//
//  Created by Dream on 11-5-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSAddtionView.h"
#import "BSAdditionCell.h"
#import "BSDataProvider.h"
#import "CVLocalizationSetting.h"

@implementation BSAddtionView
@synthesize dicInfo;
@synthesize delegate;
@synthesize arySelectedAddtions,aryAdditions,aryResult,tv;


- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        BSDataProvider *dp = [[BSDataProvider alloc] init];
        self.aryAdditions = [NSMutableArray arrayWithArray:[dp getAdditions]];
        NSLog(@"%@",aryAdditions);
        self.aryResult = [NSMutableArray arrayWithArray:aryAdditions];
        arySelectedAddtions =[[NSMutableArray alloc] init];
//        CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
        
        [self setTitle:@"附加项"];
        
        vAddition = [[UIView alloc] initWithFrame:CGRectMake(15, 55, 320, 50)];
        barAddition = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        barAddition.barStyle = UIBarStyleDefault;
        //       barAddition.showsBookmarkButton = YES;
        //       barAddition.tintColor = [UIColor whiteColor];
        barAddition.delegate = self;
        [vAddition addSubview:barAddition];
        [self addSubview:vAddition];
        
        tv = [[UITableView alloc] initWithFrame:CGRectMake(15, 105, 320, 205) style:UITableViewStylePlain];
        tv.backgroundColor = [UIColor whiteColor];
        tv.opaque = NO;
        tv.delegate = self;
        tv.dataSource = self;
        [self addSubview:tv];
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.frame = CGRectMake(350, 90, 100, 44);
        btnConfirm.titleLabel.textColor=[UIColor whiteColor];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"TableButtonRed.png"] forState:UIControlStateNormal];
        btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(350, 150, 100, 44);
        btnCancel.titleLabel.textColor=[UIColor whiteColor];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"TableButtonRed.png"] forState:UIControlStateNormal];
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        tfAddition = [[UITextField alloc] initWithFrame:CGRectMake(350, 210, 100, 44)];
        tfAddition.borderStyle = UITextBorderStyleRoundedRect;
        tfAddition.font = [UIFont systemFontOfSize:12];
        [self addSubview:tfAddition];
        
        [self addSubview:btnConfirm];
        [self addSubview:btnCancel];
    }
    
    return self;
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.






- (void)confirm{
    NSMutableArray *aryMut = [NSMutableArray arrayWithArray:arySelectedAddtions];
//    NSLog(@"%@",arySelectedAddtions);
    
    if ([tfAddition.text length]>0){
        NSDictionary *dicCustom = [NSDictionary dictionaryWithObjectsAndKeys:tfAddition.text,@"FoodFuJia_Des",@"0.0",@"FoodFujia_Checked",nil];
        [aryMut addObject:dicCustom];
        NSLog(@"%@",aryMut);
    }
    NSLog(@"%@",aryMut);
    [delegate additionSelected:aryMut];
}

- (void)cancel{
    [delegate additionSelected:nil];
}

#pragma mark TableView Delegate & DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CellIdentifier";
    BSAdditionCell *cell = (BSAdditionCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[BSAdditionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
        

    }
    NSArray *ary = aryResult;
    
    [cell setContent:[ary objectAtIndex:indexPath.row] withTag:1];
    BOOL selected = NO;
    for (NSDictionary *dic in arySelectedAddtions){
        if ([[[ary objectAtIndex:indexPath.row] objectForKey:@"FOODFUJIA_ID"] isEqualToString:[dic objectForKey:@"FOODFUJIA_ID"]]){
            selected = YES;
            break;
        }
    }

    cell.bSelected = selected;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [aryResult count];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BSAdditionCell *cell = (BSAdditionCell *)[tableView cellForRowAtIndexPath:indexPath];

    cell.bSelected = !cell.bSelected;
    
    BOOL needAdd = YES;
    int index = -1;
    NSLog(@"%@",arySelectedAddtions);
    for (NSDictionary *dicAdd in arySelectedAddtions){
        NSLog(@"%@",dicAdd);
        if ([[dicAdd objectForKey:@"FOODFUJIA_ID"] isEqualToString:[[aryAdditions objectAtIndex:indexPath.row] objectForKey:@"FOODFUJIA_ID"]]){
            needAdd = NO;
            index = [arySelectedAddtions indexOfObject:dicAdd];
            break;
        }
    }
    NSLog(@"%d",indexPath.row);
    if (cell.bSelected)
    {
        NSLog(@"%@",[aryResult objectAtIndex:indexPath.row]);
        [arySelectedAddtions addObject:[aryResult objectAtIndex:indexPath.row]];
    }
    else{
        [arySelectedAddtions removeObject:[aryResult objectAtIndex:indexPath.row]];
    }
        
    NSLog(@"%@",arySelectedAddtions);
    [tv reloadData];
}


NSInteger intSort(id num1,id num2,void *context){
    int v1 = [[(NSDictionary *)num1 objectForKey:@"ITCODE"] intValue];
    int v2 = [[(NSDictionary *)num2 objectForKey:@"ITCODE"] intValue];
    
    if (v1 < v2)
    return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}


#pragma mark SearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText length]>0){
        searchText = [searchText uppercaseString];

        NSArray *ary = aryAdditions;
        int count = [ary count];
        [aryResult removeAllObjects];
        for (int i=0;i<count;i++){
            NSDictionary *dic = [ary objectAtIndex:i];
            
            NSString *strITCODE = [[dic objectForKey:@"ITCODE"] uppercaseString];
            NSString *strINIT = [[dic objectForKey:@"INIT"] uppercaseString];
            NSString *strDES = [dic objectForKey:@"FoodFuJia_Des"];
            if ([strITCODE rangeOfString:searchText].location!=NSNotFound ||
                [strINIT rangeOfString:searchText].location!=NSNotFound ||
                [strDES rangeOfString:searchText].location!=NSNotFound){
                [aryResult addObject:dic];
            }
        }
        
        self.aryResult = [NSMutableArray arrayWithArray:[aryResult sortedArrayUsingFunction:intSort context:NULL]];

        
        [tv reloadData];
    }
    else{
//        [searchBar resignFirstResponder];
        self.aryResult = [NSMutableArray arrayWithArray:aryAdditions];
        self.aryResult = [NSMutableArray arrayWithArray:[aryResult sortedArrayUsingFunction:intSort context:NULL]];
        [tv reloadData];
    }
}

- (void)sortArray:(NSDictionary *)dict{
    
}

@end
