//
//  LVFmdbTool.m
//  LVDatabaseDemo
//

#import "DeviceModelController.h"
@implementation DeviceModelController
static FMDatabase *_fmdb;



+ (BOOL)createDeviceTable {
    __block BOOL res = NO;
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_deviceinfo(id INTEGER PRIMARY KEY,dm TEXT,os TEXT ,ov TEXT,sh TEXT,sw TEXT,c TEXT ,imei TEXT,uuid TEXT,cpu TEXT,sim TEXT,define TEXT);";
        res = [db executeUpdate:sql];
    }];
    
    if (res) {
        NSLog(@"device create succ");
    }
    return res;
}

+ (BOOL)insertDevice:(DeviceModel *)model{
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_deviceinfo(dm,os, ov,sh,sw,c,imei,uuid,cpu,sim) VALUES ('%@', '%@', '%@','%@','%@','%@','%@','%@','%@','%@');", model.dm,model.os,model.ov,model.sh,model.sw,model.c,model.imei,model.uuid,model.cpu,model.sim];
        res = [db executeUpdate:insertSql];
    }];
    if (res) {
        NSLog(@"device insert succ");
    }
    return res;
}

+ (NSArray *)queryDeviceData{
    NSMutableArray *arrM = [NSMutableArray array];
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *select = @"SELECT * FROM t_deviceinfo;";
        FMResultSet *set = [db executeQuery:select];
        while ([set next]) {
            NSString *dm = [set stringForColumn:@"dm"];
            NSString *os = [set stringForColumn:@"os"];
            NSString *ov = [set stringForColumn:@"ov"];
            NSString *sh = [set stringForColumn:@"sh"];
            NSString *sw = [set stringForColumn:@"sw"];
            NSString *c = [set stringForColumn:@"c"];
            NSString *imei = [set stringForColumn:@"imei"];
            NSString *uuid = [set stringForColumn:@"uuid"];
            NSString *cpu = [set stringForColumn:@"cpu"];
            NSString *sim = [set stringForColumn:@"sim"];

            
            DeviceModel *modal = [[DeviceModel alloc]initWithDevice:dm OS:os osVersion:ov ScreenHeight:sh ScreenWidth:sw Carriers:c Imei:imei Uuid:uuid CpuInfo:cpu SimSn:sim];
            NSDictionary *stuDict = modal.mj_keyValues;
            [arrM addObject:stuDict];
            
        }
    }];
    
    return arrM;
    
}


+ (BOOL)clearDeviceTabData {
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_deviceinfo"];
        res = [db executeUpdate:sql];
    }];
    
    if (res) {
        NSLog(@"clear device tab");
    }
    return res;
}


@end
