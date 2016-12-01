//
//  AppDelegate.h
//  notification
//
//  Created by Siraj Raval on 2/11/16.
//  Copyright © 2016 Twilio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProvisioningProfileInspector.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSData *deviceToken;

@property (nonatomic, assign) APNSEnvironment apnsEnvironment;

@end

