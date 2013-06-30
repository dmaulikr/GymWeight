//
//  Outfit.h
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 30..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Outfit : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * weight;

@end
