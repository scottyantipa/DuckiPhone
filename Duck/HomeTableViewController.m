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
        Bottle *bottle = [Bottle newBlankBottleInContext:_managedObjectContext];
        [segue.destinationViewController setBottle:bottle];
        bottle.userHasBottle = [NSNumber numberWithBool:YES];
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
    }
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
    NSLog(@"Result Text: %@", resultText);
    
    // Check and see if there is a bottle with that barcode
    Bottle * bottle = [Bottle bottleForBarcode:resultText inManagedObjectContext:_managedObjectContext];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BottleDetailTableViewController * bottleTVC = [storyboard instantiateViewControllerWithIdentifier:@"BottleDetailStoryBoardID"];
    [bottleTVC setBottle:bottle];
    [bottleTVC setManagedObjectContext:_managedObjectContext];
    [self.navigationController pushViewController:bottleTVC animated:YES];
    
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
@end
