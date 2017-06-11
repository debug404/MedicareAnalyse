//
//  LogModel.h
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogModel : NSObject

-(instancetype)initWithDevice:(NSString *)eventid desc:(NSString *)desc date:(long long)date duration:(long long)duration channel:(NSString *)channel eventtype:(NSString *)eventtype extradata:(NSDictionary *)extradata appId:(NSString *)appId deviceId:(NSString *)deviceId appVersion:(NSString *)appVersion networkModel:(int)networkModel locationId:(NSString *)locationId userType:(NSString *)userType ;

/**
 *  eventid	字符串	操作对象
 */
@property (nonatomic, copy) NSString * eventid;

/**
 *  字符串	日志说明
 */
@property (nonatomic, copy) NSString * desc;

/**
 *  date	长整型	日志产生时间
 */
@property (nonatomic, assign) long long  date;

/**
 * 长整型	操作时长
 */
@property (nonatomic, assign) long long duration;

/**
 *  字符串	渠道
 */
@property (nonatomic, copy) NSString *channel;

/**
 *  //eventtype	eventtype	字符串	事件类型（1应用启动，2页面打开，3计数，4计算，5系统日志，6错误日志，7其他日志）
 */
@property (nonatomic, copy) NSString *eventtype;

/**
 *  extradata
 Map对象
 其他日志
 */
@property (nonatomic, copy) NSMutableDictionary *extradata;


/**
 *  appId
 */
@property (nonatomic, copy) NSString *appId;

/**
 *  deviceId
 */
@property (nonatomic, copy) NSString *deviceId;

/**
 *  appVersion
 */
@property (nonatomic, copy) NSString *appVersion;


/**
 *  networkModel 网络类型
 */
@property (nonatomic, assign) int networkModel;


/**
 *  位置地区，可以是地市或者社区
 */
@property (nonatomic, copy) NSString *locationId;

/**
 * 用户类型，1-匿名用户 2-注册用户 3-认证用户
 */
@property (nonatomic, copy) NSString *userType;


@end
