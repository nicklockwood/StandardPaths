//
//  NSFileManager+StandardPaths.h
//
//  Version 1.1
//
//  Created by Nick Lockwood on 10/11/2011.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from either of these locations:
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
    
    //append offline data folder
    folder = [folder stringByAppendingPathComponent:@"Offline Data"];
    
    //create the folder if it doesn't exist
	if (![self fileExistsAtPath:folder])
    {
		[self createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:NULL];
	}
    
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#ifdef __IPHONE_5_1
    
    if (&NSURLIsExcludedFromBackupKey && [NSURL instancesRespondToSelector:@selector(setResourceValue:forKey:error:)])
    {
        //use iOS5.1 method to exclude file from backp
        NSURL *fileURL = [NSURL fileURLWithPath:folder isDirectory:YES];
        [fileURL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:NULL];
    }
    else
        
#endif
        
    {
        //use the iOS5.0.1 mobile backup flag to exclude file from backp
        u_int8_t b = 1;
        setxattr([folder fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
    }
    
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

- (NSString *)pathForPublicFile:(NSString *)file
{
	return [[self publicDataPath] stringByAppendingPathComponent:file];
}

- (NSString *)pathForPrivateFile:(NSString *)file
{
    return [[self privateDataPath] stringByAppendingPathComponent:file];
}

- (NSString *)pathForCacheFile:(NSString *)file
{
    return [[self cacheDataPath] stringByAppendingPathComponent:file];
}

- (NSString *)pathForOfflineFile:(NSString *)file
{
    return [[self offlineDataPath] stringByAppendingPathComponent:file];
}

- (NSString *)pathForTemporaryFile:(NSString *)file
{
    return [[self temporaryDataPath] stringByAppendingPathComponent:file];
}

- (NSString *)pathForResource:(NSString *)file
{
    return [[self resourcePath] stringByAppendingPathComponent:file];
}

@end
