//
//  AKOrderRepastListCell.m
//  BookSystem
//
//  Created by chensen on 13-11-22.
//
//

#import "AKOrderRepastListCell.h"

@implementation AKOrderRepastListCell
@synthesize name=_name,number=_number,price=_price,unit=_unit,count=_count;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 80)];
        _name=[[UILabel alloc] init];
        _number=[[UILabel alloc] init];
        _price=[[UILabel alloc] init];
        _unit=[[UILabel alloc] init];
        _count=[[UILabel alloc] init];
        NSArray *array=[[NSArray alloc] initWithObjects:_name,_number,_price,_unit,_count, nil];
        int i=1;
        for (UILabel *lb in array) {
            lb.frame=CGRectMake(768/7*i, 0, 768/7-1, 80);
            i++;
            lb.textAlignment=NSTextAlignmentCenter;
            [view addSubview:lb];
        }
        UIButton *btn1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn1 setTitle:@"+" forState:UIControlStateNormal];
        btn1.frame=CGRectMake(500,0, 50,80);
        [view addSubview:btn1];
        UILabel *lib=[[UILabel alloc] initWithFrame:CGRectMake(550, 0, 50, 80)];
        lib.text=@"附加项";
        [view addSubview:lib];
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn2 setTitle:@"-" forState:UIControlStateNormal];
        btn2.frame=CGRectMake(600,0, 50,80);
        [view addSubview:btn2];
        [self.contentView addSubview:view];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
