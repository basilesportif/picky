::  picky.hoon
::  chat admin dashboard backend
::
/-  *picky, md=metadata-store, store=chat-store, group
/+  dbug, default-agent, group-lib=group, resource
|%
+$  versioned-state
    $%  state-0
        state-1
    ==
::
+$  state-0
    $:  [%0 counter=@]
    ==
+$  state-1  [%1 =chat-cache]
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state-1
=*  state  -
^-  agent:gall
=<
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
    hc    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%picky initialized successfully'
  `this
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ~&  >  '%picky  recompiled successfully'
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
      %1  `this(state old)
    ::
      %0
    `this(state [%1 *^chat-cache])
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  |^
  =^  cards  state
  ?+    mark  (on-poke:def mark vase)
      %picky-action
    (poke-action !<(action vase))
  ==
  [cards this]
  ++  poke-action
    |=  =action
    ^-  (quip card _state)
    ?-    -.action
        %load-chats
      =/  mgc  my-groups-chats:hc
      =/  summary  (summarize-groups:hc mgc)
::      ~&  >>>  summary
      =.  chat-cache.state  (update-cache:hc mgc)
      [subscribe-chat-updates:hc state]
      ::
        %dummy
      `state
    ==
  --
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
::  TODO: handle chat updates
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
::  HELPER CORE
::
|_  =bowl:gall
+*  grp  ~(. group-lib bowl)
::  subscribes to chat updates if we're not subscribed
++  subscribe-chat-updates
  ^-  (list card)
  ?:  %-  ~(any in `(set [wire ship term])`~(key by wex.bowl))
        |=([=wire *] ?=([%chat-store-updates ~] wire))
    ~
  ~[[%pass /chat-store-updates %agent [our.bowl %chat-store] %watch /updates]]
++  update-cache
  |=  xs=(list [gp=group-path:md chat-path=app-path:md])
  =*  ccs  chat-cache.state
  |-  ^-  ^chat-cache
  ?~  xs  ccs
  =/  m=(unit mailbox:store)
    (scry-mailbox chat-path.i.xs)
  ?~  m  $(xs t.xs)
  $(xs t.xs, ccs (cache-mailbox chat-path.i.xs u.m))
::  caches a chat-store if it's uncached
::
++  cache-mailbox
  |=  [chat-path=path m=mailbox:store]
  ^-  ^chat-cache
  =*  ccs  chat-cache.state
  ?~  envelopes.m  ccs
  ::  make sure this chat-path not here before we flop
  ?:  (~(has by ccs) [chat-path author.i.envelopes.m])
    ccs
  =/  es  (flop envelopes.m)
  |-
  ?~  es  ccs
  =/  user-msgs=(list envelope:store)
    (~(gut by ccs) [chat-path author.i.es] ~)
  =.  ccs
    %+  ~(put by ccs)
      [chat-path author.i.es]
    [i.es user-msgs]
  $(es t.es)
::
::
++  summarize-groups
  ~&  >>  "summarize-groups"
  |=  xs=(list [gp=group-path:md chat-path=app-path:md])
  ^-  group-summaries
  =|  gs=group-summaries
  |-
  ?~  xs  gs
  =/  rid=resource
    (de-path:resource gp.i.xs)
  =/  g=(unit group:group)
    (scry-group:grp rid)
  ?~  g  $(xs t.xs)
  =/  gsum=group-summary
    ?:  (~(has by gs) rid)
      (~(got by gs) rid)
    (init-group-summary u.g)
  =.  chats.gsum
    (~(put in chats.gsum) chat-path.i.xs)
  =.  stats.gsum
    (calc-stats stats.gsum chat-path.i.xs)
  $(xs t.xs, gs (~(put by gs) rid gsum))
++  init-group-summary
  |=  [g=group:group]
  ^-  group-summary
  :-  *(set path)
  %-  malt
  %+  turn  ~(tap in (all-members g))
  |=(user=ship [user *user-summary])
::  includes admins members to handle DM case
::
++  all-members
  |=  g=group:group
  =/  admins=(set ship)
    (~(gut by tags.g) %admin *(set ship))
  (~(uni in admins) members.g)
++  calc-stats
  |=  [stats=(map ship user-summary) chat-path=path]
  =/  num-msgs=@  10
  =/  users=(list ship)
    ~(tap in ~(key by stats))
  |-  ^+  stats
  ?~  users  stats
  =/  us=user-summary
    (~(got by stats) i.users)
  =/  es=(list envelope:store)
    (~(gut by chat-cache) [chat-path i.users] ~)
  =.  stats
    %+  ~(put by stats)  i.users
    (update-user-summary us es)
  $(users t.users)
++  update-user-summary
  |=  [us=user-summary msgs=(list envelope:store)]
  |-  ^-  user-summary
  ?~  msgs  us
  ?.  (after-date ~d30 when.i.msgs)  us
  =.  us
    :*  ?:((after-date ~d7 when.i.msgs) +(num-week.us) num-week.us)
        +(num-month.us)
    ==
  $(msgs t.msgs)
++  after-date
  |=  [interval=@dr d=@da]
  (gte d (sub now.bowl interval))
::
::
++  is-my-group
  |=  gp=group-path:md
  ?&
    ?=([%ship @ @ ~] gp)
    =(i.t.gp (scot %p our.bowl))
  ==
++  my-groups-chats
  ^-  (list [group-path:md app-path:md])
  =/  xs=(list [group-path:md app-path:md])
    %~  tap  in
    =/  ai=(jug app-name:md [group-path:md app-path:md])
      .^
       (jug app-name:md [group-path:md app-path:md])
       %gy
       (scot %p our.bowl)
       %metadata-store
       (scot %da now.bowl)
       /app-indices
      ==
    (~(gut by ai) %chat *(set [group-path:md app-path:md]))
  %+  skim  xs
  |=([g=group-path:md *] (is-my-group g))
++  scry-mailbox
  |=  pax=path
  .^
    (unit mailbox:store)
    %gx
    (scot %p our.bowl)
    %chat-store
    (scot %da now.bowl)
    %mailbox
    (snoc `path`pax %noun)
  ==
--
