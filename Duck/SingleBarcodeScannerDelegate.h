//
//  SingleBarcodeScannerDelegate.h
//  Duck
//
//  Created by Scott Antipa on 11/11/14.
//  Copyright (c) 2014 Scott Antipa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SingleBarcodeScannerDelegate <NSObject>
-(void)didFindMetaData:(AVMetadataMachineReadableCodeObject *)metaDataObj;
@end
