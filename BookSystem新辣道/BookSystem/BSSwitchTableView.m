//
//  BSSwitchTableView.m
//  BookSystem
//
//  Created by Dream on 11-7-13.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSSwitchTableView.h"
#import "CVLocalizationSetting.h"
#import "BSDataProvider.h"

@implementation BSSwitchTableView
@synthesize delegate,tfOldTable,tfNewTable;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[[NSUserDefaults standardUserDefaults] setObject:@"switchTable" forKey:@"DeskMainButton"]
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DeskMainButton"] isEqualToString:@"switchTable"]){
            // Initialization code
            [self setTitle:@"换台"];
        }
        else
        {
            [self setTitle:@"并台"];
        }
        
        
        lblOldTable = [[UILabel alloc] initWithFrame:CGRectMake(15, 80, 95, 30)];
        lblOldTable.textAlignment = UITextAlignmentRight;
        lblOldTable.backgroundColor = [UIColor clearColor];
        lblOldTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lblOldTable.textColor=[UIColor blackColor];
        lblOldTable.text =@"当前台位:";//@"当前台位:";
        [self addSubview:lblOldTable];
        [lblOldTable release];
        
        lblNewTable = [[UILabel alloc] initWithFrame:CGRectMake(15, 150, 95, 30)];
        lblNewTable.textAlignment = UITextAlignmentRight;
        lblNewTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        lblNewTable.textColor=[UIColor blackColor];
        lblNewTable.backgroundColor = [UIColor clearColor];
        lblNewTable.text = @"目标台位:";//@"目标台位:";
        [self addSubview:lblNewTable];
        [lblNewTable release];
        tfOldTable = [[UITextField alloc] initWithFrame:CGRectMake(115, 80, 300, 40)];
        tfOldTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];;
        tfNewTable = [[UITextField alloc] initWithFrame:CGRectMake(115, 150, 300, 40)];
        tfNewTable.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        tfOldTable.borderStyle = UITextBorderStyleRoundedRect;
        tfOldTable.keyboardType=UIKeyboardTypeNumberPad;
        tfNewTable.borderStyle = UITextBorderStyleRoundedRect;
        tfNewTable.keyboardType=UIKeyboardTypeNumberPad;
        [self addSubview:tfOldTable];
        [self addSubview:tfNewTable];
        [tfOldTable release];
        [tfNewTable release];
        
        btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
        btnConfirm.frame = CGRectMake(240, 265, 90, 40);
        btnConfirm.titleLabel.textColor=[UIColor whiteColor];
        btnConfirm.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnConfirm setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];

        [btnConfirm setTitle:@"确认" forState:UIControlStateNormal];
        [self addSubview:btnConfirm];
        btnConfirm.tag = 700;
        [btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        
        btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnCancel.frame = CGRectMake(345, 265, 90, 40);
        btnCancel.titleLabel.textColor=[UIColor whiteColor];
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        btnCancel.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
        [btnCancel setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
        [self addSubview:btnCancel];
        btnCancel.tag = 701;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    self.tfOldTable = nil;
    self.tfNewTable = nil;
    self.delegate = nil;
    [super dealloc];
}

- (void)confirm{
    if ([tfNewTable.text length]<=0 || tfOldTable.text.length<=0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"台位号不能为空" message:nil delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([tfOldTable.text length]>0){
            [dic setObject:tfOldTable.text forKey:@"oldtable"];
//            BSDataProvider *dp=[[BSDataProvider alloc] init];
//            NSArray *array=[dp getOrdersBytabNum1:tfOldTable.text];
            
        }
        
        if ([tfNewTable.text length]>0)
            [dic setObject:tfNewTable.text forKey:@"newtable"];
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"DeskMainButton"] isEqualToString:@"switchTable"]){
            [delegate switchTableWithOptions:dic];
        }
        else
        {
            [delegate multipleTableWithOptions:dic];
        }
    }
}

- (void)cancel{
    [delegate switchTableWithOptions:nil];
}

@end
