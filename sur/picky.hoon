/-  *resource, store=chat-store
|%
+$  action
  $%  [%messages rid=resource user=ship num-msgs=@ cutoff=@dr]
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
+$  group-meta  [name=@t stats=group-stats]
::  envelope marked with chat path
::
+$  msg  [=chat-path e=envelope:store]
+$  user-summary
  $:   num-week=@
       num-month=@
  ==
+$  group-stats
  $:  chats=(set chat-meta)
      stats=(map ship user-summary)
  ==
:: DEPRECATED
::
+$  group-summary
  $:  chats=(set chat-path)
      stats=(map ship user-summary)
  ==
+$  group-summaries  (map resource group-summary)
+$  chat-cache  (jar [path ship] envelope:store)
+$  gs-cache  [updated=time ttl=@dr gs=group-summaries]
--

