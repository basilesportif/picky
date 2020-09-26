::  picky-view.hoon
::  handle view actions
::
/+  dbug, default-agent, view=picky-view, picky
|%
+$  versioned-state
    $%  state-0
    ==
::
+$  state-0  [%0 counter=@]
::
+$  card  card:agent:gall
::
--
%-  agent:dbug
=|  state-0
=*  state  -
^-  agent:gall
|_  =bowl:gall
+*  this      .
    def   ~(. (default-agent this %|) bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%picky-view initialized  successfully'
  =/  filea  [%file-server-action !>([%serve-dir /'~picky' /app/picky-view %.n %.y])]
  :_  this
  :~  [%pass /srv %agent [our.bowl %file-server] %poke filea]
  ==
++  on-save
  ^-  vase
  !>(state)
++  on-load
  |=  old-state=vase
  ^-  (quip card _this)
  ~&  >  '%picky-view recompiled successfully'
  `this(state !<(versioned-state old-state))
++  on-poke
  |=  [=mark =vase]
  |^  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %picky-view-action
      (handle-action !<(action:view vase))
  ==
  ++  handle-action
    |=  =action:view
    ~&  >>>  action
    `this
  --
::
++  on-watch
  |=  =path
  |^  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%primary ~]
    :_  this
    ~[[%give %fact ~[/primary] [%json !>((group-metas:enjs:picky scry-group-metas))]]]
  ==
  ++  scry-group-metas
    .^
      (set group-meta:picky)
      %gx
      (scot %p our.bowl)
      %picky
      (scot %da now.bowl)
      %groups
      %noun
      ~
    ==
  --
++  on-leave  on-leave:def
++  on-peek   on-peek:def
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
++  on-fail   on-fail:def
--
