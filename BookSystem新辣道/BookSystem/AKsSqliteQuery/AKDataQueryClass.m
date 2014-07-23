//
//  AKDataQueryClass.m
//  BookSystem
//
//  Created by sundaoran on 13-12-2.
//
//

#import "AKDataQueryClass.h"
#import "AKsFenLeiClass.h"
#import "AKsSettlementClass.h"
#import "Singleton.h"

@implementation AKDataQueryClass

static AKDataQueryClass *_sharedAKDataQuery;

+(AKDataQueryClass *)sharedAKDataQueryClass
{
    if(!_sharedAKDataQuery)
    {
        _sharedAKDataQuery=[[AKDataQueryClass alloc]init];
        
    }
    return _sharedAKDataQuery;
}

-(NSArray *)selectDataFromSqlite:(NSString *)selectSentence
{
    
//    NSString *dounmentPath=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd = selectSentence;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *foodKey = (char *)sqlite3_column_name(stat, i);
                    char *foodValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    
                    if (foodKey)
                        strKey = [NSString stringWithUTF8String:foodKey];
                    if (foodValue)
                        strValue = [NSString stringWithUTF8String:foodValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    return ary;
//    FMDatabase *fmdb=[[FMDatabase alloc]initWithPath:dounmentPath];
//    if(![fmdb open])
//    {
//        return NULL;
//    }
//    if([Api isEqualToString:@"分类"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            AKsFenLeiClass *fenLei=[[AKsFenLeiClass alloc]init];
//            fenLei.fenLeiName=[resultSet stringForColumn:@"NAM"];
//            fenLei.fenLeiId=[resultSet stringForColumn:@"KINDID"];
//            [array addObject:fenLei];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"分类信息"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            AKsSettlementClass *settlement=[[AKsSettlementClass alloc]init];
//            settlement.SettlementName=[resultSet stringForColumn:@"NAM"];
//            settlement.SettlementId=[resultSet stringForColumn:@"CODE"];
//            settlement.SettlementkindId=[resultSet stringForColumn:@"KINDID"];
//            [array addObject:settlement];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"银行卡"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            AKsSettlementClass *settlement=[[AKsSettlementClass alloc]init];
//            settlement.SettlementName=[resultSet stringForColumn:@"OPERATENAME"];
//            settlement.SettlementId=[resultSet stringForColumn:@"OPERATE"];
//            [array addObject:settlement];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"现金"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            AKsSettlementClass *settlement=[[AKsSettlementClass alloc]init];
//            settlement.SettlementName=[resultSet stringForColumn:@"OPERATENAME"];
//            settlement.SettlementId=[resultSet stringForColumn:@"OPERATE"];
//            [array addObject:settlement];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"菜品查询"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            AKsSettlementClass *settlement=[[AKsSettlementClass alloc]init];
//            settlement.SettlementName=[resultSet stringForColumn:@"DES"];
//            [array addObject:settlement];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"现金显示"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            NSString *moneyName=[resultSet stringForColumn:@"OPERATENAME"];
//            [array addObject:moneyName];
//            NSString *OPERATEGROUPID=[resultSet stringForColumn:@"OPERATEGROUPID"];
//            [array addObject:OPERATEGROUPID];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"优惠显示"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            NSString *moneyName=[resultSet stringForColumn:@"OPERATENAME"];
//            [array addObject:moneyName];
//            NSString *OPERATEGROUPID=[resultSet stringForColumn:@"OPERATEGROUPID"];
//            [array addObject:OPERATEGROUPID];
//        }
//        [fmdb close];
//        
//        return array;
//    }
//    else if([Api isEqualToString:@"找零显示"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        while([resultSet next])
//        {
//            NSString *molingId=[resultSet stringForColumn:@"OPERATE"];
//            [array addObject:molingId];
//        }
//        [fmdb close];
//        return array;
//    }
//    else if([Api isEqualToString:@"号码保存"])
//    {
//        FMResultSet *resultSet=[fmdb executeQuery:selectSentence];
//        NSMutableArray *array=[[NSMutableArray alloc]init];
//        NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
//        while([resultSet next])
//        {
//            [dict setObject:[resultSet stringForColumn:@"zhangdanId"] forKey:@"zhangdanId"];
//            [dict setObject:[resultSet stringForColumn:@"phoneNum"] forKey:@"phoneNum"];
//            [dict setObject:[resultSet stringForColumn:@"dateTime"] forKey:@"dateTime"];
//            [dict setObject:[resultSet stringForColumn:@"cardNum"] forKey:@"cardNum"];
//            [dict setObject:[resultSet stringForColumn:@"IntegralOverall"] forKey:@"IntegralOverall"];
//            [array addObject:dict];
//        }
//        [fmdb close];
//        return array;
//    }
//    
//    else
//        return NULL;
//    
}

-(void)savePhoneNumWhithZhangdanId:(NSString *)phoneNum andZhangDanId:(NSString *)zhangdan
{
    NSString *dounmentPath=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *fmdb=[[FMDatabase alloc]initWithPath:dounmentPath];
    if(![fmdb open])
    {
        return ;
    }
    else
    {
        NSString *sql=[NSString stringWithFormat:@"insert into PhoneNumSave ('zhangdanId','phoneNum','dateTime','cardNum','IntegralOverall') values ('%@','%@','%@','%@','%@')",zhangdan,phoneNum,[Singleton sharedSingleton].Time,[NSString stringWithFormat:@"1"],[NSString stringWithFormat:@"2"]];
        NSLog(@"%@",sql);
        [fmdb executeUpdate:sql];
        [fmdb close];
    }
}

-(void)delectPhoneNumWhithZhangdanId:(NSString *)zhangdan
{
    NSString *dounmentPath=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *fmdb=[[FMDatabase alloc]initWithPath:dounmentPath];
    if(![fmdb open])
    {
        return ;
    }
    else
    {
        NSString *sql=[NSString stringWithFormat:@"delete from PhoneNumSave where zhangdanId='%@'",zhangdan];
        NSLog(@"%@",sql);
        [fmdb executeUpdate:sql];
        [fmdb close];
    }
    
}

-(void)saveCardNumforVip:(NSString *)cardNum  andPhoneNum:(NSString *)phoneNum andzhangdanId:(NSString *)zhangdan andIntegralOverall:(NSString *)IntegralOverall
{
    NSString *dounmentPath=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *fmdb=[[FMDatabase alloc]initWithPath:dounmentPath];
    if(![fmdb open])
    {
        return ;
    }
    else
    {
        NSString *sql=[NSString stringWithFormat:@"UPDATE PhoneNumSave SET cardNum='%@',IntegralOverall='%@' WHERE zhangdanId='%@' and phoneNum='%@' and dateTime='%@'" ,cardNum,IntegralOverall,zhangdan,phoneNum,[Singleton sharedSingleton].Time];
        NSLog(@"%@",sql);
        [fmdb executeUpdate:sql];
        [fmdb close];
    }
    
}


@end
