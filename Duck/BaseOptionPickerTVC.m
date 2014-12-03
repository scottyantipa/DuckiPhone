//
//  BaseOptionPickerTVC.m
//  Duck
//
//  Created by Scott Antipa on 12/2/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import "BaseOptionPickerTVC.h"

@interface BaseOptionPickerTVC ()

@end

@implementation BaseOptionPickerTVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Base Picker Cell ID"];
    NSString * value = (NSString *)[self.data objectAtIndex:indexPath.row];
    cell.textLabel.text = value;
    if ([value isEqualToString:self.selectedValue]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didFinishPickingWithValue:(NSString *)[self.data objectAtIndex:indexPath.row]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
