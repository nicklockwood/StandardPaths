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
    //load image 1
    self.imageView1.image = [NSImage imageNamed:@"Image1"];
    
    //load image 2
    NSString *path = [[NSFileManager defaultManager] normalizedPathForFile:@"Image2"];
    CGFloat scale = [path scaleFromSuffix];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:path];
    image.size = CGSizeMake(image.size.width / scale, image.size.width / scale);
    self.imageView2.image = image;
}

@end
