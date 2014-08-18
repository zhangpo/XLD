//
//  AKOrderRepastViewController.m
//  BookSystem
//
//  Created by chensen on 13-11-13.
//
//
#import "AKOrederClassButton.h"
#import "AKOrderRepastViewController.h"
#import "Singleton.h"
#import "SearchCoreManager.h"
#import "SearchBage.h"
#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "BSLogViewController.h"
#import "AKsIsVipShowView.h"
#import "AKComboButton.h"
#import "SVProgressHUD.h"


@interface AKOrderRepastViewController ()

@end

@implementation AKOrderRepastViewController
{
    NSArray *_array;
    NSMutableArray *_buttonArray;
    NSMutableArray *_dataArray;
    NSMutableArray *_selectArray;
    
    NSMutableDictionary *_dict;
    NSMutableArray *_searchByName;
    NSMutableArray *_searchByPhone;
    UISearchBar *_searchBar;
    UIScrollView *_scroll;
    NSMutableArray *_Combo;
    NSMutableArray *_ComButton;
    NSArray *_array1;
    UIImageView *_view;
    UIScrollView *scrollview;
    UIButton *_button;
    NSArray *arry;
//    NSMutableArray *_tableArray;
    AKMySegmentAndView *akmsav;
    UILabel *label;
    NSMutableArray *classButton;
    BSAddtionView *vAddition;
    NSMutableDictionary *_dataDic;
    NSMutableDictionary *_Weight;
    UITableView *_comboTableView;
    int _com;
    int _count;
    int _total;
    int _sele;
    int _btn;
    int _x;
    int _z;
    int cishu;
    int _y;
    
    AKsIsVipShowView    *showVip;
    BSDataProvider      *_dp;
    NSArray *_soldOut;
}
-(void)viewDidDisappear:(BOOL)animated
{
    _array=nil;
    _dataArray=nil;
    _dict=nil;
    _searchByName=nil;
    _searchByPhone=nil;
    _Combo=nil;
    _ComButton=nil;
    for (UIView *view in [scrollview subviews]) {
        [view removeFromSuperview];
    }
    for (UIView *view in [aScrollView subviews]) {
        [view removeFromSuperview];
    }
    _dp=nil;
    _array1=nil;
    arry=nil;
    classButton=nil;
    _selectArray=nil;
    _buttonArray=nil;
    _dataDic=nil;
    _Weight=nil;
    _soldOut=nil;
    classArray=nil;
     [self.view.layer removeAllAnimations];
    [super viewDidDisappear:animated];
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
    [super viewWillDisappear:animated];
    if(_dp)
    {
        _dp=nil;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!_dp)
    {
        
        _dp=[[BSDataProvider alloc]init];
        _dataDic=[NSMutableDictionary dictionary];
        _ComButton=[[NSMutableArray alloc] init];
        _Combo=[[NSMutableArray alloc] init];
        _buttonArray=[[NSMutableArray alloc] init];
        _array=[[NSArray alloc] init];
        classButton=[[NSMutableArray alloc] init];
        //_array=[BSDataProvider selectFood:1];
        classArray =[_dp getClassById];
        [scrollview setContentSize:CGSizeMake(100,60*[classArray count])];
        UIImageView *image=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 60*[classArray count])];
        [image setImage:[UIImage imageNamed:@"feilei ditu.png"]];
        [scrollview addSubview:image];
        image=nil;
        _dataArray=[[NSMutableArray alloc] init];
        _searchByName=[[NSMutableArray alloc] init];
        _searchByPhone=[[NSMutableArray alloc] init];
        _dict=[[NSMutableDictionary alloc] init];
        bs_dispatch_sync_on_main_thread(^{
            _soldOut=[_dp soldOut];
        });
        
        int j=0;
        for (NSDictionary *dict in classArray) {
            AKOrederClassButton *btn=[[AKOrederClassButton alloc] initWithFrame:CGRectMake(0,60*j,90, 59)];
            [btn.button setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
            btn.button.tag=j;
            [btn.button addTarget:self action:@selector(segmentClick1:) forControlEvents:UIControlEventTouchUpInside];
            [scrollview addSubview:btn];
            [classButton addObject:btn];
            j++;
        }
        [self upload];
        
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
}
//-(void)soldOut
//{
//    
//    [SVProgressHUD dismiss];
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    akmsav= [[AKMySegmentAndView alloc] init];
    akmsav.frame=CGRectMake(0, 0, 768, 114);
    akmsav.delegate=self;
    [self.view addSubview:akmsav];
    [self searchBarInit];
    _y=0;
    // Do any additional setup after loading the view from its nib.
    scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 170, 100, 1024-190)];
//    [scrollview setContentSize:CGSizeMake(100,60*i)];
    [self.view addSubview:scrollview];
    scrollview.backgroundColor=[UIColor whiteColor];
    _count=0;
    _total=1;
    _scroll=[[UIScrollView alloc] init];
    _scroll.bounces=NO;
    _view=[[UIImageView alloc] init];
    _view.frame=CGRectMake(90, 350, 678, 580);
    [_view setImage:[UIImage imageNamed:@"bg.png"]];
    _view.userInteractionEnabled=YES;
    _scroll.frame=CGRectMake(0, 35,678, 500);
    [_view addSubview:_scroll];
    [self.view addSubview:_view];
    [self.view sendSubviewToBack:_view];
    aScrollView.frame=CGRectMake(80,175, 688, 740);
    aScrollView.backgroundColor=[UIColor whiteColor];
    
}

-(void)upload
{
    _selectArray=[NSMutableArray array];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *ary =[Singleton sharedSingleton].dishArray;
    
    
    for (UIButton *btn in [aScrollView subviews])
    {
        [btn removeFromSuperview];
    }
    [self button:0];
    [_selectArray removeAllObjects];
    [_ComButton removeAllObjects];
    
    NSArray *array=[_dp selectCache];
    
    if (![ary count])
    {
        for (NSDictionary * dict in array)
        {
            [_selectArray addObject:dict];
        }
    }
    for (NSDictionary *dict in ary)
    {
        [_selectArray addObject:[dict objectForKey:@"food"]];
    }
    for (int i=0; i<[classArray count]; i++) {
        NSLog(@"%d",[[_buttonArray objectAtIndex:i] count]);
        for (int j=0;j<[[_buttonArray objectAtIndex:i] count];j++) {
            int x=0;
            UIButton *btn=[[_buttonArray objectAtIndex:i] objectAtIndex:j];
            for (NSString *str in _soldOut) {
                if ([[[[_dataArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"ITCODE"] isEqualToString:str]) {
                    x++;
                }
            }
            if (x>0) {
                [btn setBackgroundImage:[UIImage imageNamed:@"gq.png"] forState:UIControlStateNormal];
            }else
            {
                [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (btn.selected==NO) {
                [[[btn subviews] lastObject] removeFromSuperview];
                btn.selected=YES;
            }
            for (NSDictionary *dict in _selectArray) {
                int k=0;
                int x=0;
                NSString *str=[dict objectForKey:@"DES"];
                if ([btn.titleLabel.text isEqualToString:str]) {
                    if (btn.selected==NO) {
                        [[[btn subviews] lastObject] removeFromSuperview];
                        btn.selected=YES;
                    }
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"DES"] isEqualToString:str]) {
                            k=k+[[dict1 objectForKey:@"total"] intValue];
                        }
                    }
                    if ([dict objectForKey:@"Tpcode"]==nil||[[dict objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"ITCODE"]]||[[dict objectForKey:@"Tpcode"] isEqualToString:@""]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"diancai01.png"] forState:UIControlStateNormal];
                        NSLog(@"%@",dict);
                        btn.selected=NO;
                        UILabel *lb=[[UILabel alloc] init];
                        lb.textColor=[UIColor redColor];
                        lb.font = [UIFont systemFontOfSize:12];
                        lb.layer.cornerRadius=5;
                        lb.backgroundColor=[UIColor blackColor];
                        lb.textAlignment=NSTextAlignmentRight;
                        lb.backgroundColor=[UIColor clearColor];
                        //            lb.font=[UIFont systemFontOfSize:20];
                        lb.frame=CGRectMake(120-50,80-25,50,25);
                        lb.text=[NSString stringWithFormat:@"%d",_total];
                        lb.text=[NSString stringWithFormat:@"%d",k];
                        //                        j+=[[dict objectForKey:@"total"] intValue];
                        [btn addSubview:lb];
                    }
                }
                
                x++;
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    [self updataTitle];
    [ary removeAllObjects];
}
-(void)changeButtonColor
{
    for (int i=0; i<[classArray count]; i++) {
        for (int j=0;j<[[_buttonArray objectAtIndex:i] count];j++) {
            int x=0;
            UIButton *btn=[[_buttonArray objectAtIndex:i] objectAtIndex:j];
            if (btn.selected==NO) {
                [[[btn subviews] lastObject] removeFromSuperview];
                btn.selected=YES;
            }
            for (NSDictionary *dict in _selectArray) {
                int k=0;
                int x=0;
                NSString *str=[dict objectForKey:@"DES"];
                if ([btn.titleLabel.text isEqualToString:str]) {
                    if (btn.selected==NO) {
                        [[[btn subviews] lastObject] removeFromSuperview];
                        btn.selected=YES;
                    }
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"DES"] isEqualToString:str]) {
                            k=k+[[dict1 objectForKey:@"total"] intValue];
                        }
                    }
                    if ([dict objectForKey:@"Tpcode"]==nil||[[dict objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"ITCODE"]]||[[dict objectForKey:@"Tpcode"] isEqualToString:@""]) {
                        [btn setBackgroundImage:[UIImage imageNamed:@"diancai01.png"] forState:UIControlStateNormal];
                        NSLog(@"%@",dict);
                        btn.selected=NO;
                        UILabel *lb=[[UILabel alloc] init];
                        lb.textColor=[UIColor redColor];
                        lb.font = [UIFont systemFontOfSize:12];
                        lb.layer.cornerRadius=5;
                        lb.backgroundColor=[UIColor blackColor];
                        lb.textAlignment=NSTextAlignmentRight;
                        lb.backgroundColor=[UIColor clearColor];
                        //            lb.font=[UIFont systemFontOfSize:20];
                        lb.frame=CGRectMake(120-50,80-25,50,25);
                        lb.text=[NSString stringWithFormat:@"%d",_total];
                        lb.text=[NSString stringWithFormat:@"%d",k];
                        //                        j+=[[dict objectForKey:@"total"] intValue];
                        [btn addSubview:lb];
                    }
                }
                
                x++;
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
            for (NSString *str in _soldOut) {
                if ([[[[_dataArray objectAtIndex:i] objectAtIndex:j] objectForKey:@"ITCODE"] isEqualToString:str]) {
                    x++;
                }
            }
            if (x>0) {
            
                [btn setBackgroundImage:[UIImage imageNamed:@"gq.png"] forState:UIControlStateNormal];
            }else
            {
                [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    [self updataTitle];
}
- (void)searchBarInit {
    _searchBar= [[UISearchBar alloc] initWithFrame:CGRectMake(0, 120, 768, 50)];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	_searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_searchBar.keyboardType = UIKeyboardTypeDefault;
	_searchBar.backgroundColor=[UIColor clearColor];
	_searchBar.translucent=YES;
	_searchBar.placeholder=@"搜索";
	_searchBar.delegate = self;
	_searchBar.barStyle=UIBarStyleDefault;
    [self.view addSubview:_searchBar];
}
#define  AdditionViewDelegate
- (void)additionSelected:(NSArray *)ary{
    if (ary) {
        [_dataDic setValue:ary forKey:@"addition"];
    }
    [vAddition removeFromSuperview];
}
-(void)updataTitle
{
    bs_dispatch_sync_on_main_thread(^{
    for (int i=0; i<[classArray count]; i++) {
        int j=0;
        AKOrederClassButton *button=[classButton objectAtIndex:i];
        for (UIButton *btn in [_buttonArray objectAtIndex:i]) {
            for (NSDictionary *dict in _selectArray) {
                NSString *str=[dict objectForKey:@"total"];
                if ([dict objectForKey:@"Tpcode"]==nil||[[dict objectForKey:@"Tpcode"] isEqualToString:@"(null)"]||[[dict objectForKey:@"Tpcode"] isEqualToString:[dict objectForKey:@"ITCODE"]]||[[dict objectForKey:@"Tpcode"] isEqualToString:@""]) {
                    if ([btn.titleLabel.text isEqualToString:[dict objectForKey:@"DES"]]) {
                        j+=[str intValue];
                    }
                }
            }
        }
        if (j==0) {
            button.label.text=@"";
            button.frame=CGRectMake(0,60*i,90, 59);
            button.button.frame=CGRectMake(0,0,90,59);
            [button.button setBackgroundImage:[UIImage imageNamed:@"feilei01(1).png"] forState:UIControlStateNormal];
        }
        else
        {
            button.frame=CGRectMake(0,60*i,100, 59);
            button.button.frame=CGRectMake(0,0,100,59);
            [button.button setBackgroundImage:[UIImage imageNamed:@"feilei01.png"] forState:UIControlStateNormal];
            button.label.text=[NSString stringWithFormat:@"%d",j];
        }
    }
    });
    
}
-(void)comboClick:(UIButton *)btn
{
    if ([_Combo count]==0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择套餐" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    if (btn.tag==1) {
        if ([_ComButton count]==0) {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提示" message:@"该套餐已选择完毕，请取消以后重新选择" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alertView show];
        }
        else
        {
            if (_com>0) {
                for (UIButton *btn in [_scroll subviews]) {
                    [btn removeFromSuperview];
                }
                _com=_com-1;
                [self comboShow:_com];
            }else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是第一个" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
    else if(btn.tag==2)
    {
        if (_com>[_Combo count]-1) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"已经是最后一个" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }else
        {
            _com=_com+1;
            for (UIButton *btn in [_scroll subviews]) {
                if (btn.selected==NO) {
                    for (UIButton *btn in [_scroll subviews]) {
                        [btn removeFromSuperview];
                    }
                    [self comboShow:_com];
                    return;
                }
            }
            _com=_com-1;
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择，请选择以后再点" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            [self comboShow:_com];
        }
    }
    else
    {
        aScrollView.frame=CGRectMake(80,175, 688, 740);
        _total=1;
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        if ([_ComButton count]>0) {
            int j=[_selectArray count];
            
            int y=0;
            for (NSDictionary *dict1 in _selectArray) {
                if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[[[_dataArray objectAtIndex:_count] objectAtIndex:_btn] objectForKey:@"ITCODE"]]) {
                    y++;
                }
            }
            NSString *str=[[[_dataArray objectAtIndex:_count] objectAtIndex:_btn] objectForKey:@"DES"];
            NSString *str1=[NSString stringWithFormat:@"%d",y-1];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (int i=0;i<j;i++) {
                if ([str isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"DES"]]&&[str1 isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                    [array addObject:[NSString stringWithFormat:@"%d",i]];
                }
                if ([str isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]]&&[str1 isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNUM"]]) {
                    [array addObject:[NSString stringWithFormat:@"%d",i]];
                }
                
            }
            int k=[array count];
            for (int i=0; i<k; i++) {
                [_selectArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
            }
            if ([str1 intValue]==0) {
                UIButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                [button setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
                button.selected=YES;
                [[[button subviews] lastObject] removeFromSuperview];
                [self.view sendSubviewToBack:_view];
//                for (UIButton *button in [_scroll subviews]) {
//                    [button removeFromSuperview];
//                }
            }else
            {
                UIButton *button=[[_buttonArray objectAtIndex:_count] objectAtIndex:_btn];
                UILabel *lb=[[button subviews] lastObject];
                lb.text=[NSString stringWithFormat:@"%d",y-1];
            }
            [_ComButton removeAllObjects];
            [_Combo removeAllObjects];
            _com=0;
            [self.view sendSubviewToBack:_view];
            aScrollView.frame=CGRectMake(80,175, 688, 740);
//            for (UIButton *button in [_scroll subviews]) {
//                [button removeFromSuperview];
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
            [self updataTitle];
        }
    }
}
//-(void)button:(int)tag
//{
//    if ([_buttonArray count]==0) {
//        int k=0;
//        for (int j=0; j<[classArray count]; j++) {
//            NSArray *array1=[BSDataProvider getFoodList:[NSString stringWithFormat:@"class=%@",[[classArray objectAtIndex:j] objectForKey:@"GRP"]]];
//            NSMutableArray *array2=[[NSMutableArray alloc] init];
//            for (int i=0; i<[array1 count]; i++)
//            {
//                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//                btn.selected=YES;
//                
//                if ([[[array1 objectAtIndex:i] objectForKey:@"ISTC"] intValue]==1) {
//                    btn.tag=i+10000;
//                }
//                else
//                {
//                    btn.tag=i;
//                }
//                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
//                btn.tintColor=[UIColor whiteColor];
//                btn.titleLabel.numberOfLines=2;
//                [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen.png"] forState:UIControlStateNormal];
//                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
//                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
//                [btn setTitle:[[array1 objectAtIndex:i] objectForKey:@"DES"] forState:UIControlStateNormal];
//                [array2 addObject:btn];
//                SearchBage *search=[[SearchBage alloc] init];
//                search.localID = [NSNumber numberWithInt:k];
//                search.name=[[array1 objectAtIndex:i] objectForKey:@"DES"];
//                NSMutableArray *ary=[[NSMutableArray alloc] init];
//                [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"ITCODE"]];
//                search.phoneArray=ary;
//                [_dict setObject:search forKey:search.localID];
//                [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
//                k++;
//            }
//            [_buttonArray addObject:array2];
//            //_buttonArray存的是所有的button
//            [_dataArray addObject:array1];
//            //_dataArray存的是所有的菜的数据
//        }
//    }
//    _array=[_buttonArray objectAtIndex:tag];
//    for (int i=0; i<[classArray count]; i++) {
//        int k=0;
//        for (UIButton *btn in [_buttonArray objectAtIndex:i]) {
//            btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
//            k++;
//        }
//    }
////    aScrollView.backgroundColor=[UIColor redColor];
//    for (UIButton *btn in _array) {
//        [aScrollView addSubview:btn];
//    }
//    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
//}
-(void)button:(int)tag
{
    if ([_buttonArray count]==0) {
        int k=0;
        NSArray *array=[BSDataProvider getFoodList];
//        [BSDataProvider getFoodList:[NSString stringWithFormat:@"class=%@",[[classArray objectAtIndex:j] objectForKey:@"GRP"]]];
        for (int j=0; j<[classArray count]; j++) {
            NSMutableArray *array2=[NSMutableArray array];
            NSMutableArray *array1=[NSMutableArray array];
            for (NSDictionary *dict in array) {
                if ([[dict objectForKey:@"CLASS"] isEqualToString:[[classArray objectAtIndex:j] objectForKey:@"GRP"]]) {
                    [array1 addObject:dict];
                }
            }
            for (int i=0; i<[array1 count]; i++)
            {
                
                UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
                btn.selected=YES;
                
                if ([[[array1 objectAtIndex:i] objectForKey:@"ISTC"] intValue]==1) {
                    btn.tag=i+10000;
                }
                else
                {
                    btn.tag=i;
                }
                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.numberOfLines=2;
                [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen.png"] forState:UIControlStateNormal];
                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                [btn setTitle:[[array1 objectAtIndex:i] objectForKey:@"DES"] forState:UIControlStateNormal];
                [array2 addObject:btn];
                SearchBage *search=[[SearchBage alloc] init];
                search.localID = [NSNumber numberWithInt:k];
                search.name=[[array1 objectAtIndex:i] objectForKey:@"DES"];
                NSMutableArray *ary=[[NSMutableArray alloc] init];
                [ary addObject:[[array1 objectAtIndex:i] objectForKey:@"ITCODE"]];
                search.phoneArray=ary;
                [_dict setObject:search forKey:search.localID];
                [[SearchCoreManager share] AddContact:search.localID name:search.name phone:search.phoneArray];
                k++;
            }
            [_buttonArray addObject:array2];
            //_buttonArray存的是所有的button
            [_dataArray addObject:array1];
            //_dataArray存的是所有的菜的数据
        }
    }
    _array=[_buttonArray objectAtIndex:tag];
    for (int i=0; i<[classArray count]; i++) {
        int k=0;
        for (UIButton *btn in [_buttonArray objectAtIndex:i]) {
            btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
            k++;
        }
    }
    //    aScrollView.backgroundColor=[UIColor redColor];
    for (UIButton *btn in _array) {
        [aScrollView addSubview:btn];
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
#define UISearchBarDelegete
- (void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    for (UIButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:nil];
    [[SearchCoreManager share] Search:searchText searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (int i=0; i<[_searchByName count]; i++) {//搜索到的
        localID = [_searchByName objectAtIndex:i];
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [_dict objectForKey:localID];
                    [array addObject:btn];
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
                    }
                }
                k++;
            }
        }
    }
    //    NSNumber *localID = nil;
    //    NSMutableString *matchString = [NSMutableString string];
    //    NSMutableArray *matchPos = [NSMutableArray array];
    NSMutableArray *matchPhones = [NSMutableArray array];
    for (int i=0; i<[_searchByPhone count]; i++) {//搜索到的
        localID = [_searchByPhone objectAtIndex:i];
        int k=0;
        for (int i=0; i<[classArray count]; i++) {//每一个类
            for (UIButton *btn in [_buttonArray objectAtIndex:i]) {//
                if (k==[localID intValue]) {
                    [array addObject:btn];
                    //号码匹配 获取对应匹配的号码串 及高亮位置
                    if ([_searchBar.text length]) {
                        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                        [matchString appendString:[matchPhones objectAtIndex:0]];
                    }
                }
                k++;
            }
        }
    }
    //
    //    //姓名匹配 获取对应匹配的拼音串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
    //    }
    //
    //    //号码匹配 获取对应匹配的号码串 及高亮位置
    //    if ([self.searchBar.text length]) {
    //        [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
    //        [matchString appendString:[matchPhones objectAtIndex:0]];
    //    }
    int a=0;
    _array=array;
    for (UIButton *btn in _array) {
        
        btn.frame=CGRectMake(a%5*135+15,a/5*90+15,120,80);
        [aScrollView addSubview:btn];
        a++;
    }
    [aScrollView setContentSize:CGSizeMake(688, [_array count]/5*90+114)];
}
-(void)buttonClick:(UIButton *)btn
{
//    if ([_selectArray count]+1>40) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前点菜数量超过40行，请先发送！" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    if(_total==0)
    {
        if (btn.selected==NO){
            if (btn.tag>=10000) {
                int k=0;
                NSMutableArray *array=[NSMutableArray array];
                for (NSDictionary *dict in _selectArray) {
                    NSString *str=[dict objectForKey:@"DES"];
                    if ([str isEqualToString:btn.titleLabel.text]||[[dict objectForKey:@"TPNANE"]isEqualToString:btn.titleLabel.text]) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }
                    k++;
                }
                int i=0;
                for (NSString *str in array) {
                    [_selectArray removeObjectAtIndex:[str intValue]-i];
                    i++;
                }
                [_ComButton removeAllObjects];
                [_Combo removeAllObjects];
                for (UIButton *btn in [_scroll subviews]) {
                    [btn removeFromSuperview];
                }
                [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
                [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                aScrollView.frame=CGRectMake(80,175, 688, 740);
                [self.view sendSubviewToBack:_view];
            }else{
                int k=0;
                NSMutableArray *array=[NSMutableArray array];
                for (NSDictionary *dict in _selectArray) {
                    NSString *str=[dict objectForKey:@"DES"];
                    if ([str isEqualToString:btn.titleLabel.text]) {
                        [array addObject:[NSString stringWithFormat:@"%d",k]];
                    }
                    k++;
                }
                int i=0;
                for (NSString *str in array) {
                    [_selectArray removeObjectAtIndex:[str intValue]-i];
                    i++;
                }
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
            [[[btn subviews] lastObject] removeFromSuperview];
            btn.selected=YES;
            [self updataTitle];
        }
        
        _total=1;
        [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
        [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
        cishu=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }else
    {
        
        if ([_ComButton count]>0) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕，请选择完毕或者取消套餐以后再选择" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            if (btn.tag>=10000) {
                _total=1;
            }
            [btn setBackgroundImage:[UIImage imageNamed:@"diancai01.png"] forState:UIControlStateNormal];
            int i=0;
            if (btn.selected==NO) {
                UILabel *lb=[[btn subviews] lastObject];
                i=[lb.text intValue]+_total;
                lb.text=[NSString stringWithFormat:@"%d",i];
            }else
            {
                UILabel *lb=[[UILabel alloc] init];
                lb.textColor=[UIColor redColor];
                lb.font = [UIFont systemFontOfSize:12];
                lb.layer.cornerRadius=5;
                lb.backgroundColor=[UIColor blackColor];
                lb.textAlignment=NSTextAlignmentRight;
                lb.backgroundColor=[UIColor clearColor];
                //            lb.font=[UIFont systemFontOfSize:20];
                lb.frame=CGRectMake(120-50,80-25,50,25);
                lb.text=[NSString stringWithFormat:@"%d",_total];
                [btn addSubview:lb];
                btn.selected=NO;
            }
            
            if (btn.tag>=10000) {
                int k=0;
                for (NSArray *array in _dataArray) {
                    for (NSDictionary *dict in array) {
                        if ([[dict objectForKey:@"DES"] isEqualToString:btn.titleLabel.text]) {
                            _count=k;
                        }
                    }
                    k++;
                }
                aScrollView.frame=CGRectMake(80,175, 688, 190);
                [self.view bringSubviewToFront:_view];
                _x=0;
                [self comboClick1:btn];
                _button=btn;
            }
            else
            {
                aScrollView.frame=CGRectMake(80,175, 688,740);
                aScrollView.backgroundColor=[UIColor whiteColor];
                [self.view sendSubviewToBack:_view];
                int k=0;
                for (NSArray *array in _dataArray) {
                    for (NSDictionary *dict in array) {
                        if ([[dict objectForKey:@"DES"] isEqualToString:btn.titleLabel.text]) {
                            _count=k;
                        }
                    }
                    k++;
                }
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]];
                if ([[dict objectForKey:@"UNITCUR"] intValue]==2) {
                    _Weight=dict;
                    [self WeightFlg];
                }
                else
                {
                    _dataDic=[NSMutableDictionary dictionaryWithDictionary:dict];
                    [_dataDic setValue:@"0" forKey:@"Weight"];
                    [_dataDic setValue:@"1" forKey:@"Weightflg"];
//                    _x=0;
                    [_dataDic setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"total"];
                    for (NSDictionary *dict1 in _selectArray) {
                        if ([[dict1 objectForKey:@"ISTC"] intValue]==0&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[_dataDic objectForKey:@"ITCODE"]]) {
                            
                            [_dataDic setValue:[NSString stringWithFormat:@"%d",_total+[[dict1 objectForKey:@"total"] intValue]] forKey:@"total"];
                            [_selectArray removeObject:dict1];
                            break;
                        }
                    }
                    [_dataDic setValue:@"0" forKey:@"TPNUM"];
                        [_selectArray addObject:_dataDic];
                    dict=nil;
                    _total=1;
                    [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
                    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                    cishu=0;
                    
                    [self updataTitle];
                }
                //            注释该行代码，菜品默认选择segment份数
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
                
            }
            //        else
            //        {
            //            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
            //
            //            [[[btn subviews]lastObject]removeFromSuperview];
            //
            //            btn.selected=YES;
            //            if (btn.tag>=10000) {
            //                NSMutableArray *array=[[NSMutableArray alloc] init];
            //                if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"ISTC"] intValue]==1) {
            //                    int j=[_selectArray count];
            //                    for (int i=0;i<j;i++) {
            //                        NSLog(@"%@",[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"]);
            //                        NSLog(@"%@",_selectArray);
            //                        NSLog(@"aaaaa%@",[[_selectArray objectAtIndex:i] objectForKey:@"DES"]);
            //                        NSLog(@"aaaaa%@",[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]);
            //                        if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"] isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"DES"]]) {
            //                            [array addObject:[NSString stringWithFormat:@"%d",i]];
            //                        }
            //                        if ([[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"DES"] isEqualToString:[[_selectArray objectAtIndex:i] objectForKey:@"TPNANE"]]) {
            //                            [array addObject:[NSString stringWithFormat:@"%d",i]];
            //                        }
            //
            //                    }
            //                    NSLog(@"%@",array);
            //                    int k=[array count];
            //                    for (int i=0; i<k; i++) {
            //                        [_selectArray removeObjectAtIndex:[[array objectAtIndex:i] intValue]-i];
            //                    }
            //                    [_ComButton removeAllObjects];
            //                    [self updataTitle];
            //                }
            //            }
            //            else
            //            {
            //                NSLog(@"%@",[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]);
            //                [_selectArray removeObject:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag]];
            //                NSLog(@"%@",_selectArray);
            //                [self updataTitle];
            //            }
            //        }
            //    }
        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
}
-(void)WeightFlg
{
    if (_total>_y) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:_Weight];
        _dataDic=dict;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        tf1.delegate=self;
        alertView.tag=3;
        [alertView show];
    }
    else
    {
        _y=0;
        _Weight=nil;
    }
}
//点套餐
-(void)comboClick1:(UIButton *)btn
{
    arry=[_dp combo:[[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000] objectForKey:@"ITCODE"]];
    [_ComButton removeAllObjects];
    NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithDictionary:[[_dataArray objectAtIndex:_count] objectAtIndex:btn.tag-10000]];
    [dict setValue:@"1" forKey:@"total"];
    [dict setValue:[NSString stringWithFormat:@"%d",_total] forKey:@"count"];
    _z=0;
    for (NSDictionary *dict1 in _selectArray) {
        if ([[dict1 objectForKey:@"ISTC"] intValue]==1&&[[dict1 objectForKey:@"ITCODE"] isEqualToString:[dict objectForKey:@"ITCODE"]]) {
            _z++;
        }
    }
    [dict setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
    [_selectArray addObject:dict];
    _dataDic=[NSMutableDictionary dictionaryWithDictionary:dict];
    dict=nil;
    [self updataTitle];
    _btn=btn.tag-10000;
    
    if ([arry count]==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"此套餐已点完" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        aScrollView.frame=CGRectMake(80,175, 688, 740);
        [self.view sendSubviewToBack:_view];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
    }
    else
    {
        NSMutableArray *array=[[NSMutableArray alloc] init];
        for (NSArray *array1 in arry) {
            if ([array1 count]==1) {
                [[array1 lastObject] setValue:@"1" forKey:@"total"];
                [[array1 lastObject] setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
//                [_tableArray addObject:[array1 lastObject]];
                [_selectArray addObject:[array1 lastObject]];
//                [self reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
            }
            else{
                [array addObject:array1];//可选择的套餐
            }
        }
        _Combo=array;
        if ([_Combo count]>0) {
//            [self reloadData];
            [self comboShow:_com];
        }else
        {
//            [_tableArray removeAllObjects];
//            [_comboTableView reloadData];
            aScrollView.frame=CGRectMake(80,175, 688, 740);
            [self.view sendSubviewToBack:_view];
        }
        
    }
    
}
-(void)comboShow:(int)tag1{
    if ([_ComButton count]==0) {
        int j=0;
        for (int i=0;i<[_Combo count];i++) {
            int k=0;
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (NSDictionary *dict in [_Combo objectAtIndex:i]) {
                AKComboButton *btn=[AKComboButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
                btn.frame=CGRectMake(k%5*135+15,k/5*90+15,120,80);
                btn.btnTag=j;
                btn.tag=k;
                btn.selected=YES;
                [btn setTitle:[dict objectForKey:@"DES"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold" size:20];
                btn.tintColor=[UIColor whiteColor];
                btn.titleLabel.numberOfLines=2;
                btn.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
                btn.titleLabel.textAlignment=NSTextAlignmentCenter;
                [array addObject:btn];
                k++;
                j++;
            }
            [_ComButton addObject:array];
        }
    }
    //
    int j=20;
    for (int i=0; i<[_ComButton count]; i++) {
        NSArray *array=[_ComButton objectAtIndex:i];
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0,j, 678, ([array count]/6+1)*90+15)];
        view.backgroundColor=[UIColor colorWithRed:200/255.0 green:239/255.0 blue:249/255.0 alpha:0.5];
//        view.backgroundColor=[UIColor ]
        for (UIButton *btn in array) {
            [view addSubview:btn];
        }
        [_scroll addSubview:view];
        j=j+([array count]/6+1)*90+25;
    }
    [_scroll setContentSize:CGSizeMake(120*5+30,j)];
}
-(void)btnClick:(AKComboButton *)btn
{
    label.text=[NSString stringWithFormat:@"%d",_com+2];
//    for (UIButton *button in [_scroll subviews]) {
//        [button removeFromSuperview];
//    }
    int j=0;
    int k=0;
    for (NSArray *array in _ComButton) {
        for (AKComboButton *button in array) {
            if (btn.btnTag==button.btnTag) {
                k++;
                _com=j;
            }
        }
        if (k>0) {
            break;
        }
        j++;
    }
    if (btn.selected) {
        int i=0;
        for (AKComboButton *btn11 in [_ComButton objectAtIndex:_com]) {
            if (btn11.selected==NO) {
                i++;
            }
        }
        if (i==0) {
            [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
            btn.selected=NO;
            [[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] setValue:@"1" forKey:@"total"];
            [[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag] setValue:[NSString stringWithFormat:@"%d",_z] forKey:@"TPNUM"];
//            [_tableArray addObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
//            [self reloadData];
            [_selectArray addObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
            _dataDic=[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag];
            if ([[_dataDic objectForKey:@"Weightflg"] intValue]==2) {
                [_dataDic setValue:@"2" forKey:@"Weightflg"];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重量" message:@"请输入重量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                UITextField *tf1 = [alertView textFieldAtIndex:0];
                tf1.delegate=self;
                alertView.tag=3;
                [alertView show];
            }
            else
            {
                [_dataDic setValue:@"0" forKey:@"Weight"];
                [_dataDic setValue:@"1" forKey:@"Weightflg"];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
                int x=0;
                for (NSArray *array in _ComButton) {
                    for (AKComboButton *button in array) {
                        if (button.selected==NO) {
                            x++;
                        }
                    }
                }
            if (x!=[_ComButton count]) {
                _com=0;
            }
            else
            {
                double mrMoney = 0.0f;
                double tcMoney=[[[_selectArray objectAtIndex:([_selectArray count]-[arry count]-1)] objectForKey:@"PRICE"] doubleValue];
                for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
                    
                    NSDictionary *dict=[_selectArray objectAtIndex:i];
                    if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
                        mrMoney+=[[dict objectForKey:@"Weight"] doubleValue]*[[dict objectForKey:@"PRICE"] doubleValue];
                    }
                    mrMoney+=[[dict objectForKey:@"PRICE"] doubleValue];
                }
                double youhuijia =mrMoney-tcMoney;
                for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++)
                {
                    NSDictionary *dict=[_selectArray objectAtIndex:i];
                    double m_price1=[[dict objectForKey:@"PRICE"] doubleValue];
                    int TC_m_State=[[dict objectForKey:@"TCMONEYMODE"] doubleValue];
                    if(TC_m_State == 1)   //计价方式一
                    {
                        //优惠的价钱    合计 - 套餐价额
                        double tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                        [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
                    }
                    else if(TC_m_State==2)
                    {
                        NSDictionary *dict1=[_selectArray objectAtIndex:[_selectArray count]-[arry count]-1];
                        [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
                    }else if (TC_m_State==3) {
                        if (mrMoney<tcMoney) {
//                            double youhuijia =mrMoney-tcMoney;     //优惠的价钱    合计 - 套餐价额
                            double tempMoney1=m_price1-(youhuijia*(m_price1/mrMoney));
                            [dict setValue:[NSString stringWithFormat:@"%.2f",tempMoney1] forKey:@"PRICE"];
                        }
                        else
                        {
                            NSDictionary *dict1=[_selectArray objectAtIndex:[_selectArray count]-[arry count]-1];
                            [dict1 setValue:[NSString stringWithFormat:@"%.2f",mrMoney] forKey:@"PRICE"];
                        }
                    }
                    if (i==[_selectArray count]-1) {
                    mrMoney = 0.0f;
                    float tcMoney=[[[_selectArray objectAtIndex:([_selectArray count]-[arry count]-1)] objectForKey:@"PRICE"] floatValue];
                    for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
                        
                        NSDictionary *dict=[_selectArray objectAtIndex:i];
                        if ([[dict objectForKey:@"Weightflg"] intValue]==2) {
                            mrMoney+=[[dict objectForKey:@"Weight"] floatValue]*[[dict objectForKey:@"PRICE"] floatValue];
                        }
                        mrMoney+=[[dict objectForKey:@"PRICE"] floatValue];
                    }
                    if (mrMoney!=tcMoney) {
                        for (int i=[_selectArray count]-[arry count]; i<[_selectArray count]; i++) {
                            NSDictionary *dict=[_selectArray objectAtIndex:i];
                            
                            if ([[dict objectForKey:@"PRICE"] floatValue]>0) {
                                if ([[dict objectForKey:@"Weightflg"] intValue]!=2) {
                                    float x=[[dict objectForKey:@"PRICE"] floatValue]+tcMoney-mrMoney;
                                    [dict setValue:[NSString stringWithFormat:@"%.2f",x] forKey:@"PRICE"];
                                    break;
                                }
                                
                            }
                        }
                    }
                    }
                }
                [_Combo removeAllObjects];
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"这一个套餐已点完" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
                [alert show];
                for (UIView *button in [_scroll subviews]) {
                    [button removeFromSuperview];
                }
                label.text=[NSString stringWithFormat:@"%d",1];
                _com=0;
                [_ComButton removeAllObjects];
                if (_x<_total-1) {
                    _x++;
                    [self comboClick1:_button];
                }
                else
                {
                    aScrollView.frame=CGRectMake(80,175, 688, 740);
                    [self.view sendSubviewToBack:_view];
                    _total=1;
                    [akmsav setsegmentIndex:[NSString stringWithFormat:@"%d",_total-1]];
                    [akmsav setTitle:[NSString stringWithFormat:@"%d",_total]];
                    cishu=0;
                }
            }
            
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"这一选项中只能选择一个,请取消已选的再选择" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
//            [self comboShow:_com];
        }
    }
    else
    {
        [btn setBackgroundImage:[UIImage imageNamed:@"TableButtonGreen"] forState:UIControlStateNormal];
        [_selectArray removeObject:[[_Combo objectAtIndex:_com] objectAtIndex:btn.tag]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
//        [self comboShow:_com];
        btn.selected=YES;
    }
//    [self reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentClick1:(UIButton *)sender
{
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你当前的套餐没有选择完毕" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    for (AKOrederClassButton *btn in [aScrollView subviews]) {
        [btn removeFromSuperview];
    }
    //    _count=sender.selectedSegmentIndex;
    [self button:sender.tag];
}


- (IBAction)alreadyBuyGreens:(id)sender//已点菜品
{
//    NSMutableArray *array=[NSMutableArray array];
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你的套餐还没有选择完毕" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSArray *foods =[[NSArray alloc] initWithArray:_selectArray];
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    for (int i=0; i<[foods count]; i++) {
        //        for (int j=0; j<[[[foods objectAtIndex:i] objectForKey:@"total"] intValue]; j++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableDictionary *dict1=[[NSMutableDictionary alloc] initWithDictionary:[_selectArray objectAtIndex:i]];
        //            [dict setObject:[NSString stringWithFormat:@"%d",j] forKey:@"count"];
        [dict setObject:[NSString stringWithFormat:@"1.00"] forKey:@"total"];
        [dict setObject:dict1 forKey:@"food"];
        [dict setObject:@"UNIT" forKey:@"unitKey"];
        [dict setObject:@"PRICE" forKey:@"priceKey"];
        [array1 addObject:dict];
        //[dp orderFood:dict];
    }
    //    }
    [Singleton sharedSingleton].dishArray=array1;
    BSLogViewController *vbsvc=[[BSLogViewController alloc] init];
    [self.navigationController pushViewController:vbsvc animated:YES];
}
- (IBAction)Beizhu:(UIButton *)sender {
    if ([_dataDic count]>0) {
        if (!vAddition){
            vAddition = [[BSAddtionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
            vAddition.delegate = self;
            
            //        vAddition.arySelectedAddtions=;
        }
        if (!vAddition.superview){
            vAddition.center = CGPointMake(self.view.center.x,924+self.view.center.y);
            [vAddition.arySelectedAddtions removeAllObjects];
            vAddition.arySelectedAddtions=[NSMutableArray arrayWithArray:[_dataDic objectForKey:@"addition"]];
            [vAddition.tv reloadData];
            [self.view addSubview:vAddition];
            [vAddition firstAnimation];
        }
        else{
            [vAddition removeFromSuperview];
            vAddition = nil;
        }
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有选择菜" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (IBAction)goBack:(id)sender//返回
{
    if ([_Combo count]>0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前套餐没有选择完毕，请将该套餐选择完毕或取消之后再返回" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
        return;
    }
    if ([_selectArray count]>0&&![Singleton sharedSingleton].isYudian) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存已点的菜品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是",@"否", nil];
        alert.tag=1;
        alert.delegate=self;
        [alert show];
    }
    else if (![AKsNetAccessClass sharedNetAccess].isVipShow)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
    }
}
#define UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (1==buttonIndex){
            NSArray *foods =[[NSArray alloc] initWithArray:_selectArray];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (int i=0; i<[foods count]; i++) {
                //        for (int j=0; j<[[[foods objectAtIndex:i] objectForKey:@"total"] intValue]; j++) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                NSMutableDictionary *dict1=[[NSMutableDictionary alloc] initWithDictionary:[_selectArray objectAtIndex:i]];
                //            [dict setObject:[NSString stringWithFormat:@"%d",j] forKey:@"count"];
                [dict setObject:[NSString stringWithFormat:@"1.00"] forKey:@"total"];
                [dict setObject:dict1 forKey:@"food"];
                [dict setObject:@"UNIT" forKey:@"unitKey"];
                [dict setObject:@"PRICE" forKey:@"priceKey"];
                [array addObject:dict];
                //[dp orderFood:dict];
            }
            BSDataProvider *dp=[[BSDataProvider alloc] init];
            [dp cache:array];
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
            [alert show];
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
            
        }else if (2==buttonIndex){
            if(![AKsNetAccessClass sharedNetAccess].isVipShow)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1]  animated:YES];
            }
        }
        
    }
    else  if (alertView.tag==10001)
    {
        [akmsav setsegmentIndex:@"11"];
        [akmsav setTitle:@"1"];
        _total=1;
    }
    
    if (alertView.tag==3) {
        UITextField *tf1 = [alertView textFieldAtIndex:0];
        
        if (1==buttonIndex) {
            [_dataDic setValue:@"1" forKey:@"total"];
            [_dataDic setValue:@"2" forKey:@"Weightflg"];
            [_dataDic setValue:tf1.text forKey:@"Weight"];
            [_selectArray addObject:_dataDic];
            _y++;
            [self WeightFlg];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"postData" object:_selectArray];
        }
        else
        {
            _y++;
            [self WeightFlg];
        }
    }
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
-(void)selectSegmentIndex:(NSString *)segmentIndex andSegment:(UISegmentedControl *)segment
{
    if(![segmentIndex isEqualToString:@"X"])
    {
        if([[NSString stringWithFormat:@"%d",_total]length]>1)
        {
            _total=1;
            cishu=0;
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
        else
        {
            int index=[segmentIndex intValue];
            cishu=cishu*10+index;
            _total=cishu;
            [segment setSelectedSegmentIndex:11];
            [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
        }
    }
    else
    {
        _total=1;
        cishu=0;
        [segment setSelectedSegmentIndex:11];
        [segment setTitle:[NSString stringWithFormat:@"%d",_total] forSegmentAtIndex:11];
    }
}
#define UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        NSString *validRegEx =@"^[0-9]+(.[0-9]{2})?$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
