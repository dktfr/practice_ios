//
//  GroupsController.m
//  PracticeProject2
//
//  Created by NHNEnt on 2016. 4. 5..
//  Copyright © 2016년 NHNEnt. All rights reserved.
//

#import "GroupsController.h"
#import "ImageManager.h"
#import "GroupItem.h"
#import "GroupItemCell.h"
#import "PhotoGridController.h"

@interface GroupsController ()

@end

@implementation GroupsController

static NSString * const reuseIdentifier = @"GroupItemCell";

#pragma mark - LifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UINib *cellNib = [UINib nibWithNibName:@"GroupItemCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:reuseIdentifier];
    
    self.title = @"Album";
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(popupCreateAlbumAlert)];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear");
    [self loadGroups];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && ![[self view] window])
    {
        [self setView:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[ImageManager sharedManager] numberOfGroups];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupItemCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    GroupItem *groupItem = [[ImageManager sharedManager].groups objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = groupItem.title;
    cell.numberLabel.text = [NSString stringWithFormat:@"%li", groupItem.numberOfPhoto];
    cell.posterThumbnail.image = groupItem.posterThumbnail;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [ImageManager sharedManager].shouldUpdateAssets = YES;
    PhotoGridController *photoGridController = [[PhotoGridController alloc] init];
    photoGridController.group = [[ImageManager sharedManager].groups objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:photoGridController animated:YES];
}

- (void) loadGroups
{
    [[ImageManager sharedManager] loadGroupUsingCallbackBlock:^{
        NSLog(@"GroupController_loadGroup - group count : %li",[[ImageManager sharedManager].groups count]);
        [self.tableView reloadData];
    } andFailedBlock:^(NSError *error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR!"
                                                        message:@"User denied access"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
}

- (void)popupCreateAlbumAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Create Album"
                                                    message:@"CreateAlbumMessage"
                                                   delegate:self
                                          cancelButtonTitle:@"cancel"
                                          otherButtonTitles:@"ok", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [ImageManager sharedManager].isMyAction = YES;
        UITextField *albumTitleField = [alertView textFieldAtIndex:0];
        NSString *albumTitle = albumTitleField.text;
        [[ImageManager sharedManager] createGroupWithTitle:albumTitle usingCallbackBlock:^{
            [ImageManager sharedManager].isMyAction = NO;
            [self.tableView reloadData];
        }];
    }
}

- (void)invalidateView
{
    NSLog(@"Group List Invalidate View");
    [self loadGroups];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
