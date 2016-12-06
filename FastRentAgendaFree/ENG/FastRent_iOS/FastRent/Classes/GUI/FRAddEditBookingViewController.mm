//
//  FRAddEditBookingViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 1/30/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRAddEditBookingViewController.h"
#import "FRCalendarBookingViewController.h"
#import "FRTaskRemainingViewController.h"
#import "FRDateHeader.h"
#import "FRGlobals.h"
#import "FRCommonEditTableViewCell.h"
#import "FRCustomModalViewController.h"
#import "FRState.h"
#import "FRBooking.h"
#import "Types.h"
#import "NSDate+FSExtension.h"
#import "FRCommonTableViewCell.h"
#import "NSString+FRFormatterPunctuation.h"
#import "FRLanguage.h"
#import "FRConfigurationManager.h"
#import "FRNotificationManager.h"
#import "AppDelegate.h"
#import "FSCalendar.h"

typedef enum {
    SectionTypeBookingDate,
    SectionTypeBookingDescription,
    SectionTypeBookingClient,
    SectionTypeBookingPrice,
    SectionTypeBookingExtras,
    SectionTypeBookingDelete,
}SectionType;

typedef enum {
    kCheckOutStatusNone,
    kCheckOutStatusInsertDelete,
    kCheckOutStatusHeaderUpdate,
}CheckOutStatus;

#define TABLE_DATA_KEY(A_TAG) [NSString stringWithFormat:@"%d", (int)A_TAG]

#define DATEPICKER_CHECKIN_HEADER_TAG 1001
#define DATEPICKER_CHECKIN_DATE_TAG 1002
#define DATEPICKER_CHECKOUT_HEADER_TAG 1003
#define DATEPICKER_CHECKOUT_DATE_TAG 1004

#define HOSTING_DESCRIPTION_TAG 2000

#define CLIENT_EDIT_TAG 3000

#define PRICE_DAYS_COUNT_TAG 4001
#define PRICE_EDIT_TAG 4002

#define EXTRA_INFO_INCOMES_EDIT_TAG 5001
#define EXTRA_INFO_INCOMES_PRICE_TAG 5002

#define NUMBER_OF_SECTIONS 6

NSString* const BookingErrorDomain = @"ValidateBookingErrorDomain";

@interface FRAddEditBookingViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableDictionary *tableData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property (nonatomic, assign) BOOL checkInDateSelected;
@property (nonatomic, assign) BOOL keyboardShowed;
@property (nonatomic, assign) CheckOutStatus checkOutStatus;
@property (nonatomic, strong) NSIndexPath *idxPathForEditSelected;

@property (nonatomic, assign) BOOL okActionPressed;

@property (nonatomic, strong) NSMutableArray<FRBooking *> *bookingsData;
@property (nonatomic, strong) FSCalendar *calendar;

@end

@implementation FRAddEditBookingViewController

#pragma mark - View lifecycle

- (void)awakeFromNib {
    
    self.checkInDate = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.tableData = [NSMutableDictionary dictionary];
    
    self.calendar = [[FSCalendar alloc] init];
    
    self.idxPathForEditSelected = nil;
    self.keyboardShowed = NO;
    
    // Register notification when the keyboard will be show
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // Register notification when the keyboard will be hide
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.title = LANG_BOOKING_DETAIL_TITLE;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(okAction:)];
    right.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItem = right;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    left.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableViewHeight.constant = [UIScreen mainScreen].bounds.size.height;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_DEFAULT_COLOR;
    
    self.okActionPressed = NO;
    self.checkInDateSelected = NO;
    self.checkOutStatus = kCheckOutStatusNone;
    
    if (self.booking != nil) {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = DEFAULT_DATE_FORMAT;
        if (![self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]) {
            
            [self.tableData setObject:[df stringFromDate:self.booking.bookingArriveDate] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)];
        }
        if (![self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]) {
            
            [self.tableData setObject:[df stringFromDate:self.booking.bookingDepartureDate] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
        }
        
        if (![self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)]) {
            
            if (self.booking.bookingDescription != nil && self.booking.bookingDescription.length > 0) {
                
                [self.tableData setObject:self.booking.bookingDescription forKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)];
            }
        }

//        self.addEditBookingStatus = kAddEditBookingStatusEdit;
        
        if (![self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)]) {
        
            [self.tableData setObject:self.booking.bookingClientDescription forKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)];
        }
        
        if (![self.tableData objectForKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)]) {
         
            if (self.booking.bookingPrice != nil) {
                
                [self.tableData setObject:self.booking.bookingPrice forKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)];
            }
        }
        
        if (![self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)]) {
            
            if (self.booking.bookingExtraIncomeDescription != nil && self.booking.bookingExtraIncomeDescription.length > 0 && ![self.booking.bookingExtraIncomeDescription isEqualToString:@""]) {
                
                [self.tableData setObject:self.booking.bookingExtraIncomeDescription forKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)];
            }
        }
        
        if (![self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)]) {
            
            if (self.booking.bookingExtraIncome != nil) {
                
                [self.tableData setObject:self.booking.bookingExtraIncome forKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)];
            }
        }
    }
    else {
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = DEFAULT_DATE_FORMAT;
        
        if (self.checkInDate) {
    
            [self.tableData setObject:[df stringFromDate:self.checkInDate] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)];
            
            if (![self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]) {
            
                //[self.tableData setObject:[df stringFromDate:[self.checkInDate.fs_dateByIgnoringTimeComponents fs_dateByAddingDays:1]] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
                [self.tableData setObject:[df stringFromDate:[self.calendar dateByAddingDays:1 toDate:self.checkInDate]] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
            }
        }
        else if (![self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]) {
            
            [self.tableData setObject:[df stringFromDate:[NSDate date].fs_dateByIgnoringTimeComponents] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)];
        }
        if (![self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]) {
            
            [self.tableData setObject:[df stringFromDate:[NSDate date].fs_dateByIgnoringTimeComponents] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
        }
    }
    
    [self.tableView reloadData];
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


#pragma mark - Private

- (void)hideKeyBoardIfPresented {
    
    for (NSInteger j = 0; j < [self.tableView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [self.tableView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:j]];
            
            if ([cell isKindOfClass:[FRCommonEditTableViewCell class]]) {
                
                [((FRCommonEditTableViewCell *)cell).componentEdit resignFirstResponder];
            }
        }
    }
}

- (void) keyboardWillShow:(NSNotification *)note {
    
    if (self.keyboardShowed)
        return;
    
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    UITableViewCell *cell = self.idxPathForEditSelected != nil ? [self.tableView cellForRowAtIndexPath:self.idxPathForEditSelected] : nil;
    CGRect rect = cell != nil ? [self.tableView convertRect:cell.bounds fromView:cell] : CGRectZero;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableViewHeight.constant -= keyboardBounds.size.height;
        
    } completion:^(BOOL finished) {
        
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            
            [self.tableView scrollRectToVisible:rect animated:NO];
        }
    }];
    
    self.keyboardShowed = YES;
}

- (void) keyboardWillHide:(NSNotification *)note {
    
    if (!self.keyboardShowed)
        return;
    
    // Get the keyboard size
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.tableViewHeight.constant += keyboardBounds.size.height;
        
    } completion:^(BOOL finished) {
       
        self.idxPathForEditSelected = nil;
    }];
    
    self.keyboardShowed = NO;
}

- (NSInteger)rowForTag:(NSInteger)tag inSection:(NSInteger)section {
    
    return tag - (section + 1) * 1000;
}

- (BOOL)validateCheckInDate:(NSDate *)chInDate checkOutDate:(NSDate *)chOutDate {
    
//    NSLog(@"%@", self.bookingsData);
    
    if (self.bookingsData != nil && self.bookingsData.count > 0) {
        
        for (FRBooking *booking in self.bookingsData) {
            
            if (self.booking != nil && (booking.bookingDBId == self.booking.bookingDBId || booking.bookingStateId != self.booking.bookingStateId)) {
                //continue; DO nothing
            }
            else {
                
                if (([booking.bookingArriveDate compare:chInDate] != NSOrderedDescending && [chInDate compare:booking.bookingDepartureDate] == NSOrderedAscending) || ([booking.bookingArriveDate compare:chOutDate] == NSOrderedAscending && [chOutDate compare:booking.bookingDepartureDate] != NSOrderedDescending)) {
                    
                    return NO;
                }
            }
        }
    }
    
    return YES;
    
}

- (BOOL)validateBooking:(NSError **)error {

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = DEFAULT_DATE_FORMAT;
    NSDate *chInDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]];
    NSDate *chOutDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]];
    if ([chInDate compare:chOutDate] != NSOrderedAscending) {
        
        if (error) {
            *error = [NSError errorWithDomain:BookingErrorDomain code:BookingEmptyHostNameErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_DATE_TEXT, NSLocalizedDescriptionKey, nil]];
        }
        
        return NO;
    }
    
    if (![self validateCheckInDate:chInDate checkOutDate:chOutDate]) {
        
        if (error) {
            *error = [NSError errorWithDomain:BookingErrorDomain code:BookingEmptyHostNameErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_MATCH_OTHER_BOOKING_ERROR, NSLocalizedDescriptionKey, nil]];
        }
        
        return NO;
    }
    
    NSString *clientDescriptionData = [self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)];
    if (clientDescriptionData == nil || [clientDescriptionData isEqualToString:@""] || clientDescriptionData.length == 0 ) {
        
        if (error) {
            *error = [NSError errorWithDomain:BookingErrorDomain code:BookingEmptyClientInfoErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_EMPTY_CLIENT_DESCRIPTION, NSLocalizedDescriptionKey, nil]];
        }
        return NO;
    }

    return YES;
}

#pragma mark - Actions

- (void)okAction:(UIBarButtonItem *)sender {

    self.okActionPressed = YES;
    [self hideKeyBoardIfPresented];
    
    NSError *err = [[NSError alloc] init];
    
    if ([self validateBooking:&err]) {
        
        if (self.booking == nil) {
            
            self.booking = [[FRBooking alloc] init];
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = DEFAULT_DATE_FORMAT;
            self.booking.bookingArriveDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]];
            self.booking.bookingDepartureDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]];
            
            self.booking.bookingDescription = [self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)];
            
            self.booking.bookingClientDescription = [self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)];
            
            self.booking.bookingPrice = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)];
            
            self.booking.bookingExtraIncomeDescription = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)];
            self.booking.bookingExtraIncome = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)];
            
            int idx = [FRBooking addToDB:self.booking];
            if (idx) {
                
                self.booking.bookingDBId = idx;
                self.booking.updateOption = UpdateOptionAdd;
                [[FRNotificationManager sharedInstance] scheduleNotificationsForBooking:self.booking];
            }
            
            [self.toReturnVC hideAddModalViewControllerAnimated:YES];
        }
        else {
            
            BOOL _needUpdate = FALSE;
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = DEFAULT_DATE_FORMAT;
            if ([self.booking.bookingArriveDate compare:[df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]]] != NSOrderedSame) {
                
                self.booking.bookingArriveDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]];
                _needUpdate = YES;
            }
            
            if ([self.booking.bookingDepartureDate compare:[df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]]] != NSOrderedSame) {
                
                self.booking.bookingDepartureDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]];
                _needUpdate = YES;
            }
            
            if ((self.booking.bookingDescription != nil || [self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)] != nil) && ![self.booking.bookingDescription isEqualToString:[self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)]]) {
                
                self.booking.bookingDescription = [self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)];
                _needUpdate = YES;
            }
            
            if ((self.booking.bookingClientDescription != nil || [self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)] != nil) && ![self.booking.bookingClientDescription isEqualToString:[self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)]]) {
                
                self.booking.bookingClientDescription = [self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)];
                _needUpdate = YES;
            }
            
            if ([self.booking.bookingPrice floatValue] != [(NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)] floatValue]) {
                
                self.booking.bookingPrice = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)];
                _needUpdate = YES;
            }
            
            if ((self.booking.bookingExtraIncomeDescription != nil || [self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)] != nil) && ![self.booking.bookingExtraIncomeDescription isEqualToString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)]]) {
                
                self.booking.bookingExtraIncomeDescription = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)];
                _needUpdate = YES;
            }
            
            if ([self.booking.bookingExtraIncome intValue] != [(NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)] intValue]) {
                
                self.booking.bookingExtraIncome = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)];
                _needUpdate = YES;
            }
            
            if (_needUpdate) {
                
                [self.booking updateToDB];
                [[FRNotificationManager sharedInstance] scheduleNotificationsForBooking:self.booking];
            }
            
            self.booking.updateOption = _needUpdate ? UpdateOptionModify : UpdateOptionNone;
            [(FRTaskRemainingViewController *)self.toReturnVC hideBookingWhenEditingFinish];
        }
        
        [self.tableData removeAllObjects];
//        self.selectedHosting = nil;
//        self.booking = nil;
    }
    else {
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GENERAL_ALERT_ERROR_TITLE_TEXT message:err.localizedDescription delegate:nil cancelButtonTitle:GENERAL_ALERT_OK_BUTTON_TEXT otherButtonTitles:nil, nil];
            [alert show];
        }
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:GENERAL_ALERT_ERROR_TITLE_TEXT message:err.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     //[self dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }

    }
}

- (void)cancelAction:(UIBarButtonItem *)sender {
    
    self.okActionPressed = YES;
    [self hideKeyBoardIfPresented];
    [self.tableData removeAllObjects];
    
    if (self.booking != nil) {
        
        [self.toReturnVC hideBookingWhenEditingFinish];
        //self.booking = nil;
        self.booking.updateOption = UpdateOptionNone;
    }
    else {
        
        [self.toReturnVC hideAddModalViewControllerAnimated:YES];
    }
}

#pragma mark - Date methods

- (void)checkInHeaderAction:(FRDateHeader *)sender {
    
    NSIndexPath *idxPathHeader;
    NSIndexPath *idxPathDatePicker;
    NSDictionary *userInfo;
    
    switch (sender.tag) {
        case DATEPICKER_CHECKIN_HEADER_TAG: {
            
            self.checkInDateSelected = !self.checkInDateSelected;
            idxPathHeader = [NSIndexPath indexPathForRow:[self rowForTag:DATEPICKER_CHECKIN_HEADER_TAG inSection:SectionTypeBookingDate] inSection:SectionTypeBookingDate];
            idxPathDatePicker = [NSIndexPath indexPathForRow:[self rowForTag:DATEPICKER_CHECKIN_DATE_TAG inSection:SectionTypeBookingDate] inSection:SectionTypeBookingDate];
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:idxPathHeader, @"IndexPathKey", [NSNumber numberWithInt:DATEPICKER_CHECKIN_HEADER_TAG], @"HeaderTagKey", nil];
            if (!self.checkInDateSelected) {
                    
                [self.tableView deleteRowsAtIndexPaths:@[idxPathDatePicker] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            else {
                    
                [self.tableView insertRowsAtIndexPaths:@[idxPathDatePicker] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            break;
        }
        case DATEPICKER_CHECKOUT_HEADER_TAG: {

            NSInteger rowToInsertDelete = self.checkInDateSelected ? [self rowForTag:DATEPICKER_CHECKOUT_DATE_TAG inSection:SectionTypeBookingDate] : [self rowForTag:DATEPICKER_CHECKOUT_HEADER_TAG inSection:SectionTypeBookingDate];
            idxPathHeader = [NSIndexPath indexPathForRow:rowToInsertDelete-1 inSection:SectionTypeBookingDate];
            idxPathDatePicker = [NSIndexPath indexPathForRow:rowToInsertDelete inSection:SectionTypeBookingDate];
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:idxPathHeader, @"IndexPathKey", [NSNumber numberWithInt:DATEPICKER_CHECKOUT_HEADER_TAG], @"HeaderTagKey", nil];
            
            if (self.checkOutStatus == kCheckOutStatusNone) {
                
                self.checkOutStatus = kCheckOutStatusInsertDelete;
                [self.tableView insertRowsAtIndexPaths:@[idxPathDatePicker] withRowAnimation:UITableViewRowAnimationMiddle];
               
            }
            else {
                
                self.checkOutStatus = kCheckOutStatusNone;
                [self.tableView deleteRowsAtIndexPaths:@[idxPathDatePicker] withRowAnimation:UITableViewRowAnimationMiddle];
            }
            break;
        }
        default:
            break;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(reloadRowWhenHeaderActionFinish:) userInfo:userInfo repeats:NO];
}

- (void)datePickerView:(FRDatePickerView *)datePicker didSelectDate:(NSDate *)date {
    
    NSIndexPath *idxPath;
    NSIndexPath *checkOutIdxPath;
    NSIndexPath *nightsCountIdxPath = [NSIndexPath indexPathForRow:[self rowForTag:PRICE_DAYS_COUNT_TAG inSection:SectionTypeBookingPrice] inSection:SectionTypeBookingPrice];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = DEFAULT_DATE_FORMAT;
    [self.tableData setObject:[df stringFromDate:date] forKey:TABLE_DATA_KEY(datePicker.tag)];
    
    switch (datePicker.tag) {
        case DATEPICKER_CHECKIN_DATE_TAG:

            idxPath = [NSIndexPath indexPathForRow:[self rowForTag:DATEPICKER_CHECKIN_HEADER_TAG inSection:SectionTypeBookingDate] inSection:SectionTypeBookingDate];
            checkOutIdxPath = [NSIndexPath indexPathForRow:[self rowForTag:DATEPICKER_CHECKOUT_HEADER_TAG inSection:SectionTypeBookingDate] inSection:SectionTypeBookingDate];
            if (self.booking == nil) {
                
                [self.tableData setObject:[df stringFromDate:[self.calendar dateByAddingDays:1 toDate:date]] forKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
            }
            break;
        
        case DATEPICKER_CHECKOUT_DATE_TAG:
    
            idxPath = [NSIndexPath indexPathForRow:self.checkInDateSelected ? [self rowForTag:DATEPICKER_CHECKOUT_HEADER_TAG inSection:SectionTypeBookingDate] : [self rowForTag:DATEPICKER_CHECKIN_DATE_TAG inSection:SectionTypeBookingDate] inSection:SectionTypeBookingDate];
            
            break;
        default:
            break;
    }
    
    [self.tableView reloadRowsAtIndexPaths:datePicker.tag == DATEPICKER_CHECKIN_DATE_TAG ? @[idxPath, checkOutIdxPath, nightsCountIdxPath] : @[idxPath, nightsCountIdxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadRowWhenHeaderActionFinish:(NSTimer *)sender {
    
    NSInteger tag = [[sender.userInfo objectForKey:@"HeaderTagKey"] integerValue];
    NSIndexPath *idxPath = [sender.userInfo objectForKey:@"IndexPathKey"];
    
    if (tag == DATEPICKER_CHECKOUT_HEADER_TAG && self.checkOutStatus == kCheckOutStatusInsertDelete) {
        
        self.checkOutStatus = kCheckOutStatusHeaderUpdate;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - FRDescriptionTableViewCellDelegate methods

- (void)descriptionEditWillUpdate:(FRDescriptionTableViewCell *)editCell {
    
    switch (editCell.tag) {
        case CLIENT_EDIT_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:CLIENT_EDIT_TAG inSection:SectionTypeBookingClient] inSection:SectionTypeBookingClient];
            
            break;
        }
        case EXTRA_INFO_INCOMES_EDIT_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:EXTRA_INFO_INCOMES_EDIT_TAG inSection:SectionTypeBookingExtras] inSection:SectionTypeBookingExtras];
            
            break;
        }
        case HOSTING_DESCRIPTION_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:HOSTING_DESCRIPTION_TAG inSection:SectionTypeBookingExtras] inSection:SectionTypeBookingDescription];
            
            break;
        }
        default:
            break;
    }
}

- (void)descriptionEditDidUpdate:(FRDescriptionTableViewCell *)editCell {
    
    if (editCell.componentEdit.text != nil && editCell.componentEdit.text.length > 0) {
        
        [self.tableData setObject:editCell.componentEdit.text forKey:TABLE_DATA_KEY(editCell.tag)];
    }
    else {
        
        [self.tableData setObject:@"" forKey:TABLE_DATA_KEY(editCell.tag)];
    }
    
    if (self.okActionPressed)
        return;
    
    self.idxPathForEditSelected = nil;
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        
        [[FRNotificationManager sharedInstance] deleteNotificationForBooking:self.booking];
        [FRBooking removeFromDB:self.booking.bookingDBId];
        
        [self.toReturnVC hideBookingWhenEditingFinish];

        self.booking.updateOption = UpdateOptionDelete;
        [self.tableData removeAllObjects];
    }
}

#pragma mark - FRPriceTableViewCellDelegate methods

- (void)priceEditWillUpdate:(FRPriceTableViewCell *)priceCell {
    
    switch (priceCell.tag) {
        case PRICE_EDIT_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:PRICE_EDIT_TAG inSection:SectionTypeBookingPrice] inSection:SectionTypeBookingPrice];
            
            break;
        }
        case EXTRA_INFO_INCOMES_PRICE_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:EXTRA_INFO_INCOMES_PRICE_TAG inSection:SectionTypeBookingExtras] inSection:SectionTypeBookingExtras];
            
            break;
        }
        default:
            break;
    }
}

- (void)priceEditDidUpdate:(FRPriceTableViewCell *)priceCell {
    
    if (priceCell.componentEdit.text != nil && priceCell.componentEdit.text.length > 0) {
        
        if ([priceCell.componentEdit.text formattedFloatValue] > 0) {
            
            [self.tableData setObject:[NSNumber numberWithFloat:priceCell.componentEdit.text.formattedFloatValue] forKey:TABLE_DATA_KEY(priceCell.tag)];
        }
    }
    else {
        
        [self.tableData setObject:[NSNumber numberWithFloat:0] forKey:TABLE_DATA_KEY(priceCell.tag)];
    }
    
    if (self.okActionPressed)
        return;
    
    switch (priceCell.tag) {
        case PRICE_EDIT_TAG: {
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:PRICE_EDIT_TAG inSection:SectionTypeBookingPrice] inSection:SectionTypeBookingPrice];
            
            [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        }
        case EXTRA_INFO_INCOMES_PRICE_TAG: {
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:EXTRA_INFO_INCOMES_PRICE_TAG inSection:SectionTypeBookingExtras] inSection:SectionTypeBookingExtras];
            [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        }

        default:
            break;
    }
    
    self.idxPathForEditSelected = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        
        case SectionTypeBookingDescription: {

            return 1;
        }
        case SectionTypeBookingDate:
        {
            int ret = 3;
            
            if (self.checkInDateSelected) {
                
                ret++;
            }
            
            if (self.checkOutStatus != kCheckOutStatusNone) {
                
                ret++; 
            }

            return ret;
        }
        case SectionTypeBookingPrice: {
            
            return 3;
        }
        case SectionTypeBookingClient:
            
            return 1;
        
        case SectionTypeBookingExtras: {
            
            return 3;
        }
        case SectionTypeBookingDelete: {
            
            if (self.booking != nil) {
                
                return 2;
            }
            break;
        }
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {

        case SectionTypeBookingDate:
            
            if (indexPath.row == 0) {
                
                return 32.0;
            }
            
            if (self.checkInDateSelected) {
                
                if (indexPath.row == [self rowForTag:DATEPICKER_CHECKIN_DATE_TAG inSection:SectionTypeBookingDate]) {
                    
                    return 160;
                }
                
                if (self.checkOutStatus != kCheckOutStatusNone && indexPath.row == [self rowForTag:DATEPICKER_CHECKOUT_DATE_TAG inSection:SectionTypeBookingDate]) {
                    
                    return 160;
                }
            }
            else if (self.checkOutStatus != kCheckOutStatusNone) {
                
                if (indexPath.row == [self rowForTag:DATEPICKER_CHECKOUT_HEADER_TAG inSection:SectionTypeBookingDate]) {
                    
                    return 160;
                }
            }
            
            return 44.0;
            
            break;
        case SectionTypeBookingPrice: {
            
            if (indexPath.row == 0) {
                
                return 32.0;
            }
            
            if (indexPath.row == [self rowForTag:PRICE_DAYS_COUNT_TAG inSection:SectionTypeBookingPrice]) {
                
                    return 60.0;
            }
            
            return 60.0;
            
            break;
        }
        case SectionTypeBookingExtras: {
            
            if (indexPath.row == 0) {
                
                return 32.0;
            }
            
            break;
        }
        default:
            break;
    }
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (!cell) {
        
        switch (indexPath.section) {
            case SectionTypeBookingDate:
                switch (indexPath.row) {
                    case 0:
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = LANG_BOOKING_SECTION_BASIC_TEXT;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.font = TABLEVIEW_HEADER_FONT;
                        cell.textLabel.textColor = TABLEVIEW_DEFAULT_HEADER_TEXT_COLOR;
                        cell.backgroundColor = TABLEVIEW_HEADER_BACKGROUND_COLOR;
                        break;
                    case 1: {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        
                        FRDateHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"FRDateHeader" owner:self options:nil] objectAtIndex:0];
                        [header setTitle:LANG_BOOKING_CHECKIN_DATE_TEXT forState:UIControlStateNormal];
                        header.titleLabel.font = TABLEVIEW_DEFAULT_CELL_FONT;
                        [header setTitleColor:TABLEVIEW_DEFAULT_CELL_TEXT_COLOR forState:UIControlStateNormal];
                        [header addTarget:self action:@selector(checkInHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                        header.disclosureImage.image = [UIImage imageNamed:@"BlackDownArrow"];
                        CGAffineTransform rotate = self.checkInDateSelected ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
                        header.disclosureImage.transform = rotate;
                        header.tag = DATEPICKER_CHECKIN_HEADER_TAG;
                        
                        NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)];
                        header.totalSelectedLbl.text = descCellText; //?:[df stringFromDate:[NSDate date]];
                        
                        [cell.contentView addSubview:header];
                        [cell bringSubviewToFront:header];
                        
                        break;
                    }
                    case 2: {
                        
                        if (self.checkInDateSelected) {
                            
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                            
                            FRDatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"FRDatePickerView" owner:self options:nil] objectAtIndex:0];
                            datePickerView.tag = DATEPICKER_CHECKIN_DATE_TAG;
                            datePickerView.datePickerDelegate = self;
                            
                            NSDateFormatter *df = [[NSDateFormatter alloc] init];
                            df.dateFormat = DEFAULT_DATE_FORMAT;
                            NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)];
                            datePickerView.datePicker.date = descCellText ? [df dateFromString:descCellText] : [NSDate date].fs_dateByIgnoringTimeComponents;
                            
                            [cell.contentView addSubview:datePickerView];
                            [cell bringSubviewToFront:datePickerView];

                            break;
                        }
                    }
                    case 3: {
                        
                        if (self.checkOutStatus != kCheckOutStatusInsertDelete) {
                        
                            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                            
                            FRDateHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"FRDateHeader" owner:self options:nil] objectAtIndex:0];
                            [header setTitle:LANG_BOOKING_CHECKOUT_DATE_TEXT forState:UIControlStateNormal];
                            header.titleLabel.font = TABLEVIEW_DEFAULT_CELL_FONT;
                            [header setTitleColor:TABLEVIEW_DEFAULT_CELL_TEXT_COLOR forState:UIControlStateNormal];
                            [header addTarget:self action:@selector(checkInHeaderAction:) forControlEvents:UIControlEventTouchUpInside];
                            header.disclosureImage.image = [UIImage imageNamed:@"BlackDownArrow"];
                            CGAffineTransform rotate = self.checkOutStatus == kCheckOutStatusNone ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
                            header.disclosureImage.transform = rotate;
                            header.tag = DATEPICKER_CHECKOUT_HEADER_TAG;
                            
                            NSDateFormatter *df = [[NSDateFormatter alloc] init];
                            df.dateFormat = DEFAULT_DATE_FORMAT;
                            NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
                            header.totalSelectedLbl.text = descCellText;
                            
                            [cell.contentView addSubview:header];
                            [cell bringSubviewToFront:header];
                            
                            break;
                        }
                    }
                    case 4: {
                        
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        
                        FRDatePickerView *datePickerView = [[[NSBundle mainBundle] loadNibNamed:@"FRDatePickerView" owner:self options:nil] objectAtIndex:0];
                        datePickerView.tag = DATEPICKER_CHECKOUT_DATE_TAG;
                        datePickerView.datePickerDelegate = self;
                        
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        df.dateFormat = DEFAULT_DATE_FORMAT;
                        NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)];
                        datePickerView.datePicker.date = descCellText ? [df dateFromString:descCellText] : [NSDate date].fs_dateByIgnoringTimeComponents;
                        
                        [cell.contentView addSubview:datePickerView];
                        [cell bringSubviewToFront:datePickerView];
                        
                        break;
                    }
                    default:
                        break;
                }
                break;
            case SectionTypeBookingPrice:
                switch (indexPath.row) {
                    case 0: {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = LANG_BOOKING_SECTION_PRICE_TEXT;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.font = TABLEVIEW_HEADER_FONT;
                        cell.textLabel.textColor = TABLEVIEW_DEFAULT_HEADER_TEXT_COLOR;
                        cell.backgroundColor = TABLEVIEW_HEADER_BACKGROUND_COLOR;
                        
                        break;
                    }
                    case 1: {
                        
                        cell = (FRCommonTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRCommonTableViewCell" owner:self options:nil] objectAtIndex:0];
                        //cell.textLabel.text = @"0 noches";
                        cell.detailTextLabel.text = LANG_BOOKING_NIGHTS_COUNT_TEXT;
                        cell.textLabel.font = TABLEVIEW_DEFAULT_CELL_FONT;
                        cell.tag = PRICE_DAYS_COUNT_TAG;
                        
                        NSDateFormatter *df = [[NSDateFormatter alloc] init];
                        df.dateFormat = DEFAULT_DATE_FORMAT;
                        NSDate *startDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKIN_DATE_TAG)]];
                        NSDate *endDate = [df dateFromString:(NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(DATEPICKER_CHECKOUT_DATE_TAG)]];
                        NSInteger daysCount = [endDate fs_daysFrom:startDate];
                        cell.textLabel.text = [NSString stringWithFormat:@"%d %@", (int)daysCount, daysCount == 1 ? LANG_BOOKING_NIGHT_TEXT : LANG_BOOKING_NIGHTS_TEXT];
                        break;
                    }
                    case 2: {
                        
                        cell = (FRPriceTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRPriceTableViewCell" owner:self options:nil] objectAtIndex:0];
                        ((FRPriceTableViewCell *)cell).delegate = self;
                        [cell bringSubviewToFront:((FRPriceTableViewCell *)cell).componentEdit];
                        ((FRPriceTableViewCell *)cell).componentImageWidth.constant = 0;
                        ((FRPriceTableViewCell *)cell).componentImageLeftPadding.constant = 0;
                        cell.tag = PRICE_EDIT_TAG;
                        
                        ((FRPriceTableViewCell *)cell).cellTitleLbl.text = LANG_BOOKING_PRICE_PER_NIGHT_TEXT;
                        
                        NSNumber *priceCellV = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(PRICE_EDIT_TAG)];
                        if (priceCellV != nil) {
                            
                            ((FRPriceTableViewCell *)cell).componentEdit.text = [NSString stringWithFormat:@"%.2f", [priceCellV floatValue]];
                        }
                        else {
                            
                            ((FRPriceTableViewCell *)cell).componentEdit.placeholder = LANG_BOOKING_AMOUNT_TEXT;
                        }
                        
                        break;
                    }
                    default:
                        break;
                }
                break;
            case SectionTypeBookingDescription: {
                switch (indexPath.row) {
                    case 0: {
                        cell = (FRDescriptionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRDescriptionTableViewCell" owner:self options:nil] objectAtIndex:0];
                        ((FRDescriptionTableViewCell *)cell).delegate = self;
                        ((FRDescriptionTableViewCell *)cell).componentEdit.placeholder = LANG_BOOKING_DESCRIPTION_HOSTING_PLACEHOLDER_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentDesc.text = LANG_BOOKING_DESCRIPTION_HOSTING_SUBTITLE_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentImageWidth.constant = 0;
                        ((FRDescriptionTableViewCell *)cell).componentImageLeftPadding.constant = 0;
                        [cell bringSubviewToFront:((FRDescriptionTableViewCell *)cell).componentEdit];
                        cell.tag = HOSTING_DESCRIPTION_TAG;
                        
                        NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(HOSTING_DESCRIPTION_TAG)];
                        if (descCellText != nil && descCellText.length > 0) {
                            
                            ((FRDescriptionTableViewCell *)cell).componentEdit.text = descCellText;
                        }
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case SectionTypeBookingClient: {
                switch (indexPath.row) {
                    case 0: {
                        cell = (FRDescriptionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRDescriptionTableViewCell" owner:self options:nil] objectAtIndex:0];
                        ((FRDescriptionTableViewCell *)cell).delegate = self;
                        ((FRDescriptionTableViewCell *)cell).componentEdit.placeholder = LANG_BOOKING_DESCRIPTION_GUESTS_PLACEHOLDER_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentDesc.text = LANG_BOOKING_DESCRIPTION_GUESTS_SUBTITLE_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentImageWidth.constant = 0;
                        ((FRDescriptionTableViewCell *)cell).componentImageLeftPadding.constant = 0;
                        [cell bringSubviewToFront:((FRDescriptionTableViewCell *)cell).componentEdit];
                        cell.tag = CLIENT_EDIT_TAG;
                        
                        NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(CLIENT_EDIT_TAG)];
                        if (descCellText != nil && descCellText.length > 0) {
                            
                            ((FRDescriptionTableViewCell *)cell).componentEdit.text = descCellText;
                        }
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case SectionTypeBookingExtras: {
                switch (indexPath.row) {
                    case 0: {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = LANG_BOOKING_SECTION_SERVICES_TEXT;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.font = TABLEVIEW_HEADER_FONT;
                        cell.textLabel.textColor = TABLEVIEW_DEFAULT_HEADER_TEXT_COLOR;
                        cell.backgroundColor = TABLEVIEW_HEADER_BACKGROUND_COLOR;
                        break;
                    }
                    case 1: {
                        cell = (FRDescriptionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRDescriptionTableViewCell" owner:self options:nil] objectAtIndex:0];
                        ((FRDescriptionTableViewCell *)cell).delegate = self;
                        ((FRDescriptionTableViewCell *)cell).componentEdit.placeholder = LANG_BOOKING_DESCRIPTION_SERVICES_PLACEHOLDER_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentDesc.text = LANG_BOOKING_DESCRIPTION_SERVICES_SUBTITLE_TEXT;
                        ((FRDescriptionTableViewCell *)cell).componentImageWidth.constant = 0;
                        ((FRDescriptionTableViewCell *)cell).componentImageLeftPadding.constant = 0;
                        [cell bringSubviewToFront:((FRDescriptionTableViewCell *)cell).componentEdit];
                        cell.tag = EXTRA_INFO_INCOMES_EDIT_TAG;
                        
                        NSString *descCellText = (NSString *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_EDIT_TAG)];
                        if (descCellText != nil && descCellText.length > 0) {
                            
                            ((FRDescriptionTableViewCell *)cell).componentEdit.text = descCellText;
                        }
                        
                        break;
                    }
                    case 2: {
                        cell = (FRPriceTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRPriceTableViewCell" owner:self options:nil] objectAtIndex:0];
                        ((FRPriceTableViewCell *)cell).delegate = self;
                        ((FRPriceTableViewCell *)cell).componentImageWidth.constant = 0;
                        ((FRPriceTableViewCell *)cell).componentImageLeftPadding.constant = 0;
                        [cell bringSubviewToFront:((FRPriceTableViewCell *)cell).componentEdit];
                        cell.tag = EXTRA_INFO_INCOMES_PRICE_TAG;
                        
                        ((FRPriceTableViewCell *)cell).cellTitleLbl.text = LANG_BOOKING_INCOME_PER_SERVICES_TEXT;
                        
                        NSNumber *priceCellText = (NSNumber *)[self.tableData objectForKey:TABLE_DATA_KEY(EXTRA_INFO_INCOMES_PRICE_TAG)];
                        if (priceCellText != nil) {
                            
                            ((FRPriceTableViewCell *)cell).componentEdit.text = [NSString stringWithFormat:@"%.2f", [priceCellText floatValue]];
                        }
                        else {
                            
                            ((FRPriceTableViewCell *)cell).componentEdit.placeholder = LANG_BOOKING_AMOUNT_PER_SERVICES_TEXT;
                        }
                        
                        break;
                    }

                    default:
                    break;
                }
                break;
            }
            case SectionTypeBookingDelete: {
                switch (indexPath.row) {
                    case 0: {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        break;
                    }
                    case 1: {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.textLabel.text = LANG_DELETE_BOOKING_TEXT;
                        cell.textLabel.textAlignment = NSTextAlignmentCenter;
                        cell.textLabel.textColor = [UIColor redColor];
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
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case SectionTypeBookingDelete: {
            switch (indexPath.row) {
                case 1: {
                    
                    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_ALERT_DELETE_BOOKING_TEXT delegate:self cancelButtonTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT otherButtonTitles:GENERAL_ALERT_OK_BUTTON_TEXT, nil];
                        [alert show];
                    }
                    else {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_ALERT_DELETE_BOOKING_TEXT preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *ok = [UIAlertAction
                                             actionWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT
                                             style:UIAlertActionStyleDestructive
                                             handler:^(UIAlertAction * action)
                                             {
                                                 //Do some thing here
                                                 [[FRNotificationManager sharedInstance] deleteNotificationForBooking:self.booking];
                                                 [FRBooking removeFromDB:self.booking.bookingDBId];
                                                 [self.toReturnVC hideBookingWhenEditingFinish];
                                                 self.booking.updateOption = UpdateOptionDelete;
                                                 [self.tableData removeAllObjects];
                                             }];
                        [alert addAction:ok];
                        
                        UIAlertAction *cancel = [UIAlertAction
                                             actionWithTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT
                                             style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction * action)
                                             {
                                                 //Do some thing here
                                                 //[self dismissViewControllerAnimated:YES completion:nil];
                                             }];
                        [alert addAction:cancel];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
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
}

@end