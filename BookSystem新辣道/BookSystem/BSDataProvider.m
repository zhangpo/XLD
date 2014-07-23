//
//  BSDataProvider.m
//  BookSystem
//
//  Created by Dream on 11-3-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "BSDataProvider.h"
#import "FMDatabase.h"
#import "Singleton.h"
#import "AKsNetAccessClass.h"
#import "AKsCanDanListClass.h"
#import "AKsYouHuiListClass.h"
#import "AKsCanDanListClass.h"
#import "AKsNetAccessClass.h"
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCrypto.h>
#import <AdSupport/AdSupport.h>
#import "OpenUDID.h"
#import "CardJuanClass.h"

//#import "PaymentSelect.h"


@implementation BSDataProvider

//static BSDataProvider *sharedInstance = nil;
//static NSDictionary *infoDict = nil;
//static NSDictionary *dicCurrentPageConfig = nil;
//static NSDictionary *dicCurrentPageConfigDetail = nil;
//static NSArray *aryPageConfigList = nil;
//static NSLock *_loadingMutex = nil;
//static NSMutableArray *aryOrders = nil;
//static NSArray *aryAllDetailPages = nil;
//static NSArray *aryAllPages = nil;
//static int dSendCount = 0;

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization cod
    }
    return self;
}
//PadId
-(NSString *)padID{
    NSString *deviceID=[[NSUserDefaults standardUserDefaults] objectForKey:@"PDAID"];
    AKsNetAccessClass *netaccess=[AKsNetAccessClass sharedNetAccess];
    netaccess.UserId=deviceID;
    return deviceID;
}
//查询菜品分类
-(NSArray *)getClassById
{  
    NSMutableArray *array =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:@"select * from class order by GRP asc"]];
    return array;
}
//select PNAME,PRICE1,PRODUCTTC_ORDER,defualtS from products_sub where pcode ='10011' order by PRODUCTTC_ORDER asc
//预定台位
-(void)reserveCache:(NSArray *)ary
{
    for (int i=0; i<ary.count; i++) {
        
        AKsCanDanListClass *caiList=[ary objectAtIndex:i];
        
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            //nslog(@"数据库打开失败");
        }
        else
        {
            //nslog(@"数据库打开成功");
        }
        FMResultSet *rs = [db executeQuery:@"select * from food where itcode=?",caiList.pcode];
        NSString *class;
        while ([rs next]){
            class=[rs stringForColumn:@"class"];
        }
        NSString *qqq;
        if ([caiList.istc intValue]==1) {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,@"1",caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",caiList.pcount];
        }
        else
        {
            qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,caiList.pkid,caiList.pcode,caiList.pcname,caiList.tpcode,caiList.tpname,caiList.tpnum,caiList.pcount,caiList.promonum,caiList.fujiacode,caiList.fujianame,caiList.eachPrice,caiList.fujiaprice,caiList.weight,caiList.weightflag,caiList.unit,caiList.istc,caiList.pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",@"1",@""];
        }
        [db executeUpdate:qqq];
        [db close];
    }
    
}
-(void)delectcombo:(NSString *)tpcode andNUM:(NSString *)num
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        //nslog(@"数据库打开失败");
    }
    else
    {
        //nslog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@' and Tpcode='%@' and TPNUM='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2",tpcode,num];
    [db executeUpdate:st];
    [db close];
}
-(void)delectdish:(NSString *)code
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        //nslog(@"数据库打开失败");
    }
    else
    {
        //nslog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@' and Pcode=%@",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2",code];
    [db executeUpdate:st];
    [db close];
}
//缓存
-(void)cache:(NSArray *)ary
{
    [self delectCache];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    int x = 0;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dict=[[ary objectAtIndex:i] objectForKey:@"food"];
        NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*CNT;
        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
        Fujiacode=[NSMutableString string];
        FujiaName=[NSMutableString string];
        FujiaPrice=[NSMutableString string];
        
        PCname=[dict objectForKey:@"DES"];
        Pcode=[dict objectForKey:@"ITCODE"];
        Price=[dict objectForKey:@"PRICE"];
        pcount=[dict objectForKey:@"total"];
        Weight=[dict objectForKey:@"Weight"];
        Weightflg=[dict objectForKey:@"Weightflg"];
        promonum=[dict objectForKey:@"promonum"];
        isTC=[dict objectForKey:@"ISTC"];
        UNIT=[dict objectForKey:@"UNIT"];
        CNT=[dict objectForKey:@"CNT"];
        Tpcode=[dict objectForKey:@"Tpcode"];
        TPNAME=[dict objectForKey:@"TPNAME"];
        TPNUM=[dict objectForKey:@"TPNUM"];
        //                CLASS=[dict objectForKey:@"CLASS"];
        NSArray *array=[dict objectForKey:@"addition"];
        for (NSDictionary *dict1 in array) {
            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
            [Fujiacode appendString:@"!"];
            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
            [FujiaName appendString:@"!"];
            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
            [FujiaPrice appendString:@"!"];
        }
        if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
            Tpcode=Pcode;
            TPNAME=PCname;
            
        }
        else
        {
            if ([dict objectForKey:@"CLASS"]==nil||[[dict objectForKey:@"CLASS"] isEqualToString:@"(null)"])
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                //                TPNUM=[dict objectForKey:@"TPNUM"];
            }
            else
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                //                Tpcode=@"";
                //                TPNAME=@"";
                TPNUM=0;
                x++;
            }
        }
        //        if ([dict objectForKey:@"CNT"]!=nil) {
        //            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
        //            TPNUM=[dict objectForKey:@"TPNUM"];
        //            CNT=[dict objectForKey:@"CNT"];
        //            isTC=@"1";
        //            TPNAME=[dict objectForKey:@"TPNANE"];
        //            Tpcode=[dict objectForKey:@"Tpcode"];
        //        }
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            //nslog(@"数据库打开失败");
        }
        else
        {
            //nslog(@"数据库打开成功");
        }
        NSString *qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,PKID,Pcode,PCname,Tpcode,TPNAME,TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,@"0",@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"2",promonum,CNT];
        [db executeUpdate:qqq];
        [db close];
    }
}
//附加项
- (NSArray *)getAdditions{
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:@"select * from FoodFuJia"]];
    
    return [NSArray arrayWithArray:ary];
    
}
-(NSArray *)chkCodesql{
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:@"select * from ERRORCUSTOM where STATE=1"]];
    return [NSArray arrayWithArray:ary];
}
//查缓存的菜品
-(NSMutableArray *)selectCache
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        //nslog(@"数据库打开失败");
    }
    else
    {
        //nslog(@"数据库打开成功");
    }
    //    [self delectCache];
    NSString *qqq=[NSString stringWithFormat:@"select * from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='2'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time];
    FMResultSet *rs=[db executeQuery:qqq];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    while ([rs next]) {
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        [dict setValue:[rs stringForColumn:@"CLASS"] forKey:@"CLASS"];
        [dict setValue:[rs stringForColumn:@"Pcode"] forKey:@"ITCODE"];
        [dict setValue:[rs stringForColumn:@"ISTC"] forKey:@"ISTC"];
        [dict setValue:[rs stringForColumn:@"price"] forKey:@"PRICE"];
        [dict setValue:[rs stringForColumn:@"PCname"] forKey:@"DES"];
        [dict setValue:[rs stringForColumn:@"TPNAME"] forKey:@"TPNAME"];
        [dict setValue:[rs stringForColumn:@"TPNUM"] forKey:@"TPNUM"];
        [dict setValue:[rs stringForColumn:@"Tpcode"] forKey:@"Tpcode"];
        [dict setValue:[rs stringForColumn:@"unit"] forKey:@"UNIT"];
        [dict setValue:[rs stringForColumn:@"Weight"] forKey:@"Weight"];
        [dict setValue:[rs stringForColumn:@"Weightflg"] forKey:@"Weightflg"];
        NSString *str=[rs stringForColumn:@"fujiacode"];
        NSArray *ary=[str componentsSeparatedByString:@"!"];
        NSString *str1=[rs stringForColumn:@"fujianame"];
        NSArray *ary1=[str1 componentsSeparatedByString:@"!"];
        NSString *str2=[rs stringForColumn:@"fujiaprice"];
        NSArray *ary2=[str2 componentsSeparatedByString:@"!"];
        NSMutableArray *ary3=[NSMutableArray array];
        for (int i=0; i<[ary count]-1; i++) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setValue:[ary objectAtIndex:i] forKey:@"FOODFUJIA_ID"];
            [dict1 setValue:[ary1 objectAtIndex:i] forKey:@"FoodFuJia_Des"];
            [dict1 setValue:[ary2 objectAtIndex:i] forKey:@"FoodFujia_Checked"];
            [ary3 addObject:dict1];
        }
        [dict setValue:ary3 forKey:@"addition"];
        [dict setValue:[rs stringForColumn:@"pcount"] forKey:@"total"];
        [dict setValue:[rs stringForColumn:@"CNT"] forKey:@"CNT"];
        [array addObject:dict];
    }
    [db close];
    return array;
    
}
//清除缓存
-(void)delectCache
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
        //nslog(@"数据库打开失败");
    }
    else
    {
        //nslog(@"数据库打开成功");
    }
    NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
    [db executeUpdate:st];
    [db close];
}
-(NSArray *)soldOut
{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]]];
    NSDictionary *dict = [self bsService:@"soldOut" arg:strParam];
    NSMutableArray *array=[NSMutableArray array];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:soldOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary=[result componentsSeparatedByString:@"@"];
        if ([[ary objectAtIndex:0] intValue]==0) {
            for (int i=1; i<[ary count]; i++) {
                [array addObject:[ary objectAtIndex:i]];
            }
        }
    }
    return array;
}
//预打印
-(NSDictionary *)priPrintOrder
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",pdanum,user,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    
    NSDictionary *dict = [self bsService:@"PrintOrder" arg:strParam];
    
    return dict;
}
//催菜成功修改数据库
-(void)gogoOrderUpData:(NSDictionary *)info
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([[info objectForKey:@"ISTC"] intValue]==1&&[[info objectForKey:@"Pcode"] isEqualToString:[info objectForKey:@"Tpcode"]])
    {
        NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and PKID='%@' and TPNUM='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"PKID"],[info objectForKey:@"TPNUM"]];
        FMResultSet *rs=[db executeQuery:str1];
        int i;
        while ([rs next]) {
            i=[[rs stringForColumn:@"Urge"] intValue];
            NSString *name=[rs stringForColumn:@"ID"];
            NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and ID='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name];
            [db executeUpdate:str];
        }
        
    }else
    {
        NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and ID='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"ID"]];
        FMResultSet *rs=[db executeQuery:str1];
        int i;
        while ([rs next]) {
            i=[[rs stringForColumn:@"Urge"] intValue];
        }
        NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and ID='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"ID"]];
        [db executeUpdate:str];
    }
    [db close];
    
}
-(void)gogoOrderUpData:(NSString *)name withCode:(NSString *)code withTPNUM:(NSString *)TPNUM
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@' and orderId='%@' and PKID='%@' and Pcode='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name,code];
    FMResultSet *rs=[db executeQuery:str1];
    int i;
    while ([rs next]) {
        i=[[rs stringForColumn:@"Urge"] intValue];
    }
    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET Urge = '%d' WHERE tableNum = '%@' and orderId='%@' and PKID='%@' and Pcode='%@' and TPNUM='%@'",i+1,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,name,code,TPNUM];
    [db executeUpdate:str];
    [db close];
}
-(void)updatecombineTable:(NSDictionary *)dict :(NSString *)cheak
{
    NSMutableArray *array=[NSMutableArray array];
    [array addObject:[dict objectForKey:@"newtable"]];
    [array addObject:[dict objectForKey:@"oldtable"]];
    for (int i=0; i<[array count]; i++) {
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            return;
        }
        
        //    NSString *str1=[NSString stringWithFormat:@"select * from AllCheck where tableNum='%@' and Time='%@'"
        NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET orderId = '%@' WHERE tableNum = '%@' and Time='%@'",cheak,[array objectAtIndex:i],[Singleton sharedSingleton].Time];
        [db executeUpdate:str];
        [db close];
    }
}
//换台更改数据库
-(void)updateChangTable:(NSDictionary *)info :(NSString *)cheak
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET tableNum = '%@' WHERE tableNum = '%@' and orderId='%@'",[info objectForKey:@"newtable"],[info objectForKey:@"oldtable"],cheak];
    [db executeUpdate:str];
    [db close];
}
//数据库划菜
-(int)updata:(NSDictionary *)dict withNum:(NSString *)num withOver:(NSString *)over
{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([over isEqualToString:@"0"]) {
        NSString *str=[NSString stringWithFormat:@"%d",[[dict objectForKey:@"Over"] intValue]+[num intValue]];
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=? and TPNUM=?",str,[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[dict objectForKey:@"PKID"],[dict objectForKey:@"Pcode"],[dict objectForKey:@"TPNUM"]];
    }
    else
    {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=? and TPNUM=?",@"0",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[dict objectForKey:@"PKID"],[dict objectForKey:@"Pcode"],[dict objectForKey:@"TPNUM"]];
    }
    FMResultSet *rs=[db executeQuery:@"select * from AllCheck where Over=0 and tableNum = ? and orderId=? and Time=?",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time];
    int i=0;
    while ([rs next]) {
        i++;
    }
    [db close];
    return i;
}
-(NSString *)scratch:(NSDictionary *)info andtag:(int)tag
{
    NSMutableString *fanfood=[NSMutableString string];
    if ([info objectForKey:@"fujiacode"]==nil) {
        [info setValue:@"" forKey:@"fujiacode"];
    }
    if ([info objectForKey:@"Weightflg"]==nil) {
        [info setValue:@"" forKey:@"Weightflg"];
    }
    [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"count"],[info objectForKey:@"PKID"]];
    [fanfood appendString:@";"];
    if (tag==0) {
        //        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
//        NSString *str2;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//        NSArray *ary = [result componentsSeparatedByString:@"@"];
//        if ([ary count]==1) {
//            str2=[ary objectAtIndex:0];
//        }else
//        {
//            str2=[ary objectAtIndex:1];
//        }
        return result;
    }else
    {
//        NSString *str;
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//        NSArray *ary = [result componentsSeparatedByString:@"@"];
//        if ([ary count]==1) {
//            str=[ary objectAtIndex:0];
//        }else
//        {
//            str=[ary objectAtIndex:1];
//        }
        return result;
    }
}
//接口划菜
-(NSString *)scratch:(NSArray *)dish
{
    //    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    //    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    NSMutableString *fanfood=[NSMutableString string];
    for (NSDictionary *info in dish) {
        if ([[info objectForKey:@"Over"] intValue]==[[info objectForKey:@"pcount"] intValue]) {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [fanfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[info objectForKey:@"Over"],[info objectForKey:@"PKID"]];
            [fanfood appendString:@";"];
        }
        else
        {
            if ([info objectForKey:@"fujiacode"]==nil) {
                [info setValue:@"" forKey:@"fujiacode"];
            }
            if ([info objectForKey:@"Weightflg"]==nil) {
                [info setValue:@"" forKey:@"Weightflg"];
            }
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%d@%@",[info objectForKey:@"Pcode"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNUM"],[info objectForKey:@"fujiacode"],[info objectForKey:@"Weightflg"],[info objectForKey:@"ISTC"],[[info objectForKey:@"pcount"] intValue]-[[info objectForKey:@"Over"] intValue],[info objectForKey:@"PKID"]];
            [mutfood appendString:@";"];
        }
    }
    NSString *str1;
    if (![mutfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
        NSDictionary *dict = [self bsService:@"callElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:callElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        str1=result;
    }
    if (![fanfood isEqualToString:@""]) {
        NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,fanfood];
        NSDictionary *dict = [self bsService:@"reCallElide" arg:strParam];
        NSString *result = [[[dict objectForKey:@"ns:reCallElideResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
//        NSArray *ary = [result componentsSeparatedByString:@"@"];
        if (str1==nil) {
            str1=result;
        }
    }
    return str1;
}
-(NSArray *)specialremark//查询全单附加项
{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [BSDataProvider sqlitePath];
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd;
    //   char *errorMsg;
    
    if (sqlite3_open([path UTF8String], &db)==SQLITE_OK){
        sqlcmd = @"select * from specialremark";
        if (sqlite3_prepare_v2(db, [sqlcmd UTF8String], -1, &stat, nil)==SQLITE_OK){
            while (sqlite3_step(stat)==SQLITE_ROW) {
                int count = sqlite3_column_count(stat);
                NSMutableDictionary *mutDC = [NSMutableDictionary dictionary];
                for (int i=0;i<count;i++){
                    char *attachKey = (char *)sqlite3_column_name(stat, i);
                    char *attachValue = (char *)sqlite3_column_text(stat, i);
                    NSString *strKey = nil,*strValue = nil;
                    if (attachKey)
                        strKey = [NSString stringWithUTF8String:attachKey];
                    if (attachValue)
                        strValue = [NSString stringWithUTF8String:attachValue];
                    if (strKey && strValue)
                        [mutDC setObject:strValue forKey:strKey];
                }
                [ary addObject:mutDC];
            }
        }
        sqlite3_finalize(stat);
    }
    sqlite3_close(db);
    
    return [NSArray arrayWithArray:ary];
}
-(NSArray *)presentreason
{
    NSArray *ary=[BSDataProvider getDataFromSQLByCommand:@"select * from presentreason"];
    return [NSArray arrayWithArray:ary];
}
+(int)updata:(NSString *)table orderID:(NSString *)order pkid:(NSString *)pkid code:(NSString *)code Over:(NSString *)over;{
    FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
    if(![db open])
    {
    }
    if ([over isEqualToString:@"0"]) {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"1",table,order,pkid,code];
    }
    else
    {
        [db executeUpdate:@"UPDATE AllCheck SET Over = ? WHERE tableNum = ? and orderId=? and PKID=? and Pcode=?",@"0",table,order,pkid,code];
    }
    FMResultSet *rs=[db executeQuery:@"select * from AllCheck where Over=0 and tableNum = ? and orderId=?",table,order];
    int i=0;
    while ([rs next]) {
        i++;
    }
    [db close];
    return i;
}
//改变台位状态
-(NSDictionary *)changTableState:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    //    NSString *tableNum=[info objectForKey:@"tableNum"];
    NSString *currentState=[info objectForKey:@"currentState"];
    NSString *nextState=[info objectForKey:@"nextState"];
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&currentState=%@&nextState=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,currentState,nextState];
    NSDictionary *dict = [self bsService:@"changTableState" arg:api];
    return dict;
}
//
//台位操作
- (NSDictionary *)pChangeTable:(NSDictionary *)info{
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n")},//6.换台changetable
    //+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n
    NSString *pdaid,*user,*oldtable,*newtable,*pwd,*orderId;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tablenumSource=%@&tablenumDest=%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"pSignTeb" arg:strParam];
    //    if (dict) {
    //        NSString *result = [[[dict objectForKey:@"ns:changeTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    //        NSArray *ary=[result componentsSeparatedByString:@"@"];
    //        if ([[ary objectAtIndex:0] isEqualToString:@"-1"]) {
    //            //nslog(@"%@",[ary objectAtIndex:1]);
    //            return [NSDictionary dictionaryWithObjectsAndKeys:result,@"Message",nil];
    //        }
    //        else
    //        {
    //            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil];
    //        }
    //    }
    return dict;
}

//并台
-(NSDictionary *)combineTable:(NSDictionary *)info
{
    NSString *pdaid,*user,*oldtable,*newtable,*pwd,*orderId;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [[Singleton sharedSingleton].userInfo objectForKey:@"user"];
    pwd = [info objectForKey:@"pwd"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    oldtable = [info objectForKey:@"oldtable"];
    newtable = [info objectForKey:@"newtable"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableList=%@@%@",pdaid,user,oldtable,newtable];
    NSDictionary *dict = [self bsService:@"combineTable" arg:strParam];
    return dict;
    //    if (dict) {
    //        NSString *result = [[[dict objectForKey:@"ns:combineTableResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    //        NSArray *ary=[result componentsSeparatedByString:@"@"];
    //        if ([[ary objectAtIndex:0] isEqualToString:@"-1"]) {
    //            //nslog(@"%@",[ary objectAtIndex:1]);
    //            return [NSDictionary dictionaryWithObjectsAndKeys:result,@"Message",nil];
    //        }
    //        else
    //        {
    //            return [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],@"Result",nil];
    //        }
    //    }
    //    return nil;
}

//查询台位菜品
-(NSMutableArray *)queryProduct:(NSString *)seat
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *tableNum=seat;
    NSString *api=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@&orderId=%@&chkCode=%@&comOrDetach=%@",pdanum,user,tableNum,@"",@"",@"",@"",@"0"];
    NSDictionary *dict = [self bsService:@"queryProduct" arg:api];
    NSString *result = [[[dict objectForKey:@"ns:queryProductResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    if ([[[result componentsSeparatedByString:@"@"] objectAtIndex:0] intValue]==0) {
        [Singleton sharedSingleton].CheckNum=[[result componentsSeparatedByString:@"@"] objectAtIndex:1];
        
    }
    NSMutableArray *array1=[[NSMutableArray alloc] init];
    NSArray *ary1 = [result componentsSeparatedByString:@"#"];
    for (int i=0;i<[ary1 count];i++) {
        if (i==0) {
            NSArray *ary2=[[ary1 objectAtIndex:0] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *array=[[NSMutableArray alloc] init];
            for (NSString *result2 in array2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsCanDanListClass *candan=[[AKsCanDanListClass alloc] init];
                    if ([[ary3 objectAtIndex:3] isEqualToString:[ary3 objectAtIndex:5]]||[[ary3 objectAtIndex:5]isEqualToString:@""]) {
                        candan.pcname=[ary3 objectAtIndex:4];
                    }
                    else
                    {
                        candan.pcname=[NSString stringWithFormat:@"--%@",[ary3 objectAtIndex:4]];
                    }
                    [Singleton sharedSingleton].CheckNum=[ary3 objectAtIndex:1];
                    candan.tpname=[ary3 objectAtIndex:6];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.fujianame=[ary3 objectAtIndex:7];
                    candan.pcount=[ary3 objectAtIndex:8];
                    candan.promonum=[ary3 objectAtIndex:9];
                    NSArray *ary4=[[ary3 objectAtIndex:11] componentsSeparatedByString:@"!"];
                    NSMutableString *FujiaName =[NSMutableString string];
                    for (NSString *str in ary4) {
                        [FujiaName appendFormat:@"%@ ",str];
                    }
                    candan.fujianame=FujiaName;
                    candan.price=[ary3 objectAtIndex:12];
                    candan.unit=[ary3 objectAtIndex:16];
                    candan.istc=[ary3 objectAtIndex:17];
                    [array addObject:candan];
                }
                else
                {
                    return nil;
                }
                
            }
            [array1 addObject:array];
        }
        else if(i==1)
        {
            NSArray *ary2=[[ary1 objectAtIndex:1] componentsSeparatedByString:@";"];
            NSMutableArray *array2=[[NSMutableArray alloc] initWithArray:ary2];
            [array2 removeLastObject];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            for (NSString *result2 in array2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([[ary3 objectAtIndex:0] intValue]==0) {
                    AKsYouHuiListClass *youhui=[[AKsYouHuiListClass alloc] init];
                    youhui.youName=[ary3 objectAtIndex:2];
                    youhui.youMoney=[ary3 objectAtIndex:3];
                    [ary addObject:youhui];
                }
            }
            [array1 addObject:ary];
        }
        else if(i==2)
        {
            NSArray *ary2=[[ary1 objectAtIndex:2] componentsSeparatedByString:@"@"];
            if ([[ary2 objectAtIndex:0] intValue]==0) {
                [Singleton sharedSingleton].man=[ary2 objectAtIndex:1];
                [Singleton sharedSingleton].woman=[ary2 objectAtIndex:2];
            }
        }
        else{
            NSArray *ary2=[[ary1 objectAtIndex:3] componentsSeparatedByString:@";"];
            NSMutableArray *ary=[[NSMutableArray alloc] init];
            NSMutableString *str=[NSMutableString string];
            //nslog(@"%@",ary);
            for (NSString *result2 in ary2) {
                NSArray *ary3=[result2 componentsSeparatedByString:@"@"];
                if ([ary3 count]==2) {
                    //                    [ary stringByAppendingString:[ary3 objectAtIndex:1]];
                    [str appendFormat:@"%@ ",[ary3 objectAtIndex:1]];
                }
                //                [ary addObject:[ary3 objectAtIndex:1]];
            }
            [ary addObject:str];
            [array1 addObject:ary];
        }
    }
    if ([array1 count]==3) {
        [array1 exchangeObjectAtIndex:1 withObjectAtIndex:2];
    }
    //nslog(@"%@",array1);
    return array1;
}
//根据台位号查账单
-(NSArray *)getOrdersBytabNum1:(NSString *)str{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],str];
    NSDictionary *dict = [self bsService:@"getOrdersBytabNum" arg:strParam];
    NSString *str1=[[[dict objectForKey:@"ns:getOrdersBytabNumResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary = [str1 componentsSeparatedByString:@"@"];
    if ([ary count]==1) {
       
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:[ary lastObject] delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        return  nil;
    }
    else
    {
        if ([[ary objectAtIndex:0] intValue]==0) {
            NSArray *valuearray = [str1 componentsSeparatedByString:@"#"];
            if([[valuearray objectAtIndex:1]isEqualToString:@"1"])
            {
                AKsNetAccessClass *netAccess =[AKsNetAccessClass sharedNetAccess];
                NSArray *cardValue=[[valuearray objectAtIndex:2]componentsSeparatedByString:@"@"];
                NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
                
                
                [dict setObject:@"" forKey:@"zhangdanId"];
                [dict setObject:[cardValue objectAtIndex:0] forKey:@"phoneNum"];
                [dict setObject:[Singleton sharedSingleton].Time forKey:@"dateTime"];
                [dict setObject:[cardValue objectAtIndex:1] forKey:@"cardNum"];
                [dict setObject:[cardValue objectAtIndex:4] forKey:@"IntegralOverall"];
                
                
                netAccess.JiFenKeYongMoney=[cardValue objectAtIndex:4];
                netAccess.ChuZhiKeYongMoney=[cardValue objectAtIndex:3];
                netAccess.VipCardNum=[cardValue objectAtIndex:1];
                
                NSArray *VipJuan=[[NSArray alloc]initWithArray:[[cardValue objectAtIndex:7]componentsSeparatedByString:@";" ]];
                //nslog(@"%@",VipJuan);
                NSMutableArray *cardJuanArray=[[NSMutableArray alloc]init];
                for (int i=0; i<[VipJuan count]-1; i++)
                {
                    NSArray *values=[[VipJuan objectAtIndex:i] componentsSeparatedByString:@","];
                    CardJuanClass *cardJuan=[[CardJuanClass alloc]init];
                    cardJuan.JuanId=[values objectAtIndex:0];
                    cardJuan.JuanMoney=[NSString stringWithFormat:@"%.2f",[[values objectAtIndex:1]floatValue]/100.0];
                    cardJuan.JuanName=[values objectAtIndex:2];
                    cardJuan.JuanNum=[values objectAtIndex:3];
                    [cardJuanArray addObject:cardJuan];
                    
                }
                
                netAccess.CardJuanArray=cardJuanArray;
                netAccess.showVipMessageDict=dict;
            }
            NSArray *array=[[ary objectAtIndex:1] componentsSeparatedByString:@";"];
            return array;
        }
        else
        {
            return Nil;
        }
    }
}
//登出
-(NSArray *)logout
{
    NSString *strParam=[NSString stringWithFormat:@"?&deviceId=%@&userCode=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict=[self bsService:@"logout" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:loginOutResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return ary1;
}
//编号注册
-(NSString *)registerDeviceId:(NSString *)str
{
    NSString *strParam =[NSString stringWithFormat:@"?&handvId=%@",str];
    NSDictionary *dict = [self bsService:@"registerDeviceId" arg:strParam];
    NSString *result = [[[dict objectForKey:@"ns:registerDeviceIdResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
    NSArray *ary1 = [result componentsSeparatedByString:@"@"];
    return [ary1 objectAtIndex:1];
}
//授权
-(NSDictionary *)checkAuth:(NSDictionary *)info
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *user=[info objectForKey:@"user"];
    NSString *pass=[info objectForKey:@"pwd"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&userPass=%@",pdanum,user,pass];
    NSDictionary *dict = [self bsService:@"checkAuth" arg:strParam];
    return dict;
    
}
//全单附加项
-(NSDictionary *)specialRemark:(NSArray *)ary
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *userCode=[NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSString *orderId=[Singleton sharedSingleton].CheckNum;
    //nslog(@"%@",ary);
    NSMutableString *remarkId=[NSMutableString string];
    NSMutableString *remark=[NSMutableString string];
    for (NSDictionary *dict in ary) {
        [remarkId appendFormat:@"%@",[dict objectForKey:@"Id"]];
        [remarkId appendString:@"!"];
        [remark appendFormat:@"%@",[dict objectForKey:@"DES"]];
        [remark appendString:@"!"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&remarkIdList=%@&remarkList=%@&flag=%@",pdanum,userCode,orderId,remarkId,remark,@"1"];
    NSDictionary *dict1 = [self bsService:@"specialRemark" arg:strParam];
    //nslog(@"%@",dict1);
    return dict1;
}
//全单
//查询全单
- (NSDictionary *)queryCompletely{
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",[self padID],[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    NSDictionary *dict = [self bsService:@"queryWholeProducts" arg:strParam];
    
    if (dict) {
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSString *result = [[[dict objectForKey:@"ns:queryWholeProductsResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary = [result componentsSeparatedByString:@"@"];
        NSMutableArray *aryResult = [NSMutableArray array];
        if ([[ary objectAtIndex:0] isEqualToString:@"0"]) {
            //获取男人数、女人数、账单号、台位等基本信息
            NSArray *aryInfo = [result componentsSeparatedByString:@"#"];
            NSArray *aryInfoRes =[[aryInfo objectAtIndex:[aryInfo count]-2] componentsSeparatedByString:@"@"];
            [Singleton sharedSingleton].man=[aryInfoRes objectAtIndex:1];
            [Singleton sharedSingleton].woman=[aryInfoRes objectAtIndex:2];
            NSArray *ary = [[aryInfo objectAtIndex:0] componentsSeparatedByString:@";"];
            NSArray *array=[[aryInfo lastObject] componentsSeparatedByString:@";"];
            NSMutableString *Common=[NSMutableString string];
            for (int i=0; i<[array count]-1; i++) {
                NSString *str=[array objectAtIndex:i];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                [Common appendFormat:@"%@ ",[itemAry objectAtIndex:1]];
            }
            [dic setValue:Common forKey:@"Common"];
            //            NSMutableDictionary *dicResult = [NSMutableDictionary dictionary];
            
            int c = [ary count];
            for (int z=0; z<c-1; z++) {
                NSString *str = [ary objectAtIndex:z];
                NSArray *itemAry = [str componentsSeparatedByString:@"@"];
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setValue:[itemAry objectAtIndex:1]  forKey:@"orderId"];
                [mutDic setValue:[itemAry objectAtIndex:2]  forKey:@"PKID"];
                [mutDic setValue:[itemAry objectAtIndex:3]  forKey:@"Pcode"];
                [mutDic setValue:[itemAry objectAtIndex:4]  forKey:@"PCname"];
                [mutDic setValue:[itemAry objectAtIndex:5]  forKey:@"Tpcode"];
                [mutDic setValue:[itemAry objectAtIndex:6]  forKey:@"TPNAME"];
                [mutDic setValue:[itemAry objectAtIndex:7]  forKey:@"TPNUM"];
                [mutDic setValue:[itemAry objectAtIndex:8]  forKey:@"pcount"];
                [mutDic setValue:[itemAry objectAtIndex:9]  forKey:@"promonum"];
                [mutDic setValue:[itemAry objectAtIndex:10] forKey:@"fujiacode"];
                [mutDic setValue:[itemAry objectAtIndex:11] forKey:@"fujianame"];
                [mutDic setValue:[itemAry objectAtIndex:12]  forKey:@"talPreice"];
                [mutDic setValue:[itemAry objectAtIndex:13] forKey:@"fujiaprice"];
                [mutDic setValue:[itemAry objectAtIndex:14]  forKey:@"weight"];
                [mutDic setValue:[itemAry objectAtIndex:15]  forKey:@"weightflg"];
                [mutDic setValue:[itemAry objectAtIndex:16]  forKey:@"unit"];
                [mutDic setValue:[itemAry objectAtIndex:17]  forKey:@"ISTC"];
                [mutDic setValue:[itemAry objectAtIndex:18]  forKey:@"Urge"];//催菜次数
                [mutDic setValue:[itemAry objectAtIndex:19]  forKey:@"Over"];//划菜数量
                [mutDic setValue:[itemAry objectAtIndex:20]  forKey:@"IsQuit"];//推菜标志（0为退菜，1为正常）
                [mutDic setValue:[itemAry objectAtIndex:21]  forKey:@"QuitCause"];//退菜原因
                [mutDic setValue:[itemAry objectAtIndex:22]  forKey:@"CLASS"];
                [mutDic setValue:[itemAry objectAtIndex:23] forKey:@"price"];
                [aryResult addObject:mutDic];
            }
            
        }
        [dic setValue:aryResult forKey:@"data"];
        return dic;
    }else
    {
        return nil;
    }
}
//退菜
-(NSDictionary *)chkCode:(NSArray *)array info:(NSDictionary *)info{
    //nslog(@"%@",array);
    NSArray *dataArray=array;
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        int count=[[info objectForKey:@"pcount"] intValue]-[[info objectForKey:@"Over"] intValue];
        if([[info objectForKey:@"ISTC"] intValue]==1&&![[info objectForKey:@"Pcode"] isEqualToString:[info objectForKey:@"Tpcode"]]){
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%@",[info objectForKey:@"CNT"]] ,[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
        else
        {
            [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],[info objectForKey:@"PCname"],[info objectForKey:@"Tpcode"],[info objectForKey:@"TPNAME"],@"0",[NSString stringWithFormat:@"-%d",count],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],[info objectForKey:@"fujianame"],[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],[info objectForKey:@"unit"],[info objectForKey:@"ISTC"]];
            [mutfood appendString:@";"];
        }
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[info objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"INIT"]];
    NSDictionary *dict1 = [self bsService:@"checkFoodAvailable" arg:strParam];
    //nslog(@"%@",dict1);
    if (dict1) {
        NSString *result = [[[dict1 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        //nslog(@"%@",ary1);
        if ([[ary1 objectAtIndex:0] intValue]==0) {
            for (NSDictionary *dict in dataArray) {
                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
                if(![db open])
                {
                    //nslog(@"数据库打开失败");
                    return nil;
                }
                else
                {
                    //nslog(@"数据库打开成功");
                }
                FMResultSet *rs=[db executeQuery:@"select * from AllCheck where PKID=?",[dict objectForKey:@"PKID"]];
                NSString *pcount,*over;
                while ([rs next]) {
                    pcount=[rs stringForColumn:@"pcount"];
                    over=[rs stringForColumn:@"Over"];
                }
                //nslog(@"%@",dict);
                int count=[pcount intValue]-[[dict objectForKey:@"pcount"] intValue]-[[dict objectForKey:@"Over"] intValue];
                int count1=[over intValue]-[[dict objectForKey:@"pcount"] intValue];
                if (count<1) {
                    NSString *qqq=[NSString stringWithFormat:@"delete from AllCheck WHERE PKID='%@'",[dict objectForKey:@"PKID"]];
                    //nslog(@"%@",qqq);
                    [db executeUpdate:qqq];
                }
                else
                {
                    //nslog(@"------%d   %d",count,count1);
                    NSString *str=[NSString stringWithFormat:@"UPDATE AllCheck SET pcount = '%d',Over='%d' WHERE PKID = '%@'",count,count1,[dict objectForKey:@"PKID"]];
                    //nslog(@"%@",str);
                    [db executeUpdate:str];
                }
                
                
                //nslog(@"%d",[db commit]);
                [db close];
                
            }
        }
    }
    return dict1;
}
//菜齐
-(void)suppProductsFinish
{
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&orderId=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum];
    
    NSDictionary *dict = [self bsService:@"ProductsFinish" arg:strParam];
    //nslog(@"%@",dict);
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:suppProductsFinishResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        //nslog(@"%@",[ary1 lastObject]);
    }
    
}
//请求连接
- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg{
    BSWebServiceAgent *agent = [[BSWebServiceAgent alloc] init];
    NSDictionary *dict = [agent GetData:api arg:arg];
    return dict;
}
//查台
- (NSDictionary *)pListTable:(NSDictionary *)info{
    //+listtable<user:%s;pdanum:%s;floor:%s;area:%s;status:%s;>\r\n
    //'全部状态' '空闲' '开台点菜' '开台未点' '预订' '预结'全部楼层=ALLFLOOR全部区域=ALLAREA全部状态=ALLSTA
    /*
     '空闲'=A
     '开台点菜'=B
     '开台未点'=C
     '预订'=D
     '预结'=E
     */
    //nslog(@"%@",info);
    
    NSMutableDictionary *mut = [NSMutableDictionary dictionary];
    NSString *user,*pdanum,*floor,*area,*status,*tableNum;
    NSString *cmd;
    //   user = [NSString stringWithFormat:@"%@-%@",[info objectForKey:@"user"],[info objectForKey:@"pwd"]];
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    floor = [info objectForKey:@"floor"];
    if (!floor)
        floor = @"";
    area = [info objectForKey:@"area"];
    if (!area)
        area = @"";
    status = [info objectForKey:@"state"];
    if (!status)
        status = @"";
    tableNum = [info objectForKey:@"tableNum"];
    if (!tableNum)
        tableNum = @"";
    
//    cmd = [NSString stringWithFormat:@"+listtable<user:%@;pdanum:%@;floor:%@;area:%@;status:%@;>\r\n",user,pdanum,floor,area,status];
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&area=%@&floor=%@&state=%@&tableNum=%@",pdanum,user,area,floor,status,tableNum];
    //nslog(@"%@",strParam);
    NSDictionary *dict = [self bsService:@"pListTable" arg:strParam];
    return dict;
}

//发送菜
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag{
    //nslog(@"%@",ary);
    NSString *pdanum = [NSString stringWithFormat:@"%@",[self padID]];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    NSMutableString *mutfood = [NSMutableString string];
    int x = 0;
    for (int i=0; i<ary.count; i++) {
        NSDictionary *dict=[[ary objectAtIndex:i] objectForKey:@"food"];
        NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*promoReason;
        NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
        Fujiacode=[NSMutableString string];
        FujiaName=[NSMutableString string];
        FujiaPrice=[NSMutableString string];
//        PCname=@"";
//        TPNAME=@"";
        //        PCname=[dict objectForKey:@"DES"];
        Pcode=[dict objectForKey:@"ITCODE"];
        Price=[dict objectForKey:@"PRICE"];
        Tpcode=[dict objectForKey:@"Tpcode"];
        
        //        TPNAME=[dict objectForKey:@"TPNANE"];
        pcount=[dict objectForKey:@"total"];
        Weight=[dict objectForKey:@"Weight"];
        Weightflg=[dict objectForKey:@"Weightflg"];
        promonum=[dict objectForKey:@"promonum"];
        promoReason=[dict objectForKey:@"promoReason"];
        isTC=[dict objectForKey:@"ISTC"];
        TPNUM=[dict objectForKey:@"TPNUM"];
        UNIT=[dict objectForKey:@"UNIT"];
        NSArray *array=[dict objectForKey:@"addition"];
        for (NSDictionary *dict1 in array) {
            [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
            [Fujiacode appendString:@"!"];
            [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
            [FujiaName appendString:@"!"];
            [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
            [FujiaPrice appendString:@"!"];
        }
        if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
            Tpcode=Pcode;
            //            TPNAME=PCname;
            //            TPNUM=[dict objectForKey:@"TPNUM"];
            x++;
        }
        else
        {
            if ([dict objectForKey:@"CNT"]!=nil&&![[dict objectForKey:@"CNT"] isEqualToString:@"(null)"])
            {
                //nslog(@"%@",dict);
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x-1];
                pcount=[dict objectForKey:@"CNT"];
                isTC=@"1";
            }
            else
            {
                PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                x++;
            }
        }
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",PKID,Pcode,@"",Tpcode,@"",TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,promoReason];
        [mutfood appendString:@";"];
    }
    //nslog(@"%@",mutfood);
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&chkCode=%@&tableNum=%@&orderId=%@&productList=%@&rebackReason=&immediateOrWait=%@",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],@"",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,mutfood,[info objectForKey:@"immediateOrWait"]];
    
    NSDictionary *dict3 = [self bsService:@"checkFoodAvailable" arg:strParam];
    
    if (dict3 && [Singleton sharedSingleton].isYudian==NO) {
        NSString *result = [[[dict3 objectForKey:@"ns:sendcResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        NSArray *ary1 = [result componentsSeparatedByString:@"@"];
        NSString *str=[ary1 objectAtIndex:0];
        if ([str isEqualToString:@"0"]) {
            x=0;
            for (int i=0; i<ary.count; i++) {
                NSDictionary *dict=[[ary objectAtIndex:i] objectForKey:@"food"];
                NSString *PKID,*Pcode,*PCname,*Tpcode,*TPNAME,*TPNUM,*pcount,*Price,*Weight,*Weightflg,*isTC,*promonum,*UNIT,*CNT;
                NSMutableString *Fujiacode,*FujiaName,*FujiaPrice;
                Fujiacode=[NSMutableString string];
                FujiaName=[NSMutableString string];
                FujiaPrice=[NSMutableString string];
                
                PCname=[dict objectForKey:@"DES"];
                Pcode=[dict objectForKey:@"ITCODE"];
                Price=[dict objectForKey:@"PRICE"];
                Tpcode=[dict objectForKey:@"Tpcode"];
                TPNAME=[dict objectForKey:@"TPNANE"];
                pcount=[dict objectForKey:@"total"];
                Weight=[dict objectForKey:@"Weight"];
                Weightflg=[dict objectForKey:@"Weightflg"];
                promonum=[dict objectForKey:@"promonum"];
                isTC=[dict objectForKey:@"ISTC"];
                UNIT=[dict objectForKey:@"UNIT"];
                CNT=[dict objectForKey:@"CNT"];
                TPNUM=[dict objectForKey:@"TPNUM"];
                NSArray *array=[dict objectForKey:@"addition"];
                for (NSDictionary *dict1 in array) {
                    [Fujiacode appendFormat:@"%@",[dict1 objectForKey:@"FOODFUJIA_ID"]];
                    [Fujiacode appendString:@"!"];
                    [FujiaName appendFormat:@"%@",[dict1 objectForKey:@"FoodFuJia_Des"]];
                    [FujiaName appendString:@"!"];
                    [FujiaPrice appendFormat:@"%@",[dict1 objectForKey:@"FoodFujia_Checked"]];
                    [FujiaPrice appendString:@"!"];
                }
                if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
                    PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                    Tpcode=Pcode;
                    TPNAME=PCname;
                    x++;
                }
                else
                {
                    if ([[dict objectForKey:@"ISTC"] isEqualToString:@"1"]) {
                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                        Tpcode=Pcode;
                        //            TPNAME=PCname;
                        //            TPNUM=[dict objectForKey:@"TPNUM"];
                        
                        x++;
                    }
                    else
                    {
                        if ([dict objectForKey:@"CLASS"]==nil)
                        {
                            //nslog(@"%@",dict);
                            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x-1];
                            pcount=[dict objectForKey:@"total"];
                            isTC=@"1";
                        }
                        else
                        {
                            PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                            x++;
                        }
                    }
                    //                    if ([dict objectForKey:@"CLASS"]==nil||[[dict objectForKey:@"CLASS"] isEqualToString:@"(null)"])
                    //                    {
                    //                        //nslog(@"%@",dict);
                    //                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],x];
                    //                        TPNUM=[dict objectForKey:@"TPNUM"];
                    //                        CNT=[dict objectForKey:@"CNT"];
                    //                        isTC=@"1";
                    //                    }
                    //                    else
                    //                    {
                    //                        PKID=[NSString stringWithFormat:@"%@%@%@%@%@%@%d",pdanum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"],[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,timeString,[[ary objectAtIndex:i] objectForKey:@"count"],i];
                    //
                    //                        TPNUM=0;
                    //                        x++;
                    //                    }
                }
                FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
                if(![db open])
                {
                    //nslog(@"数据库打开失败");
                    return nil;
                }
                else
                {
                    //nslog(@"数据库打开成功");
                }
                NSString *qqq=[NSString stringWithFormat:@"insert into AllCheck ('tableNum','orderId','Time','PKID','Pcode','PCname','Tpcode','TPNAME','TPNUM','pcount','promonum','fujiacode','fujianame','price','fujiaprice','Weight','Weightflg','unit','ISTC','Over','Urge' ,'man','woman' ,'Send','CLASS','CNT') values ('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,PKID,Pcode,PCname,Tpcode,TPNAME,TPNUM,pcount,promonum,Fujiacode,FujiaName,Price,FujiaPrice,Weight,Weightflg,UNIT,isTC,pcount,@"0",[Singleton sharedSingleton].man,[Singleton sharedSingleton].woman,@"1",[info objectForKey:@"immediateOrWait"],CNT];
                //nslog(@"%@",qqq);
                [db executeUpdate:qqq];
                NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
                [db executeUpdate:st];
                //nslog(@"%d",[db commit]);
                [db close];
            }
        }
    }
    else
    {
        FMDatabase *db=[[FMDatabase alloc] initWithPath:[BSDataProvider sqlitePath]];
        if(![db open])
        {
            //nslog(@"数据库打开失败");
            return nil;
        }
        else
        {
            //nslog(@"数据库打开成功");
        }
        NSString *st=[NSString stringWithFormat:@"delete from AllCheck where tableNum='%@' and orderId='%@' and Time='%@' and Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"2"];
        [db executeUpdate:st];
        [db close];
    }
    return dict3;
}
// SQLite相关
+ (NSString *)sqlitePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"BookSystem.sqlite"];
    return path;
}
//查找本地的发送的菜
+(NSArray *)tableNum:(NSString *)table orderID:(NSString *)order
{
    NSMutableArray *ary = [NSMutableArray array];
    [ary addObjectsFromArray:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select * from AllCheck where tableNum = '%@'and orderId='%@' and send='%@'",table,order,@"1"]]];
    return ary;
}
-(NSArray *)AllCheak{
    NSMutableArray *ary = [NSMutableArray array];
    [ary addObjectsFromArray:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select Pcode,PCname,sum(Over),sum(pcount),ISTC from AllCheck where tableNum='%@' AND orderId = '%@' AND Time='%@' AND ISTC='%@' AND Send='%@' GROUP BY Pcode;",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"0",@"1"]]];
    [ary addObjectsFromArray:[BSDataProvider getDataFromSQLByCommand:[NSString stringWithFormat:@"select Pcode,PCname,pcount,ISTC,Over,Tpcode,CNT from AllCheck where tableNum='%@' AND orderId = '%@' AND Time='%@' AND ISTC='%@' AND Send='%@'",[Singleton sharedSingleton].Seat,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Time,@"1",@"1"]]];
    return ary;
}
-(NSString *)UUIDString{
    NSString *uuid = nil;
    //    if ([UIDevice currentDevice].systemVersion.floatValue>=7.0){
    uuid =[OpenUDID value];
    ////        [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
    //    }else{
    //        uuid = [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
    //    }
    return uuid;
}
//登陆
- (NSDictionary *)pLoginUser:(NSDictionary *)info{
    NSString *user,*pwd;
    user = [info objectForKey:@"userCode"];
    pwd = [info objectForKey:@"usePass"];
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@@1.%@&handvId=%@&userCode=%@&userPass=%@",pdaid,versionNum,[self UUIDString],user,pwd];
    NSDictionary *dict = [[self bsService:@"pLoginUser" arg:strParam] objectForKey:@"ns:loginResponse"];
    return dict;
}
//开台
- (NSDictionary *)pStart:(NSDictionary *)info{
    NSString *pdaid,*user,*table,*mancount,*womancounts,*pwd;
    pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    NSDictionary *dict1=[[NSUserDefaults standardUserDefaults] objectForKey:@"UserInfo"];
    user = [dict1 objectForKey:@"name"];
    pwd = [dict1 objectForKey:@"password"];
    if (pwd)
        user = [NSString stringWithFormat:@"%@%@",user,pwd];
    table = [info objectForKey:@"table"];
    //nslog(@"%@",table);
    mancount = [info objectForKey:@"man"];
    womancounts = [info objectForKey:@"woman"];
    
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&tableNum=%@&manCounts=%@&womanCounts=%@&ktKind=%@&openTablemwyn=%@",pdaid,user,table,mancount,womancounts,@"1",[info objectForKey:@"tag"]];
    //nslog(@"%@",strParam);
    NSDictionary *dict = [[self bsService:@"pStart" arg:strParam] objectForKey:@"ns:startcResponse"];
    //nslog(@"%@",dict);
    return dict;
}
-(NSArray *)selectNotice
{
    NSString *sqlcmd = @"select * from notice where ENABLESTATE=2";
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:sqlcmd]];
    return ary;
}

- (NSArray *)getArea{//根据区域区分
    NSString *sqlcmd = @"select * from storearear_mis";
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:sqlcmd]];
    return ary;
}

- (NSArray *)getFloor{//根据楼层区分
    NSString *sqlcmd = @"select * from codedesc where code = 'LC'";
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:sqlcmd]];
    return ary;
}

- (NSArray *)getStatus{//根据状态区分
//    CVLocalizationSetting *langSetting = [CVLocalizationSetting sharedInstance];
//    
//    NSString *langCode = [langSetting localizedString:@"LangCode"];
//    
//    if ([langCode isEqualToString:@"en"])
//        return [NSArray arrayWithObjects:@"Idle",@"Ordered",@"No order",nil];
//    else if ([langCode isEqualToString:@"cn"])
    return [NSArray arrayWithObjects:@"空闲",@"开台未点",@"开台点餐",@"结账",@"已封台",@"换台",@"子台位",@"挂单",@"菜齐",nil];
//    else
//        return [NSArray arrayWithObjects:@"空閒",@"開台點菜",@"開台未點",nil];
    
}

NSInteger intSort2(id num1,id num2,void *context){
    int v1 = [[(NSDictionary *)num1 objectForKey:@"ITCODE"] intValue];
    int v2 = [[(NSDictionary *)num2 objectForKey:@"ITCODE"] intValue];
    
    if (v1 < v2)
        return NSOrderedAscending;
    else if (v1 > v2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}
//查询全部菜品
+ (NSMutableArray *)getFoodList{
    NSString *sqlcmd = [NSString stringWithFormat:@"select * from food"];
    NSMutableArray *ary =[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:sqlcmd]];
    return [NSMutableArray arrayWithArray:[ary sortedArrayUsingFunction:intSort2 context:NULL]];
}

//查套餐明细
-(NSMutableArray *)combo:(NSString *)tag{
    NSString *path1=[NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];
    FMDatabase *db = [[FMDatabase alloc]initWithPath:path1];
    if(![db open])
    {
        return Nil;
    }
    NSString *str=[NSString stringWithFormat:@"SELECT PRODUCTTC_ORDER FROM products_sub WHERE PCODE = '%@' AND defualtS = '0' GROUP BY PRODUCTTC_ORDER",tag];
    NSMutableArray *array=[NSMutableArray arrayWithArray:[BSDataProvider getDataFromSQLByCommand:str]];
    NSString *str2=[NSString stringWithFormat:@"SELECT * from food where itcode='%@'",tag];
    FMResultSet *rs2 = [db executeQuery:str2];
    NSString *PKID,*pcode,*pcname,*TCMONEYMODE;
    while ([rs2 next]){
        PKID=[rs2 stringForColumn:@"item"];
        pcode=[rs2 stringForColumn:@"itcode"];
        pcname=[rs2 stringForColumn:@"DES"];
        TCMONEYMODE=[rs2 stringForColumn:@"TCMONEYMODE"];
    }
    NSMutableArray *array2=[[NSMutableArray alloc] init];
    for(int j=0;j<[array count];j++){
        NSString *str1=[NSString stringWithFormat:@"SELECT * from products_sub where pcode='%@' and producttc_order =%@",tag,[[array objectAtIndex:j] objectForKey:@"PRODUCTTC_ORDER"]];
        FMResultSet *rs1 = [db executeQuery:str1];
        NSMutableArray *array1=[[NSMutableArray alloc] init];
        while([rs1 next]) {
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];;
            //            //food.PKID=PKID;
//            [dict setObject:PKID forKey:@"PKID"];
            [dict setValue:pcode forKey:@"Tpcode"];
            [dict setValue:pcname forKey:@"TPNANE"];
            [dict setValue:[rs1 stringForColumn:@"pcode1"] forKey:@"ITCODE"];
            [dict setValue:[rs1 stringForColumn:@"pname"] forKey:@"DES"];
            [dict setValue:[rs1 stringForColumn:@"unit"] forKey:@"UNIT"];
            [dict setValue:[rs1 stringForColumn:@"price1"] forKey:@"PRICE"];
            [dict setValue:[rs1 stringForColumn:@"CNT"] forKey:@"CNT"];
            [dict setValue:TCMONEYMODE forKey:@"TCMONEYMODE"];
            NSString *str1=[NSString stringWithFormat:@"SELECT UNITCUR,PRICE from food where ITCODE='%@'",[rs1 stringForColumn:@"pcode1"]];
            FMResultSet *rs2 = [db executeQuery:str1];
            while ([rs2 next]) {
                [dict setValue:[rs2 stringForColumn:@"UNITCUR"] forKey:@"Weightflg"];
                if ([TCMONEYMODE intValue]==2) {
                    [dict setValue:[rs2 stringForColumn:@"PRICE"] forKey:@"PRICE"];
                }
            }
            [array1 addObject:dict];
        }
        [array2 addObject:array1];
    }
    [db close];
    return array2;
}
//催菜
- (NSDictionary *)pGogo:(NSArray *)array{
    NSString *user;
    NSString *pdaid = [NSString stringWithFormat:@"%@",[self padID]];
    user = [NSString stringWithFormat:@"%@",[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSMutableString *mutfood = [NSMutableString string];
    for (NSDictionary *info in array) {
        [mutfood appendFormat:@"%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@@%@",[info objectForKey:@"PKID"],[info objectForKey:@"Pcode"],@"",[info objectForKey:@"Tpcode"],@"",[info objectForKey:@"TPNUM"],[info objectForKey:@"pcount"],[info objectForKey:@"promonum"],[info objectForKey:@"fujiacode"],@"",[info objectForKey:@"price"],[info objectForKey:@"fujiaprice"],[info objectForKey:@"Weight"],[info objectForKey:@"Weightflg"],@"",[info objectForKey:@"ISTC"]];
        [mutfood appendString:@";"];
    }
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&orderId=%@&tableNum=%@&productList=%@",pdaid,user,[Singleton sharedSingleton].CheckNum,[Singleton sharedSingleton].Seat,mutfood];
    
    NSDictionary *dict = [self bsService:@"pGogo" arg:strParam];
    return dict;
}
//验证优惠是否可以
-(NSString *)validateCouponCode:(NSDictionary *)info
{
    NSString *vcCode=[[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&userName=%@&token=%@&userEmail=%@",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[info objectForKey:@"USERNAME"],[info objectForKey:@"TOKEN"],[info objectForKey:@"USEREMAIL"]];
    NSDictionary *dict = [self bsService:@"validateCouponCode" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:validateCouponCodeResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }else
    {
        return [NSString stringWithFormat:@"%@",dict];
    }
}
-(NSString *)consumerCouponCode:(NSDictionary *)info
{
    NSString *vcCode=[[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&userName=%@&token=%@&userEmail=%@&voperator=%@",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[info objectForKey:@"USERNAME"],[info objectForKey:@"TOKEN"],[info objectForKey:@"USEREMAIL"],[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
//    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&username=%@&token=&userEmail=",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict = [self bsService:@"consumerCouponCode" arg:strParam];
    if (dict) {
        NSString *result = [[[dict objectForKey:@"ns:consumerCouponCodeResponse"] objectForKey:@"ns:return"] objectForKey:@"text"];
        return result;
    }else
    {
        return [NSString stringWithFormat:@"%@",dict];
    }
}
+(NSArray *)getDataFromSQLByCommand:(NSString *)cmd{
    NSMutableArray *ary = [NSMutableArray array];
    NSString *path = [NSString stringWithFormat:@"%@/Documents/BookSystem.sqlite",NSHomeDirectory()];;
    sqlite3 *db;
    sqlite3_stmt *stat;
    NSString *sqlcmd = cmd;
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
}
-(NSString *)selectSCODE
{
    NSArray *ary=[BSDataProvider getDataFromSQLByCommand:@"select scode from storetables_mis"];
    return [[ary lastObject] objectForKey:@"SCODE"];
}
//检查是否需要更新
-(NSDictionary *)isTypUpdateWebService
{
    NSString *dianPuNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults]setObject:versionNum forKey:@"versionNum"];
    NSString *xmlstr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",versionNum];
    NSString *urlStr=[NSString stringWithFormat:@"isTypUpdateWebService?version=%@&code=%@&typ=IPAD&xmlStr=%@",versionNum,dianPuNum,[xmlstr MD5]];
//    IPADchoicesoft1.3.33.001
//    IPADchoicesoft1.3.33.001
    NSDictionary *dict=[[[BSWebServiceAgent alloc] init] GetDataarg:urlStr];
    return [[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:isTypUpdateWebServiceResponse"] objectForKey:@"return"];
}
//更新内容
-(NSDictionary *)getTypUpdateCont
{
    NSString *dianPuNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults]setObject:versionNum forKey:@"versionNum"];
    NSString *xmlstr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",versionNum];
    NSString *urlStr=[NSString stringWithFormat:@"getTypUpdateCont?version=%@&code=%@&typ=IPAD&xmlStr=%@",versionNum,dianPuNum,[xmlstr MD5]];
    NSDictionary *dict=[[[BSWebServiceAgent alloc] init] GetDataarg:urlStr];
    return [[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:getTypUpdateContResponse"] objectForKey:@"return"];
}
//更新地址
-(NSDictionary *)findVersionPADWebService
{
    NSString *dianPuNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"DianPuId"];
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    [[NSUserDefaults standardUserDefaults]setObject:versionNum forKey:@"versionNum"];
    NSString *xmlstr=[NSString stringWithFormat:@"IPADchoicesoft%@.001",versionNum];
    NSString *urlStr=[NSString stringWithFormat:@"findVersionPADWebService?version=%@&code=%@&typ=IPAD&xmlStr=%@",versionNum,dianPuNum,[xmlstr MD5]];
    NSDictionary *dict=[[[BSWebServiceAgent alloc] init] GetDataarg:urlStr];
    return [[[[dict objectForKey:@"soap:Envelope"] objectForKey:@"soap:Body"] objectForKey:@"ns1:findVersionPADWebServiceResponse"] objectForKey:@"return"];
}
-(NSDictionary *)updataHHT:(NSDictionary *)info
{
//    netAccess.UserId,@"deviceId",netAccess.UserPass,@"userCode",netAccess.dataVersion,@"dataVersion"
    NSString *strParam = [NSString stringWithFormat:@"?&deviceId=%@&userCode=%@&dataVersion=%@",[info objectForKey:@"deviceId"],[info objectForKey:@"userCode"],[info objectForKey:@"dataVersion"]];
    //    NSString *strParam = [NSString stringWithFormat:@"?&type=%@&code=%@&vscode=%@&vsname=&sqnum=%@&username=%@&token=&userEmail=",[info objectForKey:@"CONPONCODE"],[info objectForKey:@"num"],vcCode,[Singleton sharedSingleton].CheckNum,[[Singleton sharedSingleton].userInfo objectForKey:@"user"]];
    NSDictionary *dict = [self bsService:@"updateDataVersion" arg:strParam];
    return dict;

}
@end
