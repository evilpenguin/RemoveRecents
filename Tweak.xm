/*
 * Tweak: 	RemoveRecents
 * Version:	0.3.1
 * Creator: EvilPenguin|
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

%hook SBAppSwitcherController
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
