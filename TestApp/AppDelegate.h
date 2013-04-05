//
//  AppDelegate.h
//  TestApp
//
//  Created by Eugene Vegner on 04.04.13.
//  Copyright (c) 2013 Eugeny Vegner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@class SecondViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate




>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MainViewController *mainViewController;
@property (strong, nonatomic) SecondViewController *secondViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
