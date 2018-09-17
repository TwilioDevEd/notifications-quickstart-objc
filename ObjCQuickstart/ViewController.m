//
//  ViewController.m
//  notification
//
//  Created by Siraj Raval on 2/11/16.
//  Copyright © 2016 Twilio. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *identityField;
@property (strong, nonatomic) IBOutlet UIButton *registerButton;

@end

static NSString *serverURL = @"https://YOUR_SERVER_HERE.twil.io/register-binding";

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
  NSString *deviceTokenString = [[[[deviceToken description]
                                    stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                   stringByReplacingOccurrencesOfString: @">" withString: @""]
                                  stringByReplacingOccurrencesOfString: @" " withString: @""];
  

  NSURLSession *session = [NSURLSession sharedSession];

  NSURL *url = [NSURL URLWithString:serverURL];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
  request.HTTPMethod = @"POST";
  
  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  
    
  NSDictionary *params = @{@"identity": identity,
                           @"endpoint": [NSString stringWithFormat:@"%@,%@", identity, deviceTokenString],
                        @"BindingType": @"apn",
                            @"Address": deviceTokenString};
  
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
  request.HTTPBody = jsonData;
  
  NSString *requestBody = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  NSLog(@"Request: %@", requestBody);

  
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", responseString);
    
    if (error == nil) {
      id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
      NSLog(@"JSON: %@", response);
    } else {
      NSLog(@"Error: %@", error);
    }
  }];
  
  [task resume];

}

@end
