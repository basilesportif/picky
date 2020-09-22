 
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
:picky &picky-action [%messages [~timluc-miptev %the-collapse] ~timluc-miptev 10 ~d10]
:picky &picky-action [%group-summary [~timluc-miptev %the-collapse]]
:picky &picky-action [%all-chats ~]

::  WORKS
:picky &picky-action [%ban [~bacdul-timzod %dm--timluc-miptev] ~timluc-miptev]
:picky &picky-action [%ban [~timluc-miptev %the-collapse] ~rivdut-pitryl]
```

### misc test actions
```
:picky &picky-action [%group-summary [~bacdul-timzod %dm--timluc-miptev]]
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
