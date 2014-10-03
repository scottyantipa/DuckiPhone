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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Inventory"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"Take Inventory"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
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
    }
}

-(void)showBottleDetail:(Bottle *)bottle {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BottleDetailTableViewController * bottleTVC = [storyboard instantiateViewControllerWithIdentifier:@"BottleDetailStoryBoardID"];
    [bottleTVC setBottle:bottle];
    [bottleTVC setManagedObjectContext:_managedObjectContext];
    [self.navigationController pushViewController:bottleTVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma Delegate methods

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;

    // just grab the first symbol
    for(symbol in results)
        break;
    
    NSString * resultText = symbol.data;
    _currentScannedBottleBarcode = resultText;
    
    // Check and see if there is a bottle with that barcode
    Bottle * bottle = [Bottle bottleForBarcode:resultText inManagedObjectContext:_managedObjectContext];
    
    // If bottle isnt in global db, ask if user wants to create it
    if (!bottle) {
        UIAlertView * noBottleAlertView = [[UIAlertView alloc] initWithTitle:@"We don't have record of this bottle" message:nil delegate:self cancelButtonTitle:@"Add Bottle" otherButtonTitles:@"Cancel", nil];
        noBottleAlertView.tag = 1;
        [noBottleAlertView show];
    } else {
        [self showBottleDetail:bottle];
    }
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma Outlets/Actions
- (IBAction)didPressScanButton:(id)sender {
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    // Disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController: reader
                        animated: YES
                        completion:nil
     ];
}

// Alert View
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) { // its the "No Bottle" alert from the scanner
        if (buttonIndex == 1) { // the "pick vendor" button
            NSLog(@"buttonIndex 1");
        } else if (buttonIndex == 2) {
            NSLog(@"buttonIndex 2");
        } else if (buttonIndex == 0) {
            Bottle *newBottle = [Bottle newBottleForBarcode:_currentScannedBottleBarcode inManagedObjectContext:_managedObjectContext];
            newBottle.userHasBottle = [NSNumber numberWithBool:YES];
            [self showBottleDetail:newBottle];
        }
    }
}

@end
