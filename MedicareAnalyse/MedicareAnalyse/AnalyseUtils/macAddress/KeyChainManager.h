//
//  KeyChainManager.h
//  Medicare
//
//  Created by admin on 16/7/19.
//  Copyright © 2016年 medicare. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainManager : NSObject

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end
