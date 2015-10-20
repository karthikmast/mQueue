//
//  HomeViewController.m
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import "HomeViewController.h"
#import "MyQRViewController.h"
#import "ScanProductsViewController.h"
#import "MyBillViewController.h"
#import <Parse/Parse.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

#pragma mark - VIEW LIFE CYCLE METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userID:(NSString*)userID objectID:(NSString*)objectID  cartID:(NSString*)cartID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.userName = userID;
        self.objID = objectID;
        self.userCart = cartID;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - MY QR CODE
- (IBAction)myQRCodeButtonAction:(id)sender
{
    MyQRViewController *myQRVC = [[MyQRViewController alloc]initWithNibName:@"MyQRViewController" bundle:nil userName:self.userName];
    [self.navigationController pushViewController:myQRVC animated:YES];
    
}

- (IBAction)logOutTapped:(id)sender
{
    PFQuery *query1 = [PFQuery queryWithClassName:@"Carts"];
    [query1 getObjectInBackgroundWithId:self.objID
                                  block:^(PFObject *object, NSError *error) {
                                      // Now let's update it with some new data. In this case, only cheatMode and score
                                      // will get sent to the cloud. playerName hasn't changed.
                                    //  self.userCart = [object valueForKey:@"CartID"];
                                      //NSLog(@"%@",self.userCart);
                                      
                                      [object setObject:@"" forKey:@"TaggedUser"];
                                      // object[@"LoginKey"] = @"LoggedIn";
                                      [object saveInBackground];
                                      
                                  }
     
     ];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)myBillTapped:(id)sender
{
    MyBillViewController *myBil = [[MyBillViewController alloc]initWithNibName:@"MyBillViewController" bundle:nil userName:self.userName ];
    [self.navigationController pushViewController:myBil animated:YES];
}


#pragma mark - READ QR CODE
- (IBAction)scanProductQRButtonAction:(id)sender
{
    ScanProductsViewController *scanQR = [[ScanProductsViewController alloc]initWithNibName:@"ScanProductsViewController" bundle:nil userName:self.userName cartID:self.userCart];
    [self.navigationController pushViewController:scanQR animated:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
