//
//  GlobalMacro.h
//  TestStoryboard
//
//  Created by MenThu on 2016/11/23.
//  Copyright © 2016年 MenThu. All rights reserved.
//

#ifndef GlobalMacro_h
#define GlobalMacro_h


#define MTColor(r,g,b,a)     [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]
#define MTRandomColor      MTColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256), 1.f)
#define LineColor MTRandomColor

#endif /* GlobalMacro_h */
