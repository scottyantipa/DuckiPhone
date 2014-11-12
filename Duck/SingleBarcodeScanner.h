//
//  SingleBarcodeScanner.h
//  Duck
//
//  Created by Scott Antipa on 11/11/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

// Used to scan a single barcode which it returns to it's delegate
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SingleBarcodeScannerDelegate.h"

@interface SingleBarcodeScanner : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic) BOOL isReading; // whether or not the scanner is reading currently
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (weak) id <SingleBarcodeScannerDelegate> delegate;
@end
