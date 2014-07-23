//
//  AKUserData.h
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import <Foundation/Foundation.h>

@interface AKUserData : NSObject

@property(retain,nonatomic)NSString *userAccount;
@property(retain,nonatomic)NSString *userPassword;
@property(retain,nonatomic)NSString *userName;

+(AKUserData*)sharedUserData;
@end
