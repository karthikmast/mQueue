//
//  ScanProductsViewController.h
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"



@interface ScanProductsViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,MBProgressHUDDelegate>
@property (strong, nonatomic) IBOutlet UITextView *productDescription;

@property(nonatomic,copy) NSString *productNPrice;
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *userCart;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UITextField *txtQuantity;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;


@property (nonatomic, strong) UIAlertView *myAlert;
@property (nonatomic, weak) NSTimer *myTimer;

@property (weak, nonatomic) IBOutlet UIButton *btnStartStop;
- (IBAction)startStopButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnSave;
- (IBAction)saveButtonAction:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblStatus;

@property (strong, nonatomic)MBProgressHUD  *HUD;


@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UIImageView *imgRedGif;
- (IBAction)backButtonAction:(id)sender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName cartID:(NSString*)cartID;
@end
