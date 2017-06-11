//
//  NSData+Encryption.h
//  AESDemo
//
//  Created by frog78 on 15/7/30.
//  Copyright (c) 2015年 frog78. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Encryption)

- (NSData *)AES256ParmEncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES256ParmDecryptWithKey:(NSString *)key;   //解密

@end
