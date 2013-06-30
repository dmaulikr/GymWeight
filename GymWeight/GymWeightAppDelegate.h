//
//  GymWeightAppDelegate.h
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 17..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GymWeightAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
