//
//  AnalyseLocation.m
//  MedicareAnalyse
//[self.extedata setObject:[IFlyUserDefault objectForKey:DOC_PHONE] forKey:@"tele"];
//[self.extedata setObject:cityName forKey:@"city"];
//[IFlyUserDefault setObject:self.extedata forKey:LOG_EXTRADATA];
//  Created by 洪旺 on 2016/11/24.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "AnalyseLocation.h"

@implementation AnalyseLocation



+ (AnalyseLocation *)sharedAnalyseLocationManager
{
    static AnalyseLocation *sharedAnalyseLocationInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAnalyseLocationInstance = [[self alloc] init];
    });
    return sharedAnalyseLocationInstance;
}



-(CLLocationManager *)manager{
    if (_manager == nil) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
    }
    return _manager;
}


- (void)startLocation{
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        self.manager.desiredAccuracy=kCLLocationAccuracyBest;
        self.manager.distanceFilter=1000;
        if (self.manager.delegate == nil) {
            self.manager.delegate = self;
        }
        
        [self.manager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        [self.manager startUpdatingLocation];//开启定位
        
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)returnCity:(ReturnCityBlock)block{
    self.returnCityBlock = block;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *loc = [locations firstObject];
    if (loc.horizontalAccuracy > 0) {//已经定位成功了
        [self.manager stopUpdatingLocation];
        [self.manager setDelegate:nil];
        
        if (self.returnLocationBlock) {
            self.returnLocationBlock(loc);
        }
        // 获取当前所在的城市名
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        //根据经纬度反向地理编译出地址信息
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *array, NSError *error)
         {
             if (array.count > 0)
             {
                 CLPlacemark *placemark = [array objectAtIndex:0];
                 //NSLog(@%@,placemark.name);//具体位置
                 //获取城市
                 NSString *city = placemark.locality;
                 if (!city) {
                     //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                     city = placemark.administrativeArea;
                 }
                 
                 if (self.returnCityBlock != nil) {
                     self.returnCityBlock(city);
                 }
                 
                 NSLog(@"定位完成:%@",city);
                 //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             }else if (error == nil && [array count] == 0)
             {
                 NSLog(@"No results were returned.");
             }else if (error != nil)
             {
                 NSLog(@"An error occurred = %@", error);
             }
         }];
        
        [self.manager stopUpdatingLocation];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    if (self.returnCityBlock != nil) {
        self.returnCityBlock(@"");
    }
}




@end
