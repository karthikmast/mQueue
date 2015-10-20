//
//  MyBillViewController.h
//  mQueue
//
//  Created by Samuha on 26/09/15.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MyBillViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *objectsArray;
}
@property (strong, nonatomic) UITableView *billData;
@property(nonatomic,copy) NSString *userID;
@property(nonatomic,copy) NSString *cellIdentifier;

@property (strong, nonatomic)MBProgressHUD  *HUD;

- (IBAction)backButton:(id)sender;

//@property (strong, nonatomic) IBOutlet UICollectionView *billData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName ;



@end
