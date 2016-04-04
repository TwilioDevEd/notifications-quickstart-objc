//
//  AppDelegate.m
//  notification
//
//  Created by Siraj Raval on 2/11/16.
//  Copyright © 2016 Twilio. All rights reserved.
//

#import "AppDelegate.h"
@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // Override point for customization after application launch.
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:(UIUserNotificationTypeAlert)
                                                             categories:nil]];
      
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  } else {
    [[UIApplication sharedApplication] registerForRemoteNotifications];
  }
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications setup

- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  [application registerForRemoteNotifications];
}

-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  static dispatch_once_t once;
  // Register the device only once
  dispatch_once(&once,^ {
    self.deviceToken = deviceToken;
    NSLog(@"deviceToken: %@", deviceToken);
  });
}

-(void) application:(UIApplication *) application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo {
  // Present the user with an alert when a notification is received
  UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Notification"
                                                                 message:[userInfo valueForKeyPath:@"aps.alert"]
                                                          preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* okButton = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
  [alert addAction:okButton];

  [self.window.rootViewController presentViewController:alert
                                               animated:YES
                                             completion:nil];
}
@end
