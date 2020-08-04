 
## dbug queries
```
:picky +dbug [%state '(~(get by chat-cache) [/~nibset-napwyn/design-3639 ~timluc-miptev])']

:picky +dbug [%state 'gs-cache']
:picky +dbug [%state 'ttl.gs-cache']
:picky +dbug [%state 'updated.gs-cache']

:picky +dbug [%state '~(get by gs-cache')]
```

## debug prints
```
::  to do this one, set "my groups" to be everything
~&  >>  (user-group-msgs:hc ~timluc-miptev [~bitbet-bolbel %urbit-community] 10)
```

## picky actions
```
:picky &picky-action [%user-msgs ~]
:picky &picky-action [%dummy ~]
```
