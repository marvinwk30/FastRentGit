//
//  FRAddEditOwnerViewController.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 3/23/16.
//  Copyright © 2016 Marvin Avila Kotliarov. All rights reserved.
//

#import "FRAddEditOwnerViewController.h"
#import "FRCommonEditTableViewCell.h"
#import "FRPhotosTableViewCell.h"
#import "FRGlobals.h"
#import "FRAccount.h"
#import "FRImagePool.h"
#import "Types.h"
#import "FRCommonEditTableViewCell.h"
#import "FRLanguage.h"

typedef enum {
    kSectionTypeOwnerPhoto,
    kSectionTypeOwnerGeneralInfo,
    kSectionTypeOwnerDelete,
}OwnerSectionType;

#define OWNER_PHOTOS_CELL_TAG 1000
#define OWNER_MAX_PHOTOS_COUNT 1

#define OWNER_NAME_EDIT_TAG 2001
#define OWNER_EMAIL_EDIT_TAG 2002
#define OWNER_PHONE_TAG 2003
#define OWNER_CELL_TAG 2004

#define OWNER_NUMBER_OF_SECTIONS 3

NSString* const OwnerErrorDomain = @"ValidateOwnerErrorDomain";

@interface FRAddEditOwnerViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) NSMutableDictionary *tableData;
@property (nonatomic, strong) NSIndexPath *idxPathForEditSelected;
@property (nonatomic, assign) BOOL keyboardShowed;
@property (nonatomic, assign) BOOL okActionPressed;

@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *photoName;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, assign) BOOL showingTakePicture;

@end

#pragma mark - View lifecycle

@implementation FRAddEditOwnerViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.tableData = [NSMutableDictionary dictionary];
    
    self.idxPathForEditSelected = nil;
    self.keyboardShowed = NO;
    self.showingTakePicture = NO;

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
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT style:UIBarButtonItemStylePlain target:self action:@selector(okAction:)];
    right.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
    self.navigationItem.rightBarButtonItem = right;
    
//    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
//    left.tintColor = NAVIGATIONBAR_DEFAULT_TEXT_COLOR;
//    self.navigationItem.leftBarButtonItem = left;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributes;
    
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_DEFAULT_COLOR;
    
    self.title = LANG_TITLE_PROFILE;
    
    self.okActionPressed = NO;
    
    if (self.account != nil) {
        
        if (self.account.accountFullName != nil) {
            
            [self.tableData setObject:self.account.accountFullName forKey:[NSString stringWithFormat:@"%d", (int)OWNER_NAME_EDIT_TAG]];
        }
        
        if (self.account.accountEmail != nil) {
            
            [self.tableData setObject:self.account.accountEmail forKey:[NSString stringWithFormat:@"%d", (int)OWNER_EMAIL_EDIT_TAG]];
        }
        
        if (self.account.accountPhone != nil) {
            
            [self.tableData setObject:self.account.accountPhone forKey:[NSString stringWithFormat:@"%d", (int)OWNER_PHONE_TAG]];
        }
        
        if (self.account.accountCellPhone != nil) {
            
            [self.tableData setObject:self.account.accountCellPhone forKey:[NSString stringWithFormat:@"%d", (int)OWNER_CELL_TAG]];
        }
        
        if (self.account.accountPicture != nil && ![self.account.accountPicture isEqualToString:@""] && !self.showingTakePicture) {
            
//            self.photoName = self.account.accountPicture;
            self.photo = [[FRImagePool sharedInstance] getImageNamed:self.account.accountPicture];
            
            if (self.photo != nil) {
                
                self.photoName = self.account.accountPicture;
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Getters and Setters

- (UIImagePickerController *)picker {
    
    if (_picker == nil) {
        
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    
    return _picker;
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

- (BOOL)validateOwner:(NSError **)error {
    
    if ([self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_NAME_EDIT_TAG]] == nil) {
        
        if (error) {
            *error = [NSError errorWithDomain:OwnerErrorDomain code:OwnerEmptyNameErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:LANG_ERROR_EMPTY_OWNER_NAME, NSLocalizedDescriptionKey, nil]];
        }
        return NO;
    }
    
    return YES;
}

#pragma mark - Actions

- (void)okAction:(id)sender {
    
    self.okActionPressed = YES;
    [self hideKeyBoardIfPresented];
    
    NSError *err = [[NSError alloc] init];
    
    if (![self validateOwner:&err]) {
        
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
                                     [self dismissViewControllerAnimated:YES completion:nil];
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        return;
    }
    
    if (self.account == nil) {
        
        self.account = [[FRAccount alloc] init];
        self.account.accountFullName = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_NAME_EDIT_TAG]];
        self.account.accountEmail = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_EMAIL_EDIT_TAG]];
        self.account.accountPhone = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_PHONE_TAG]];
        self.account.accountCellPhone = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_CELL_TAG]];
        
        if (self.photo != nil && self.photoName != nil && self.photoName.length > 0 && ![self.photoName isEqualToString:@""]) {
            
            [[FRImagePool sharedInstance] saveImageLocally:self.photo imageName:self.photoName];
            self.account.accountPicture = self.photoName;
        }
        
        self.account.accountIsAppAccount = NO;
        
        [FRAccount addToDB:self.account];
    }
    else {
        
        BOOL _needUpdate = FALSE;
        BOOL _photoNeedUpdate = FALSE;
        
        if (![self.account.accountFullName isEqualToString:[self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_NAME_EDIT_TAG]]])
        {
            self.account.accountFullName = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_NAME_EDIT_TAG]];
            _needUpdate = TRUE;
        }
        
        if (![self.account.accountEmail isEqualToString:[self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_EMAIL_EDIT_TAG]]])
        {
            self.account.accountEmail = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_EMAIL_EDIT_TAG]]?:@"";
            _needUpdate = TRUE;
        }

        if (![self.account.accountPhone isEqualToString:[self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_PHONE_TAG]]])
        {
            self.account.accountPhone = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_PHONE_TAG]]?:@"";
            _needUpdate = TRUE;
        }
        
        if (![self.account.accountCellPhone isEqualToString:[self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_CELL_TAG]]])
        {
            self.account.accountCellPhone = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", OWNER_CELL_TAG]]?:@"";
            _needUpdate = TRUE;
        }
        
        if (![self.photoName isEqualToString:self.account.accountPicture]) {
            
            [[FRImagePool sharedInstance] removeLocalImage:self.account.accountPicture];
            self.account.accountPicture = @"";
            _photoNeedUpdate = YES;
        }
        
        if (_photoNeedUpdate) {
            
            if (self.photoName != nil && self.photoName.length > 0 && self.photo != nil) {
                
                [[FRImagePool sharedInstance] saveImageLocally:self.photo imageName:self.photoName];
                self.account.accountPicture = self.photoName;
            }
            else {
                
                self.account.accountPicture = @"";
            }
        }
        
        if (_needUpdate || _photoNeedUpdate) {
            
            [self.account updateToDB];
        }
    }
}

- (void)cancelAction:(id)sender {
    
    self.okActionPressed = YES;
    [self hideKeyBoardIfPresented];
    
    [self.tableData removeAllObjects];
    self.photo = nil;
    self.photoName = nil;
    
    if (self.account != nil) {

        self.account = nil;
    }
}

- (void)addPhotoAction:(id)sender {
    
    UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:LANG_MAKE_PHOTO, LANG_CHOOSE_PHOTO, nil];
    [actions showInView:self.view];
}

- (void)removePhotoAction:(id)sender {
    
    if (self.photo == nil)
        return;
    
    self.photo = nil;
    self.photoName = nil;
    
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_PHOTOS_CELL_TAG inSection:kSectionTypeOwnerPhoto] inSection:kSectionTypeOwnerPhoto];
    
    [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - FRDescriptionTableViewCellDelegate methods

- (void)descriptionEditWillUpdate:(FRDescriptionTableViewCell *)editCell {
    
    switch (editCell.tag) {
        case OWNER_NAME_EDIT_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_NAME_EDIT_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            
            break;
        }
        case OWNER_EMAIL_EDIT_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_EMAIL_EDIT_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            
            break;
        }
        default:
            break;
    }
}

- (void)descriptionEditDidUpdate:(FRDescriptionTableViewCell *)editCell {
    
    if (editCell.componentEdit.text != nil && editCell.componentEdit.text.length > 0) {
        
        [self.tableData setObject:editCell.componentEdit.text forKey:[NSString stringWithFormat:@"%d", (int)editCell.tag]];
    }
    else {
        
        [self.tableData removeObjectForKey:[NSString stringWithFormat:@"%d", (int)editCell.tag]];
    }
    
    if (self.okActionPressed)
        return;
    
    self.idxPathForEditSelected = nil;
}

#pragma mark - FRPhoneTableViewCellDelegate methods

- (void)phoneEditWillUpdate:(FRPhoneTableViewCell *)phoneCell {
    
    switch (phoneCell.tag) {
        case OWNER_PHONE_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_PHONE_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            
            break;
        }
        case OWNER_CELL_TAG: {
            
            self.idxPathForEditSelected = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_CELL_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            
            break;
        }
        default:
            break;
    }
}

- (void)phoneEditDidUpdate:(FRPhoneTableViewCell *)phoneCell {
    
    if (phoneCell.componentEdit.text != nil && phoneCell.componentEdit.text.length > 0) {
        
        if ([phoneCell.componentEdit.text intValue] > 0) {
            
            [self.tableData setObject:phoneCell.componentEdit.text forKey:[NSString stringWithFormat:@"%d", (int)phoneCell.tag]];
        }
    }
    else {
        
        [self.tableData removeObjectForKey:[NSString stringWithFormat:@"%d", (int)phoneCell.tag]];
    }
    
    if (self.okActionPressed)
        return;
    
    switch (phoneCell.tag) {
        case OWNER_PHONE_TAG: {
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_PHONE_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        }
        case OWNER_CELL_TAG: {
            
            NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_CELL_TAG inSection:kSectionTypeOwnerGeneralInfo] inSection:kSectionTypeOwnerGeneralInfo];
            [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            break;
        }
        default:
            break;
    }
    
    self.idxPathForEditSelected = nil;
}

- (void)phoneCallAction:(FRPhoneTableViewCell *)phoneCell {
    
    NSLog(@"Call action on:%ld", (long)phoneCell.tag);
}

#pragma mark - UIActionSheetDelegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0: {
            
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        }
        case 1: {
            
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        }
        default:
            break;
    }
    
    if (buttonIndex != 2) {
        
        [self presentViewController:self.picker animated:YES completion:^{
            
            self.showingTakePicture = YES;
        }];
    }
}

#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != 0) {
        
        [FRAccount removeFromDB:self.account.accountDBId];
        
        if (self.account.accountPicture != nil && ![self.account.accountPicture isEqualToString:@""]) {
            
            [[FRImagePool sharedInstance] removeLocalImage:self.account.accountPicture];
        }
        
        self.account = nil;
        [self.tableData removeAllObjects];
        self.photoName = nil;
        self.photo = nil;
    }
}


#pragma mark - UIImagePickerControllerDelegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:[self rowForTag:OWNER_PHOTOS_CELL_TAG inSection:kSectionTypeOwnerPhoto] inSection:kSectionTypeOwnerPhoto];
    
    self.photo = image;
    self.photoName = [NSString stringWithFormat:@"%@.JPG", [NSUUID UUID].UUIDString];
    
    [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        self.showingTakePicture = NO;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        self.showingTakePicture = NO;
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return (self.account != nil && self.account.accountIsAppAccount) ? OWNER_NUMBER_OF_SECTIONS - 1 : OWNER_NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case kSectionTypeOwnerPhoto:
            return 1;
            break;
        case kSectionTypeOwnerGeneralInfo:
            return 5;
            break;
        case kSectionTypeOwnerDelete: {
            
            if (self.account != nil) {
                
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
        case kSectionTypeOwnerPhoto: {
            
            return 200.0;
            break;
        }
        case kSectionTypeOwnerGeneralInfo: {
            
            if (indexPath.row == 0) {
                
                return 32.0;
            }
            break;
        }
        default:
            break;
    }
    
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case kSectionTypeOwnerPhoto:
            
            switch (indexPath.row) {
                case 0: {
                    cell = (FRPhotosTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRPhotosTableViewCell" owner:self options:nil] objectAtIndex:0];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.tag = OWNER_PHOTOS_CELL_TAG;
                    
                    ((FRPhotosTableViewCell *)cell).photosImgView.image = self.photo?:[UIImage imageNamed:@"TakePhoto"];
                    
                    [((FRPhotosTableViewCell *)cell).addPhotoBtn addTarget:self action:@selector(addPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
                    [((FRPhotosTableViewCell *)cell).delPhotoBtn addTarget:self action:@selector(removePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
                    ((FRPhotosTableViewCell *)cell).photosPgControl.hidden = YES;
                    break;
                }
                default:
                    break;
            }
            break;
        case kSectionTypeOwnerGeneralInfo: {
            
            switch (indexPath.row) {
                case 0: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = LANG_PROFILE_SECTION_BASIC_TEXT;
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.font = TABLEVIEW_HEADER_FONT;
                    cell.textLabel.textColor = TABLEVIEW_DEFAULT_HEADER_TEXT_COLOR;
                    cell.backgroundColor = TABLEVIEW_HEADER_BACKGROUND_COLOR;
                    break;
                }
                case 1: {
                    cell = (FRDescriptionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRDescriptionTableViewCell" owner:self options:nil] objectAtIndex:0];
                    ((FRDescriptionTableViewCell *)cell).delegate = self;
                    ((FRDescriptionTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_NAME_PLACEHOLDER_TEXT;
                    ((FRDescriptionTableViewCell *)cell).componentDesc.text = LANG_PROFILE_NAME_SUBTITLE_TEXT;
                    ((FRDescriptionTableViewCell *)cell).componentImageView.image = [UIImage imageNamed:@"UserIcon"];
                    [cell bringSubviewToFront:((FRDescriptionTableViewCell *)cell).componentEdit];
                    cell.tag = OWNER_NAME_EDIT_TAG;
                    
                    NSString *descCellText = (NSString *)[self.tableData objectForKey:[NSString stringWithFormat:@"%d", (int)OWNER_NAME_EDIT_TAG]];
                    if (descCellText != nil && descCellText.length > 0) {
                        
                        ((FRDescriptionTableViewCell *)cell).componentEdit.text = descCellText;
                    }
                    
                    break;
                }
                case 2: {
                    cell = (FRDescriptionTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRDescriptionTableViewCell" owner:self options:nil] objectAtIndex:0];
                    ((FRDescriptionTableViewCell *)cell).delegate = self;
                    ((FRDescriptionTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_EMAIL_PLACEHOLDER_TEXT;
                    ((FRDescriptionTableViewCell *)cell).componentDesc.text = LANG_PROFILE_EMAIL_SUBTITLE_TEXT;
                    ((FRDescriptionTableViewCell *)cell).componentImageView.image = [UIImage imageNamed:@"EmailIcon"];
                    ((FRDescriptionTableViewCell *)cell).componentEdit.keyboardType = UIKeyboardTypeEmailAddress;
                    [cell bringSubviewToFront:((FRDescriptionTableViewCell *)cell).componentEdit];
                    cell.tag = OWNER_EMAIL_EDIT_TAG;
                    
                    NSString *descCellText = (NSString *)[self.tableData objectForKey:[NSString stringWithFormat:@"%d", (int)OWNER_EMAIL_EDIT_TAG]];
                    if (descCellText != nil && descCellText.length > 0) {
                        
                        ((FRDescriptionTableViewCell *)cell).componentEdit.text = descCellText;
                    }
                    
                    break;
                }
                case 3: {
                    cell = (FRPhoneTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRPhoneTableViewCell" owner:self options:nil] objectAtIndex:0];
                    ((FRPhoneTableViewCell *)cell).delegate = self;
                    ((FRPhoneTableViewCell *)cell).titleLbl.text = LANG_PROFILE_PHONE_SUBTITLE_TEXT;
                    ((FRPhoneTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_PHONE_PLACEHOLDER_TEXT;
                    [((FRPhoneTableViewCell *)cell).actionBtn setImage:[UIImage imageNamed:@"PhoneButton"] forState:UIControlStateNormal];
                    [cell bringSubviewToFront:((FRPhoneTableViewCell *)cell).componentEdit];
                    cell.tag = OWNER_PHONE_TAG;
                    
                    NSString *phoneCellV = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", (int)OWNER_PHONE_TAG]];
                    if (phoneCellV != nil) {
                        
                        ((FRPhoneTableViewCell *)cell).componentEdit.text = phoneCellV;
                        ((FRPhoneTableViewCell *)cell).actionBtn.hidden = NO;
                    }
                    else {
                        
                        ((FRPhoneTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_PHONE_PLACEHOLDER_TEXT;
                        ((FRPhoneTableViewCell *)cell).actionBtn.hidden = YES;
                    }
                    break;
                }
                case 4: {
                    cell = (FRPhoneTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FRPhoneTableViewCell" owner:self options:nil] objectAtIndex:0];
                    ((FRPhoneTableViewCell *)cell).delegate = self;
                    ((FRPhoneTableViewCell *)cell).titleLbl.text = LANG_PROFILE_CELL_SUBTITLE_TEXT;
                    ((FRPhoneTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_CELL_PLACEHOLDER_TEXT;
                    [((FRPhoneTableViewCell *)cell).actionBtn setImage:[UIImage imageNamed:@"CellButton"] forState:UIControlStateNormal];
                    [cell bringSubviewToFront:((FRPhoneTableViewCell *)cell).componentEdit];
                    cell.tag = OWNER_CELL_TAG;
                    
                    NSString *phoneCellV = [self.tableData objectForKey:[NSString stringWithFormat:@"%d", (int)OWNER_CELL_TAG]];
                    if (phoneCellV != nil) {
                        
                        ((FRPhoneTableViewCell *)cell).componentEdit.text = phoneCellV;
                        ((FRPhoneTableViewCell *)cell).actionBtn.hidden = NO;
                    }
                    else {
                        
                        ((FRPhoneTableViewCell *)cell).componentEdit.placeholder = LANG_PROFILE_CELL_PLACEHOLDER_TEXT;
                        ((FRPhoneTableViewCell *)cell).actionBtn.hidden = YES;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case kSectionTypeOwnerDelete: {
            switch (indexPath.row) {
                case 0: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                }
                case 1: {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.textLabel.text = LANG_DELETE_PROFILE_TEXT;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDataDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case kSectionTypeOwnerPhoto: {
                        
            UIActionSheet *actions = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT destructiveButtonTitle:nil otherButtonTitles:LANG_MAKE_PHOTO, LANG_CHOOSE_PHOTO, nil];
            [actions showInView:self.view];
            break;
        }
        case kSectionTypeOwnerDelete: {
            switch (indexPath.row) {
                case 1: {
                    
                    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                    
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_ALERT_DELETE_PROFILE_TEXT delegate:self cancelButtonTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT otherButtonTitles:GENERAL_ALERT_OK_BUTTON_TEXT, nil];
                        [alert show];
                    }
                    else {
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_ALERT_DELETE_PROFILE_TEXT preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *ok = [UIAlertAction
                                             actionWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT
                                             style:UIAlertActionStyleDestructive
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [FRAccount removeFromDB:self.account.accountDBId];
                                                 
                                                 if (self.account.accountPicture != nil && ![self.account.accountPicture isEqualToString:@""]) {
                                                     
                                                     [[FRImagePool sharedInstance] removeLocalImage:self.account.accountPicture];
                                                 }
                                                 
                                                 self.account = nil;
                                                 [self.tableData removeAllObjects];
                                                 self.photoName = nil;
                                                 self.photo = nil;
                                             }];
                        [alert addAction:ok];
                        
                        UIAlertAction *cancel = [UIAlertAction
                                                 actionWithTitle:GENERAL_ALERT_CANCEL_BUTTON_TEXT
                                                 style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction * action)
                                                 {
                                                     //Do some thing here
                                                     [self dismissViewControllerAnimated:YES completion:nil];
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
