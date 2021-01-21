/-  *resource, store=chat-store, graph-store, post
|%
+$  action
  $%  [%messages-by-group rids=(set resource) user=ship num-msgs=@ cutoff=@dr]
      [%all-messages user=ship num-msgs=@ cutoff=@dr]
      [%group-summary rid=resource]
      [%chats-groups only-mine=?]
      [%ban rid=resource user=ship]
      [%ignore rid=resource]                  ::  groups you don't want included in summaries (e.g. DMs)
  ==
+$  banned  (jug resource ship)
+$  ignored  (set resource)
+$  chat-path   path
+$  group-names  (map resource @t)
+$  chat-meta   [=chat-path name=@t]
+$  group-meta  [name=@t rid=resource stats=group-stats]
::  envelope marked with chat path
::
+$  msg-node  [=chat-path =post:post]
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
+$  chat-cache  (jar [path ship] post:post)
+$  gs-cache  [updated=time ttl=@dr gs=group-summaries]
--
