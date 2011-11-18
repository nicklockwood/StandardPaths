Purpose
-------------

iOS and the Mac App Store place quite strict conditions on where files should be stored, but it's not always clear where the right place is. As of iOS 5 and iOS 5.0.1 it's even more complex because of the need to ensure that certain files aren't backed up to iCloud or aren't wiped out when the device gets full.

StandardPaths provides a simple set of NSFileManager extension methods to access these folders in a clear and consistent way, and abstracts the complexities of applying the `com.apple.MobileBackup` attribute.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 5.0 (Xcode 4.2)
* Earliest supported deployment target - iOS 4.0 (Xcode 4.2)
* Earliest compatible deployment target - iOS 3.0

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


Installation
--------------

To use the StandardPaths in your project, just drag the category files into your project. It has no dependencies.


NSFileManager extension methods
--------------------------------

	- (NSString *)publicDataPath;
	
Return the path to the user `Documents` folder. On iOS this a good place to store user-created documents. You can make these documents available for the user to access through iTunes by setting `UIFileSharingEnabled` to YES in the application's Info.plist. For this reason it's a bad idea to store private application data files in the `Documents` folder as you lose this flexibility. You should store these in `Library/Application Support` instead. Note also that the Mac App Store sandbox rules prohibit accessing files in `Documents` without requesting explicit permission from the user.

	- (NSString *)privateDataPath;

Returns the path for `Library/Application Support` on iOS, or `Library/Application Support/<AppName>` on Mac OS and creates it if it does not exist. This is a good place to store application data files that are not user editable and so shouldn't be stored in the `Documents` folder.

	- (NSString *)cacheDataPath;
	
Returns the path to the Application's `Library/Caches` folder. On Mac OS, the path will include a subfolder named after the Application's bundle ID to prevent namespace collisions. If your app downloads data from the Internet, or caches the result of expensive calculations, this is a good place to store the result. On iOS 5 and above these files will be deleted automatically when the device runs low on space, so if the data is important you should store it using the `offlineDataPath` instead.

	- (NSString *)offlineDataPath;
	
Returns the path for `Library/Application Support/Offline Data` on iOS, or `Library/Application Support/<AppName>/Offline Data` on Mac OS and creates it if it does not exist. This is not a standard defined path, but it is a safe place to put cache files that you do not wish to be automatically deleted when the device runs low on disk space. On iOS 5.0.1 the `com.apple.MobileBackup` attribute is set on this folder to prevent it from being automatically backed up to iCloud. On iOS 5.0 this attribute is not available, and Apple take a dim view of using up users' iCloud space with cache files, so on iOS 5.0 and earlier this path is mapped back to `Library/Caches/Offline Data` instead.
	
	- (NSString *)temporaryDataPath;
	
Returns the path to the temporary data folder. This is a good place to store temporary files e.g. during some complex process where the data can't all fit in memory. Files stored here will be deleted when the application is closed.

	- (NSString *)resourcePath;
	
Returns the path to files in the application resources folder. This basically just maps to `[[NSBundle mainBundle] resourcePath]`. Files in this folder are read-only.


Usage
-----------

As long as you have included the NSFileManager+StandardPaths.h file, you can call any of the methods above on any instance of NSFileManager. For example, if you wanted to get the path to a file called "Foo.bar" in the cache folder, you would write:

	NSString *path = [[[NSFileManager defaultManager] cacheDataPath] stringByAppendingPathComponent:@"Foo.bar"];