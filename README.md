New features:
* Oct 8, 2020: see messages for any user across all groups you're in.

# picky
See who is active or not in your chats. Keep control of your groups as Urbit expands. Quickly associate planet names with their views across chats.

In addition to being useful, `%picky` shows lots of examples of how to use already-available Urbit ship data to craft custom group/user experiences.

`%picky` is now "ready to use at your own risk". It shouldn't break anything since it's all scrys.

## Installation
* make sure your `home` is mounted (`|mount %`) 

*THEN*
* run `./install.sh $PIER_DIR`
  - `$PIER_DIR` will be like `~/timluc-miptev/home`

*OR*

* copy `app/backy.hoon` to `/app`
* copy `sur/backy.hoon` to `/sur`
* copy `/mar/backy/action.hoon` to `/mar/backy`

THEN, to install:
```
|commit %home
|start %picky
```

## Usage

### All Groups/Chats 
Of which you're an admin:
```
:picky &picky-action [%chats-groups only-mine=%.y]
```

All:
```
:picky &picky-action [%chats-groups only-mine=%.n]
```

### Activity Stats for One Group
View poster activity over the past week/month.
(Takes a long time, since Urbit Community has a lot of users. Best to substitute your own group here.)
```
:picky &picky-action [%group-summary [~bitbet-bolbel 'urbit-community']]
```

### See Past N Messages from a Given User
(The "past X days" parameter below is to keep scrys fast. If your target is lower activity, adjust back in time as needed).

`~timluc-miptev`'s last 10 messages across 2 groups, over the past 10 days:
```
=groups (sy ~[[~timluc-miptev '---the-collapse-3.1--secure-the-bag'] [entity=~bitbet-bolbel name=%urbit-community]])
:picky &picky-action [%messages-by-group groups ~timluc-miptev 10 ~d10]
```

`~timluc-miptev`'s last 20 messages in all chats that I subscribe to, over the past year:
```
:picky &picky-action [%all-messages ~timluc-miptev 20 ~d365]
```

### Banning
Banning can only be done for groups in which you're an admin. Not fully implemented yet; use at your own risk.

## Dev: Live Code Reload
If you want to watch the code directories and copy them to their ship as they are modified:
```
./install.sh -w $PIER_DIR
```
