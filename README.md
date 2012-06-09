Purpose
-------------

iOS and the Mac App Store place quite strict conditions on where files should be stored, but it's not always clear where the right place is. As of iOS 5 and iOS 5.0.1 it's even more complex because of the need to ensure that certain files aren't backed up to iCloud or aren't wiped out when the device gets full.

Also, since the advent of Retina displays and hybrid apps, it is often quite complex to identify the correct file path for resources such as images or nib files because on different devices they may have different suffixes such as @2x or ~ipad, and whilst many iOS and Mac OS APIs manage these suffixes automatically, they do so in an inconsistent and opaque way.

StandardPaths provides a simple set of NSFileManager and NSString extension methods to access files in a clear and consistent way across platforms, and abstracts the complexities of applying file suffixes for Retina graphics and the mobile backup attribute to disable iCloud backup on iOS 5 and above.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 5.1 / Mac OS 10.7 (Xcode 4.3.2)
* Earliest supported deployment target - iOS 4.0 / Mac OS 10.6
* Earliest compatible deployment target - iOS 4.0 / Mac OS 10.6

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

StandardPaths work with both ARC and non-ARC projects. There is no need to exclude StandardPaths files from the ARC validation process, or to convert StandardPaths using the ARC conversion tool.


Thread Safety
--------------

You can call the StandardPaths methods safely from any thread.


Installation
--------------

To use the StandardPaths in your project, just drag the StandardPaths.h and .m files into your project. It has no dependencies.


NSFileManager extension methods
--------------------------------

StandardPaths extends NSFileManager with a collection of useful standard directories. Most methods come in two versions, one that returns just the path to the directory and a second that returns a path for a specific file name or path fragment within that directory. In the interests of concision, these methods are paired together in the documentation below.

	- (NSString *)publicDataPath;
	- (NSString *)pathForPublicFile:(NSString *)file;
	
Return the path for the user `Documents` folder. On iOS this a good place to store user-created documents. You can make these documents available for the user to access through iTunes by setting `UIFileSharingEnabled` to YES in the application's Info.plist. For this reason it's a bad idea to store private application data files in the `Documents` folder as you lose this flexibility. You should store these in `Library/Application Support` instead. Note also that the Mac App Store sandbox rules prohibit accessing files in `Documents` without requesting explicit permission from the user.

	- (NSString *)privateDataPath;
	- (NSString *)pathForPrivateFile:(NSString *)file;
	
Returns the path for `Library/Application Support` on iOS, or `Library/Application Support/<AppName>` on Mac OS and creates it if it does not exist. This is a good place to store application data files that are not user editable and so shouldn't be stored in the `Documents` folder.

	- (NSString *)cacheDataPath;
	- (NSString *)pathForCacheFile:(NSString *)file;
	
Returns the path to the Application's `Library/Caches` folder. On Mac OS, the path will include a subfolder named after the Application's bundle ID to prevent namespace collisions. If your app downloads data from the Internet, or caches the result of expensive calculations, this is a good place to store the result. On iOS 5 and above these files will be deleted automatically when the device runs low on space, so if the data is important you should store it using the `offlineDataPath` instead.

	- (NSString *)offlineDataPath;
	- (NSString *)pathForOfflineFile:(NSString *)file;

Returns the path for `Library/Application Support/Offline Data` on iOS, or `Library/Application Support/<AppName>/Offline Data` on Mac OS and creates it if it does not exist. This is not a standard defined path, but it is a safe place to put cache files that you do not wish to be automatically deleted when the device runs low on disk space. On iOS 5.0.1 the `com.apple.MobileBackup` attribute is set on this folder to prevent it from being automatically backed up to iCloud. This flag is deprecated in iOS 5.1, so when compiling for 5.1 and above, a new API is used. These mechanisms are not available prior to iOS 5.0.1, so users on iOS 5.0 will find that these files are synced to their cloud space. Previous releases of the StandardPaths library stored offline data files in `Library/Caches`, but this would cause inconvenience for users upgrading from iOS 4/5 to 5.0.1 that is probably not justified, so as of version 1.1, offlineDataPath no longer does this.
	
	- (NSString *)temporaryDataPath;
	- (NSString *)pathForTemporaryFile:(NSString *)file;
	
Returns the path for the temporary data folder. This is a good place to store temporary files e.g. during some complex process where the data can't all fit in memory. Files stored here *may* be deleted automatically when the application is closed, or when the device runs low on memory, but it's a good idea to delete them yourself anyway when you've finished with them.

	- (NSString *)resourcePath;
	- (NSString *)pathForResource:(NSString *)file;
	
Returns the path for files in the application resources folder. This basically just maps to `[[NSBundle mainBundle] resourcePath]`. Files in this folder are read-only. Note that unlike the `[[NSBundle mainBundle] pathForResource:ofType:]` method, `pathForResource:` does not return nil if the file does not exist.

    - (NSString *)normalizedPathForFile:(NSString *)fileOrPath;

This method serves several functions. Firstly, it can take a path fragment or file name and convert it to a complete path by prefixing the application bundle resources path. Secondly, it replicates the behaviours of Mac OS and iOS when finding different versions of resource files such as @2x image files and files suffixed with ~ipad or ~iphone. These behaviours will work with any file, not just images or nibs, so it can be useful if you want to load @2x versions of 3D models or shaders for OpenGL applications without writing a lot of branching code. Additionally, this method also implements a few pseudo-standards such as the Cocos2D -hd suffix to indicate image files that should be used both for Retina iPhones and standard definition iPads/Macs. Finally, it correctly maps .png image paths to the multi-page TIFF files used on Mac OS 10.7 for handling standard and Retina scale images. Unlike the other NSFileManager extension methods, this method will return nil if the file does not exist. This method makes multiple filesystem calls, so may be relatively slow the first time it is called for each path, however it caches the result for a given input so the next time it will be faster. See the Image file suffixes section below for more information.


NSString extension methods
-----------------------------

StandardPaths extends NSString with some additional methods for manipulating file paths by adding, deleting and retrieving the standard and pseudo-standard path extensions used for Retina-resolution images and device-specific resources. See the Image file suffixes section below for more information.

    - (NSString *)stringByAppendingInterfaceIdiomSuffix;
    
This method appends the user interface idiom suffix for the current device (~ipad, ~iphone or ~mac) to the string. If the string includes a file extension, the suffix is correctly inserted before the file extension. See the Image file suffixes section below for more information.
    
    - (NSString *)stringByDeletingInterfaceIdiomSuffix;
    
This method removes the user interface idiom suffix from the string if present, or does nothing if a suffix is not found.
    
    - (NSString *)interfaceIdiomSuffix;
    
This method returns the user interface idiom suffix if found, or @"" if not.

    - (UIUserInterfaceIdiom)interfaceIdiom;

This method returns the UIUserInterfaceIdiom value specified by a file's interface idiom suffix (if found). If no suffix is found it returns the current device idiom. UIUserInterfaceIdiom is part of UIKit, and isn't defined on Mac OS, so StandardPaths defines these constants if running on Mac OS, and adds an additional UIUserInterfaceIdiomDesktop constant to represent the Mac OS desktop idiom. This implementation is compatible with the one used by the Chameleon iOS-Mac conversion library, so you should be able to use both libraries together.
    
     - (NSString *)stringByAppendingScaleSuffix;
    
This method appends an @2x suffix to the string if the device has a Retina display. The method correctly handles file extensions and device type suffixes, so the @2x will be inserted before the file extension or device type suffix if present. See the Image file suffixes section below for more information.
    
    - (NSString *)stringByDeletingScaleSuffix;
    
This method removes the @2x suffix from a file path, or does nothing if the suffix is not found.
    
    - (NSString *)scaleSuffix;
    
This method returns the @2x suffix if found, or @"" if not.
    
    - (CGFloat)scale;
    
This method returns the image scale value for a file path as a floating point number, e.g. 2.0f if the file includes an -hd suffix (on iPhone) or @2x suffix and 1.0f if it doesn't.
    
    - (NSString *)stringByAppendingHDSuffix;
    
This method appends the -hd suffix to the string if the device is a Retina display iPhone or is an iPad or Mac, and does nothing if it isn't. See the Image file suffixes section below for more information.
    
    - (NSString *)stringByDeletingHDSuffix;
    
This method deletes the -hd suffix from the string if found, or does nothing if the suffix is not found.
    
    - (NSString *)HDSuffix;
    
This method returns @"-hd" if the string has the -hd suffix and @"" if it doesn't.
    
    - (BOOL)isHD;

This method returns YES if the string has an -hd suffix and NO if it doesn't.


Image file suffixes
--------------------

Mac OS and iOS have a clever mechanism for managing multiple versions of assets by using file suffixes. The first iPad introduced the ~ipad suffix for specifying ipad-specific versions of files (e.g. foo~ipad.png). The iPhone 4 introduced the @2x suffix for managing double-resolution images for Retina displays (e.g. foo@2x.png). With the 3rd generation iPad you can combine these to have Retina-quality iPad images (e.g. foo@2x~ipad.png). As of Mac OS 10.7, the same @2x image naming is supported, presumably to support (as-yet unreleased) Retina Macs, although there is also a secondary convention in place on Mac OS, where standard def and @2x images are merged into a single multi-page TIFF file.

This file naming convention is an elegant solution for apps, but is sometimes insufficient for games because, unlike apps, hybrid games often share near-identical interfaces on iPhone, iPad and Mac, with the assets and interface elements simply scaled up, and this means that the standard definition iPad/Mac and the Retina resolution iPhone need to use the same images.

Naming your images with the @2x suffix works for the Retina iPhone but not the standard def iPad or Mac, and naming them with the ~ipad suffix works for iPad but not iPhone, which forces you to either duplicate identical assets with different filenames, or to write your own file loading logic.

The -hd suffix is a solution introduced by the Cocos2D library to the problem of wanting to use the same 2x graphics for both the iPhone Retina display and the iPad standard definition display by using the same -hd filename suffix for both.

StandardPaths supports this solution by adding some utility methods to NSString for automatically applying this suffix to file paths when using the `normalizedFilePath:` method. Files using the @2x, ~ipad and -hd conventions (or any combination thereof) are automatically detected and loaded as appropriate. For example, If you pass in an image file called foo.png, GLImage will automatically look for foo@2x.png or foo-hd.png on a Retina iPhone, or foo~ipad.png or foo-hd.png on an iPad and will also find foo-hd@2x.png if you are using a Retina iPad. For cross-platform consistency, StandardPaths also extends these concepts to Mac OS by introducing a ~mac suffix, and treating Mac the same way as iPad with respect to the -hd suffix. It will also look for multi-page TIFF file alternatives as appropriate.


Usage
-----------

As long as you have included the NSFileManager+StandardPaths.h file, you can call any of the methods above on any instance of NSFileManager. For example, if you wanted to get the path to a file called "Foo.bar" in the cache folder, you could write either of the following:

    NSString *path = [[NSFileManager defaultManager] pathForCacheFile:@"Foo.bar"];
    NSString *path = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent:@"Foo.bar"];
    
To get a normalized file path within the application bundle, you an use just the file name, e.g.

    NSString *path = [[NSFileManager defaultManager] normalizedPathForFile:@"Foo.png"];
    
To get a normalized file path that is not inside the application bundle, either use an absolute file path, or use one of the other methods to first convert the path to an absolute path before normalizing, e.g.

    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [manager normalizedPathForFile:[manager publicDataPath:@"Foo.png"]];
    
Note that file lookups outside of the application bundle are not cached (as the files are not changed) so it is more CPU-intensive to use `normalizedPathForFile:` for these files. If you are accessing the same file multiple times, you may wish to cache the path yourself rather than calling the method multiple times.
