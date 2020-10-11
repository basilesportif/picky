 
## dbug queries
```
:picky +dbug [%state 'banned']
```

## Group scrys
```
=md -build-file %/sur/metadata-store/hoon
.^(associations:md %gx /=metadata-store=/app-name/chat/noun)

:: 'contacts' is the app for Group names
.^(associations:md %gx /=metadata-store=/app-name/contacts/noun)
```

## picky actions
```
::  Info about one group
:picky &picky-action [%group-summary [~timluc-miptev '---the-collapse-3.1--secure-the-bag']]
:picky &picky-action [%messages-by-group (sy ~[[~timluc-miptev '---the-collapse-3.1--secure-the-bag']]) ~timluc-miptev 10 ~d10]

::  only-mine param sets whether to return only groups I'm an admin of
:picky &picky-action [%chats-groups %.y]
:picky &picky-action [%chats-groups %.n]

::  Chats from multiple groups
:picky &picky-action [%messages-by-group (sy ~[[~timluc-miptev '---the-collapse-3.1--secure-the-bag'] [entity=~bitbet-bolbel name=%urbit-community]]) ~timluc-miptev 10 ~d10]

::  Chats from all groups
:picky &picky-action [%all-messages ~timluc-miptev 10 ~d10]

::  WORKS
:picky &picky-action [%ban [~bacdul-timzod %dm--timluc-miptev] ~timluc-miptev]
:picky &picky-action [%ban [~timluc-miptev %the-collapse] ~rivdut-pitryl]
```

### misc test actions
```
:picky &picky-action [%group-summary [~bacdul-timzod %dm--timluc-miptev]]
```

## `on-peek` scrys
```
=picky -build-file %/sur/picky/hoon
.^((set group-meta:picky) %gx /=picky=/groups/noun)
```

## dbug state
```
::  Check banned members in The Collapse
:picky +dbug [%state 'banned']
```
3
## picky actions remote JS
```
window.urb.poke(window.ship, 'picky-view', 'picky-view-action', {'messages': {rid: {entity: '~timluc-miptev', name: 'the-collapse'}, user: '~timluc-miptev', 'num-msgs': 4}}, () => console.log("Successful poke"), (err) => console.log(err));

window.urb.poke(window.ship, 'picky-view', 'picky-view-action', {'group-summary': {rid: {entity: '~timluc-miptev', name: 'the-collapse'}}}, () => console.log("Successful poke"), (err) => console.log(err));

window.urb.poke(window.ship, 'picky-view', 'picky-view-action', {ban: {rid: {entity: '~timluc-miptev', name: 'the-collapse'}, user: '~fabnev-hinmur'}}, () => console.log("Successful poke"), (err) => console.log(err));
```


## Old `on-poke`
```
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
        %messages-by-group
      ~&  >>  %+  turn  (user-group-msgs:hc +.action)
              |=([=msg] [chat-path.msg when.e.msg letter.e.msg])
      `state
      ::
        %all-messages
      =/  gns=(set resource)
        ~(key by all-group-names:hc)
      ~&  >>  %+  turn  (user-group-msgs:hc gns +.action)
              |=([=msg] [chat-path.msg when.e.msg letter.e.msg])
      `state
      ::
        %group-summary
      ~&  >>  (group-info:hc rid.action)
      `state
      ::
        %chats-groups
      =/  chats=(jug resource chat-meta)
        ?:(only-mine.action my-chats-by-group:hc all-chats-by-group:hc)
      ~&  >>  chats
      `state
      ::
      ::  actual banning happens when our poke is acked
      ::
        %ban
      :_  state
      ~[(ban-user rid.action user.action)]
        %ignore
      `state(ignored (~(put in ignored) rid.action))
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
```
