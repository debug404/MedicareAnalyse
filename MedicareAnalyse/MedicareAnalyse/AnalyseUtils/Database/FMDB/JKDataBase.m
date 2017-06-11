//
//  JKDataBase.m
//  ismarter2.0_sz
//
//  Created by zx_04 on 15/6/24.
//
//

#import "JKDataBase.h"
#define LVSQLITE_NAME @"mobileX.sqlite"
@interface JKDataBase ()

@property (nonatomic, retain) FMDatabaseQueue *dbQueue;

@end

@implementation JKDataBase

static JKDataBase *_instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init] ;
    }) ;
    return _instance;
}

- (FMDatabaseQueue *)dbQueue
{
    if (_dbQueue == nil) {
        NSString* docsdir = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *filemanage = [NSFileManager defaultManager];
        docsdir = [docsdir stringByAppendingPathComponent:@"MobileX"];
        BOOL isDir;
        BOOL exit =[filemanage fileExistsAtPath:docsdir isDirectory:&isDir];
        if (!exit || !isDir) {
            [filemanage createDirectoryAtPath:docsdir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString* dbpath = [docsdir stringByAppendingPathComponent:LVSQLITE_NAME];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:dbpath];
    }
    return _dbQueue;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [JKDataBase shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone
{
    return [JKDataBase shareInstance];
}

@end
