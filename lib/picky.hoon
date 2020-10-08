/-  picky
/+  *resource
^?
|%
++  enjs
  =,  enjs:format
  |%
  ++  group-metas
    |=  gms=(set group-meta:picky)
    ^-  json
    [%a (turn ~(tap in gms) group-meta)]
  ++  group-meta
    |=  gm=group-meta:picky
    %-  pairs
    :~
      [%name [%s name.gm]]
      [%resource (custom-resource rid.gm)]
      [%chats [%a (turn ~(tap in chats.stats.gm) chat-meta)]]
      [%users [%a ~]]
    ==
  ::  spat is path to cord; stab is cord to path
  ++  chat-meta
    |=  cm=chat-meta:picky
    %-  pairs
    :~
      [%name [%s name.cm]]
      [%path [%s (spat chat-path.cm)]]
    ==
  ::  preserves '~' in ship name
  ::
  ++  custom-resource
    |=  rid=resource
    %-  pairs
    :~
      [%ship [%s (scot %p entity.rid)]]
      [%name [%s name.rid]]
    ==
  --
--
