//
//  MyQRViewController.m
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import "MyQRViewController.h"
#import "UIImage+MDQRCode.h"


@interface MyQRViewController ()

@end

@implementation MyQRViewController

#pragma mark - VIEW LIFE CYCLE METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.qrInput = userName;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //Creating QR code by passing a string object. Pass username or password or any string required here.
    _imgMyQR.contentMode = UIViewContentModeScaleAspectFit;
    _imgMyQR.image = [UIImage mdQRCodeForString:self.qrInput size:_imgMyQR.bounds.size.height fillColor:[UIColor blackColor]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - BACK BUTTON ACTION
- (IBAction)backButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
