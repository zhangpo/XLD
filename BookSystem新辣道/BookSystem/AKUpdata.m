//
//  AKUpdata.m
//  BookSystem
//
//  Created by chensen on 14-6-18.
//
//

#import "AKUpdata.h"

@implementation AKUpdata
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame withString:(NSString *)html
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.transform = CGAffineTransformIdentity;
        [self setTitle:@"升级"];
        UIWebView *web=[[UIWebView alloc] initWithFrame:CGRectMake(10, 75, frame.size.width-35, frame.size.height-170)];
        [web loadHTMLString:html baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle]  bundlePath]]];
        [self addSubview:web];
        for (int i=0; i<2; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            button.frame=CGRectMake(200+110*i, frame.size.height-90, 100, 50);
//            button.backgroundColor=[UIColor redColor];
            button.titleLabel.font=[UIFont fontWithName:@"ArialRoundedMTBold"size:20];
            [button setBackgroundImage:[UIImage imageNamed:@"TableButtonRed"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (i==0) {
                
                [button setTitle:@"升级" forState:UIControlStateNormal];
            }else
            {
                [button setTitle:@"取消" forState:UIControlStateNormal];
            }
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=1+i;
            [self addSubview:button];
        }
    }
    return self;
}
-(void)btnClick:(UIButton *)btn
{
    [_delegate updata:btn.tag];
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
