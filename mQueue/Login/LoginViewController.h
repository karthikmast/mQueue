//
//  LoginViewController.h
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *objectsArray;
}
@property (strong, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic)MBProgressHUD  *HUD;
@property(nonatomic,copy) NSString *objectID;
@property(nonatomic,copy) NSString *userCart;

- (IBAction)loginTapped:(id)sender;

- (IBAction)signinTapped:(id)sender;



@end
