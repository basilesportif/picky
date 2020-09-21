::  picky.hoon
::  chat admin dashboard backend
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
  ~&  >  '%picky  recompiled successfully'
  ^-  (quip card _this)
  =/  old  !<(versioned-state old-state)
  ?-  -.old
      %3  `this(state old)
    ::
      %2
    `this(state [%3 banned.old])
    ::
      %1
    `this(state [%3 *^banned])
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
    ?-    -.action
        %messages
      ~&  >>  %messages
      `state
      ::
        %group-summary
      ~&  >>  %group-summary
      `state
      ::
        %all-groups
        ::  TODO: return/print (set group-info)
      ~&  >>  %all-groups
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
    ~&  >>  "banned {<user>} from {<rid>}"
    =.  banned.state  (~(put ju banned.state) rid user)
    `this
  --
::
++  on-watch  on-watch:def
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
::
::  HELPER CORE
::
|_  =bowl:gall
+*  grp  ~(. group-lib bowl)
++  user-group-msgs
  |=  [group-rid=resource user=ship num-msgs=@]
  ^-  (list msg)
  ~
::
++  summarize-groups
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
    (~(gut by gs) rid (init-group-summary u.g))
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
  stats
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
