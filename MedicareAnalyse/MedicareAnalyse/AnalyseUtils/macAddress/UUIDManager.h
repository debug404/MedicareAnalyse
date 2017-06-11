//
//  UUIDManager.h
//  Medicare
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 medicare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUIDManager : NSObject

+ (void)saveUUID:(NSString *)uuid;

+ (NSString *)getUUID;

+ (void)deleteUUID;

@end
