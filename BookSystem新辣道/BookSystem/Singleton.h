//
//  Singleton.h
//  BookSystem
//
//  Created by chensen on 13-11-22.
//
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject
{
    NSMutableArray *_dishArray;
    NSDictionary *_userInfo;
    NSString *_Seat;
    NSString *_CheckNum;
    NSString *_Time;
    NSString *_man;
    NSString *_woman;
    NSString *_userName;
    int _segment;
    NSMutableArray *_order;
    BOOL _quandan;
    BOOL _SELEVIP;
    NSString *_WaitNum;
    BOOL _isYudian;

}
@property(nonatomic,strong)NSMutableArray *dishArray;
@property(nonatomic,strong)NSDictionary *userInfo;
@property(nonatomic,strong)NSString *Seat;
@property(nonatomic,strong)NSString *CheckNum;
@property(nonatomic,strong)NSString *Time;
@property(nonatomic,strong)NSString *man;
@property(nonatomic,strong)NSString *woman;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)int segment;
@property(nonatomic,strong)NSMutableArray *order;
@property(nonatomic,assign)BOOL quandan;
@property(nonatomic,assign)BOOL SELEVIP;
@property(nonatomic,strong)NSString *WaitNum;
@property(nonatomic)BOOL isYudian;
+(Singleton *)sharedSingleton;
@end
