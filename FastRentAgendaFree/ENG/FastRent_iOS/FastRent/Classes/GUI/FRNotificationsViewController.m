//
//  FRNotificationsViewController.m
//  FastRent Agenda Free
//
//  Created by Marvin Avila Kotliarov on 10/17/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRNotificationsViewController.h"
#import "FRNotificationManager.h"
#import "FRBookingListTableViewCell.h"
#import "FREmptyContentViewController.h"
#import "FRBooking.h"
#import "FRState.h"
#import "UIStoryboard+Bundle.h"
#import "NSDate+FSExtension.h"
#import "FRGlobals.h"
#import "FRAddEditBookingViewController.h"
#import "MainNavigationController.h"
#import "FRLanguage.h"

@interface FRNotificationsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) __block NSMutableArray<FRBooking *> *tableData;
@property (nonatomic, strong) NSArray *sortedNotifiedBookings;
@property (nonatomic, strong) FREmptyContentViewController *emptyContentVC;
@property (nonatomic, strong) FREmptyContentViewController *empty;
@property (nonatomic, strong) FRAddEditBookingViewController *addEditBookingVC;

@end

@implementation FRNotificationsViewController

#pragma mark - View lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = LANG_TITLE_NOTIFICATIONS;
    
    _tableData = [NSMutableArray array];
    
    [self.tableData removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self reloadInfo];
    
    [self.view addSubview:self.empty.view];
    
    self.empty.closeBtn.hidden = NO;
    ((FREmptyView *)self.empty.view).infoLbl.textColor = [UIColor whiteColor];
    ((FREmptyView *)self.empty.view).infoLbl.textAlignment = NSTextAlignmentLeft;
    self.empty.view.backgroundColor = [UIColor darkGrayColor];
    self.empty.view.alpha = 0.95;
    ((FREmptyView *)self.empty.view).infoLblCenterY = InfoLblCenterYWithNavigationBar;
    ((FREmptyView *)self.empty.view).infoLbl.text = LANG_NOTIFICATIONS_OVERLAY_TEXT
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        CGFloat height = [((FREmptyView *)self.empty.view).infoLbl.text boundingRectWithSize:CGSizeMake(((FREmptyView *)self.empty.view).infoLbl.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:((FREmptyView *)self.empty.view).infoLbl.font} context:nil].size.height;
        ((FREmptyView *)self.empty.view).infoLbl.numberOfLines = (int)ceilf(height/((FREmptyView *)self.empty.view).infoLbl.font.pointSize);
        ((FREmptyView *)self.empty.view).infoLbl.frame = CGRectMake(((FREmptyView *)self.empty.view).infoLbl.frame.origin.x, ([UIScreen mainScreen].bounds.size.height - 20 - height)/2 + 44.0, ((FREmptyView *)self.empty.view).infoLbl.frame.size.width, height);
    }
}

#pragma mark - Getters and Setters

- (FREmptyContentViewController *)emptyContentVC {
    
    if (_emptyContentVC == nil) {
        
        _emptyContentVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
    }
    
    return _emptyContentVC;
}

- (FREmptyContentViewController *)empty {
    
    if (_empty == nil) {
        
        _empty = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
    }
    
    return _empty;
}

- (FRAddEditBookingViewController *)addEditBookingVC {
    
    if (_addEditBookingVC == nil) {
        
        _addEditBookingVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRAddEditBookingViewController"];
        _addEditBookingVC.toReturnVC = self;
        _addEditBookingVC.booking = nil;
    }
    
    return _addEditBookingVC;
}

#pragma mark - Private

- (void)reloadInfo {
    
    [self.tableData removeAllObjects];
    
    UILocalNotification *n;
    
    self.sortedNotifiedBookings = [[FRNotificationManager sharedInstance].notifiedBookings sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSNumber *n1 = [((UILocalNotification *)obj1).userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY];
        FRBooking *b1 = [FRBooking getByField:[FRBooking getColumnIdentifierName] value:n1];
        NSNumber *n2 = [((UILocalNotification *)obj2).userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY];
        FRBooking *b2 = [FRBooking getByField:[FRBooking getColumnIdentifierName] value:n2];
        
        return [b1.bookingArriveDate compare:b2.bookingArriveDate];
        
    }];
    
    for (int i = 0; i< self.sortedNotifiedBookings.count; i++) {
        
        n = [self.sortedNotifiedBookings objectAtIndex:i];
        
        FRBooking *b = [FRBooking getByField:[FRBooking getColumnIdentifierName] value:(NSNumber *)[n.userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY]];
        
        if (b) {
            
            [self.tableData addObject:b];
        }
    }
    
    [self.tableData sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        return [((FRBooking *)obj1).bookingArriveDate compare:((FRBooking *)obj2).bookingArriveDate];
    }];
    
    [self.tableView reloadData];
    
    if (self.tableData.count == 0) {
        
        [self.view addSubview:self.emptyContentVC.view];
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.text = LANG_NOTIFICATION_EMPTY_CONTENT;
        self.emptyContentVC.closeBtn.hidden = YES;
    }
    else {
        
        [self.emptyContentVC.view removeFromSuperview];
    }
}

- (NSString *)notificationMessageForBooking:(FRBooking *)booking {
    
    for (UILocalNotification *n in [FRNotificationManager sharedInstance].notifiedBookings) {
        
        if ([(NSNumber *)[n.userInfo objectForKey:NOTIFICATION_BOOKING_DBID_KEY] integerValue] == booking.bookingDBId) {
            
            return n.alertBody;
        }
    }
    
    return nil;
}

- (void)showBookingForEditing {
    
    [self.mainNC pushViewController:self.addEditBookingVC animated:YES];
}

- (void)hideBookingWhenEditingFinish {
    
    [self.mainNC popToRootViewControllerAnimated:YES];
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(popBookingFinished:) userInfo:nil repeats:NO];
}

- (void)popBookingFinished:(NSTimer *)timer {
    
    self.addEditBookingVC.booking = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    return 105;
    FRBookingListTableViewCell *cell = (FRBookingListTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    float height = [cell.titleLbl.text boundingRectWithSize:CGSizeMake(cell.titleLbl.frame.size.width, cell.titleLbl.frame.size.width) options:NSRegularExpressionCaseInsensitive attributes:@{NSFontAttributeName:cell.titleLbl.font} context:nil].size.height + [cell.descriptionLbl.text boundingRectWithSize:CGSizeMake(cell.descriptionLbl.frame.size.width, cell.descriptionLbl.frame.size.width) options:NSRegularExpressionCaseInsensitive attributes:@{NSFontAttributeName:cell.descriptionLbl.font} context:nil].size.height + [cell.priceLbl.text boundingRectWithSize:CGSizeMake(cell.priceLbl.frame.size.width, cell.priceLbl.frame.size.width) options:NSRegularExpressionCaseInsensitive attributes:@{NSFontAttributeName:cell.priceLbl.font} context:nil].size.height + [cell.clientsLbl.text boundingRectWithSize:CGSizeMake(cell.clientsLbl.frame.size.width, cell.clientsLbl.frame.size.width) options:NSRegularExpressionCaseInsensitive attributes:@{NSFontAttributeName:cell.clientsLbl.font} context:nil].size.height + 32.0;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"BookingListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = (FRBookingListTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRBookingListTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    FRBooking *booking = [self.tableData objectAtIndex:indexPath.row];
    
    // DATE AND NIGHTS INFO
    NSInteger nightsCount = [booking.bookingDepartureDate fs_daysFrom:booking.bookingArriveDate];
    NSString *nightsStr = [NSString stringWithFormat:@"%d %@", (int)nightsCount, nightsCount == 1 ? LANG_BOOKING_NIGHT_TEXT : LANG_BOOKING_NIGHTS_TEXT];
    
    if (booking.bookingDescription == nil || [booking.bookingDescription isEqualToString:@""] || booking.bookingDescription.length == 0) {
        
        ((FRBookingListTableViewCell *)cell).titleLbl.text = LANG_WITHOUT_HOSTING_TEXT;
    }
    else {
        
        ((FRBookingListTableViewCell *)cell).titleLbl.text = booking.bookingDescription;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = RESUME_DATE_FORMAT;
    
    ((FRBookingListTableViewCell *)cell).descriptionLbl.text = [NSString stringWithFormat:@"%@  al  %@ %@", [df stringFromDate:booking.bookingArriveDate], [df stringFromDate:booking.bookingDepartureDate], [NSString stringWithFormat:@"= $%.2f", booking.bookingTotal]];
    
    ((FRBookingListTableViewCell *)cell).priceLbl.text = [self notificationMessageForBooking:booking];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    ((FRBookingListTableViewCell *)cell).clientsLbl.attributedText = [[NSAttributedString alloc] initWithString:[booking.bookingClientDescription stringByAppendingFormat:@" / %@", nightsStr]                                                         attributes:underlineAttribute];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.addEditBookingVC.booking = [self.tableData objectAtIndex:indexPath.row];
    [self showBookingForEditing];
}

@end
