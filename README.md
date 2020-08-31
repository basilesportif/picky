**warning** `%picky` is in active development; don't use on real ships yet

If you want to see its power, I recommend firing it up on an `-L` ship where you are a group owner or admin, and then poking it with `%group-summary` or `%messages`.

# picky
See who is active or not in your chats. Keep control of your groups as Urbit expands.

In addition to being useful, `%picky` shows lots of examples of how to use already-available Urbit ship data to craft custom group/user experiences.

## Installation
* make sure your `home` is mounted (`|mount %`) 

*THEN*
* run `./install.sh $PIER_DIR`
  - `$PIER_DIR` will be like `~/timluc-miptev/home`

*OR*

* copy `app/backy.hoon` to `/app`
* copy `sur/backy.hoon` to `/sur`
* copy `/mar/backy/action.hoon` to `/mar/backy`

THEN
```
|commit %home
|start %picky
:picky &picky-action [%load-chats ~]
```

### Live Code Reload
If you want to watch the code directories and copy them to their ship as they are modified:
```
./install.sh -w $PIER_DIR
```
