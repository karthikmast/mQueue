//
//  LoginViewController.m
//  mQueue
//
//  Created by Samuha on 25/09/15.

//

#import "LoginViewController.h"
#import "SigninViewController.h"
#import "HomeViewController.h"
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize userField = _userTextField, passwordField = _passwordTextField;

#pragma mark - VIEW LIFE CYCLE METHODS
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
-(void)viewWillAppear:(BOOL)animated
{
    self.userField.text = @"";
    self.passwordField.text = @"";
}
- (void)viewDidLoad

{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    self.userField = nil;
    self.passwordField = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - TEXTFIELD DELEGATE METHODS

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    // [self.view setFrame:CGRectMake(0,-110,320,460)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
    [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame  = CGRectMake(0, 0, 320,460);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.view.frame  = CGRectMake(0, -110, 320,460);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame  = CGRectMake(0, -110, 320,460);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.view.frame  = CGRectMake(0,0,320,460);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    //[self.view setFrame:CGRectMake(0,0,320,460)];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - LOGIN BUTTON ACTION

- (IBAction)loginTapped:(id)sender
{
    [self.passwordField resignFirstResponder];
    [self.userField resignFirstResponder];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    _HUD.square = YES;
    
    [_HUD show:YES];

    
    [PFUser logInWithUsernameInBackground:self.userField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (user)
        {
            [self checkOperationsTeam];
            //Open the wall
            
            
        }
        else
        {
            //Something bad has ocurred
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            self.userField.text = @"";
            self.passwordField.text = @"";
            [errorAlertView show];
            [_HUD hide:YES];
        }
    }];
    

}

#pragma mark - SIGIN BUTTON ACTION
- (IBAction)signinTapped:(id)sender
{
    SigninViewController *signin = [[SigninViewController alloc]initWithNibName:@"SigninViewController" bundle:nil];
    [self.navigationController pushViewController:signin animated:YES];
    
}

#pragma mark - OPERATIONS TEAM LOGIN CHECK
-(void) checkOperationsTeam
{
    PFQuery *query = [PFUser query];
    [query whereKey:@"EmployeeKey" equalTo:@"operations"];
    [query whereKey:@"LoginKey" equalTo:@"LoggedIn"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error1) {
        //3
        if (!error1)
        {
            //Everything was correct, put the new objects and load
            if([objects count] > 0)
            {
                [self checkCartsAvailable];
                
            }
            else
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Operations Team not logged in. Hence mQ is not available" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                self.userField.text = @"";
                self.passwordField.text = @"";
                [errorAlertView show];
                [_HUD hide:YES];
            }
        }
        else
        {
            //Something bad has ocurred
            NSString *errorString = [[error1 userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            self.userField.text = @"";
            self.passwordField.text = @"";
            [errorAlertView show];
            [_HUD hide:YES];
        }
    }];
}

- (void) checkCartsAvailable
{
    PFQuery *query = [PFQuery queryWithClassName:@"Carts"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error1) {
        //3
        if (!error1)
        {
            int flag = 0, i=0;
            do
            {
                if([[[objects objectAtIndex:i] valueForKey:@"TaggedUser"] isEqualToString:@""])
                {
                    flag = 1;
                    PFObject *obj = [objects objectAtIndex:i];
                    self.objectID = [obj objectId];
                    
                    PFQuery *query1 = [PFQuery queryWithClassName:@"Carts"];
                    [query1 getObjectInBackgroundWithId:self.objectID
                                                 block:^(PFObject *object, NSError *error) {
                                                     // Now let's update it with some new data. In this case, only cheatMode and score
                                                     // will get sent to the cloud. playerName hasn't changed.
                                                     self.userCart = [object valueForKey:@"CartID"];
                                                     NSLog(@"%@",self.userCart);
                                                     
                                                     [object setObject:self.userField.text forKey:@"TaggedUser"];
                                                     // object[@"LoginKey"] = @"LoggedIn";
                                                     [object saveInBackground];
                                                     HomeViewController *homeScreen = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil userID:self.userField.text objectID:self.objectID cartID:self.userCart];
                                                     [self.navigationController pushViewController:homeScreen animated:YES];
                                                     [_HUD hide:YES];

                                                 }
                     
                     ];
                                    }
                i++;
            }while(i<[objects count] && flag == 0);
            if(flag == 0)
            {
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No Carts Available. Please wait for some time"  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                self.userField.text = @"";
                self.passwordField.text = @"";
                [errorAlertView show];
                [_HUD hide:YES];
            }
        } else
            {
                //Something bad has ocurred
                NSString *errorString = [[error1 userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                self.userField.text = @"";
                self.passwordField.text = @"";
                [errorAlertView show];
                [_HUD hide:YES];
            }
        }];
}


@end
