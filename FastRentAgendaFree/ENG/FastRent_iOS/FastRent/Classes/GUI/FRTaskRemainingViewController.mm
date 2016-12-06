//
//  FRTaskRemainingViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/25/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRTaskRemainingViewController.h"
#import "FRBookingListTableViewCell.h"
#import "FRLanguage.h"
#import "MainNavigationController.h"
#import "FRAddEditBookingViewController.h"
#import "FRFilterViewController.h"
#import "UIStoryboard+Bundle.h"
#import "FRMyHostingsViewController.h"
#import "FRBooking.h"
#import "FRGlobals.h"
#import "NSDate+FSExtension.h"
#import "FREmptyContentViewController.h"
#import "FRConfigurationManager.h"
#import "FRNotificationManager.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, ModalOperation)
{
    ModalOperationFilter,
    ModalOperationBooking,
};

@interface FRTaskRemainingViewController ()

@property (nonatomic, strong) NSMutableArray<FRBooking *> *tableData;
@property (nonatomic, strong) NSArray<FRBooking *> *filteredTableData;

@property (nonatomic, strong) FREmptyContentViewController *emptyContentVC;
@property (nonatomic, strong) FREmptyContentViewController *empty;
@property (nonatomic, strong) FRAddEditBookingViewController *addEditBookingVC;
@property (nonatomic, strong) FRFilterViewController *filterVC;

@property (nonatomic) BOOL filterShowed;
@property (nonatomic) BOOL addEditBookingShowed;
@property (nonatomic, assign) ModalOperation modalOperation;

@end

@implementation FRTaskRemainingViewController

#pragma mark - View lifecycle

- (instancetype)init {
    
    if (!(self = [super init]))
        return nil;
    
    _tableData = [[NSMutableArray alloc] init];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    _tableData = [[NSMutableArray alloc] init];
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.title = LANG_TITLE_LIST_BOOKING;
    
    UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 100, 40)];
    lbNavTitle.textAlignment = NSTextAlignmentLeft;
    lbNavTitle.text = LANG_TITLE_LIST_BOOKING;
    lbNavTitle.textColor = [UIColor whiteColor];
    lbNavTitle.font = [UIFont fontWithName:@"Roboto-Bold" size:18];
    self.navigationItem.titleView = lbNavTitle;
    
    UIBarButtonItem *search = [[UIBarButtonItem alloc] initWithTitle:LANG_BOOKING_LIST_SEARCH_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(showFilter:)];
    search.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
//    self.navigationItem.leftBarButtonItems = @[left];
    
    UIBarButtonItem *addBookingBtnItem = [[UIBarButtonItem alloc] initWithTitle:LANG_BOOKING_ADD_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(addBooking:)];
    addBookingBtnItem.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItems = @[addBookingBtnItem, search];
    
    self.filterShowed = NO;
    self.addEditBookingShowed = NO;
    
    self.filteredTableData = [NSMutableArray array];
    self.tableData = [FRBooking getListOfObjets];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.tableData = [FRBooking getListOfObjets];
    
    [self filterBookingsData];
    [self.tableView reloadData];
    
    if (self.filteredTableData.count == 0) {
        
        [self.view addSubview:self.emptyContentVC.view];
        ((FREmptyView *)self.emptyContentVC.view).infoLbl.text = LANG_BOOKING_LIST_EMPTY_CONTENT;
    }
    else {
        
        [self.emptyContentVC.view removeFromSuperview];
    }
    
    [self.view addSubview:self.empty.view];
    
    self.empty.closeBtn.hidden = NO;
    ((FREmptyView *)self.empty.view).infoLbl.textColor = [UIColor whiteColor];
    ((FREmptyView *)self.empty.view).infoLbl.textAlignment = NSTextAlignmentLeft;
    self.empty.view.backgroundColor = [UIColor darkGrayColor];
    self.empty.view.alpha = 0.95;
    ((FREmptyView *)self.empty.view).infoLblCenterY = InfoLblCenterYWithNavigationBar;
    ((FREmptyView *)self.empty.view).infoLbl.text = LANG_TASKS_REMAINING_OVERLAY_TEXT
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        CGFloat height = [((FREmptyView *)self.empty.view).infoLbl.text boundingRectWithSize:CGSizeMake(((FREmptyView *)self.empty.view).infoLbl.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:((FREmptyView *)self.empty.view).infoLbl.font} context:nil].size.height;
        ((FREmptyView *)self.empty.view).infoLbl.numberOfLines = (int)ceilf(height/((FREmptyView *)self.empty.view).infoLbl.font.pointSize);
        ((FREmptyView *)self.empty.view).infoLbl.frame = CGRectMake(((FREmptyView *)self.empty.view).infoLbl.frame.origin.x, ([UIScreen mainScreen].bounds.size.height - 20 - height)/2 + 44.0, ((FREmptyView *)self.empty.view).infoLbl.frame.size.width, height);
    }
}

#pragma mark - Getters and Setters

- (FREmptyContentViewController *)empty {
    
    if (_empty == nil) {
        
        _empty = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
    }
    
    return _empty;
}

- (FREmptyContentViewController *)emptyContentVC {
    
    if (_emptyContentVC == nil) {
        
        _emptyContentVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FREmptyContentViewController"];
    }
    
    return _emptyContentVC;
}

- (FRFilterViewController *)filterVC {
    
    if (_filterVC == nil) {
        
        _filterVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"FRFilterViewController"];
        _filterVC.toReturnVC = self;
    }
    
    return _filterVC;
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

- (void)removeBookingWithInfo:(FRBooking *)bookingInfo {
    
    for (FRBooking *booking in self.tableData) {
        
        if (booking.bookingDBId == bookingInfo.bookingDBId) {
            
            [self.tableData removeObject:booking];
            return;
        }
    }
}

- (BOOL)bookingInSelectedHostings:(FRBooking *)booking {
    
    for (FRState *st in self.filterVC.filterInfo.selectedHostings) {
        
        if (st.stateDBId == booking.bookingStateId) {
            
            return YES;
        }
    }
    
    return NO;
}

- (void)filterBookingsData {
    
    NSMutableArray <FRBooking *> *arr = [NSMutableArray array];
    [self.tableData enumerateObjectsUsingBlock:^(FRBooking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.bookingArriveDate compare:self.filterVC.filterInfo.checkInDate] != NSOrderedAscending && [obj.bookingArriveDate compare:self.filterVC.filterInfo.checkOutDate] != NSOrderedDescending) {
            
            [arr addObject:obj];
        }
    }];
    
    self.filteredTableData = [arr sortedArrayUsingComparator:^NSComparisonResult(FRBooking *  _Nonnull obj1, FRBooking *  _Nonnull obj2) {
        
        return [obj1.bookingArriveDate compare:obj2.bookingArriveDate];
        
    }];
}

#pragma mark - Public

- (void)showAddModalViewControllerAnimated:(BOOL)animate {
    
    switch (self.modalOperation) {
        case ModalOperationFilter: {
            
            self.modalVC = self.filterVC;
            [super showAddModalViewControllerAnimated:animate];
            
            if (!self.filterShowed) {
                
                [self.mainNC presentViewController:self.modalNC animated:animate completion:^{
                    
                    self.filterShowed = YES;
                }];
            }
            
            break;
        }
        case ModalOperationBooking: {
            
            self.modalVC = self.addEditBookingVC;
            [super showAddModalViewControllerAnimated:animate];
            
            if (self.addEditBookingShowed)
                return;
            
            [self.mainNC presentViewController:self.modalNC animated:YES completion:nil];
            
            self.addEditBookingShowed = YES;

            break;
        }
        default:
            break;
    }
}

- (void)hideAddModalViewControllerAnimated:(BOOL)animate {
    
    switch (self.modalOperation) {
        case ModalOperationFilter: {
            
            [super hideAddModalViewControllerAnimated:animate];
            
            if (self.filterShowed) {
                
                [self.mainNC dismissViewControllerAnimated:animate completion:^{
                    
                    self.filterShowed = NO;
                    [self.view setNeedsLayout];
                }];
            }
         
            break;
        }
        case ModalOperationBooking: {
            
            [super hideAddModalViewControllerAnimated:animate];
            
            if (!self.addEditBookingShowed)
                return;
            
            [self.mainNC dismissViewControllerAnimated:YES completion:^{
                
                self.addEditBookingShowed = NO;
                self.addEditBookingVC.booking = nil;
            }];
            
            break;
        }
        default:
            break;
    }
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

#pragma mark - Actions

- (void)addBooking:(id)sender {
    
    self.modalOperation = ModalOperationBooking;
    self.addEditBookingVC.checkInDate = [NSDate date];
    [self showAddModalViewControllerAnimated:YES];
}

- (void)showFilter:(id)sender {
    
    self.modalOperation = ModalOperationFilter;
    [self showAddModalViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredTableData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    FRBooking *booking = [self.filteredTableData objectAtIndex:indexPath.row];
    
    // DATE AND NIGHTS INFO
    NSInteger nightsCount = [booking.bookingDepartureDate fs_daysFrom:booking.bookingArriveDate];
    NSString *nightsStr = [NSString stringWithFormat:@"%d %@", nightsCount, nightsCount == 1 ? LANG_BOOKING_NIGHT_TEXT : LANG_BOOKING_NIGHTS_TEXT];
    
    if (booking.bookingDescription == nil || [booking.bookingDescription isEqualToString:@""] || booking.bookingDescription.length == 0) {
        
        ((FRBookingListTableViewCell *)cell).titleLbl.text = LANG_WITHOUT_HOSTING_TEXT;
    }
    else {
        
        ((FRBookingListTableViewCell *)cell).titleLbl.text = booking.bookingDescription;
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = RESUME_DATE_FORMAT;
    
    ((FRBookingListTableViewCell *)cell).descriptionLbl.text = [NSString stringWithFormat:@"%@  al  %@ %@", [df stringFromDate:booking.bookingArriveDate], [df stringFromDate:booking.bookingDepartureDate], [NSString stringWithFormat:@"= $%.2f", booking.bookingTotal]];
    
    ((FRBookingListTableViewCell *)cell).priceLbl.text = nil; //[self notificationMessageForBooking:booking];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    ((FRBookingListTableViewCell *)cell).clientsLbl.attributedText = [[NSAttributedString alloc] initWithString:[booking.bookingClientDescription stringByAppendingFormat:@" / %@", nightsStr]                                                         attributes:underlineAttribute];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    self.addEditBookingVC.booking = [self.filteredTableData objectAtIndex:indexPath.row];
    [self showBookingForEditing];
}

@end
