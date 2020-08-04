/-  *resource, store=chat-store
|%
+$  action
  $%  [%load-chats ~]
      [%dummy ~]
  ==
:: all messages for a user in a chat, newest first
::
+$  chat-cache  (map [path ship] (list envelope:store))
+$  gs-cache  [updated=time ttl=@dr gs=group-summaries]
::  envelope marked with chat path
::
+$  msg  [chat-path=path e=envelope:store]
+$  group-summaries  (map resource group-summary)
+$  group-summary
  $:  chats=(set path)
      stats=(map ship user-summary)
  ==
+$  user-summary
   $:  num-week=@
       num-month=@
  ==
--
