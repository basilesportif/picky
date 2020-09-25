::  picky.hoon
::  chat admin dashboard backend
::
::  +peek paths
::  /groups                 (set group-meta)
::
/-  *picky, md=metadata-store, store=chat-store, group, *resource
/+  dbug, default-agent, group-lib=group, resource
|%
+$  versioned-state
    $%  state-0
        state-1
        state-2
        state-3
    ==
::  record banned users since private groups don't record this
::
+$  state-3  [%3 =banned]
+$  state-2  [%2 =banned =chat-cache =gs-cache]
+$  state-1  [%1 =chat-cache]
+$  state-0
    $:  [%0 counter=@]
    ==
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state-3
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
  `this(state [%3 *^banned])
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ~&  >  '%picky recompiled successfully'
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
      %3  `this(state old)
    ::
      %2
    :_  this(state [%3 banned.old])
    ~[[%pass /leave %agent [our.bowl %chat-store] %leave ~]]
    ::
      %1
    :_  this(state [%3 *^banned])
    ~[[%pass /leave %agent [our.bowl %chat-store] %leave ~]]
    ::
      %0
    `this(state [%3 *^banned])
  ==
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  (team:title [our src]:bowl)
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
    ?-  -.action
        %messages
      ~&  >>  %+  turn  (user-group-msgs:hc +.action)
              |=([=msg] [chat-path.msg when.e.msg letter.e.msg])
      `state
      ::
        %group-summary
      ~&  >>  (group-info:hc rid.action)
      `state
      ::
        %all-chats
      ~&  >>  my-chats-by-group:hc
      `state
      ::
      ::  actual banning happens when our poke is acked
      ::
        %ban
      :_  state
      ~[(ban-user rid.action user.action)]
    ==
  ++  ban-user
    |=  [rid=resource user=ship]
    :*
      %pass
      /ban-user/[(scot %p entity.rid)]/[name.rid]/[(scot %p user)]
      %agent
      [entity.rid %group-push-hook]
      %poke
      [%group-update !>([%remove-members rid (sy ~[user])])]
    ==
  --
++  on-agent
  |=  [=wire =sign:agent:gall]
  |^  ^-  (quip card _this)
  ::  add user to our banned list on good group-push-hook ack
  ::
  ?:  ?&  ?=([%ban-user @ @ @ ~] wire)
          ?=([%poke-ack ~] sign)
      ==
    =/  rid=resource
      [(slav %p i.t.wire) i.t.t.wire]
    =/  user=ship  (slav %p i.t.t.t.wire)
    (ban rid user)
  `this
  ++  ban
    |=  [rid=resource user=ship]
    ^-  (quip card _this)
    ~&  >>  "banned {<user>} from {<rid>} "
    =.  banned.state  (~(put ju banned.state) rid user)
    `this
  --
::
++  on-peek
  |=  pax=path
  ^-  (unit (unit cage))
  ?+  pax  (on-peek:def pax)
      [%x %groups ~]
    =/  =group-names  my-group-names:hc
    =/  group-metas=(set group-meta)
      dummy-group-metas:hc
::      %-  ~(run in ~(key by group-names))
::      |=  rid=resource
::      [(~(got by group-names) rid) (group-info:hc rid)]
    ``noun+!>(group-metas)
  ==
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
::  HELPER CORE
::
|_  =bowl:gall
+*  grp  ~(. group-lib bowl)
++  dummy-group-metas
  ^-  (set group-meta)
  (sy ~[['The Collapse' [~timluc-miptev %the-collapse] [(sy ~[[/stupid-chat 'A Stupid Chat'] [/dumb-chat 'Very Dumb Stuff']]) *(map ship user-summary)]]])
+$  omsgs  ((mop msg $~) msg-after)
++  orm  ((ordered-map msg $~) msg-after)
++  tap-omsgs
  |=  ms=omsgs
  (turn (tap:orm ms) |=([m=msg *] m))
++  user-group-msgs
  |=  [group-rid=resource user=ship num-msgs=@ cutoff=@dr]
  ^-  (list msg)
  =|  ms=omsgs
  =/  chats=(list chat-meta)
    ~(tap in (~(gut by my-chats-by-group) group-rid *(set chat-meta)))
  |-
  ?~  chats  (scag num-msgs (tap-omsgs ms))
  %_  $
      ms  (process-mailbox chat-path.i.chats user num-msgs cutoff ms)
      chats  t.chats
  ==
::
++  process-mailbox
  |=  [=chat-path user=ship num-msgs=@ cutoff=@dr ms=omsgs]
  ^-  omsgs
  =/  mailbox  (scry-mailbox chat-path)
  ?~  mailbox  ms
  =/  es  envelopes.u.mailbox
  =|  seen=@
  |-
  ?~  es  ms
  ?:  (gte seen num-msgs)  ms
  ?.  (after-date cutoff when.i.es)  ms
  ?.  =(user author.i.es)  $(es t.es)
  $(es t.es, seen +(seen), ms (put:orm ms [chat-path i.es] ~))
::
++  group-info
  |=  rid=resource:resource
  ^-  group-stats
  =|  gs=group-stats
  =/  g=(unit group:group)
    (scry-group:grp rid)
  ?~  g  gs
  =/  stats=(map ship user-summary)
    %-  malt
    %+  turn  ~(tap in (all-members u.g))
    |=(user=ship [user *user-summary])
  =/  chats=(set chat-meta)
    (~(gut by my-chats-by-group) rid *(set chat-meta))
  =/  cs  ~(tap in chats)
  |-
  ?~  cs  [chats stats]
  =.  stats
    (calc-stats stats chat-path.i.cs)
  $(cs t.cs)
::  includes admins members to handle DM case
::
++  all-members
  |=  g=group:group
  ^-  (set ship)
  =/  admins=(set ship)
    (~(gut by tags.g) %admin *(set ship))
  (~(uni in admins) members.g)
++  calc-stats
  |=  [stats=(map ship user-summary) =chat-path]
  =/  users=(list ship)
    ~(tap in ~(key by stats))
  =/  mailbox  (scry-mailbox chat-path)
  ?~  mailbox  stats
  =/  es  envelopes.u.mailbox
  |-  ^+  stats
  ?~  users  stats
  =/  us=user-summary
    (~(got by stats) i.users)
  =.  stats
  %+  ~(put by stats)  i.users
    (update-user-summary i.users us es)
  $(users t.users)
++  update-user-summary
  |=  [user=ship us=user-summary es=(list envelope:store)]
  |-  ^-  user-summary
  ?~  es  us
  ?.  (after-date ~d30 when.i.es)  us
  ?.  =(author.i.es user)  $(es t.es)
  =.  us
    :*  ?:((after-date ~d7 when.i.es) +(num-week.us) num-week.us)
        +(num-month.us)
    ==
  $(es t.es)
++  after-date
  |=  [interval=@dr d=@da]
  ^-  ?  (gte d (sub now.bowl interval))
::
::
++  is-my-group
  |=  gp=group-path:md
  =/  rid=resource
    (de-path:resource gp)
  ?:  =(entity.rid our.bowl)
    %.y
  =/  g=(unit group:group)
    (scry-group:grp rid)
  ?~  g  %.n
  =/  admins=(set ship)
    (~(gut by tags.u.g) %admin *(set ship))
  (~(has in admins) our.bowl)
++  my-chats-by-group
  ^-  (jug resource chat-meta)
  =/  mc  my-chats
  =|  metas=(jug resource chat-meta)
  |-
  ?~  mc  metas
  =.  metas
    (~(put ju metas) rid.i.mc [app-path.i.mc title.i.mc])
  $(mc t.mc)
++  my-chats
  ^-  (list [rid=resource:resource =app-path:md title=@t])
  %+  turn
    %+  skim  ~(tap by (scry-md-assocs %chat))
    |=([[gp=group-path:md *] *] (is-my-group gp))
  |=([[gp=group-path:md @ ap=app-path:md] m=metadata:md] [(de-path:resource gp) ap title.m])
++  my-group-names
  ^-  group-names
  %-  ~(gas by *group-names)
    %+  turn
      %+  skim  ~(tap by (scry-md-assocs %contacts))
      |=([[gp=group-path:md *] *] (is-my-group gp))
    |=([[gp=group-path:md *] m=metadata:md] [(de-path:resource gp) title.m])
++  msg-after
  |=  [m1=msg m2=msg]
  ^-  ?  (gth when.e.m1 when.e.m2)
++  scry-md-assocs
  |=  app=app-name:md
  .^  associations:md
     %gx
     (scot %p our.bowl)
     %metadata-store
     (scot %da now.bowl)
     /app-name/[app]/noun
    ==
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
