//
//  AppDelegate.m
//  FastRent
//
//  Created by Marvin Avila Kotliarov on 11/16/15.
//  Copyright © 2015 Marvin Avila Kotliarov. All rights reserved.
//

#import "AppDelegate.h"
#import "MainMenuViewController.h"
#import "UIStoryboard+Bundle.h"
#import "FRConfigurationManager.h"
#import "UIImage+AssetImage.h"
#import "FRLanguage.h"
#import "NSDate+FSExtension.h"
#import "FRState.h"
#import "LeftMenuTVC.h"
#import "FRTaskRemainingViewController.h"
#import "FRNotificationManager.h"
#import "FRBooking.h"
#import "FRCalendarBookingViewController.h"
#import "MainNavigationController.h"
#import "FRNotificationsViewController.h"
#import "NSDate+FSExtension.h"
#import "FRGlobals.h"

#define APP_ALERT_TAG 1002

#define SPLASH_TIME 1.2

@interface SplashViewController : UIViewController

@property (nonatomic, retain) UIImageView *splashImage;

@end

@implementation SplashViewController

- (void)viewDidLoad {
    
    _splashImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _splashImage.image = [UIImage assetLaunchImage];
    
    self.view.frame = _splashImage.frame;
    [self.view addSubview:_splashImage];
}

@end

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic, retain) SplashViewController *splashVC;
@property (nonatomic, assign) BOOL splashShowed;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == APP_ALERT_TAG) {
        
        exit(0);
    }
}

- (void) setUpSplash {
    
    // splah image
    [self.window.rootViewController.view addSubview:self.splashVC.view];
    self.splashShowed = YES;
}

- (void) removeSplash {
    
    [self.splashVC.view removeFromSuperview];
    self.splashShowed = NO;
}

bool checkingUrl = false;

- (BOOL)checkSecurity {
    
    if (![self fireActivationDate]) {
        
        [NSTimer scheduledTimerWithTimeInterval:SPLASH_TIME target:self selector:@selector(removeSplash) userInfo:nil repeats:NO];
        return YES;
    }
    
    return NO;
}

- (BOOL)fireActivationDate {
    
    if (!APPLY_ACTIVATION_DATE) {
        
        return NO;
    }
    
    if ([FRConfigurationManager sharedInstance].activationDate == nil) {
        
        [[FRConfigurationManager sharedInstance] setActivationDate];
        return NO;
    }
    else {
        
        NSError *error = [[NSError alloc] init];
        if ([[FRConfigurationManager sharedInstance] fireActivationDate:&error]) {
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GENERAL_ALERT_ERROR_TITLE_TEXT message:error.localizedDescription delegate:self cancelButtonTitle:GENERAL_ALERT_OK_BUTTON_TEXT otherButtonTitles:nil, nil];
                alert.tag = APP_ALERT_TAG;
                [alert show];
            }
            else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:GENERAL_ALERT_ERROR_TITLE_TEXT message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here
                                     }];
                [alert addAction:ok];
                
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            
            return YES;
        }
        else {
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            df.dateFormat = ACTIVATION_DATE_FORMAT;
            NSDate *finalDate = [[df dateFromString:[FRConfigurationManager sharedInstance].activationDate].fs_dateByIgnoringTimeComponents fs_dateByAddingDays:ACTIVATION_PERIOD_IN_DAYS];
            int days = (int)[finalDate.fs_dateByIgnoringTimeComponents fs_daysFrom:[NSDate date].fs_dateByIgnoringTimeComponents];
            NSString *daysStr = [NSString stringWithFormat:@"%d", days];
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_TRIAL_TEXT(daysStr) delegate:self cancelButtonTitle:GENERAL_ALERT_OK_BUTTON_TEXT otherButtonTitles:nil, nil];
                alert.tag = APP_ALERT_TAG;
                [alert show];
            }
            else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:GENERAL_ALERT_INFORMATION_TITLE_TEXT message:LANG_TRIAL_TEXT(daysStr) preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *ok = [UIAlertAction
                                     actionWithTitle:GENERAL_ALERT_OK_BUTTON_TEXT
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         //Do some thing here
                                     }];
                [alert addAction:ok];
                
                [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
            }
            
            return NO;
        }
        
        return NO;
    }
}

- (void)registerAppForLocalNotifications {
    
    if ([FRNotificationManager sharedInstance].registeredForLocalNotifications)
        return;
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        
        
    }
    else {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil]];
    }
}

#pragma mark - Getters and Setters

- (SplashViewController *)splashVC {
    
    if (_splashVC != nil)
        
        return _splashVC;
    
    _splashVC = [[SplashViewController alloc] init];
    
    return _splashVC;
}

#pragma mark - App lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//    [[FRConfigurationManager sharedInstance] updateDeviceIdWord:nil];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
//                                                    message:[NSString stringWithFormat:@"UDID Added %@", [FRConfigurationManager sharedInstance].deviceIdSecretWord]
//                                                   delegate:nil cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
//    
//    [[FRConfigurationManager sharedInstance] updateAppSecretWord:nil];
//    
//    alert = [[UIAlertView alloc] initWithTitle:@"Info"
//                                       message:[NSString stringWithFormat:@"Pass Added %@", [FRConfigurationManager sharedInstance].appSecretWord]
//                                      delegate:nil cancelButtonTitle:@"OK"
//                             otherButtonTitles:nil];
//    [alert show];
//    
//    return YES;
    
    MainMenuViewController *mainVC = [[UIStoryboard mainStoryboard] instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
    
    UINavigationController *mainNavController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = mainNavController;
    [self.window makeKeyAndVisible];
    
    self.splashShowed = NO;
    [self setUpSplash];
    
    if ([self checkSecurity]) {
        
        //Schedule Local Notifications
        UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (!notification) {
            
            [self registerAppForLocalNotifications];
        }
        
        [[FRNotificationManager sharedInstance] scheduleNotifications];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    if (!checkingUrl) {
        
        [self checkSecurity];
        
        [[FRNotificationManager sharedInstance] scheduleNotifications];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
    [FRNotificationManager sharedInstance].registeredForLocalNotifications = YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    
    [[FRNotificationManager sharedInstance] confirmNotification:notification];
    
    UIViewController *wrvc = self.window.rootViewController;
    
    if ([wrvc isKindOfClass:[UINavigationController class]]) {
        
        UIViewController *mmvc = [((UINavigationController *)wrvc).viewControllers objectAtIndex:0];
        
        if ([mmvc isKindOfClass:[MainMenuViewController class]]) {
            
            LeftMenuTVC *leftMenu = (LeftMenuTVC *)((MainMenuViewController *)mmvc).leftMenu;
            [leftMenu.tableView reloadData];
            [leftMenu.notificationsVC reloadInfo];
        }
    }
}

@end
