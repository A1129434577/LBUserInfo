//
//  LBUserModel+SystemAuth.m
//  LBUserInfoExample
//
//  Created by 刘彬 on 2020/7/7.
//  Copyright © 2020 刘彬. All rights reserved.
//

#import "LBUserModel+SystemAuth.h"

static void (^locationComplete)(BOOL, CLAuthorizationStatus);

@implementation LBUserModel (SystemAuth)
#pragma mark 相机、麦克风权限
+ (void)checkAndRequestMediaAuthTypes:(NSArray<AVMediaType> *)authTypes complete:(void(^)(NSArray<AVMediaType> *notPassedAuthTypes))complete{
    NSMutableArray<AVMediaType> *notPassedAuthTypes = [NSMutableArray array];
    [self requestMediaAuthTypes:authTypes atCheckIndex:0 allRequestComplete:^{
        [authTypes enumerateObjectsUsingBlock:^(AVMediaType  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([AVCaptureDevice authorizationStatusForMediaType:obj] != AVAuthorizationStatusAuthorized) {
                [notPassedAuthTypes addObject:obj];
            }
        }];
        complete?
        complete(notPassedAuthTypes):NULL;
    }];
}

+ (void)requestMediaAuthTypes:(NSArray<AVMediaType> *)authTypes atCheckIndex:(NSUInteger )index allRequestComplete:(void(^)(void))complete{
    __block NSUInteger theIndex = index;
    
    AVMediaType currentCheckType = authTypes[theIndex];
    __block AVAuthorizationStatus auth = [AVCaptureDevice authorizationStatusForMediaType:currentCheckType];
    
    if (auth == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:currentCheckType completionHandler:^(BOOL granted) {
            theIndex ++;
            
            if (theIndex == authTypes.count) {
                complete?
                complete():NULL;
            }else{
                [self requestMediaAuthTypes:authTypes atCheckIndex:theIndex allRequestComplete:complete];
            }
        }];
    }else{
        theIndex ++;
        if (theIndex == authTypes.count) {
            complete?
            complete():NULL;
        }else{
            [self requestMediaAuthTypes:authTypes atCheckIndex:theIndex allRequestComplete:complete];
        }
    }
}

+ (void)checkAndRequestPhotoLibraryAuthComplete:(void (^)(BOOL, PHAuthorizationStatus))complete{
    __block BOOL photoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    
    __block PHAuthorizationStatus auth = [PHPhotoLibrary authorizationStatus];
    
    if (auth == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            complete?
            complete(photoLibraryAvailable,status):NULL;
        }];
    }else{
        complete?
        complete(photoLibraryAvailable,auth):NULL;
    }
}

+ (void)checkAndRequestLocationAlwaysAuth:(BOOL )always complete:(void (^)(BOOL, CLAuthorizationStatus))complete{
    locationComplete = complete;
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = [self shareInstanse];
    
    if (always) {
        [locationManager requestAlwaysAuthorization];
    }else{
        [locationManager requestWhenInUseAuthorization];
    }
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (locationComplete) {
        locationComplete([CLLocationManager locationServicesEnabled],status);
    }
}
@end
