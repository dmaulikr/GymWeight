//
//  GymWeightViewController.m
//  GymWeight
//
//  Created by 박 성완 on 13. 6. 30..
//  Copyright (c) 2013년 박 성완. All rights reserved.
//

#import "GymWeightViewController.h"
#import "Outfit.h"

@interface GymWeightViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, assign) NSInteger selectedIndex;

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
    
    
    //self.tableView.allowsSelection = NO;
    
    
    self.pickerViewArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 31; i++) {
        [self.pickerViewArray addObject:[NSNumber numberWithInt: i * 5]];
        
    }
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.selectedIndex = -1;
    

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
    static NSString *PickerCellIdentifier = @"Picker";
    
    id arrayItem = [self.outfitsArray objectAtIndex:indexPath.row];
    
    if ([arrayItem isKindOfClass:[Outfit class]]) {
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
        
        return cell;
    } else {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PickerCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PickerCellIdentifier];
        }
        
        [cell addSubview:self.pickerView];
        
        
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id arrayItem = [self.outfitsArray objectAtIndex:indexPath.row];
    
    if (![arrayItem isKindOfClass:[Outfit class]]) {
        return 216.0;
    }
    
    return 93.0;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"현재 인덱스 패스는 %d", indexPath.row);
    id arrayItem = [self.outfitsArray objectAtIndex:indexPath.row];
    
    if ([arrayItem isKindOfClass:[Outfit class]]) {
        // 현재 인덱스 패스 로우 다음 부분에 집어넣는거당...
        
        
        
        // 같지 않으면 분기가 생긴다
        
        // 만약에 지금까지 선택된게 있었다면?
        if (self.selectedIndex != -1) {
            
            // 인덱스가 같으면 무선택 상태로.
            if (self.selectedIndex == indexPath.row) {
                [self.outfitsArray removeObjectAtIndex:self.selectedIndex+1];
                NSIndexPath *willBeDeletedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex+1 inSection:0];
                
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:willBeDeletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tableView deselectRowAtIndexPath:indexPath animated:NO];
                [self.tableView endUpdates];
                
                self.selectedIndex = -1;
            } else {
                // 삭제와 추가가 동시에.
                [self.outfitsArray removeObjectAtIndex:self.selectedIndex+1];
                if (indexPath.row > self.selectedIndex) {
                    [self.outfitsArray insertObject:[[NSObject alloc] init] atIndex:indexPath.row];
                } else {
                    [self.outfitsArray insertObject:[[NSObject alloc] init] atIndex:indexPath.row+1];
                }
                
                
                NSIndexPath *willBeDeletedIndexPath = [NSIndexPath indexPathForRow:self.selectedIndex+1 inSection:0];
                NSIndexPath *nextIndexPath;
                if (indexPath.row > self.selectedIndex) {
                    nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                } else {
                    nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
                }
                
                
                [self.tableView beginUpdates];
                
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:nextIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:willBeDeletedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                [self.tableView endUpdates];
                
                if (indexPath.row > self.selectedIndex) {
                    self.selectedIndex = indexPath.row-1;
                } else {
                    self.selectedIndex = indexPath.row;
                }
                
                [self.pickerView selectRow:[self getCurrentRow:self.selectedIndex] inComponent:0 animated:NO];
                
                // 디텍팅
                [self scrollWithIndexPath:nextIndexPath];
            }

        } else {
        // 만약에 지금까지 선택된게 없었다면?
            
            [self.outfitsArray insertObject:[[NSObject alloc] init] atIndex:indexPath.row+1];
            
            // 새 인덱스 패스를 만들어준다.
            [self.tableView beginUpdates];
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:nextIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
            
            self.selectedIndex = indexPath.row;
            [self.pickerView selectRow:[self getCurrentRow:self.selectedIndex] inComponent:0 animated:NO];
            
            // 디텍팅
            [self scrollWithIndexPath:nextIndexPath];
        }
        
        
    } else {
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    //NSLog(@"현재 selectedIndex 는 %d", self.selectedIndex);
}

- (void) scrollWithIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:indexPath];
    cellRect = [self.tableView convertRect:cellRect toView:self.tableView.superview];
    BOOL completelyVisible = CGRectContainsRect(self.tableView.frame, cellRect);
    if (!completelyVisible) {
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (NSInteger) getCurrentRow:(NSInteger)index
{
    //일단 outfit을 가져온다. 무게도 가져온다.
    Outfit *outfit = (Outfit *)[self.outfitsArray objectAtIndex:index];
    NSInteger weight = [[outfit weight] integerValue];
    
    // 무게를 통해서 나눈다.
    return weight / 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [self.pickerViewArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSNumber *number = [self.pickerViewArray objectAtIndex:row];
    return [NSString stringWithFormat:@"%@ lb",number];//Or, your suitable title; like Choice-a, etc.
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // 교체할 숫자 받기
    NSNumber *number = [self.pickerViewArray objectAtIndex:row];
    //NSLog(@"으앙 %d", [number integerValue]);
    
    // 오브젝트 받기
    //NSLog(@"%d", self.selectedIndex);
    Outfit *outfit = (Outfit *)[self.outfitsArray objectAtIndex:self.selectedIndex];
    
    //NSLog(@"%@", [outfit name]);
    [outfit setWeight:number];
    
    NSError *error;
    
    if (![self.managedObjectContext save:&error]) {
        // Handle error
    }
    
    // refresh cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.selectedIndex inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    
    
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
