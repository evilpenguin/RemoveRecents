/*
 * Tweak: 	RemoveRecents
 * Version:	0.4.0
 * Creator: EvilPenguin (James Emrich)
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

#pragma mark -
#pragma mark == Public Functions ==

static id RemoveRecentsEditAppListArray(NSArray *array, BOOL isRunningIOS8) {
    if (array.count > 0) {
        NSMutableArray *newAppList = [NSMutableArray array];
        SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
        
        for (id object in array) {
		    NSString *bundleIdentifier = object;

            // iOS8 Support
 	    	if (isRunningIOS8) {
                bundleIdentifier = nil; // set this to nil, so we do not crash below. 
                SBDisplayLayout *displayLayout = (SBDisplayLayout *)object;
                NSDictionary *plistDict = [displayLayout plistRepresentation];
                if (plistDict.count > 0) {
                    NSArray *displayItemsArray = plistDict[@"SBDisplayLayoutDisplayItemsPlistKey"];
                    if (displayItemsArray.count > 0) {
                        NSDictionary *item = displayItemsArray[0];
                        if (item.count > 0) {
                            bundleIdentifier = item[@"SBDisplayItemDisplayIdentifierPlistKey"];
                        }
                    }
                }
			}

            // Move along and remove the apps that are not running :)
        	if ([bundleIdentifier rangeOfString:@"com.apple.springboard"].location != NSNotFound) {
            	[newAppList addObject:object];
       		}
        	else {
           		// Use `applicationWithBundleIdentifier:` so we dont have to loop the array from `applicationsWithBundleIdentifier:`
                if ([appController respondsToSelector:@selector(applicationWithBundleIdentifier:)]) {
					id app = [appController applicationWithBundleIdentifier:bundleIdentifier];
					if ([app isRunning]) [newAppList addObject:object];
				}
				else {
					NSArray *apps = [appController applicationsWithBundleIdentifier:bundleIdentifier];
         			for (id app in apps) {
            	    	if ([app isRunning]) [newAppList addObject:object];
        	    	}
				}
    	    }
        }
        
        return newAppList;
    }

    return array;
}

#pragma mark -
#pragma mark == Hooking ==

// iOS7, iOS8
%hook SBAppSwitcherModel
- (id) snapshot {
    id appList = %orig;
    
    return RemoveRecentsEditAppListArray(appList, kCFCoreFoundationVersionNumber >= 1140.10);
}
%end

%hook SBAppSwitcherController
// iOS 6
- (id) _bundleIdentifiersForViewDisplay {
	id appList = %orig;
	
    return RemoveRecentsEditAppListArray(appList, kCFCoreFoundationVersionNumber >= 1140.10);
}

// iOS 5
- (id) _applicationIconsExceptTopApp {
	id appList = %orig;
	
	NSMutableArray *newAppList = [NSMutableArray array];
	for (SBIconView *iconView in appList) {
		id sbApplication = [iconView.icon application];
        if ([[sbApplication process] isRunning]) [newAppList addObject:iconView];
	}
	
    return newAppList;
}

// iOS 4
- (id) _applicationIconsExcept:(id)application forOrientation:(int)orientation {
	id appList = %orig(application, orientation);

	NSMutableArray *newAppList = [NSMutableArray array];
	for (SBApplicationIcon *icon in appList) {
		if ([[[icon application] process] isRunning]) [newAppList addObject:icon];
	}

    return newAppList;
}
%end

