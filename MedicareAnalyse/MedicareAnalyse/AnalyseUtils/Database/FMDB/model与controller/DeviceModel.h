//
//  DeviceModel.h
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface DeviceModel : NSObject
/**
 *  dm	device	字符串	手机型号
 */
@property (nonatomic, copy) NSString * dm;

/**
 *  操作系统标识（A安卓，I苹果）
 */
@property (nonatomic, copy) NSString * os;

/**
 * osVersion	字符串	手机系统版本
 */
@property (nonatomic, copy) NSString * ov;

/**
 * screenHeight	字符串	屏幕高度
 */
@property (nonatomic, copy) NSString * sh;

/**
 * screenWidth	字符串	屏幕宽度
 */
@property (nonatomic, copy) NSString * sw;

/**
 * carriers	字符串	运营商（1移动 2联通 3电信 4其他）
 */
@property (nonatomic, copy) NSString * c;

/**
 * imei	字符串	手机唯一码
 */
@property (nonatomic, copy) NSString * imei;

/**
 * 字符串	客户端UUID
 */
@property (nonatomic, copy) NSString * uuid;

/**
 * 字符串	Cpu型号
 */
@property (nonatomic, copy) NSString * cpu;

/**
 *  simSn	字符串	Sim卡编码
 */
@property (nonatomic, copy) NSString * sim;


-(instancetype)initWithDevice:(NSString *)dm OS:(NSString *)os osVersion:(NSString *)ov ScreenHeight:(NSString *)screenHeight ScreenWidth:(NSString *)screenWidth Carriers:(NSString *)carriers Imei:(NSString *)imei Uuid:(NSString *)uuid CpuInfo:(NSString *)cpuInfo SimSn:(NSString *)simSn;

@end
