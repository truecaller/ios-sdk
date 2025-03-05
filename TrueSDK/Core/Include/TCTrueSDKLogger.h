//
//  TCTrueSDKLogger.h
//  TrueSDK
//
//  Created by Stefan Stolevski on 03/01/17.
//  Copyright © 2016 True Software Scandinavia AB. All rights reserved.
//

#ifdef DEBUG
#   define TCLog(...) NSLog(__VA_ARGS__)
#else
#   define TCLog(...)
#endif
