//
//  BSLogCell.m
//  BookSystem
//
//  Created by Dream on 11-5-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSLogCell.h"
#import "BSAdditionCell.h"
#import "BSDataProvider.h"


@implementation BSLogCell
{
    BSAddtionView *vAddition;
}
@synthesize delegate=_delegate,arySelectedAdditions=_arySelectedAdditions,tfPrice=_tfPrice,lblUnit=_lblUnit,lblName=_lblName,lblTotalPrice=_lblTotalPrice,lblAddition=_lblAddition,tfCount=_tfCount,btnAdd=_btnAdd,btnReduce=_btnReduce,jia=_jia,jian=_jian,lb=_lb,lblLine=_lblLine,supTableView=_supTableView,btnEdit=_btnEdit;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //        此处修改了lable坐标，让已点菜品名称尽量显示全面
        _lblName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 160, 50)];
        _lblName.backgroundColor = [UIColor clearColor];
        _lblName.font = [UIFont systemFontOfSize:16];
        _lblName.numberOfLines =0;
        _lblName.lineBreakMode = UILineBreakModeWordWrap;     //指定换行模式
        _lblName.textAlignment=NSTextAlignmentLeft;
        [self.contentView addSubview:_lblName];
        _tfCount = [[UILabel alloc] initWithFrame:CGRectMake(109*2, 10,109, 30)];
        _tfCount.backgroundColor=[UIColor lightGrayColor];
        _tfCount.textColor=[UIColor redColor];
        _tfCount.textAlignment=UITextAlignmentCenter;
        _tfCount.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_tfCount];
        _jia=[UIButton buttonWithType:UIButtonTypeCustom];
        _jia.frame=CGRectMake(109*2-20,-5, 40, 40);
        [_jia setBackgroundImage:[UIImage imageNamed:@"+.png"] forState:UIControlStateNormal];
        [_jia addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        _jia.tag=1;
        [self.contentView addSubview:_jia];
        _jian=[UIButton buttonWithType:UIButtonTypeCustom];
        _jian.frame=CGRectMake(109*3-20,-5, 40, 40);
        [_jian setBackgroundImage:[UIImage imageNamed:@"-.png"] forState:UIControlStateNormal];
        _jian.tag=2;
        [_jian addTarget:self action:@selector(countchange:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_jian];
        _tfPrice = [[UILabel alloc] initWithFrame:CGRectMake(109*3, 15, 109, 25)];
        _tfPrice.backgroundColor = [UIColor clearColor];
        _tfPrice.textAlignment=UITextAlignmentRight;
        _tfPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_tfPrice];
        
        _lblUnit = [[UILabel alloc] init];
        
        _lblUnit.textAlignment=NSTextAlignmentCenter;
        _lblUnit.font = [UIFont systemFontOfSize:16];
        _lblUnit.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lblUnit];
        _lblTotalPrice = [[UILabel alloc] init ];
        _lblTotalPrice.textAlignment=NSTextAlignmentRight;
        _lblTotalPrice.backgroundColor = [UIColor clearColor];
        _lblTotalPrice.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_lblTotalPrice];
        _lb=[[UILabel alloc] initWithFrame:CGRectMake(109, 45, 65, 25)];
        _lb.backgroundColor=[UIColor clearColor];
        _lb.textColor=[UIColor grayColor];
        [self.contentView addSubview:_lb];
        _lblAddition = [[UILabel alloc] initWithFrame:CGRectMake(170, 45, 440, 25)];
        _lblAddition.backgroundColor = [UIColor clearColor];
        _lblAddition.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_lblAddition];
        //        lblAddition.text = [langSetting localizedString:@"Additions:"];//@"附加项:";
        
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [btnAdd setImage:imgPlusNormal forState:UIControlStateNormal];
        //        [btnAdd setImage:imgPlusPressed forState:UIControlStateHighlighted];
        [_btnAdd sizeToFit];
        [self.contentView addSubview:_btnAdd];
        [_btnAdd addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
        [_btnAdd setBackgroundImage:[UIImage imageNamed:@"赠.png"] forState:UIControlStateNormal];
        _btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnReduce setBackgroundImage:[UIImage imageNamed:@"删.png"] forState:UIControlStateNormal];
        [_btnReduce sizeToFit];
        
        [self.contentView addSubview:_btnReduce];
        [_btnReduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
        _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnEdit.frame = CGRectMake(109*5.7+45, 10, 60, 40);
        [_btnEdit setBackgroundImage:[UIImage imageNamed:@"附加.png"] forState:UIControlStateNormal];
        [_btnEdit sizeToFit];
        
        [self.contentView addSubview:_btnEdit];
        [_btnEdit addTarget:self action:@selector(setAddition) forControlEvents:UIControlEventTouchUpInside];
        
        _lblUnit.Frame=CGRectMake(109*4, 15, 109, 25);
        _lblTotalPrice.frame= CGRectMake(109*5-20, 15, 100, 25);
        
        _btnAdd.frame=CGRectMake(109*5.7, 10, 40, 40);
        _btnReduce.frame=CGRectMake(109*5.7+110, 10, 40, 40);
        _lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 768, 2)];
        _lblLine.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:_lblLine];
    }
    return self;
}

-(void)countchange:(UIButton *)btn
{
    if (btn.tag==1) {
        [_delegate cell:self count:1];
    }else if(btn.tag==2){
        if ([_tfCount.text intValue]-1>0) {
            [_delegate cell:self count:-1];
        }
        else
        {
            [self reduce];
        }
        
    }
}



#pragma mark Handle Button Events
- (void)add{
    BOOL ZS;
    if ([self.lblTotalPrice.text floatValue]!=[[NSString stringWithFormat:@"%.2f",[self.tfPrice.text floatValue]*[self.tfCount.text floatValue]] floatValue]) {
        ZS=NO;
    }
    else
    {
        ZS=YES;
    }
    
    [_delegate cell:self present:ZS];
}

- (void)reduce{
//    float fCount=[_tfCount.text floatValue];
//    if (fCount-1>0){
//        fCount -= 1.0f;
//        _tfCount.text = [NSString stringWithFormat:@"%.2f",fCount];
//        _lblTotalPrice.text = [NSString stringWithFormat:@"%.2f",[_tfPrice.text floatValue]*fCount];
//        [_delegate cell:self countChanged:fCount];
//    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"是否确定要从列表中移除这个菜品?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"移除", nil];
        [alert show];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"移除"]){
        //        [self.arySelectedAdditions removeAllObjects];
        [_delegate cell:self countChanged:0];
    }
}


- (void)setAddition{
    self.supTableView.userInteractionEnabled=NO;
    if (!vAddition){
        vAddition = [[BSAddtionView alloc] initWithFrame:CGRectMake(0, 0, 492, 354)];
        vAddition.delegate = self;
        [self.window addSubview:vAddition];
        vAddition.arySelectedAddtions=[[NSMutableArray alloc] initWithArray:self.arySelectedAdditions];
    }
}
- (void)additionSelected:(NSArray *)ary{
    self.supTableView.userInteractionEnabled=YES;
    if (ary!=nil) {
        [_delegate cell:self additionChanged:[NSMutableArray arrayWithArray:ary]];
    }
    [vAddition removeFromSuperview];
    vAddition=nil;
}


- (void)deleteSelf{
    [_delegate cell:self countChanged:0];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //  判断输入的是否为数字 (只能输入数字)输入其他字符是不被允许的
    
    if([string isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        if ([textField.text length]>=2) {
            return NO;
        }
        //        ^\d{m,n}$
        
        NSString *validRegEx =@"^[0-9]$";
        
        NSPredicate *regExPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", validRegEx];
        
        BOOL myStringMatchesRegEx = [regExPredicate evaluateWithObject:string];
        
        if (myStringMatchesRegEx)
            
            return YES;
        
        else
            
            return NO;
    }
    
}

@end
