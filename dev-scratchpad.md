 
## dbug queries
```
:picky +dbug [%state '(~(get by chat-cache) [/~timluc-miptev/the-collapse ~timluc-miptev])']

:picky +dbug [%state 'gs-cache']
:picky +dbug [%state 'ttl.gs-cache']
:picky +dbug [%state 'updated.gs-cache']

:picky +dbug [%state '~(get by gs-cache')]
```

## debug prints
```
~&  >>  (user-group-msgs:hc ~timluc-miptev [~timluc-miptev %the-collapse] 10)
```

## picky actions
```
:picky &picky-action [%messages ~timluc-miptev [~timluc-miptev %the-collapse] 5]
:picky &picky-action [%group-summary [~timluc-miptev %the-collapse]]
:picky &picky-action [%all-groups ~]
:picky &picky-action [%alter-cache-ttl ~m1]
```
