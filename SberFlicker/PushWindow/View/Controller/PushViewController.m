//
//  PushViewController.m
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "PushViewController.h"
@import UserNotifications;

@interface PushViewController ()

@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addCustomActions];
    [self historyLocalNotification];
    [self.view setBackgroundColor:UIColor.whiteColor];
    [self addButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self removeSearchBar];
}

- (void)addButtons
{
    CGFloat buttonHeight = 80.0f;
    CGFloat buttonWidth = 200.0f;
    
    UIButton *historyPushButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - buttonWidth / 2, self.view.center.y - buttonHeight - 15.0f, buttonWidth, buttonHeight)];
    [historyPushButton addTarget:self action:@selector(historyLocalNotification) forControlEvents:UIControlEventTouchUpInside];
    [historyPushButton setTitle:@"History push" forState:UIControlStateNormal];
    [historyPushButton setBackgroundColor:UIColor.redColor];
    
    UIButton *randomPushButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x - buttonWidth / 2, self.view.center.y + 15.0f, buttonWidth, buttonHeight)];
    [randomPushButton addTarget:self action:@selector(randomLocalNotification) forControlEvents:UIControlEventTouchUpInside];
    [randomPushButton setTitle:@"Random push" forState:UIControlStateNormal];
    [randomPushButton setBackgroundColor:UIColor.greenColor];
    
    [self.view addSubview:historyPushButton];
    [self.view addSubview:randomPushButton];
}

- (void)removeSearchBar
{
    NSArray *array = self.navigationController.navigationBar.subviews;
    for (int i = 0; i < array.count; i++)
    {
        UIView *view = array[i];
        if ([view isKindOfClass:UISearchBar.class])
        {
            [view removeFromSuperview];
        }
    }
}

- (void)addCustomActions
{
    UNNotificationAction *checkAction = [UNNotificationAction actionWithIdentifier:@"Check" title:@"Check" options:UNNotificationActionOptionNone];
    UNNotificationAction *destrAction = [UNNotificationAction actionWithIdentifier:@"Delete" title:@"Ignore" options:UNNotificationActionOptionDestructive];
    
    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:@"BasicCategory" actions:@[checkAction, destrAction] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
    NSSet *categories = [NSSet setWithObject:category];
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center setNotificationCategories:categories];
}

- (void)historyLocalNotification
{
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    [content setTitle:@"Hello dear User!"];
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [content setBadge:@(badgeNumber + 1)];
    NSString *searchRequest = [NSUserDefaults.standardUserDefaults stringForKey:@"searchRequest"];
    NSString *message = [NSString stringWithFormat:@"We accidentally noticed that you have not been looking for %@ for a long time", searchRequest];
    [content setBody:message];
    content.categoryIdentifier = @"BasicContentCategory";
    
    NSDictionary *dict = @{@"searchRequest": searchRequest};
    
    content.userInfo = dict;
    
    UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:(10) repeats: NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UserDefaultsLocalPush" content:content trigger:trigger];
    
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"error");
        }
    }];
}

- (void)randomLocalNotification
{
    NSArray *array = @[@"nasa",
                       @"football",
                       @"tesla",
                       @"twitter",
                       @"nature",
                       @"cat",
                       @"dog",
                       @"zebra",
                       @"horse",
                       @"sky"];
    
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    [content setTitle:@"Hello dear User!"];
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    [content setBadge:@(badgeNumber + 1)];
    NSInteger index = arc4random() % array.count;
    NSString *searchRequest = array[index];
    NSString *message = [NSString stringWithFormat:@"We accidentally noticed that you have not been looking for %@ for a long time", searchRequest];
    [content setBody:message];
    content.categoryIdentifier = @"BasicContentCategory";
    
    NSDictionary *dict = @{@"searchRequest": searchRequest};
    
    content.userInfo = dict;
    
    UNNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:(10) repeats: NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"UserDefaultsLocalPush" content:content trigger:trigger];
    
    
    
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error)
        {
            NSLog(@"error");
        }
    }];
}

@end
