//
//  LogModel.m
//  MobileXCoreBusiness
//
//  Created by 洪旺 on 16/7/7.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "LogModel.h"

@implementation LogModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.eventid = @"";
        self.desc = @"";
        self.channel = @"";
        self.eventtype = @"";
        self.extradata = [[NSDictionary alloc] init];
        self.appId = @"";
        self.deviceId = @"";
        self.appVersion = @"";
        self.locationId = @"";
        self.userType = @"";
    }
    return self;
}



-(instancetype)initWithDevice:(NSString *)eventid desc:(NSString *)desc date:(long long)date duration:(long long)duration channel:(NSString *)channel eventtype:(NSString *)eventtype extradata:(NSDictionary *)extradata appId:(NSString *)appId deviceId:(NSString *)deviceId appVersion:(NSString *)appVersion networkModel:(int)networkModel locationId:(NSString *)locationId userType:(NSString *)userType {
    self = [super init];
    if (self) {
        
        if (!eventid) {
             self.eventid = @"";
        } else {
            self.eventid = eventid;
        }
        self.desc = desc;
        self.date = date;
        self.duration = duration;
        self.channel = channel;
        if (!eventtype) {
            self.eventtype = @"";
        } else {
            self.eventtype = eventtype;
        }
        self.extradata = extradata;
        self.appId = appId;
        self.deviceId = deviceId;
        self.appVersion = appVersion;
        self.networkModel = networkModel;
        self.locationId = locationId;
        self.userType = userType;

    }
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.eventid = [aDecoder decodeObjectForKey:@"eventid"];
        self.desc = [aDecoder decodeObjectForKey:@"desc"];
        self.date = [aDecoder decodeIntegerForKey:@"date"];
        self.duration = [aDecoder decodeIntegerForKey:@"duration"];
        self.channel = [aDecoder decodeObjectForKey:@"channel"];
        self.eventtype=[aDecoder decodeObjectForKey:@"eventtype"];
        self.appId=[aDecoder decodeObjectForKey:@"appId"];
        self.extradata=[aDecoder decodeObjectForKey:@"extradata"];
        self.deviceId=[aDecoder decodeObjectForKey:@"deviceId"];
        self.appVersion=[aDecoder decodeObjectForKey:@"appVersion"];
        self.networkModel=[aDecoder decodeIntForKey:@"networkModel"];
        self.locationId=[aDecoder decodeObjectForKey:@"locationId"];
        self.userType=[aDecoder decodeObjectForKey:@"userType"];
        
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.eventid forKey:@"eventid"];
    [aCoder encodeObject:self.desc forKey:@"desc"];
    [aCoder encodeInteger:self.date forKey:@"date"];
    [aCoder encodeInteger:self.duration forKey:@"duration"];
    [aCoder encodeObject:self.channel forKey:@"channel"];
    [aCoder encodeObject:self.eventtype forKey:@"eventtype"];
    [aCoder encodeObject:self.appId forKey:@"appId"];
    [aCoder encodeObject:self.extradata forKey:@"extradata"];
    [aCoder encodeObject:self.deviceId forKey:@"deviceId"];
    [aCoder encodeObject:self.appVersion forKey:@"appVersion"];
    [aCoder encodeInt:self.networkModel forKey:@"networkModel"];
    [aCoder encodeObject:self.locationId forKey:@"locationId"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
    
}

@end
