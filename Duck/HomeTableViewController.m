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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Inventory"]) {
        [segue.destinationViewController setManagedObjectContext:_managedObjectContext];
    }
    else if ([segue.identifier isEqualToString:@"New Bottle"]) {
        Bottle *bottle = [Bottle newBottleForName:@"New Bottle" inManagedObjectContext:_managedObjectContext];
        [segue.destinationViewController setBottle:bottle];
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
    } else if ([segue.identifier isEqualToString:@"Show Vendors Segue ID"]) {
        VendorsTableViewController * tvc = [segue destinationViewController];
        tvc.managedObjectContext = _managedObjectContext;
    }
}

#pragma Delegate methods

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id <NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;

    // EXAMPLE: just grab the first barcode
    for(symbol in results)
        break;
    
    // EXAMPLE: do something useful with the barcode data
    NSString * resultText = symbol.data;
//    NSLog(@"Result Text: %@", resultText );
    
    // Check and see if there is a bottle with that barcode
    Bottle * bottle = [Bottle bottleForBarcode:resultText inManagedObjectContext:_managedObjectContext];
//    BottleDetailTableViewController * bottleTVC = [BottleDetailTableViewController new];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    BottleDetailTableViewController * bottleTVC = [storyboard instantiateViewControllerWithIdentifier:@"BottleDetailStoryBoardID"];
    [bottleTVC setBottle:bottle];
    [bottleTVC setManagedObjectContext:_managedObjectContext];
    [self.navigationController pushViewController:bottleTVC animated:YES];
    
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissViewControllerAnimated:YES completion:nil];
}

#pragma Outlets/Actions
- (IBAction)didPressScanButton:(id)sender {

    // ADD: present a barcode reader that scans from the camera feed
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
@end
