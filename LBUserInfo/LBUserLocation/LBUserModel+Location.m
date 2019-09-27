//
//  AppDelegate+Positioning.m
//  MBP_MAPP
//
//  Created by 刘彬 on 16/5/6.
//  Copyright © 2016年 刘彬. All rights reserved.
//

#import "LBUserModel+Location.h"
#import <objc/runtime.h>

static NSString *placemarkKey = @"placemarkKey";
static NSString *getLocationInfoBlockKey = @"getLocationInfoBlockKey";

static CLLocationManager *_locationManager;
@interface LBUserModel ()<CLLocationManagerDelegate>

@end

@implementation LBUserModel (Location)

-(CLPlacemark *)placemark{
    return objc_getAssociatedObject(self, &placemarkKey);
}
-(void)setPlacemark:(CLPlacemark *)placemark{
    objc_setAssociatedObject(self, &placemarkKey, placemark, OBJC_ASSOCIATION_COPY);
}

-(void (^)(CLPlacemark * _Nullable, NSError * _Nullable))getLocationInfoBlock{
    return objc_getAssociatedObject(self, &getLocationInfoBlockKey);
}

-(void)setGetLocationInfoBlock:(void (^)(CLPlacemark * _Nullable, NSError * _Nullable))getLocationInfoBlock{
    objc_setAssociatedObject(self, &getLocationInfoBlockKey, getLocationInfoBlock, OBJC_ASSOCIATION_COPY);
    
    if (_locationManager) {
        [_locationManager startUpdatingLocation];
    }else{
        _locationManager = [[CLLocationManager alloc]init];//初始化一个定位管理对象
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];//申请定位服务权限
        }
        _locationManager.delegate = self;//设置代理
        [_locationManager startUpdatingLocation];//开启定位服务
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [manager stopUpdatingLocation];
    
    typeof(self) __weak weakSelf = self;
    CLLocation *location = [locations firstObject];
    //开始检索定位到的地址
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> *placemarks,NSError *error){
        weakSelf.placemark = placemarks.firstObject;
        weakSelf.getLocationInfoBlock?
        weakSelf.getLocationInfoBlock(weakSelf.placemark,error):NULL;
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.getLocationInfoBlock?
    self.getLocationInfoBlock(self.placemark,error):NULL;
    if (![CLLocationManager locationServicesEnabled]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往设置中心开启定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil] show];
        });
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"请前往设置中心为本应用开启定位服务" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil] show];
        });
    }
}


@end
