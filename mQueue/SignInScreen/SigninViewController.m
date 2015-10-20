//
//  SigninViewController.m
//  mQueue
//
//  Created by Samuha on 26/09/15.

#import "SigninViewController.h"
#import <Parse/Parse.h>

@interface SigninViewController ()

@end

@implementation SigninViewController

#pragma mark - VIEW LIFE CYCLE METHODS
- (void)viewDidLoad {
    [super viewDidLoad];

    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];

    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    _HUD.square = YES;
    

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - SIGIN BUTTON ACTION
- (IBAction)signinTapped:(id)sender
{
    [_HUD show:YES];

    if([self.userRegisterText.text isEqualToString:@""]||[self.passwordRegisterText.text isEqualToString:@""]||[self.passwordRegisterReTypeText.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Required fields are missing!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        self.userRegisterText.text = @"";
        self.passwordRegisterText.text = @"";
        self.passwordRegisterReTypeText.text = @"";
        [self.userRegisterText becomeFirstResponder];
        [alert show];
      [_HUD hide:YES];
    }
    else if(![self isValidEmail:self.userRegisterText.text])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"User name should be a valid mail ID"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        self.userRegisterText.text = @"";
        self.passwordRegisterText.text = @"";
        self.passwordRegisterReTypeText.text = @"";
        [self.userRegisterText becomeFirstResponder];
        [alert show];
        [_HUD hide:YES];
        
    }
    else if([self.passwordRegisterReTypeText.text isEqualToString:self.passwordRegisterText.text])
    {
            [_HUD show:YES];
        //1
        PFUser *user = [PFUser user];
        //2
        user.username = self.userRegisterText.text;
        user.password = self.passwordRegisterText.text;
        //3
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                //The registration was successful, go to the wall
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"User Registered Successfully!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                alertView.tag = 1;
                [alertView show];
                     [_HUD hide:YES];
                
            } else {
                //Something bad has occurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
                [_HUD hide:YES];
            }
        }];
      [_HUD hide:YES];
    }
    else     {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Passwords does not match!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        self.passwordRegisterText.text = @"";
        self.passwordRegisterReTypeText.text = @"";
        [self.passwordRegisterText becomeFirstResponder];
        [alert show];
       [_HUD hide:YES];
    }

}

#pragma mark - ALERTVIEW DELEGATE
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView tag] == 1) {
        if (buttonIndex == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];

                  }
    }
}

#pragma mark - BACK BUTTON ACTION
- (IBAction)siginBackTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TEXTFIELD METHODS
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isValidEmail:(NSString*)txt
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:txt];
}



@end
