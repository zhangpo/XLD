//
//  AKOrderButton.m
//  BookSystem
//
//  Created by chensen on 13-12-23.
//
//

#import "AKOrderButton.h"

@implementation AKOrderButton
@synthesize label=_label,button=_button;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame=self.frame;
        [self addSubview:_button];
            UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"s.png"]];
            image.frame=CGRectMake(-5, -5, 20, 20);
            [_button addSubview:image];
            _label=[[UILabel alloc] initWithFrame:CGRectMake(-5, -5, 20, 20)];
            _label.textColor=[UIColor blackColor];
            _label.backgroundColor=[UIColor clearColor];
            [image addSubview:_label];
        
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

@end
