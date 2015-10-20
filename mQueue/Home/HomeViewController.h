//
//  HomeViewController.h
//  mQueue
//
//  Created by Samuha on 25/09/15.

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    UIAlertView *logOutAlertView;
}

//QR CODE BUTTON
@property (weak, nonatomic) IBOutlet UIButton *btnMyQRCode;
- (IBAction)myQRCodeButtonAction:(id)sender;
- (IBAction)logOutTapped:(id)sender;
- (IBAction)myBillTapped:(id)sender;

//Scan Product Button
@property (weak, nonatomic) IBOutlet UIButton *btnScanProductQR;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *objID;
@property(nonatomic,copy) NSString *userCart;
- (IBAction)scanProductQRButtonAction:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userID:(NSString*)userID objectID:(NSString*)objectID cartID:(NSString*)cartID;

@end
