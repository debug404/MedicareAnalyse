//
//  LVFmdbTool.m
//  LVDatabaseDemo
//

#import "LogModelController.h"
@implementation LogModelController
static FMDatabase *_fmdb;

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

+ (BOOL)createLogTable {
    __block BOOL res = NO;
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS t_loginfo(id INTEGER PRIMARY KEY,eventid TEXT,desc TEXT ,date TEXT,duration TEXT,channel TEXT,eventtype TEXT ,extradata TEXT,appId TEXT,deviceId TEXT,appVersion TEXT,networkModel Integer,locationId TEXT,userType TEXT);";
        res = [db executeUpdate:sql];
    }];
    if (res) {
        NSLog(@"logtable create succ");
    }
    return res;
}

+ (BOOL)insertLog:(LogModel *)model {
    [self createLogTable];
    
    NSNumber *longlongNumber = [NSNumber numberWithLongLong:model.date];
    NSString *date = [longlongNumber stringValue];
    
    NSNumber *longlongduration = [NSNumber numberWithLongLong:model.duration];
    NSString *duration = [longlongduration stringValue];

    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_loginfo(eventid,desc, date,duration,channel,eventtype,extradata,appId,deviceId,appVersion,networkModel,locationId,userType) VALUES ('%@','%@', '%@','%@','%@','%@','%@','%@','%@','%@','%d','%@','%@');",model.eventid,model.desc, date,duration,model.channel,model.eventtype,[self stringToJson:model.extradata
],model.appId,model.deviceId,model.appVersion,model.networkModel,model.locationId,model.userType];
        res = [db executeUpdate:insertSql];
    }];
    if (res) {
        NSLog(@"log insert succ");
    }
    return res;
}


+(NSString *) stringToJson:(id)parameters{
    if (parameters == nil) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSMutableArray *)queryLogData{
    NSMutableArray *arrM = [NSMutableArray array];
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *select = @"SELECT * FROM t_loginfo ORDER BY date ASC";// 查询出来升序处理
        FMResultSet *set = [db executeQuery:select];
        while ([set next]) {
            NSString *eventid = [set stringForColumn:@"eventid"];
            NSString *desc = [set stringForColumn:@"desc"];
            long long date = [[set stringForColumn:@"date"] longLongValue];
            long long duration = [[set stringForColumn:@"duration"] longLongValue];
            NSString *channel = [set stringForColumn:@"channel"];
            NSString *eventtype = [set stringForColumn:@"eventtype"];
            NSDictionary *extradata = [self dictionaryWithJsonString:[set stringForColumn:@"extradata"]];
            NSString *appId = [set stringForColumn:@"appId"];
            NSString *deviceId = [set stringForColumn:@"deviceId"];
            NSString *appVersion = [set stringForColumn:@"appVersion"];
            int networkModel = [[set stringForColumn:@"networkModel"] intValue];
            NSString *locationId = [set stringForColumn:@"locationId"];
            NSString *userType = [set stringForColumn:@"userType"];
          
            LogModel *modal = [[LogModel alloc] initWithDevice:eventid desc:desc date:date duration:duration channel:channel eventtype:eventtype extradata:extradata appId:appId deviceId:deviceId appVersion:appVersion networkModel:networkModel locationId:locationId userType:userType];
            NSDictionary *stuDict = modal.mj_keyValues;
            [arrM addObject:stuDict];

        }
    }];
    return arrM;
}

+ (NSMutableArray *)queryLogDataNoeventtype:(NSString *)type{
    [self createLogTable];
    
    NSMutableArray *arrM = [NSMutableArray array];
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM t_loginfo where eventtype != '%@' ORDER BY date ASC",type];
        FMResultSet *set = [db executeQuery:select];
        while ([set next]) {
            NSString *eventid = [set stringForColumn:@"eventid"];
            NSString *desc = [set stringForColumn:@"desc"];
            long long date = [[set stringForColumn:@"date"] longLongValue];
            long long duration = [[set stringForColumn:@"duration"] longLongValue];
            NSString *channel = [set stringForColumn:@"channel"];
            NSString *eventtype = [set stringForColumn:@"eventtype"];
            NSDictionary *extradata = [self dictionaryWithJsonString:[set stringForColumn:@"extradata"]];
            NSString *appId = [set stringForColumn:@"appId"];
            NSString *deviceId = [set stringForColumn:@"deviceId"];
            NSString *appVersion = [set stringForColumn:@"appVersion"];
            int networkModel = [[set stringForColumn:@"networkModel"] intValue];
            NSString *locationId = [set stringForColumn:@"locationId"];
            NSString *userType = [set stringForColumn:@"userType"];
            
            LogModel *modal = [[LogModel alloc] initWithDevice:eventid desc:desc date:date duration:duration channel:channel eventtype:eventtype extradata:extradata appId:appId deviceId:deviceId appVersion:appVersion networkModel:networkModel locationId:locationId userType:userType];
            NSDictionary *stuDict = modal.mj_keyValues;
            [arrM addObject:stuDict];
            
        }
    }];
    return arrM;
}


+ (NSMutableArray *)queryAppOnEventLogData:(NSString *)eventType{
    NSMutableArray *arrM = [NSMutableArray array];
    JKDataBase *jkDB = [JKDataBase shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *select = [NSString stringWithFormat:@"SELECT * FROM t_loginfo where eventtype = '%@'",eventType];

        FMResultSet *set = [db executeQuery:select];
        while ([set next]) {
            NSString *eventid = [set stringForColumn:@"eventid"];
            NSString *desc = [set stringForColumn:@"desc"];
            long long date = [[set stringForColumn:@"date"] longLongValue];
            long long duration = [[set stringForColumn:@"duration"] longLongValue];
            NSString *channel = [set stringForColumn:@"channel"];
            NSString *eventtype = [set stringForColumn:@"eventtype"];
            NSDictionary *extradata = [self dictionaryWithJsonString:[set stringForColumn:@"extradata"]];
            NSString *appId = [set stringForColumn:@"appId"];
            NSString *deviceId = [set stringForColumn:@"deviceId"];
            NSString *appVersion = [set stringForColumn:@"appVersion"];
            int networkModel = [[set stringForColumn:@"networkModel"] intValue];
            NSString *locationId = [set stringForColumn:@"locationId"];
            NSString *userType = [set stringForColumn:@"userType"];
            
            LogModel *modal = [[LogModel alloc] initWithDevice:eventid desc:desc date:date duration:duration channel:channel eventtype:eventtype extradata:extradata appId:appId deviceId:deviceId appVersion:appVersion networkModel:networkModel locationId:locationId userType:userType];
            NSDictionary *stuDict = modal.mj_keyValues;
            [arrM addObject:stuDict];
            
        }
    }];
    return arrM;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSDictionary *dic  = [[NSDictionary alloc] init];
        return dic;
    }
    return dic;
}


/**
 *  根据创建时间修改页面访问时长
 *
 *  @param cerateTime <#cerateTime description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)updatePageTimebycreateTime:(NSString *)cerateTime andUpdatetime:(NSString *)uptime {
    if (cerateTime == nil) {
        return NO;
    }
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"update t_loginfo set name = '%@' where duration = %@", cerateTime,uptime];
        res = [db executeUpdate:sql];
    }];
    if (res) {
        NSLog(@"clear log tab time");
    }
    return res;
}


/**
 *  根据生成时间删除对应的记录
 *
 *  @param cerateTime <#cerateTime description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteTabByCreateTime:(NSString *)cerateTime {
    if (cerateTime == nil) {
        return NO;
    }
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_loginfo where date = '%@'",cerateTime];
        res = [db executeUpdate:sql];
    }];
    if (res) {
        NSLog(@"clear log tab time");
    }
    return res;
}


/**
 *  根据事件类型删除对应的记录
 *
 *
 */
+ (BOOL)deleteTabByEventType:(NSString *)eventtype {
    if (eventtype == nil) {
        return NO;
    }
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_loginfo where eventtype = '%@'",eventtype];
        res = [db executeUpdate:sql];
    }];
    if (res) {
        NSLog(@"clear log tab eventtype");
    }
    return res;
}


/**
 *  根据生成时间删除对应的记录
 *
 *  @param cerateTime <#cerateTime description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)deleteTab {
    JKDataBase *jkDB = [JKDataBase shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_loginfo"];
        res = [db executeUpdate:sql];
    }];
   
    return res;
}

@end
