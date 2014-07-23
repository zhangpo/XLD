//
//  BSDataProvider.h
//  BookSystem
//
//  Created by Dream on 11-3-24.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "AKsNetAccessClass.h"
#import "BSWebServiceAgent.h"
#define kPlistPath      @"ftp://shipader:shipader123@61.174.28.122/BookSystem/BookSystem.sqlite"
#define kPathHeader      @"ftp://ipad:ipad@10.211.55.4/BookSystem/"
#define kSocketServer   @"192.168.1.115:8080"
#define kPDAID          @"8"
#define kDianPuId       @"600000"
#define  TCHAR unsigned char

#define msgSendTab      @"NotificationSendTab"
#define msgQuery        @"NotificationQuery"
#define msgGogo         @"NotifcationGogo"
#define msgChuck        @"NotificationChuck"
#define msgListTable    @"NotificationListTable"
#define msgOpenTable    @"NotificationOpenTable"
#define msgCancelTable  @"NotificationCancelTable"
#define msgPrint        @"NotificationPrint"


#define kBGFileName         @"BackgroundImage.plist"
#define kOrdersFileName     @"Orders.plist"
#define kOrdersCountFileName    @"OrdersCount.plist"
#define kFunctionControlFileName @"FunctionControl.plist"

@interface BSDataProvider : NSObject<NSStreamDelegate,AKsNetAccessClassDelegate>{
    NSMutableData *data;
    
    NSInputStream *iStream;
    NSOutputStream *oStream;
    UIImage *imgBG;
}
-(NSString *)scratch:(NSDictionary *)info andtag:(int)tag;                                  //划菜反划菜
-(NSDictionary *)queryCompletely;                                                           //全单
-(NSArray *)specialremark;                                                                  //全单附加项
-(NSArray *)presentreason;
-(NSArray *)soldOut;                                                                        //估清
-(void)updatecombineTable:(NSDictionary *)dict :(NSString *)cheak;                          //并台更改数据库
-(void)delectcombo:(NSString *)tpcode andNUM:(NSString *)num;                               //删除缓存里的套餐
-(void)delectdish:(NSString *)code;                                                         //单独删除
-(NSString *)UUIDString;                                                                    //物理编号
-(NSArray *)chkCodesql;                                                                     //查询退菜原因
-(void)delectCache;                                                                         //清除缓存
-(void)reserveCache:(NSArray *)ary;                                                         //预定台位存入
-(NSMutableArray *)selectCache;                                                             //查询缓存
-(NSArray *)logout;                                                                         //登出
-(NSString *)registerDeviceId:(NSString *)str;                                              //注册
-(void)cache:(NSArray *)ary;                                                                //缓存
-(NSMutableArray *)queryProduct:(NSString *)seat;                                           //根据台位查账单
-(NSDictionary *)specialRemark:(NSArray *)ary;                                              //全单附加项
-(void)updateChangTable:(NSDictionary *)info :(NSString *)cheak;                            //换台更改数据库
- (NSDictionary *)pListTable:(NSDictionary *)info;                                          //查询台位
-(void)suppProductsFinish;                                                                  //菜齐
-(NSDictionary *)priPrintOrder;                                                             //预打印
-(NSDictionary *)combineTable:(NSDictionary *)info;                                         //并台
-(void)gogoOrderUpData:(NSDictionary *)info;                                                //催菜成功修改数据库
//-(void)gogoOrderUpData:(NSString *)name withCode:(NSString *)code whitTPNUM:(NSString *)tpnum;//催菜成功修改数据库
-(NSDictionary *)changTableState:(NSDictionary *)info;                                      //改变台位状态
-(NSDictionary *)chkCode:(NSArray *)array info:(NSDictionary *)info;                        //退菜
-(NSDictionary *)checkAuth:(NSDictionary *)info;                                            //授权
-(NSString *)scratch:(NSArray *)dish;
-(int)updata:(NSDictionary *)dict withNum:(NSString *)num withOver:(NSString *)over;
+(int)updata:(NSString *)table orderID:(NSString *)order pkid:(NSString *)pkid code:(NSString *)code Over:(NSString *)over;                                                                  //数据库划菜
+(NSArray *)tableNum:(NSString *)table orderID:(NSString *)order;                           //查找本地的发送的菜
-(NSArray *)AllCheak;
-(NSArray *)getOrdersBytabNum1:(NSString *)str;                                             //根据台位号查账单
+ (void)loadConfig;                                                                         //加载配置
+ (void)reloadConfig;                                                                       //重新配置
+ (void)reloadCurrentPageConfig;                                                            //最近的配置
-(NSMutableArray *)combo:(NSString *)tag;                                                   //查套餐明细
+ (NSString *)sqlitePath;                                                                   //数据库的地址
- (NSDictionary *)pStart:(NSDictionary *)info;                                              //开台
- (NSDictionary *)pChangeTable:(NSDictionary *)info;                                        //换台
- (NSDictionary *)pGogo:(NSArray *)array;                                                   //催菜
- (NSArray *)getArea;                                                                       //根据区域分
- (NSArray *)getFloor;                                                                      //根据楼层分
- (NSArray *)getStatus;                                                                     //根据状态分
- (NSDictionary *)checkFoodAvailable:(NSArray *)ary info:(NSDictionary *)info tag:(int)tag; //发送菜
- (NSDictionary *)bsService:(NSString *)api arg:(NSString *)arg;                            //网络请求
- (NSDictionary *)pLoginUser:(NSDictionary *)info;                                          //登陆
-(NSArray *)getClassById;                                                                   //查询菜品分类
- (NSArray *)getAdditions;                                                                  //查数据库里的附加项
+ (NSMutableArray *)getFoodList;                                                            //获得全部的菜品
-(NSArray *)selectNotice;                                                                   //查询通知
-(NSString *)validateCouponCode:(NSDictionary *)info;                                       //验证优惠可用
-(NSString *)consumerCouponCode:(NSDictionary *)info;                                       //优惠券使用
-(NSDictionary *)isTypUpdateWebService;                                                     //检查是否需要更新
-(NSString *)selectSCODE;                                                                   //查询店铺编号
-(NSDictionary *)getTypUpdateCont;                                                          //查询更新内容
-(NSDictionary *)findVersionPADWebService;                                                  //查询下载地址
-(NSDictionary *)updataHHT:(NSDictionary *)info;
+ (BSDataProvider *)sharedInstance;
//
//+ (NSDictionary *)currentOrder;
//+ (void)removeOrderOfName:(NSString *)name;
//+ (void)importOrderOfName:(NSString *)name;
//+ (NSArray *)cachedFoodList;
//+ (BOOL)isCacheNameExist:(NSString *)name;
//+ (void)saveFoods:(NSArray *)foods withName:(NSString *)name;
//- (NSString *)cachedOrder:(NSDictionary *)order;
//
//+ (id)getDataFromSQLByCommand:(NSString *)cmd;
//- (NSArray *)getADNames;
//
//- (void)refreshFiles;
//
//- (void)updateData;
//- (NSDictionary *)dataDict;
//- (void)getCachedFile;
//- (NSMutableArray *)getAllFoods;
//
//- (NSArray *)getAccounts;//
//- (NSArray *)getAllBG;//
//- (NSMutableArray *)getCodeDesc;//
//- (NSArray *)getCovers;//
//- (NSArray *)getCaptions;//获得logo
//
//
//- (UIImage *)backgroundImage;//
//- (void)setBackgroundImage:(NSDictionary *)info;//
//
//
//- (void)orderFood:(NSDictionary *)info;//
//- (NSMutableArray *)orderedFood;//
//- (void)saveOrders;//
//
//
//- (void)writeToServer:(const uint8_t *)buf;//
//
//
//
//- (void)getQueryResult:(NSString *)result;//
//
//- (NSString *)pSendTab:(NSArray *)ary options:(NSDictionary *)info;//
//
//- (NSDictionary *)pQuery:(NSDictionary *)info;//
//
//- (NSDictionary *)pChuck:(NSDictionary *)info;//
//
//- (NSDictionary *)pOver:(NSDictionary *)info;//
//- (NSDictionary *)pPrintQuery:(NSDictionary *)info;//
//- (BOOL)pCommentFood:(NSDictionary *)info;//
//- (NSArray *)pGetFoodComment:(NSDictionary *)info;//
//- (NSString *)pGetFoodVideo:(NSDictionary *)info;
//- (NSDictionary *)pListSubscribeOfTable:(NSDictionary *)info;//
//- (NSArray *)pListResv:(NSDictionary *)info;
//
//
//
//
////List Table
//
//
//
//- (NSString *)bsService_string:(NSString *)api arg:(NSString *)arg;
//
//
//#pragma mark -  Template Functions
//- (NSArray *)pageList;//
//- (NSDictionary *)resourceConfig;//
//- (NSDictionary *)buttonConfig;//
//- (NSDictionary *)foodDetailConfig;//
//- (NSArray *)menuItemList;//
//- (NSUInteger)totalPages;//
//- (NSArray *)foodListForClass:(NSString *)classid;
//- (NSDictionary *)pageInfoAtIndex:(NSUInteger)index;
- (NSArray *)allPages;
//- (NSArray *)allDetailPages;
//- (NSMutableArray *)getClassList;
//
//
//- (NSDictionary *)getFoodByCode:(NSString *)itcode;
//- (NSArray *)pageConfigList;
//- (NSDictionary *)currentPageConfig;
//- (void)updateRecommendList;
////  套餐相关
////- (NSDictionary *)getPackageByID:(NSString *)packageid;
//- (NSDictionary *)getPackageDetail:(NSString *)packageid;
//- (NSArray *)getShiftFood:(NSString *)foodid ofPackage:(NSString *)packageid;

#pragma mark - New Demo
- (NSArray *)topPages;
#pragma mark - 激活
- (BOOL)activated;
@end


/*
 
 char* scCommandWord[22]=
 { 
 {("+login<user:%s;password:%s;>\r\n")}, //0.登陆login
 {("+logout<user:%s;>\r\n")},//1.退出登陆logout
 {("+listtable<user:%s;pdanum:%s;floor:%s;area:%s;status:%s;>\r\n")},// 2.查询桌位list table  
 {("+start<pdaid:%s;user:%s;table:%s;peoplenum:%s;waiter:%s;acct:%s;>\r\n")},//3.开台start
 {("+over<pdaid:%s;user:%s;table:%s;>\r\n")},//4.取消开台
 {("+sendtab<pdaid:%s;user:%s;tabid:%d;acct:%s;tb:%s;usr:%s;pn:%s;foodnum:%d;type:%s;tablist:%s;>\r\n")},//5.发送菜单
 {("+changetable<pdaid:%s;user:%s;oldtable:%s;newtable:%s;>\r\n")},//6.换台changetable
 {("+signteb<pdaid:%s;user:%s;tabto:%s;intotab:%s;type:%s;>\r\n")},//7.标记并单
 {("+query<pdaid:%s;user:%s;table:%s;>\r\n")},//8.查询
 {("+gogo<pdaid:%s;user:%s;tab:%s;foodnum:%s;>\r\n")},//9.催菜
 {("+rebate<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;rebatetype:%s;foodnum:%s;pic:%s;ispic:%d;>\r\n")},//10.打折//fwang modif
 {("+printquery<pdaid:%s;user:%s;tab:%s;type:%s;>\r\n")},//11.打印
 {("+printtab<pdaid:%s;user:%s;tab:%s;>\r\n")},//12.打印
 {("+chuck<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;result:%s;foodnum:%s;>\r\n")}, //13.退菜
 {("+listsubscribetab<pdaid:%s;user:%s;table:%s;>\r\n")}, //14.显示预订单
 {("+entersubscribetab<pdaid:%s;user:%s;tab:%s;num:%s;>\r\n")},  //15.预定单转成正式单
 {("+updata<pdaid:%s;user:%s;updatatype:%s;cls:%s;>\r\n") },//16.更新//fwang modif
 {("+modifyfoodnum<pdaid:%s;user:%s;foodid:%s;newnum:%.2f;oldnum:%.2f;>\r\n") },//17.更改数量
 {("+gototab<pdaid:%s;user:%s;tab:%s;foodnum:%s;>\r\n") },//18.转单  
 {("+set_branch<pdaid:%s;branch:%s;>\r\n") },//19.set branch  
 {("+customer<pdaid:%s;user:%s;tab:%s;data:%s;>\r\n") },//20.customer
 {("+card<pdaid:%s;user:%s;id:%s;pwd:%s;tab:%s;do:%s;vip:%s;vpwd:%s;money:%s;type:%s;>\r\n") }//21.card
 };
 
 */

