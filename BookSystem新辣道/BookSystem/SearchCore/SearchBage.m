//
//  SearchBage.m
//  BookSystem
//
//  Created by chensen on 13-11-23.
//
//

#import "SearchBage.h"

@implementation SearchBage
@synthesize localID;
@synthesize name;
@synthesize phoneArray;

- (void)dealloc
{
    self.localID = nil;
    self.name = nil;
    self.phoneArray = nil;
    [super dealloc];
}


@end
