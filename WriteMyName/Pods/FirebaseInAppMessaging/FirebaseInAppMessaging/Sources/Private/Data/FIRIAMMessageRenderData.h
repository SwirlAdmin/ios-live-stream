/*
 * Copyright 2017 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <Foundation/Foundation.h>
#import "FirebaseInAppMessaging/Sources/Private/Data/FIRIAMRenderingEffectSetting.h"

@protocol FIRIAMMessageContentData;
NS_ASSUME_NONNULL_BEGIN
// This wraps the data that's needed for render the message's content in UI. It also contains
// certain meta data that's needed in responding to user's action
@interface FIRIAMMessageRenderData : NSObject
@property(nonatomic, nonnull, readonly) id<FIRIAMMessageContentData> contentData;
@property(nonatomic, nonnull, readonly) FIRIAMRenderingEffectSetting *renderingEffectSettings;
@property(nonatomic, nonnull, copy, readonly) NSString *messageID;
@property(nonatomic, nullable, copy, readonly) NSString *name;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithMessageID:(NSString *)messageID
                      messageName:(nullable NSString *)messageName
                      contentData:(id<FIRIAMMessageContentData>)contentData
                  renderingEffect:(FIRIAMRenderingEffectSetting *)renderEffect;
@end
NS_ASSUME_NONNULL_END
