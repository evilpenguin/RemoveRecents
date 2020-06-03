/*
 * Tweak: 	RemoveRecents
 * Version:	0.5.0
 * Creator: EvilPenguin (James Emrich)
 * 
 * Enjoy :0)
 */

#import "RemoveRecents.h"

#pragma mark -
#pragma mark == Public Functions ==

static id getRemoveRecentsArray(NSArray *array) {
  if (array.count > 0) {
    NSMutableArray *newArray = [NSMutableArray array];
    SBApplicationController *appController = [%c(SBApplicationController) sharedInstance];
    
    for (id object in array) {
      NSString *bundleIdentifier = NULL;
      if (@available(iOS 11.0, *)) {
        SBDisplayItem *displayItem = (SBDisplayItem *)[object allItems][0];
        bundleIdentifier = [displayItem displayIdentifier];
      } else if (@available(iOS 9.0, *)) {
        SBDisplayItem *displayItem = (SBDisplayItem *)object;
        bundleIdentifier = [displayItem displayIdentifier];
      } else if (@available(iOS 8.0, *)) {
        SBDisplayLayout *displayLayout = (SBDisplayLayout *)object;
        NSDictionary *plistDict = [displayLayout plistRepresentation];
        if ([plistDict count] > 0) {
          NSArray *displayItemsArray = plistDict[@"SBDisplayLayoutDisplayItemsPlistKey"];
          if ([displayItemsArray count] > 0) {
            NSDictionary *item = displayItemsArray[0];
            if ([item count] > 0) {
              bundleIdentifier = item[@"SBDisplayItemDisplayIdentifierPlistKey"];
            }
          }
        }
      } else {
        bundleIdentifier = object;
      }
      // Move along and remove the apps that are not running :)
      if ([bundleIdentifier rangeOfString:@"com.apple.springboard"].location != NSNotFound) {
        [newArray addObject:object];
      } else {
        // Use `applicationWithBundleIdentifier:` so we dont have to loop the array from `applicationsWithBundleIdentifier:`
        if ([appController respondsToSelector:@selector(applicationWithBundleIdentifier:)]) {
          id app = [appController applicationWithBundleIdentifier:bundleIdentifier];
          if ([app respondsToSelector:@selector(isRunning)]) {
            if ([app isRunning]) {
              [newArray addObject:object];
            }
          } else {
            if ([[app processState] isRunning]) {
              [newArray addObject:object];
            }
          }
        } else {
          NSArray *apps = [appController applicationsWithBundleIdentifier:bundleIdentifier];
          for (id app in apps) {
            if ([app isRunning]) [newArray addObject:object];
          }
        }
      }
    }
    return newArray;
  }
  return array;
}

#pragma mark -
#pragma mark == Hooking ==

%hook SBAppSwitcherModel
// iOS7, 8
- (id) snapshot {
  id appList = %orig;
  
  return getRemoveRecentsArray(appList);
}

// iOS 9, 10
- (id) displayItemsForAppsOfRoles:(id)arg1 {
  id appList = %orig;

  return getRemoveRecentsArray(appList);
}

// iOS 11
- (id) mainSwitcherAppLayouts {
  id appLayouts = %orig;
  
  return getRemoveRecentsArray(appLayouts);
}

%end

%hook SBAppSwitcherController
// iOS 6
- (id) _bundleIdentifiersForViewDisplay {
	id appList = %orig;

  return getRemoveRecentsArray(appList);
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
