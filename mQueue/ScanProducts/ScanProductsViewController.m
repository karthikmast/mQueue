//
//  ScanProductsViewController.m
//  mQueue
//
//  Created by Samuha on 25/09/15.


#import "ScanProductsViewController.h"
#import <Parse/Parse.h>

@interface ScanProductsViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;

-(BOOL)startReading;
-(void)stopReading;
-(void)loadBeepSound;


@end

@implementation ScanProductsViewController

#pragma mark - VIEW LIFE CYCLE METHODS
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName cartID:(NSString*)cartID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.userID = userName;
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
     _imgRedGif.hidden = YES;//Added by athith

    // Do any additional setup after loading the view from its nib.
    self.txtQuantity.keyboardType = UIKeyboardTypeNumberPad;
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    
    
   // NSArray *items = [theString componentsSeparatedByString:@","];
    
  //  [self loadBeepSound]; not required
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    _HUD.square = YES;


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


#pragma mark - Start Stop Action
- (IBAction)startStopButtonAction:(id)sender
{
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
            [_btnStartStop setTitle:@"Stop" forState:UIControlStateNormal];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
       // _lblStatus.text = @"QR Code Reader is not yet running...";
        [self stopReading];
        // The bar button item's title should change again.
        [_btnStartStop setTitle:@"Start!" forState:UIControlStateNormal];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;

}

#pragma mark - CANCEL button Action
- (IBAction)cancelButtonAction:(id)sender {
}


#pragma mark - Private method implementation

- (BOOL)startReading
{
    NSError *error;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    
    // Start video capture.
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
     [_lblStatus setText:@"QR Code Reader is not yet running..."];
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}


#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSLog(@"the metaDataObjects is %@",metadataObjects);
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        NSLog(@"metadataObj is %@",metadataObj);
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            // If the found metadata is equal to the QR code metadata then update the status label's text,
            // stop reading and change the bar button item's title and the flag's value.
            // Everything is done on the main thread.
            //Karthik
            [self performSelectorOnMainThread:@selector(setProductNPriceStringValue:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            NSLog(@"the prductNprice string is %@", self.productNPrice);
            
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
           [self performSelectorOnMainThread:@selector(setButtonTitle) withObject:nil waitUntilDone:NO];
            
            
                        _isReading = NO;
            
            // If the audio player is not nil, then play the sound effect.
//            if (_audioPlayer) {
//                [_audioPlayer play];
//            }
        }
    }
    
    
}

-(void)setProductNPriceStringValue:(NSString *)strValue
{
    self.productNPrice = strValue;
    
    if ([self.productNPrice rangeOfString:@","].location == NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid QR code!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }
    else
    {
        NSLog(@"string contains bla!");
        NSArray *items = [self.productNPrice componentsSeparatedByString:@","];
        NSLog(@"the item array is %@",items);
        self.productDescription.text = [items objectAtIndex:0];
        self.lblPrice.text = [items objectAtIndex:1];
        self.txtQuantity.text = @"1";
        
    }

}

-(void)setButtonTitle
{
     [_btnStartStop setTitle:@"Start!" forState:UIControlStateNormal];
}

#pragma mark - BACK Button Action
- (IBAction)backButtonAction:(id)sender
{
   
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TEXTFIELD DELEGATE METHODS
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    if([textField isEqual:self.txtQuantity])
    {
        if([textField.text isEqualToString:@""])
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"" message:@"Quantity cannot be empty field" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            [textField becomeFirstResponder];
        }
        else
        {
            int tempa = [self.lblPrice.text intValue] * [self.txtQuantity.text intValue];
            self.lblPrice.text = [NSString stringWithFormat:@"%d",tempa ];
        }
    }
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
            self.view.frame  = CGRectMake(0, -130, 320,460);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [UIView animateWithDuration:.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.frame  = CGRectMake(0, -130, 320,460);
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

#pragma mark - SAVE BUTTON METHODS
- (IBAction)saveButtonAction:(id)sender
{
      [_HUD show:YES];
    PFObject *productObject = [PFObject objectWithClassName:@"Bills"];
    [productObject setObject:self.productDescription.text forKey:@"ProductDescription"];
    [productObject setObject:self.userID forKey:@"user"];
    [productObject setObject:self.txtQuantity.text forKey:@"Quantity"];
    [productObject setObject:self.lblPrice.text forKey:@"Price"];
    //3
    [productObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        //4
        if (succeeded){
            //Go back to the wall
            //resetting the field
           
            PFObject *queueObject = [PFObject objectWithClassName:@"ProductsQueue"];
            [queueObject setObject:self.productDescription.text forKey:@"ProductDescription"];
           // [queueObject setObject:self.userID forKey:@"UserId"];
            [queueObject setObject:self.txtQuantity.text forKey:@"ProductsQuantity"];
            [queueObject setObject:self.userCart forKey:@"CartID"];
            self.productDescription.text = @"";
            self.lblPrice.text = @"";
            self.txtQuantity.text = @"";
            
            [queueObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                //4
                if (succeeded)
                {

            self.myAlert = [[UIAlertView alloc]initWithTitle:@"" message:@"Product added to your Kart" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(cancelAlert) userInfo:nil repeats:NO];
            [self.myAlert show];
              [_HUD hide:YES];
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [errorAlertView show];
                    [_HUD hide:YES];
                }
            }];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
             [_HUD hide:YES];
        }
    }];
}

#pragma mark - ALERT DELEGATES
- (void)cancelAlert {

    [self.myAlert dismissWithClickedButtonIndex:-1 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self.myTimer invalidate];
    // Process pressed button
}

@end
