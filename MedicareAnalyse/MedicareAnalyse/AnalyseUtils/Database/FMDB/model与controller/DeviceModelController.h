//
//  LVFmdbTool.h
//  LVDatabaseDemo
//


#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "JKDataBase.h"
#import "DeviceModel.h"
@interface DeviceModelController : NSObject

/*!
 *  创建表
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDeviceTable;
/*!
 *  插入模型数据
 *
 *  @return 是否插入成功
 */
+ (BOOL)insertDevice:(DeviceModel *)model;

/*!
 *  查询数据,如果 传空 默认会查询表中所有数据
 *
 *  @return 返回数据集合
 */
+ (NSArray *)queryDeviceData;
/*!
 *  删除表
 *
 *  @return 是否创建成功
 */
+ (BOOL)clearDeviceTabData;

/*!
 *  根据userid查询所有信息
 *
 *  @return 是否创建成功
 */
+ (DeviceModel *)queryDataModelByAppID:(NSString *)userId;

@end
