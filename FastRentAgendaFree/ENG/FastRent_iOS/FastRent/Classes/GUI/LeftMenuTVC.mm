//
//  LeftMenuTVC.m
//  testProject
//
//  Created by artur on 2/14/14.
//  Copyright (c) 2014 artur. All rights reserved.
//

#import "LeftMenuTVC.h"
#import "MainMenuViewController.h"
#import "FRLanguage.h"
#import "UIStoryboard+Bundle.h"
#import "MainNavigationController.h"

#import "FRCalendarBookingViewController.h"
#import "FRMyHostingsViewController.h"
#import "FRTaskRemainingViewController.h"
#import "FRStatisticsViewController.h"
#import "FRProfileMenuTableViewCell.h"
#import "FRAboutUsViewController.h"
#import "FRNotificationsViewController.h"
#import "FRGlobals.h"
#import "FRAccount.h"
#import "FRImagePool.h"
#import "FRNotificationCount.h"
#import "FRConfigurationManager.h"
#import "FRNotificationManager.h"
#import "FRAddEditOwnerViewController.h"
#import "Utilities.h"

@interface LeftMenuTVC ()

@property (nonatomic, strong) UIViewController *currentVC;
//@property (nonatomic, strong) FRCalendarBookingViewController *calendarBookingVC;
@property (nonatomic, strong) FRMyHostingsViewController *myHostingsVC;
@property (nonatomic, strong) FRTaskRemainingViewController *taskRemainingVC;
@property (nonatomic, strong) FRStatisticsViewController *statisticsVC;
//@property (nonatomic, strong) FROwnersViewController *ownersVC;
//@property (nonatomic, strong) FRNotificationsViewController *notificationsVC;
@property (nonatomic, strong) FRAboutUsViewController *aboutUsVC;
@property (nonatomic, strong) FRAddEditOwnerViewController *addEditOwnerVC;
@property (nonatomic, strong) MainNavigationController *nvc;
@property (nonatomic, readonly) NSInteger selectedIndex;

@end

@implementation LeftMenuTVC

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Initilizing data souce
    self.tableData = [@[@"", LANG_TITLE_CALENDAR_BOOKING, LANG_TITLE_MY_HOSTINGS, LANG_TITLE_LIST_BOOKING, LANG_TITLE_NOTIFICATIONS, LANG_TITLE_REPORTS, LANG_TITLE_ABOUT_US, /*LANG_TITLE_ACCOUNT*/] mutableCopy];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!IS_3_5_INCHES()) {
        
        self.tableView.scrollEnabled = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = NAVIGATIONBAR_DEFAULT_COLOR;
    
//    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
//    NSLog(@"status Bar height:%@", NSStringFromCGRect([UIApplication sharedApplication].statusBarFrame));
//    NSLog(@"view height:%@", NSStringFromCGRect(self.view.frame));
    
//    self.tableView.contentOffset = CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y - 20);
}

#pragma mark - Public

- (void) updateMenuTitles {
    
    [self.tableView reloadData];
}

#pragma mark - Private 

- (FRAboutUsViewController *)aboutUsVC {
 
    if (_aboutUsVC != nil) {
        
        return _aboutUsVC;
    }
    
    _aboutUsVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRAboutUsViewController"];
    
    return _aboutUsVC;
}

- (FRCalendarBookingViewController *)calendarBookingVC {
    
    if (_calendarBookingVC != nil) {
        
        return _calendarBookingVC;
    }
    
    _calendarBookingVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRCalendarBookingViewController"];
    
    return _calendarBookingVC;
}

- (FRMyHostingsViewController *)myHostingsVC {
    
    if (_myHostingsVC != nil) {
        
        return _myHostingsVC;
    }
    
    _myHostingsVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRMyHostingsViewController"];
    
    return _myHostingsVC;
}

- (FRTaskRemainingViewController *)taskRemainingVC {
    
    if (_taskRemainingVC != nil) {
        
        return _taskRemainingVC;
    }
    
    _taskRemainingVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRTaskRemainingViewController"];
    
    return _taskRemainingVC;
}

- (FRNotificationsViewController *)notificationsVC {
    
    if (_notificationsVC != nil) {
        
        return _notificationsVC;
    }
    
    _notificationsVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRNotificationsViewController"];
        
    return _notificationsVC;
}

- (FRStatisticsViewController *)statisticsVC {
    
    if (_statisticsVC != nil) {
        
        return _statisticsVC;
    }
    
    _statisticsVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRStatisticsViewController"];
    
    return _statisticsVC;
}

//- (FROwnersViewController *)ownersVC {
//    
//    if (_ownersVC != nil) {
//        
//        return _ownersVC;
//    }
//    
//    _ownersVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FROwnersViewController"];
//    
//    return _ownersVC;
//}

//- (FRAccountViewController *)accountVC {
//    
//    if (_accountVC != nil) {
//        
//        return _accountVC;
//    }
//    
//    _accountVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRAccountViewController"];
//    
//    return _accountVC;
//}

- (FRAddEditOwnerViewController *)addEditOwnerVC {
    
    if (_addEditOwnerVC == nil) {
        
        _addEditOwnerVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRAddEditOwnerViewController"];
        //_addEditOwnerVC.toReturnVC = self;
    }
    
    return _addEditOwnerVC;
}

- (NSInteger)selectedIndex {
    
    if (self.currentVC == self.taskRemainingVC) {
        return 3;
    }
    if (self.currentVC == self.myHostingsVC) {
        return 2;
    }
    if (self.currentVC == self.calendarBookingVC) {
        return 1;
    }
    if (self.currentVC == self.notificationsVC) {
        return 4;
    }
    if (self.currentVC == self.statisticsVC) {
        return 5;
    }
    if (self.currentVC == self.aboutUsVC) {
        return 6;
    }
    if (self.currentVC == self.addEditOwnerVC) {
        return 0;
    }
    return 0;
}

- (NSString *)imageNameForMenuIndex:(NSInteger)idx {
    
    switch (idx) {
        case 3:
            return @"BookingsMenuIcon";
            break;
        case 2:
            return @"RoomCountIcon";
            break;
        case 1:
            return @"CalendarMenuIcon";
            break;
        case 4:
            return @"InformationMenuIcon"; //CHANGE
            break;
        case 5:
            return @"StatisticsMenuIcon";
            break;
        case 6:
            return @"HelpMenuIcon";
            break;
        case 0:
            return @""; //@"InformationMenuIcon";
            break;
        default:
            break;
    }
    
    return nil;
}

#pragma mark - TableView Datasource

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    NSLog(@"offset:%@", NSStringFromCGPoint(scrollView.contentOffset));
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") || SYSTEM_VERSION_LESS_THAN(@"9.0"))  {
//        
//        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y - 20) animated:NO];
//    }
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, [UIApplication sharedApplication].statusBarFrame.size.height)];
//    
//    [headerView setBackgroundColor:[UIColor clearColor]];
//    
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    CGFloat res = ([UIScreen mainScreen].bounds.size.height - [self tableView:tableView heightForHeaderInSection:0] - [UIApplication sharedApplication].statusBarFrame.size.height) / (CGFloat)self.tableData.count;
//    return (int)res;
    
    if (indexPath.row == 0) {
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"9.0"))  {
            
            return 100.0;
        }
        
        return 114.0;
    }
    
    return 72.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        
        cell = (FRProfileMenuTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRProfileMenuTableViewCell" owner:self options:nil] objectAtIndex:0];
        
        FRAccount *account = [FRAccount getAppAccount];
        
        if (account.accountPicture == nil || account.accountPicture.length == 0) {
            
            ((FRProfileMenuTableViewCell *)cell).accountImageView.image = [UIImage imageNamed:@"UserListIcon"];
        }
        else {
        
            ((FRProfileMenuTableViewCell *)cell).accountImageView.image = [[FRImagePool sharedInstance] getImageNamed:account.accountPicture]?:[UIImage imageNamed:@"UserListIcon"];
        }
        
        ((FRProfileMenuTableViewCell *)cell).accountNameLbl.text = account.accountFullName;
        ((FRProfileMenuTableViewCell *)cell).emailLbl.text = account.accountEmail?:@"";
        
        cell.textLabel.textColor = indexPath.row == self.selectedIndex ? LEFTMENU_SELECTED_TEXT_COLOR: LEFTMENU_DEFAULT_TEXT_COLOR;
        cell.backgroundColor = indexPath.row == self.selectedIndex ? LEFTMENU_SELECTED_COLOR : NAVIGATIONBAR_DEFAULT_COLOR;
        //cell.userInteractionEnabled = NO;
    }
    else {
    
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.textLabel.text = self.tableData[indexPath.row];
        cell.textLabel.font = TABLEVIEW_MENU_CELL_FONT;
//        cell.textLabel.textColor = indexPath.row == self.selectedIndex ? LEFTMENU_SELECTED_TEXT_COLOR: LEFTMENU_DEFAULT_TEXT_COLOR;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.imageView.image = [UIImage imageNamed:[self imageNameForMenuIndex:indexPath.row]];
        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, cell.imageView.frame.size.width * 1.2f, cell.imageView.frame.size.height * 1.2f);
        cell.backgroundColor = indexPath.row == self.selectedIndex ? LEFTMENU_SELECTED_COLOR : NAVIGATIONBAR_DEFAULT_COLOR;
        
        NSInteger i = [FRNotificationManager sharedInstance].notifiedBookings.count;
        if (indexPath.row == 4 && i>0) {

            cell.accessoryView = (FRNotificationCount *)[[[NSBundle mainBundle] loadNibNamed:@"FRNotificationCount" owner:self options:nil] objectAtIndex:0];

            ((FRNotificationCount *)cell.accessoryView).countLbl.text = [NSString stringWithFormat:@"%d", i];
        }
//        else if (indexPath.row == 3) {
//            
//            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 21)];
//            lbl.text = @"Free";
//            lbl.textColor = [UIColor whiteColor];
//            lbl.font = [UIFont systemFontOfSize:18.0];
//            cell.accessoryView = lbl;
//        }
        else {
            cell.accessoryView = nil;
        }
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.nvc = [[MainNavigationController alloc] init];
    
    switch (indexPath.row) {
        
        case 3:
        {
            if (self.currentVC == self.taskRemainingVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.taskRemainingVC;
            self.taskRemainingVC.mainNC = self.nvc;
        
            break;
        }
        case 2:
        {
            if (self.currentVC == self.myHostingsVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.myHostingsVC;
            self.myHostingsVC.mainNC = self.nvc;
        
            break;
        }
        case 1:
        {
            if (self.currentVC == self.calendarBookingVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.calendarBookingVC;
            self.calendarBookingVC.mainNC = self.nvc;
        
            break;
        }
        case 4:
        {
            if (self.currentVC == self.notificationsVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.notificationsVC;
            self.notificationsVC.mainNC = self.nvc;
            
            break;
        }
        case 5:
        {
            if (self.currentVC == self.statisticsVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.statisticsVC;
            self.statisticsVC.mainNC = self.nvc;
            
            break;
        }
        case 6:
        {
            if (self.currentVC == self.aboutUsVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.aboutUsVC;
//            self.ownersVC.mainNC = self.nvc;
        
            break;
        }
        case 0:
        {
            if (self.currentVC == self.addEditOwnerVC) {
                
                [self.mainVC closeLeftMenu];
                return;
            }
            
            self.currentVC = self.addEditOwnerVC;
            self.addEditOwnerVC.account = [FRAccount getAppAccount];
            //self.addEditOwnerVC.mainNC = self.nvc;
        
            break;
        }
        default:
            break;
    }
    
    //nvc = [[MainNavigationController alloc] initWithRootViewController:self.currentVC];
    [self.nvc setViewControllers:@[self.currentVC]];
    
//    if (indexPath.row == 0) {
//        
//        [self.mainVC openLeftMenuAnimated:NO];
//    }
//    else {
    
        [self openContentNavigationController:self.nvc];
//    }
}

@end
