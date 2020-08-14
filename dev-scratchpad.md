 
## dbug queries
```
:picky +dbug [%state '(~(get by chat-cache) [/~timluc-miptev/the-collapse ~timluc-miptev])']

:picky +dbug [%state 'gs-cache']
:picky +dbug [%state 'ttl.gs-cache']
:picky +dbug [%state 'updated.gs-cache']
:picky +dbug [%state 'banned']

:picky +dbug [%state '~(get by gs-cache)']
```

## debug prints
```
~&  >>  (user-group-msgs:hc [~timluc-miptev %the-collapse] ~timluc-miptev 10)
```

## picky actions
```
:picky &picky-action [%messages [~timluc-miptev %the-collapse] ~larsum-tacrus 10]
:picky &picky-action [%group-summary [~timluc-miptev %the-collapse]]
:picky &picky-action [%all-groups ~]
:picky &picky-action [%alter-cache-ttl ~m1]

::  WORKs
:picky &picky-action [%ban [~bacdul-timzod %dm--timluc-miptev] ~timluc-miptev]
:picky &picky-action [%ban [~timluc-miptev %the-collapse] ~larsum-tacrus]

```

## dbug state
```
::  GET ALL members in The Collapse
:group-store +dbug [%state '(~(get by groups) [entity=~timluc-miptev name=%the-collapse])']

::  Check banned members in The Collapse
:picky +dbug [%state 'banned']
```
