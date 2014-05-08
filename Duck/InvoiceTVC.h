//
//  InvoiceTVC.h
//  Duck
//
//  Created by Scott Antipa on 5/3/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "InvoicePhoto.h"
#import "Tesseract.h"
#import "Bottle+Create.h"
#import "Order+Create.h"

@interface InvoiceTVC : UITableViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) Invoice * invoice;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addPhotoBarButton;
@property (weak, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) NSArray * sortedBottlesInOrder;
@property (weak, nonatomic) NSArray * sortedInvoicePhotos;
@end
