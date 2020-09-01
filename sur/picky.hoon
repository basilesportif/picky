/-  *resource, store=chat-store
|%
+$  action
  $%  [%messages rid=resource user=ship num-msgs=@]
      [%group-summary rid=resource]
      [%all-groups ~]
      [%bust-cache ~]
      [%alter-cache-ttl ttl=@dr]
      [%ban rid=resource user=ship]
  ==
:: all messages for a user in a chat, newest first
::
+$  banned  (jug resource ship)
+$  chat-cache  (jar [path ship] envelope:store)
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

