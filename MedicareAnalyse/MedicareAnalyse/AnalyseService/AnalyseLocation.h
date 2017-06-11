//
//  AnalyseLocation.h
//  MedicareAnalyse
//
//  Created by 洪旺 on 2016/11/24.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^ReturnCityBlock)(NSString *cityName);
typedef void (^ReturnLocationBlock)(CLLocation *location);

@interface AnalyseLocation : NSObject <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *manager;

+ (AnalyseLocation *)sharedAnalyseLocationManager;

@property (nonatomic, copy) ReturnCityBlock returnCityBlock;
@property (nonatomic, copy) ReturnLocationBlock returnLocationBlock;

- (void)returnCity:(ReturnCityBlock)block;


/**
 开始定位
 */
- (void)startLocation;

@end
