//
//  NSFileManager+StandardPaths.m
//
//  Version 1.0
//
//  Created by Nick Lockwood on 10/11/2011.
//  Copyright 2010 Charcoal Design. All rights reserved.
//
//  Get the latest version of iCarousel from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#standardpaths
//  https://github.com/nicklockwood/StandardPaths
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
//

#import "NSFileManager+StandardPaths.h"
#include <sys/xattr.h>


@implementation NSFileManager (StandardPaths)

- (NSString *)publicDataPath
{
    //user documents folder
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];  
}

- (NSString *)privateDataPath
{
    //application support folder
	NSString *folder = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    //append application name on Mac OS
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    folder = [folder stringByAppendingPathComponent:identifier];
    
#endif
    
    //create the folder if it doesn't exist
	if (![self fileExistsAtPath:folder])
    {
		[self createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	return folder;
}

- (NSString *)cacheDataPath
{
    //get the cache folder path
	NSString *folder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    //append application bundle ID on Mac OS
    NSString *identifier = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    folder = [folder stringByAppendingPathComponent:identifier];
    
#endif
    
    //create the folder if it doesn't exist
	if (![self fileExistsAtPath:folder])
    {
		[self createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
	
	return folder;
}

- (NSString *)offlineDataPath
{
    //get application support folder
    NSString *folder = [self privateDataPath];
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

    if ([[[UIDevice currentDevice] systemVersion] compare:@"5.0.1" options:NSNumericSearch] == NSOrderedAscending)
    {
    	//store in Library/Caches to avoid wasting iCloud space
        return [self cacheDataPath];
    }
    
#endif
    
    //append offline data folder
    folder = [folder stringByAppendingPathComponent:@"Offline Data"];
    
    //create the folder if it doesn't exist
	if (![self fileExistsAtPath:folder])
    {
		[self createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
    
    //set the mobile backup flag to prevent files in this folder being backed up
    u_int8_t b = 1;
    setxattr([folder fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
    
#endif
    
    return folder;
}

- (NSString *)temporaryDataPath
{
    return NSTemporaryDirectory();
}

- (NSString *)resourcePath
{
    return [[NSBundle mainBundle] resourcePath];
}

@end
