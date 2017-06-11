//
//  RSAUtil.h
//  MobileXCoreBusiness
//
//  Created by feiwu on 15/8/3.
//  Copyright (c) 2015年 iflytek. All rights reserved.

// http://www.cnblogs.com/makemelike/articles/3802518.html


#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface RSAUtil : NSObject

#pragma mark - Instance Methods
- (void) loadPublicKeyFromFile: (NSString*) derFilePath;
- (void) loadPublicKeyFromData: (NSData*) derData;

- (void) loadPrivateKeyFromFile: (NSString*) p12FilePath password:(NSString*)p12Password;
- (void) loadPrivateKeyFromData: (NSData*) p12Data password:(NSString*)p12Password;

- (NSString*) rsaEncryptString:(NSString*)string;
- (NSData*) rsaEncryptData:(NSData*)data ;

- (NSString*) rsaDecryptString:(NSString*)string;
- (NSData*) rsaDecryptData:(NSData*)data;

#pragma mark - Class Methods
+ (void) setSharedInstance: (RSAUtil *)instance;
+ (RSAUtil *) sharedInstance;

@end
