//
//  PhoneUtil.h
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"
@interface PhoneUtil : NSObject

/**
 *  获取手机信息
 */
+ (DeviceModel *)getPhoneModel;

/**
 *  获取手机时间戳
 *
 *  @return
 */
+(NSString *) getTimeStampToString;

/**
 *  获取手机uuid
 *
 *  @return <#return value description#>
 */

+(NSString *) getDeviceUUID;


+ (NSString *)getFakeMacAddress;

/**
 *  获取字符串时间戳
 *
 *  @return 字符串时间戳
 */
+(NSString *)getStringTimeStamp;


/**
 随机生成uuid
 
 @return
 */
+ (NSString *)uuidString;
@end
