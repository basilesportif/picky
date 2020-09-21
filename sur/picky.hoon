/-  *resource, store=chat-store
|%
+$  action
  $%  [%messages rid=resource user=ship num-msgs=@]
      [%group-summary rid=resource]
      [%all-chats ~]
      [%ban rid=resource user=ship]
  ==
:: all messages for a user in a chat, newest first
::
+$  banned  (jug resource ship)
+$  chat-path   path
+$  group-names  (map resource @t)
+$  chat-meta   [=chat-path name=@t]
::  envelope marked with chat path
::
+$  msg  [chat-path=path e=envelope:store]
+$  group-info
  $:  chats=(set chat-meta)
      stats=(set user-stats)
  ==
+$  user-stats
  $:   user=ship
       num-week=@
       num-month=@
  ==
:: DEPRECATED
::
+$  user-summary
  $:   num-week=@
       num-month=@
  ==
+$  group-summary
  $:  chats=(set chat-path)
      stats=(map ship user-summary)
  ==
+$  group-summaries  (map resource group-summary)
+$  chat-cache  (jar [path ship] envelope:store)
+$  gs-cache  [updated=time ttl=@dr gs=group-summaries]
--
