# picky
See who is active or not in your chats. Keep control of your groups as Urbit expands.

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
