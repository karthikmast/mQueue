//
//  AppDelegate.m
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import "AppDelegate.h"
#import "LoginViewController.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"TUTYg70FyqbY8TRhXsIShiaTZvQONw5Kkuutypub" clientKey:@"RIvvLSfeq3vBHBWR54Frt0VGGIulTScrJWqOAMQ8"];
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    _navigationController.navigationBarHidden = YES;
    _window.rootViewController = _navigationController;
    [_window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
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
    PFQuery *query1 = [PFQuery queryWithClassName:@"Carts"];
    NSString *currentUser = [[PFUser currentUser] valueForKey:@"username"];
    [query1 getObjectInBackgroundWithId:currentUser
                                  block:^(PFObject *object, NSError *error) {
                                      // Now let's update it with some new data. In this case, only cheatMode and score
                                      // will get sent to the cloud. playerName hasn't changed.
                                      //self.userCart = [object valueForKey:@"CartID"];
                                      //NSLog(@"%@",self.userCart);
                                      
                                      [object setObject:@"" forKey:@"TaggedUser"];
                                      // object[@"LoginKey"] = @"LoggedIn";
                                      [object saveInBackground];
                                      
                                  }
     
     ];

}

@end
