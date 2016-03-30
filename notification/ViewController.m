//
//  ViewController.m
//  notification
//
//  Created by Siraj Raval on 2/11/16.
//  Copyright © 2016 Twilio. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *identityField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@end

static NSString * serverURL = @"http://e5d5d81f.ngrok.io/register";

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (IBAction)registerPressed:(id)sender {
  AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
  [self registerDevice:appDelegate.deviceToken identity:self.identityField.text];
}

#pragma mark - Networking

-(void) registerDevice:(NSData *) deviceToken identity:(NSString *) identity {
  // Create a POST request to the /register endpoint with device variables to register for Twilio Notifications
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  NSString * deviceTokenString = [[[[deviceToken description]
                                   stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                   stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];
    
  NSDictionary *params = @{@"identity": identity,
                           @"endpoint": [NSString stringWithFormat:@"%@,%@", identity, deviceTokenString],
                        @"BindingType": @"apn",
                            @"Address": deviceTokenString};
    
  manager.responseSerializer = [AFHTTPResponseSerializer serializer];
  [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
  [manager POST:serverURL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"JSON: %@", responseObject);
  }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

@end
