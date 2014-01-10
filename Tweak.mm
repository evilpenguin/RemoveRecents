/*
 * Tweak: 	RemoveRecents
 * Version:	0.3.4
 * Creator: EvilPenguin|
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

#pragma mark -
#pragma mark == Public Methods ==

static id removeRecentsAppListFromArray(id array) {
    if (array != nil && [array count] > 0) {
        NSMutableArray *newAppList = [NSMutableArray array];
        SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
        
        for (NSString *bundleIdentifier in array) {
            if ([bundleIdentifier rangeOfString:@"com.apple.springboard"].location != NSNotFound) {
                [newAppList addObject:bundleIdentifier];
            }
            else {
                NSArray *apps = [appController applicationsWithBundleIdentifier:bundleIdentifier];
                for (id app in apps) {
                    if ([app isRunning]) [newAppList addObject:bundleIdentifier];
                }
            }
        }
        
        return newAppList;
    }

    return nil;
}

#pragma mark -
#pragma mark == Hooking ==

%hook SBAppSliderController
// iOS 7
- (id)_beginAppListAccess {
    id appList = %orig;
    
    return removeRecentsAppListFromArray(appList);
}

- (NSArray *) applicationList {
    id appList = %orig;

    return removeRecentsAppListFromArray(appList);
}
%end

%hook SBAppSwitcherController
// iOS 6
- (id)_bundleIdentifiersForViewDisplay {
	id appList = %orig;

	return removeRecentsAppListFromArray(appList);
}

// iOS 5
- (id)_applicationIconsExceptTopApp {
	id appList = %orig;
	
	NSMutableArray *newAppList = [NSMutableArray array];
	for (SBIconView *iconView in appList) {
		id sbApplication = [iconView.icon application];
		if ([[sbApplication process] isRunning]) [newAppList addObject:iconView];
	}
	return newAppList;
}

// iOS 4
- (id)_applicationIconsExcept:(id)application forOrientation:(int)orientation {
	id appList = %orig(application, orientation);

	NSMutableArray *newAppList = [NSMutableArray array];
	for (SBApplicationIcon *icon in appList) {
		if ([[[icon application] process] isRunning]) [newAppList addObject:icon];
	}
	return newAppList;
}
%end
