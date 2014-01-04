/*
 * Tweak: 	RemoveRecents
 * Version:	0.3.3
 * Creator: EvilPenguin|
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

%hook SBAppSliderController 
// iOS 7
- (id)_beginAppListAccess { 
	id appList = %orig;

	NSMutableArray *newAppList = [NSMutableArray array];
	SBApplicationController *appController = [objc_getClass("SBApplicationController") sharedInstance];

	for (NSString *bundleIdentifier in appList) {
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
%end

%hook SBAppSwitcherController
//iOS 6
- (id)_bundleIdentifiersForViewDisplay {
	id appList = %orig;

	NSMutableArray *newAppList = [NSMutableArray array];
	SBApplicationController *appController = [objc_getClass("SBApplicationController") sharedInstance];

	for (NSString *bundleIdentifier in appList) {
		NSArray *apps = [appController applicationsWithBundleIdentifier:bundleIdentifier];
		for (id app in apps) {
			if ([app isRunning]) [newAppList addObject:bundleIdentifier];
		}
	}
	
	return newAppList;
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
