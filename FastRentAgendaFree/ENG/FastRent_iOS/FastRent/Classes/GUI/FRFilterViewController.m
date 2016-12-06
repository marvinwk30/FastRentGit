//
//  FRFilterViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 4/6/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRFilterViewController.h"
#import "FRCustomModalViewController.h"
#import "FRGlobals.h"
#import "FRTaskRemainingViewController.h"
#import "FRBooking.h"
#import "FRFilterInfo.h"
#import "NSDate+FSExtension.h"
#import "FRCommonTableViewCell.h"
#import "FRDateHeader.h"
#import "FRLanguage.h"

typedef enum {
    SectionFilterTypeCheckInDate,
    SectionFilterTypeCheckOutDate,
}   SectionFilterType;

#define FILTER_NUMBER_OF_SECTIONS 4

#define FILTER_DATEPICKER_CHECKIN_HEADER_TAG 1000
#define FILTER_DATEPICKER_CHECKIN_TAG 1001
#define FILTER_DATEPICKER_CHECKOUT_HEADER_TAG 2000
#define FILTER_DATEPICKER_CHECKOUT_TAG 2001

@interface FRFilterViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL bookingStatusShowed;
@property (nonatomic, assign) BOOL checkInDateSelected;
@property (nonatomic, assign) BOOL checkOutDateSelected;

@end

@implementation FRFilterViewController

#pragma mark - View lifecycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (instancetype) init {
    
    if (!(self = [super init]))
        return nil;
    
    _filterInfo = [[FRFilterInfo alloc] init];
    
    [self resetFilter];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (!(self = [super initWithCoder:aDecoder]))
        return nil;
    
    _filterInfo = [[FRFilterInfo alloc] init];
    
    [self resetFilter];
    
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.title = LANG_FILTER_TITLE_TEXT;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(okAction:)];
    right.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItem = right;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_DEFAULT_COLOR;
    
    self.bookingStatusShowed = YES;
    self.checkInDateSelected = NO;
    self.checkOutDateSelected = NO;
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)resetFilter {
    
    self.filterInfo.bookingStatusInfo = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:BookingStatusPrebooking], [NSNumber numberWithInt:BookingStatusConfirmed], [NSNumber numberWithInt:BookingStatusPending], [NSNumber numberWithInt:BookingStatusFinished], nil];
    self.filterInfo.checkInDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_firstDayOfMonth];
    self.filterInfo.checkOutDate = [[NSDate date].fs_dateByIgnoringTimeComponents fs_lastDayOfMonth];
    self.filterInfo.selectedHostings = [FRState getListOfObjets];
    
    FRState *st = [[FRState alloc] init];
    st.stateName = LANG_WITHOUT_HOSTING_TEXT;
    st.stateDBId = 0;
    [self.filterInfo.selectedHostings insertObject:st atIndex:0];
}

- (NSInteger)rowForTag:(NSInteger)tag inSection:(NSInteger)section {
    
    return tag - (section + 1) * 1000;
}

- (void)checkinDateHeaderAction:(FRDateHeader *)sender {
    
    if (sender.tag != FILTER_DATEPICKER_CHECKIN_HEADER_TAG)
        return;
    
    if (self.checkInDateSelected) {
        
        self.checkInDateSelected = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckInDate]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else {
        
        self.checkInDateSelected = YES;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckInDate]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

- (void)checkoutDateHeaderAction:(FRDateHeader *)sender {
    
    if (sender.tag != FILTER_DATEPICKER_CHECKOUT_HEADER_TAG)
        return;
    
    if (self.checkOutDateSelected) {
        
        self.checkOutDateSelected = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckOutDate]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
    else {
        
        self.checkOutDateSelected = YES;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckOutDate]] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}

#pragma mark - Actions

- (void)okAction:(UIBarButtonItem *)sender {
    
    [self.toReturnVC hideAddModalViewControllerAnimated:YES];
}

- (void)backAction:(id)sender {
    
    [self.toReturnVC hideAddModalViewControllerAnimated:YES];
}

- (void)resetFilterAction:(id)sender {
    
    [self resetFilter];
    [self.tableView reloadData];
}

- (void)showHostingsAction:(id)sender {
    
    [self.toReturnVC showHostingsListWithStatesSelected:self.filterInfo.selectedHostings];
}

#pragma mark - FRDatePickerProtocol methods

- (void)datePickerView:(FRDatePickerView *)datePicker didSelectDate:(NSDate *)date {
 
    switch (datePicker.tag) {
        case FILTER_DATEPICKER_CHECKIN_TAG: {
            self.filterInfo.checkInDate = date;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:SectionFilterTypeCheckInDate]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case FILTER_DATEPICKER_CHECKOUT_TAG: {
            self.filterInfo.checkOutDate = date;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:SectionFilterTypeCheckOutDate]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        default:
            break;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return FILTER_NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SectionFilterTypeCheckInDate: {
            return self.checkInDateSelected ? 2 : 1;
            break;
        }
        case SectionFilterTypeCheckOutDate: {
            return self.checkOutDateSelected ? 2 : 1;
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case SectionFilterTypeCheckInDate: {
            if (indexPath.row == 1) {
                return 160.0;
            }
            break;
        }
        case SectionFilterTypeCheckOutDate: {
            if (indexPath.row == 1) {
                return 160.0;
            }
            break;
        }
        default:
            break;
    }
    
    return 52.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SectionFilterTypeCheckInDate: {
            
            switch (indexPath.row) {
                case 0: {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = DEFAULT_DATE_FORMAT;
                    
                    cell = [[FRCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    FRDateHeader *header = (FRDateHeader *)[[[NSBundle mainBundle] loadNibNamed:@"FRDateHeader" owner:self options:nil] objectAtIndex:0];
                    
                    [header setTitle:LANG_FILTER_FROM_TEXT forState:UIControlStateNormal];
                    header.titleLabel.font = TABLEVIEW_DEFAULT_CELL_FONT;
                    [header setTitleColor:TABLEVIEW_DEFAULT_CELL_TEXT_COLOR forState:UIControlStateNormal];
                    header.totalSelectedLbl.text = [df stringFromDate:self.filterInfo.checkInDate];
                    header.totalSelectedLbl.font = [UIFont fontWithName:@"MyriadPro-Bold" size:19];
                    [header addTarget:self action:@selector(checkinDateHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                    header.disclosureImage.image = [UIImage imageNamed:@"BlackDownArrow"];
                    header.tag = FILTER_DATEPICKER_CHECKIN_HEADER_TAG;
                    
                    [cell.contentView addSubview:header];
                    [cell bringSubviewToFront:header];
                    
                    break;
                }
                case  1: {
                    
                    cell = [[FRCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    FRDatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"FRDatePickerView" owner:self options:nil] objectAtIndex:0];
                    datePickerView.tag = FILTER_DATEPICKER_CHECKIN_TAG;
                    datePickerView.datePickerDelegate = self;
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = DEFAULT_DATE_FORMAT;
                    datePickerView.datePicker.date = self.filterInfo.checkInDate;
                    
                    [cell.contentView addSubview:datePickerView];
                    [cell bringSubviewToFront:datePickerView];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case SectionFilterTypeCheckOutDate: {
            switch (indexPath.row) {
                case 0: {
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = DEFAULT_DATE_FORMAT;
                    
                    cell = [[FRCommonTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    
                    FRDateHeader *header = (FRDateHeader *)[[[NSBundle mainBundle] loadNibNamed:@"FRDateHeader" owner:self options:nil] objectAtIndex:0];
                    
                    [header setTitle:LANG_FILTER_TO_TEXT forState:UIControlStateNormal];
                    header.titleLabel.font = TABLEVIEW_DEFAULT_CELL_FONT;
                    [header setTitleColor:TABLEVIEW_DEFAULT_CELL_TEXT_COLOR forState:UIControlStateNormal];
                    header.totalSelectedLbl.text = [df stringFromDate:self.filterInfo.checkOutDate];
                    header.totalSelectedLbl.font = [UIFont fontWithName:@"MyriadPro-Bold" size:19];
                    [header addTarget:self action:@selector(checkoutDateHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                    header.disclosureImage.image = [UIImage imageNamed:@"BlackDownArrow"];
                    header.tag = FILTER_DATEPICKER_CHECKOUT_HEADER_TAG;
                    
                    [cell.contentView addSubview:header];
                    [cell bringSubviewToFront:header];
                    
                    break;
                }
                case  1: {
                    
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    
                    FRDatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"FRDatePickerView" owner:self options:nil] objectAtIndex:0];
                    datePickerView.tag = FILTER_DATEPICKER_CHECKOUT_TAG;
                    datePickerView.datePickerDelegate = self;
                    
                    NSDateFormatter *df = [[NSDateFormatter alloc] init];
                    df.dateFormat = DEFAULT_DATE_FORMAT;
                    datePickerView.datePicker.date = self.filterInfo.checkOutDate;
                    
                    [cell.contentView addSubview:datePickerView];
                    [cell bringSubviewToFront:datePickerView];
                    
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case SectionFilterTypeCheckInDate: {
            if (indexPath.row == 0) {
                
                if (self.checkInDateSelected) {
                    
                    self.checkInDateSelected = NO;
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckInDate]] withRowAnimation:UITableViewRowAnimationMiddle];
                }
                else {
                    
                    self.checkInDateSelected = YES;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckInDate]] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
            break;
        }
        case SectionFilterTypeCheckOutDate: {
            if (indexPath.row == 0) {
                
                if (self.checkOutDateSelected) {
                    
                    self.checkOutDateSelected = NO;
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckOutDate]] withRowAnimation:UITableViewRowAnimationMiddle];
                }
                else {
                    
                    self.checkOutDateSelected = YES;
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:SectionFilterTypeCheckOutDate]] withRowAnimation:UITableViewRowAnimationMiddle];
                }
            }
            break;
        }
        default:
            break;
    }
}

@end
