//
//  LVFmdbTool.h
//  LVDatabaseDemo
//


#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JKDataBase.h"
#import "LogModel.h"
@interface LogModelController : NSObject

/*!
 *  创建表
 *
 *  @return 是否创建成功
 */
+ (BOOL)createLogTable;
/*!
 *  插入模型数据
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertLog:(LogModel *)model;

/*!
 *  查询数据,如果 传空 默认会查询表中所有数据
 *
 *  @return 返回数据集合
 */
+ (NSMutableArray *)queryLogData;
/*!
 *  更具创建时间删除对应的数据
 *
 *  @return 是否创建成功
 */
+ (BOOL)deleteTabByCreateTime:(NSString *)cerateTime;


/*!
 *  根据日志类型查询对应的日志
 *
 */
+ (NSMutableArray *)queryAppOnEventLogData:(NSString *)eventType;

/**
 *  根据事件类型删除对应的记录
 *
 *
 */
+ (BOOL)deleteTabByEventType:(NSString *)eventtype;

/*
* 查询过滤某一个事件类型的日志
*
*/
+ (NSMutableArray *)queryLogDataNoeventtype:(NSString *)type;

/**
 *  根据创建时间修改页面访问时长
 *
 *  @param cerateTime <#cerateTime description#>
 *
 *  @return <#return value description#>
 */
+ (BOOL)updatePageTimebycreateTime:(NSString *)cerateTime andUpdatetime:(NSString *)uptime;

+ (BOOL)deleteTab ;

@end
