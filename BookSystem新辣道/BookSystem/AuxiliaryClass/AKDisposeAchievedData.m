//
//  AKDisposeAchievedData.m
//  BookSystem
//
//  Created by chensen on 13-11-7.
//
//

#import "AKDisposeAchievedData.h"

@implementation AKDisposeAchievedData

+(NSMutableArray *)deskMainDisposeWithDictionary:(NSDictionary*)aDic
{
    NSLog(@"%@",aDic);
    NSMutableArray *mutTables = [NSMutableArray array];    if (aDic){
        NSString *result = [[[aDic objectForKey:@"ns:listTablesResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        //[mut setObject:[NSNumber numberWithBool:YES] forKey:@"Result"];
        NSArray *ary = [result componentsSeparatedByString:@";"];
        
        for (NSString *str in ary) {
            NSArray *aryTableInfo = [str componentsSeparatedByString:@"@"];
            NSMutableDictionary *mutTable = [NSMutableDictionary dictionary];
            NSLog(@"%@",aryTableInfo);
            if ([aryTableInfo count]>=4){
                [mutTable setObject:[aryTableInfo objectAtIndex:1] forKey:@"code"];
                [mutTable setObject:[aryTableInfo objectAtIndex:2] forKey:@"short"];
                [mutTable setObject:[aryTableInfo objectAtIndex:3] forKey:@"name"];
                [mutTable setObject:[aryTableInfo objectAtIndex:4] forKey:@"status"];
                [mutTables addObject:mutTable];
            } else{
                [mutTables addObject:[aryTableInfo objectAtIndex:1]];
            }
            
        }
    }
    else{
        [mutTables addObject:@"查询失败"];
//        [mut setObject:[NSNumber numberWithBool:NO] forKey:@"Result"];
//        [mut setObject:@"查询失败" forKey:@"Message"];
    }
    
    return mutTables;
}
@end
