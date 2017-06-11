//
//  AnalyseHttpsManager
//  NetWorkDemo
//
//  Created by 洪旺 on 2016/12/6.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "AnalyseHttpsManager.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "JSONKit.h"
#import "IFlyUserDefaults.h"
#import "MJExtension.h"
#import "AnalyseHttpsManager.h"
#import "AFNetworking.h"


#define kTimeOutInterval 30 // 请求超时的时间

#define ANALYSEBASE_URL @"ANALYSEBASE_URL"

@implementation AnalyseHttpsManager


+ (AFSecurityPolicy*)setSecurityPolicy
{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"analyse" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone  withPinnedCertificates:certSet];
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setPinnedCertificates:certSet];
    return securityPolicy;
}

+(void) setAnalyseBaseUrl:(NSString *) url
{
    [IFlyUserDefault setObject:url forKey:ANALYSEBASE_URL];
}

#pragma mark - 创建请求者
+(AFHTTPSessionManager *)manager
{
    
    AFHTTPSessionManager *manager  = nil;
    
    NSString *baseUrl = [IFlyUserDefault objectForKey:ANALYSEBASE_URL];
    
    NSURL *URL = [NSURL URLWithString:baseUrl];
    
    if (baseUrl == nil || [baseUrl isEqualToString:@""]) {
        
        manager = [[AFHTTPSessionManager manager] init];
        
    }else{
        manager = [[AFHTTPSessionManager manager] initWithBaseURL:URL];
    }

    
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeOutInterval;
    
    // 声明上传的是json格式的参数
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    
    // 声明获取到的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    return manager;
}


/**
 get请求  Method
 @param url URL·
 @param param 参数
 @param success 返回成功状态
 @param fail 返回请求错误状态
 */
+ (void)getRequest:(NSString *)url  andParams:(NSDictionary *)param ProgressBlock:(ProgressBlock)progress Success:(SuccessBlock)success fail:(AFNErrorBlock)fail
{
    @try {
        
        // 创建请求类
        AFHTTPSessionManager *manager = [self manager];
        
        [manager setSecurityPolicy:[self setSecurityPolicy]];
        
        [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
            
            NSLog(@"当前请求的进度:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
            progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 请求成功
            if(responseObject){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                success(dict,YES);
            } else {
                success(@{@"msg":@"暂无数据"}, NO);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            fail(error);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        
    }
}



/**
 post请求
 
 @param url URL
 @param param 参数
 @param success 成功回调
 @param fail 下载失败
 */
+ (void)postRequest:(NSString *)url  andParams:(NSDictionary *)param  ProgressBlock:(ProgressBlock)progress Success:(SuccessBlock)success fail:(AFNErrorBlock)fail
{
    @try {
        // 创建请求类
        AFHTTPSessionManager *manager = [self manager];
        
        [manager setSecurityPolicy:[self setSecurityPolicy]];
        
        [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
            
            NSLog(@"当前请求的进度:%lf", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
            progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (dict == nil) {
                NSString *result = [[NSString alloc] initWithData:responseObject  encoding:NSUTF8StringEncoding];
                success(@{@"msg":result}, YES);
                return ;
            }
            
            // 请求成功
            if(responseObject){
                success(dict,YES);
            } else {
                success(@{@"msg":@"暂无数据"}, NO);
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // 请求失败
            fail(error);
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        
    }
}


/**
 文件下载
 @param urlString URL
 @param path 保存路径
 @param success 成功回调
 @return 句柄
 */
+ (NSURLSessionDownloadTask *)downLoadWithUrlString:(NSString *)urlString ProgressBlock:(ProgressBlock)progress andParams:(NSDictionary *)param  andFilePath:(NSString *)path Success:(SuccessBlock)success
{
    @try {
        // 1.创建管理者对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager setSecurityPolicy:[self setSecurityPolicy]];
        
        // 2.设置请求的URL地址
        NSURL *url = [NSURL URLWithString:urlString];
        // 3.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        // 4.下载任务
        NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            // 下载进度
            NSLog(@"当前下载进度为:%lf", 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            progress(1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            // 下载地址
            NSLog(@"默认下载地址%@",path);
            // 设置下载路径,通过沙盒获取缓存地址,最后返回NSURL对象
            return [NSURL fileURLWithPath:path]; // 返回的是文件存放在本地沙盒的地址
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            // 下载完成调用的方法
            NSLog(@"%@---%@", response, filePath);
            success(@{@"msg":@"1"}, YES);
        }];
        
        //启动下载任务
        [task resume];
        //取消下载任务
        //    [task cancel];
        return task;
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        
    }
    
    
}


/**
 上传文件
 
 @param param 参数
 @param urlString URL
 @param upImg 上传的文件  可以变成文件的url
 */
+(void)uploadRequest:(NSString *)userId ProgressBlock:(ProgressBlock)progress andParams:(NSDictionary *)param UrlString:(NSString *)urlString upImg:(UIImage *)upImg
{
    @try {
        
        // 创建管理者对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // 参数
        [manager POST:urlString parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            /******** 1.上传已经获取到的img *******/
            // 把图片转换成data
            NSData *data = UIImagePNGRepresentation(upImg);
            // 拼接数据到请求题中
            [formData appendPartWithFileData:data name:@"file" fileName:@"123.png" mimeType:@"image/png"];
            /******** 2.通过路径上传沙盒或系统相册里的图片 *****/
            //        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"文件地址"] name:@"file" fileName:@"1234.png" mimeType:@"application/octet-stream" error:nil];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            // 打印上传进度
            NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            progress(1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //请求成功
            NSLog(@"请求成功：%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //请求失败
            NSLog(@"请求失败：%@",error);
        }];
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    } @finally {
        
    }
}


@end
