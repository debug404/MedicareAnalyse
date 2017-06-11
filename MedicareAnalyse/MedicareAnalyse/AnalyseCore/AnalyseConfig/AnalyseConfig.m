//
//  AnalyseConfig.m
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "AnalyseConfig.h"

@implementation AnalyseConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.uploadStategy = @"";
        self.saveType =  @"";
        self.timeIntervals = @"";
        self.uploadSize =  @"";
        self.userHosCode= @"";
        self.autoLocation= @"";
        self.crashLogEnable= @"";
        self.isOpenAnalyse= @"";
        self.appId= @"";
        self.serverUrl= @"";
        self.userName= @"";
        self.channel= @"";
        self.userPhone= @"";
        self.isSavelog =@"";
        self.deptCode =@"";
        self.deptName =@"";
        self.userTitle =@"";
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.uploadStategy = [aDecoder decodeObjectForKey:@"uploadStategy"];
        self.saveType = [aDecoder decodeObjectForKey:@"saveType"];
        self.timeIntervals = [aDecoder decodeObjectForKey:@"timeIntervals"];
        self.uploadSize = [aDecoder decodeObjectForKey:@"uploadSize"];
        self.userHosCode=[aDecoder decodeObjectForKey:@"userHosCode"];
        self.autoLocation=[aDecoder decodeObjectForKey:@"autoLocation"];
        self.crashLogEnable=[aDecoder decodeObjectForKey:@"crashLogEnable"];
        self.isOpenAnalyse=[aDecoder decodeObjectForKey:@"isOpenAnalyse"];
        self.appId=[aDecoder decodeObjectForKey:@"appId"];
        self.serverUrl=[aDecoder decodeObjectForKey:@"serverUrl"];
        self.userName=[aDecoder decodeObjectForKey:@"userName"];
        self.channel=[aDecoder decodeObjectForKey:@"channel"];
        self.userPhone=[aDecoder decodeObjectForKey:@"userPhone"];
        self.isSavelog=[aDecoder decodeObjectForKey:@"isSavelog"];
        self.deptCode=[aDecoder decodeObjectForKey:@"deptCode"];
        self.deptName=[aDecoder decodeObjectForKey:@"deptName"];
        self.userTitle=[aDecoder decodeObjectForKey:@"userTitle"];
    }
    return self;
}




- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.appId forKey:@"appId"];
    [aCoder encodeObject:self.uploadStategy forKey:@"uploadStategy"];
    [aCoder encodeObject:self.saveType forKey:@"saveType"];
    [aCoder encodeObject:self.timeIntervals forKey:@"timeIntervals"];
    [aCoder encodeObject:self.uploadSize forKey:@"uploadSize"];
    [aCoder encodeObject:self.userHosCode forKey:@"userHosCode"];
    [aCoder encodeObject:self.autoLocation forKey:@"autoLocation"];
    [aCoder encodeObject:self.crashLogEnable forKey:@"crashLogEnable"];
    [aCoder encodeObject:self.isOpenAnalyse forKey:@"isOpenAnalyse"];
    [aCoder encodeObject:self.serverUrl forKey:@"serverUrl"];
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.channel forKey:@"channel"];
    [aCoder encodeObject:self.userPhone forKey:@"userPhone"];
    [aCoder encodeObject:self.isSavelog forKey:@"isSavelog"];
    [aCoder encodeObject:self.deptCode forKey:@"deptCode"];
    [aCoder encodeObject:self.deptName forKey:@"deptName"];
    [aCoder encodeObject:self.userTitle forKey:@"userTitle"];

}

@end
