//
//  MyQRViewController.h
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import <UIKit/UIKit.h>

@interface MyQRViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgMyQR;
@property(nonatomic,copy) NSString *qrInput;
- (IBAction)backButtonAction:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName;
@end
