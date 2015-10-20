//
//  AppDelegate.h
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "HomeViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic)UINavigationController *navigationController;
@property (strong,nonatomic)LoginViewController *loginVC;
@property (strong,nonatomic) HomeViewController *homeVC;


@end

