/*!
 *  \~chinese
 *  @header EMConversation.h
 *  @abstract 聊天会话
 *  @author Hyphenate
 *  @version 3.00
 *
 *  \~english
 *  @header EMConversation.h
 *  @abstract Chat conversation
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "EMMessageBody.h"

/*
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *   Conversation type
 */
typedef enum{
    EMConversationTypeChat  = 0,    /*! \~chinese 单聊会话 \~english Chat */
    EMConversationTypeGroupChat,    /*! \~chinese 群聊会话 \~english Group chat */
    EMConversationTypeChatRoom,     /*! \~chinese 聊天室会话 \~english Chatroom chat */
}EMConversationType;

@class EMMessage;

/*!
 *  \~chinese
 *  聊天会话
 *
 *  \~english
 *  Chat conversation
 */
@interface EMConversation : NSObject

/*!
 *  \~chinese
 *  会话唯一标识
 *
 *  \~english
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/*!
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
@property (nonatomic, assign, readonly) EMConversationType type;

/*!
 *  \~chinese
 *   会话未读消息数量
 *
 *  \~english
 *  Count of unread messages
 */
@property (nonatomic, assign, readonly) int unreadMessagesCount;

/*!
 *  \~chinese
 *  会话扩展属性
 *
 *  \~english
 *  Conversation extend property
 */
@property (nonatomic, strong) NSDictionary *ext;

/*!
 *  \~chinese
 *  会话最新一条消息
 *
 *  \~english
 *  Conversation latest message
 */
@property (nonatomic, strong, readonly) EMMessage *latestMessage;

/*!
 *  \~chinese
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage  消息实例
 *
 *  @result 是否成功
 *
 *  \~english
 *  Insert a message to conversation, message's conversationId should equle to conversation's conversationId, message will be inserted to DB, and update conversation's property
 *
 *  @param aMessage  Message
 *
 *  @result Message insert result, YES: success, No: fail
 */
- (BOOL)insertMessage:(EMMessage *)aMessage;

/*!
 *  \~chinese
 *  删除一条消息
 *
 *  @param aMessageId  要删除消失的ID
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete a message
 *
 *  @param aMessageId  Message's ID who will be deleted
 *
 *  @result Message delete result, YES: success, No: fail
 */
- (BOOL)deleteMessageWithId:(NSString *)aMessageId;

/*!
 *  \~chinese
 *  删除该会话所有消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Delete all message of the conversation
 *
 *  @result Delete result, YES: success, No: fail
 */
- (BOOL)deleteAllMessages;

/*!
 *  \~chinese
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage  要更新的消息
 *
 *  @result 是否成功
 *
 *  \~english
 *  Update a message, can't update message's messageId, conversation's latestMessage and so on properties will update after update the message
 *
 *  @param aMessage  Message
 *
 *  @result Message update result, YES: success, No: fail
 */
- (BOOL)updateMessage:(EMMessage *)aMessage;

/*!
 *  \~chinese
 *  将消息设置为已读
 *
 *  @param aMessageId  要设置消息的ID
 *
 *  @result 是否成功
 *
 *  \~english
 *  Mark a message as read
 *
 *  @param aMessageId  Message's ID who will be set read status
 *
 *  @result Result of mark message as read, YES: success, No: fail
 */
- (BOOL)markMessageAsReadWithId:(NSString *)aMessageId;

/*!
 *  \~chinese
 *  将所有未读消息设置为已读
 *
 *  @result 是否成功
 *
 *  \~english
 *  Mark all message as read
 *
 *  @result Result of mark all message as read, YES: success, No: fail
 */
- (BOOL)markAllMessagesAsRead;

/*!
 *  \~chinese
 *  更新会话扩展属性到DB
 *
 *  @result 是否成功
 *
 *  \~english
 *  Update conversation extend properties to DB
 *
 *  @result Extend properties update result, YES: success, No: fail
 */
- (BOOL)updateConversationExtToDB;

/*!
 *  \~chinese
 *  获取指定ID的消息
 *
 *  @param aMessageId  消息ID
 *
 *  @result 消息
 *
 *  \~english
 *  Get a message with the ID
 *
 *  @param aMessageId  Message's id
 *
 *  @result Message instance
 */
- (EMMessage *)loadMessageWithId:(NSString *)aMessageId;

/*!
 *  \~chinese
 *  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息向前取
 *
 *  @param aMessageId  参考消息的ID
 *  @param aLimit      获取的条数
 *
 *  @result 消息列表<EMMessage>
 *
 *  \~english
 *  Get more messages from DB, result messages are sorted by receive time, and NOT include the reference message, if reference messag's ID is nil, will fetch message from latest message
 *
 *  @param aMessageId  Reference message's ID
 *  @param aLimit      Count of messages to load
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesFromId:(NSString *)aMessageId
                              limit:(int)aLimit;

/*!
 *  \~chinese
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aLimit是负数，则获取所有符合条件的消息
 *
 *  @param aType        消息类型
 *  @param aTimestamp   参考时间戳
 *  @param aLimit       获取的条数
 *
 *  @result 消息列表<EMMessage>
 *
 *  \~english
 *  Get more messages with specified type from DB, result messages are sorted by received time, if reference timestamp is negative, will fetch message from latest message, andd will fetch all messages that meet the condition if aLimit is negative
 *
 *  @param aType        Message type to load
 *  @param aTimestamp   Reference timestamp
 *  @param aLimit       Count of messages to load
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesWithType:(EMMessageBodyType)aType
                               before:(long long)aTimestamp
                                limit:(int)aLimit;

/*!
 *  \~chinese
 *  从数据库获取包含指定内容的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aLimit是负数，则获取所有符合条件的消息
 *
 *  @param aKeywords    搜索关键字
 *  @param aTimestamp   参考时间戳
 *  @param aLimit       获取的条数
 *
 *  @result 消息列表<EMMessage>
 *
 *  \~english
 *  Get more messages contain specified keywords from DB, result messages are sorted by received time, if reference timestamp is negative, will fetch message from latest message, andd will fetch all messages that meet the condition if aLimit is negative
 *
 *  @param aType        Message type to load
 *  @param aTimestamp   Reference timestamp
 *  @param aLimit       Count of messages to load
 *
 *  @result Message list<EMMessage>
 */
- (NSArray *)loadMoreMessagesContain:(NSString*)aKeywords
                               before:(long long)aTimestamp
                                limit:(int)aLimit;

/*!
 *  \~chinese
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 *
 *  \~english
 *  Get latest message that received from others
 *
 *  @result Message instance
 */
- (EMMessage *)latestMessageFromOthers;


@end
