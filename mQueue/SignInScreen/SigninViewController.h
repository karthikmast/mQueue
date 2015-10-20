//
//  SigninViewController.h
//  mQueue
//
//  Created by Samuha on 26/09/15.


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SigninViewController : UIViewController <MBProgressHUDDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *userRegisterText;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterText;
@property (nonatomic, strong) IBOutlet UITextField *passwordRegisterReTypeText;

@property (strong, nonatomic)MBProgressHUD  *HUD;

- (IBAction)signinTapped:(id)sender;
- (IBAction)siginBackTapped:(id)sender;
-(BOOL)isValidEmail:(NSString*)txt;

@end
