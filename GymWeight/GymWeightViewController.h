//
//  GymWeightViewController.h
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 30..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GymWeightViewController : UITableViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIBarButtonItem *addButton;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSMutableArray *outfitsArray;
@property (nonatomic, strong) NSMutableArray *outfitsTempWeight;

-(void) addGym;
@end
