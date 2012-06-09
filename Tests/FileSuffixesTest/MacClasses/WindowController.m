//
//  WindowController.m
//  FileSuffixesTest
//
//  Created by Nick Lockwood on 09/06/2012.
//  Copyright (c) 2012 Charcoal Design. All rights reserved.
//

#import "WindowController.h"
#import "StandardPaths.h"


@implementation WindowController

@synthesize imageView1;
@synthesize imageView2;

- (void)awakeFromNib
{    
    //NOTE: we are not using [[NSImage alloc] initWithContentsOfFile:...] here
    //to avoid conflicts with built-in @2x suffix handling behaviour
    
    //load image 1
    NSString *path1 = [[NSFileManager defaultManager] normalizedPathForFile:@"image1.png"];
    NSData *data1 = [NSData dataWithContentsOfFile:path1];
    NSImage *image1 = [[NSImage alloc] initWithData:data1];
    CGFloat scale = [path1 scale];
    image1.size = CGSizeMake(image1.size.width / scale, image1.size.width / scale);
    self.imageView1.image = image1;
    
    //load image 2
    NSString *path2 = [[NSFileManager defaultManager] normalizedPathForFile:@"image2.png"];
    NSData *data2 = [NSData dataWithContentsOfFile:path2];
    NSImage *image2 = [[NSImage alloc] initWithData:data2];
    image2.size = CGSizeMake(image2.size.width / scale, image2.size.width / scale);
    self.imageView2.image = image2;
}

@end
