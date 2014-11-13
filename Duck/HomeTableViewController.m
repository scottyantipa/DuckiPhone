//
//  HomeTableViewController.m
//  Duck03
//
//  Created by Scott Antipa on 8/24/13.
//  Copyright (c) 2013 Scott Antipa. All rights reserved.
//

#import "HomeTableViewController.h"


@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize currentScannedBottleBarcode = _currentScannedBottleBarcode;
@synthesize mostRecentFoundBottle = _mostRecentFoundBottle;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Inventory"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"Take Inventory"]) {
        TakeInventoryTVC * tvc = (TakeInventoryTVC *)[[segue destinationViewController] topViewController];
        [tvc setManagedObjectContext:_managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"New Order Segue ID"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"Show Past Orders Segue ID"]) {
        PastOrdersTableViewController * vc = [segue destinationViewController];
        vc.managedObjectContext = _managedObjectContext;
    } else if ([segue.identifier isEqualToString:@"Show All Invoices Segue ID"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    } else if ([segue.identifier isEqualToString:@"Show Losses"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    } else if ([segue.identifier isEqualToString:@"ShowBottleDetailsFromHome"]) {
        BottleDetailTableViewController * bottleTVC = (BottleDetailTableViewController*)[[segue destinationViewController] topViewController];
        [bottleTVC setBottle:_mostRecentFoundBottle];
        [bottleTVC setManagedObjectContext:_managedObjectContext];
        bottleTVC.delegate = self;
    } else if ([segue.identifier isEqualToString:@"Show Single Barcode Reader"]) {
        SingleBarcodeScanner * scanner = (SingleBarcodeScanner *)[[segue destinationViewController] topViewController];
        scanner.delegate = self;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma Delegate methods

-(void)didFindMetaData:(AVMetadataMachineReadableCodeObject *)metaDataObj
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void) {
        NSString * barcode = [metaDataObj stringValue];
        _currentScannedBottleBarcode = barcode;
        Bottle * bottle = [Bottle bottleForBarcode:barcode inManagedObjectContext:_managedObjectContext];
        if (!bottle) {
            UIAlertView * noBottleAlertView = [[UIAlertView alloc] initWithTitle:@"We don't have record of this bottle" message:nil delegate:self cancelButtonTitle:@"Add Bottle" otherButtonTitles:@"Cancel", nil];
            noBottleAlertView.tag = 1;
            [noBottleAlertView show];
        } else {
            _mostRecentFoundBottle= bottle;
            [self performSegueWithIdentifier:@"ShowBottleDetailsFromHome" sender:nil];
        }
    }];

}


// Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) { // its the "No Bottle" alert from the scanner
        if (buttonIndex == 0) {
            Bottle *newBottle = [Bottle newBottleForBarcode:_currentScannedBottleBarcode inManagedObjectContext:_managedObjectContext];
            newBottle.userHasBottle = [NSNumber numberWithBool:YES];
            _mostRecentFoundBottle = newBottle;
            [self performSegueWithIdentifier:@"ShowBottleDetailsFromHome" sender:nil];
        }
    }
}

-(void)didFinishEditingBottle:(Bottle *)bottle {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
