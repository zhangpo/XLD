//
//  AKUserData.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import "AKUserData.h"

@implementation AKUserData
static AKUserData *userData = nil;
-(void)dealloc
{
    [_userAccount release];
    [_userPassword release];
    [_userName release];
    [super dealloc];
}
+(AKUserData*)sharedUserData
{
    @synchronized(userData){
        if (userData==nil) {
            userData = [[AKUserData alloc]init];
        }
    }
    return userData;
}
@end
