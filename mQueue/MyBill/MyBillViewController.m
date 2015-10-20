//
//  MyBillViewController.m
//  mQueue
//
//  Created by Samuha on 26/09/15.
//

#import "MyBillViewController.h"
#import <Parse/Parse.h>

@interface MyBillViewController ()

@end

@implementation MyBillViewController

#pragma mark - VIEW LIFE CYCLE METHODS

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil userName:(NSString*)userName 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.userID = userName;
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

    _HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    _HUD.square = YES;
    

    [self loadData];
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


#pragma mark - LOAD DATA METHODS
-(void) loadData
{
       [_HUD show:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"Bills"];
    //2
    [query whereKey:@"user" equalTo:self.userID];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        //3
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            objectsArray = nil;
            objectsArray = [[NSMutableArray alloc] initWithArray:objects];
            //[self loadWallViews];
            NSLog(@"%@",[objectsArray valueForKey:@"objectId"]);
    
            [self.billData reloadData];
             [_HUD hide:YES];
        } else {
            
            //4
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
             [_HUD hide:YES];
        }
    }];
}

#pragma mark - TABLE VIEW DELEGATE METHODS
// table view delegates
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    
    UILabel *lblProduct = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 160, 50)];
    lblProduct.text = @"Product";
    lblProduct.backgroundColor = [UIColor clearColor];
    lblProduct.textColor=[UIColor whiteColor];
    
    UILabel *lblQty = [[UILabel alloc]initWithFrame:CGRectMake(170, 0, 40, 50)];
    lblQty.text = @"Qty";
    lblQty.backgroundColor = [UIColor clearColor];
    lblQty.textColor=[UIColor whiteColor];
    
    UILabel *lblPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 80, 50)];
    lblPrice.text = @"Price";
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textColor=[UIColor whiteColor];

    [headerView addSubview:lblProduct];
    [headerView addSubview:lblQty];
    [headerView addSubview:lblPrice];
    headerView.backgroundColor = [UIColor grayColor];
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    if([objectsArray count] > 0)
    {
        UILabel *lblTotal = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 60, 50)];
        lblTotal.text = @"Total";
        lblTotal.backgroundColor = [UIColor clearColor];
        lblTotal.textColor=[UIColor whiteColor];
        
        int total = 0;
        for(int i=0;i<[objectsArray count];i++)
        {
            total = total + [[[objectsArray objectAtIndex:i] valueForKey:@"Price" ] integerValue];
        }
        
        UILabel *lbltotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(215, 0, 80, 50)];
        lbltotalPrice.text = [NSString stringWithFormat:@"%d",total];
        lbltotalPrice.backgroundColor = [UIColor clearColor];
        lbltotalPrice.textColor=[UIColor whiteColor];
        
        [footerView addSubview:lblTotal];
        [footerView addSubview:lbltotalPrice];
        // [headerView addSubview:lblPrice];
        footerView.backgroundColor = [UIColor grayColor];
        
    }
    
    return footerView;
}
//- (int)numberOfSectionsInTableView:(UITableView *) tableView {
//    return 1;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (int) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [objectsArray count];
    
}

-(UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell"];
    
    
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
        NSLog(@"%d",indexPath.row);
        NSLog(@"%f",cell.bounds.origin.x);
        for (int i=0;i<=2;i++)
        {
            UILabel *mView;
            if (i==0)
            {
                mView = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 160, 50)];
                mView.text = [[objectsArray objectAtIndex:indexPath.row]valueForKey:@"ProductDescription"];
                
            }
            else if (i==1)
            {
                mView = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 40, 50)];
                mView.text = [[objectsArray objectAtIndex:indexPath.row]valueForKey:@"Quantity"];
            }
            else if (i==2)
            {
                mView = [[UILabel alloc] initWithFrame:CGRectMake(215, 0, 80, 50)];
                mView.text = [[objectsArray objectAtIndex:indexPath.row]valueForKey:@"Price"];
            }
            mView.backgroundColor= [UIColor clearColor];
            mView.textColor=[UIColor whiteColor];
            [cell addSubview:mView];
        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        PFQuery *query = [PFQuery queryWithClassName:@"Bills"];
        [query whereKey:@"objectId" equalTo:[[objectsArray objectAtIndex:indexPath.row] valueForKey:@"objectId"]];
        
        
      //  [query whereKey:@"objectId" equalTo:[objectsArray valueForKey:@"objectId"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded.
                NSLog(@"Successfully retrieved %d scores.", objects.count);
                // Do something with the found objects
                [PFObject deleteAllInBackground:objects];
            }
            else
            {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        [objectsArray removeObjectAtIndex:indexPath.row];
        [self loadData];

        //add code here for when you hit delete
    }
}

#pragma mark - BACK BUTTON ACTION
- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
