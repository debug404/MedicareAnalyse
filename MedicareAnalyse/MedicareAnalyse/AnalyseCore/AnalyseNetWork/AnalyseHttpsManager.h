 //
//  AnalyseHttpsManager
//  NetWorkDemo
//
//  Created by 洪旺 on 2016/12/6.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success); // 访问成功block

typedef void (^ProgressBlock)(double progress); // 请求进度回调

typedef void (^AFNErrorBlock)(NSError *error); // 访问失败block


@interface AnalyseHttpsManager : NSObject

#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager;
#pragma mark - GET请求
+ (void)getRequest:(NSString *)url  andParams:(NSDictionary *)param ProgressBlock:(ProgressBlock)progress Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;
#pragma mark - POST请求
+ (void)postRequest:(NSString *)url  andParams:(NSDictionary *)param  ProgressBlock:(ProgressBlock)progress Success:(SuccessBlock)success fail:(AFNErrorBlock)fail;
#pragma mark - 下载请求
+ (NSURLSessionDownloadTask *)downLoadWithUrlString:(NSString *)urlString ProgressBlock:(ProgressBlock)progress andParams:(NSDictionary *)param  andFilePath:(NSString *)path Success:(SuccessBlock)success;
#pragma mark - 文件上传请求  (可拓展)
+(void)uploadRequest:(NSString *)userId ProgressBlock:(ProgressBlock)progress andParams:(NSDictionary *)param UrlString:(NSString *)urlString upImg:(UIImage *)upImg;

+(void) setAnalyseBaseUrl:(NSString *) url;


@end
