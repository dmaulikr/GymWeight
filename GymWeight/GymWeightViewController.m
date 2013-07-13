//
//  GymWeightViewController.m
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 30..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import "GymWeightViewController.h"
#import "Outfit.h"

@interface GymWeightViewController ()
@property (nonatomic, assign) NSInteger cellIndex;

-(void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer;

@end

@implementation GymWeightViewController

- (void) addGym
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"init"]) {
        NSLog(@"먼가 있으니 그거 날려버리겠다.");
        [userDefault removeObjectForKey:@"init"];
        [userDefault synchronize];
    } else {
        NSLog(@"아무것도 없어서 할게 없당...");
    }
    return;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    self.title = @"Gym Weight";

    self.addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addGym)];
    
    self.navigationItem.leftBarButtonItem= self.editButtonItem;
    self.navigationItem.rightBarButtonItem = self.addButton;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Outfit"];
    NSError *error = nil;
     NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (mutableFetchResults == nil) {
        // error handling
    }
    
    self.outfitsArray = mutableFetchResults;
    self.outfitsTempWeight = [self.outfitsArray valueForKeyPath:@"weight"];
    
    self.tableView.allowsSelection = NO;
    self.cellIndex = 0;
    
    // gesture recognizer
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [recognizer setMaximumNumberOfTouches:1];
    [recognizer setDelegate:self];
    [self.tableView addGestureRecognizer:recognizer];
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    //NSLog(@"did swipe called %@", gestureRecognizer);
    
    CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    //UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.cellIndex = swipedIndexPath.row;
    }
    
    Outfit *outfit = [self.outfitsArray objectAtIndex:self.cellIndex];
    
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translationInView = [gestureRecognizer translationInView:self.tableView];
        // NSLog(@"%ld번째 셀, x좌표 이동은 %f, y좌표 이동은 %f", (long)self.cellIndex, translationInView.x, translationInView.y);
        // 일단 어레이 원래 값은 계속 보존되어야 해.
        // 그리고 어레이에서 해당 값을 가져오장.
        
        // 계산값 설정
        
        // 스텝화 시킨 x 분할값 넣기
        NSInteger translationXStep = floor(translationInView.x / 20) * 5;
        // 너무 한번에 확 안늘게 하기
        
        
        
        //NSInteger computedValue = [outfit.weight integerValue] + translationXStep;
    
        NSInteger computedValue =  [[self.outfitsTempWeight objectAtIndex:swipedIndexPath.row] integerValue] + translationXStep;
        
        //NSLog(@"%ld", (long)computedValue);
        if (computedValue < 0) {
            computedValue = 0;
        }
        // 값에 따라 해당 모델을 바꿨땅.
        [outfit setWeight:[NSNumber numberWithInt:computedValue]];
        
        // 뷰 리프레쉬
        [self.tableView reloadRowsAtIndexPaths:@[swipedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //NSLog(@"%@",outfit.weight);
        
    }
    
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.outfitsTempWeight = [self.outfitsArray valueForKeyPath:@"weight"];
        
        NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"save error!");
        }
        
    }
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    UIView *cell = [gestureRecognizer view];
    UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint translation = [panGestureRecognizer translationInView:[cell superview]];
    
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y))
    {
        return YES;
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.outfitsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Outfit *outfit = (Outfit *)[self.outfitsArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@lb", outfit.weight];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:47];
    cell.textLabel.textColor = [UIColor colorWithRed:.4 green:.4 blue:.4 alpha:1.0];
    
    cell.detailTextLabel.text = outfit.name;
    cell.detailTextLabel.font = [cell.detailTextLabel.font fontWithSize:14];
    
//    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
//    [recognizer setMaximumNumberOfTouches:1];
//    [recognizer setDelegate:self];
//    [cell addGestureRecognizer:recognizer];

    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 93.0;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
