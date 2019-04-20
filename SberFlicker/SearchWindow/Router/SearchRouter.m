//
//  SearchRouter.m
//  SberFlicker
//
//  Created by Сергей Грызин on 20/04/2019.
//  Copyright © 2019 Сергей Грызин. All rights reserved.
//

#import "SearchRouter.h"
#import "PushViewController.h"

@interface SearchRouter ()

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation SearchRouter

- (void)setNavVC:(UINavigationController *)navVC
{
    self.navigationController = navVC;
}

- (void)showPushNotificationsWindow
{
    PushViewController *pushVC = [PushViewController new];
    [self.navigationController pushViewController:pushVC animated:YES];
}

- (void)showCurrentPicture:(PhotoModel *)picture
{
    
}

@end
