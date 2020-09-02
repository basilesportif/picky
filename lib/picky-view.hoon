/-  sur=picky-view
^?
=<  [sur .]
=,  sur
|%
++  dejs
  |%
  ++  action
    |=  jon=json
    ^-  ^action
    =,  dejs:format
    =<  (parse-json jon)
    |%
    ++  parse-json
      %-  of
      :~  [%messages messages]
          [%group-summary group-summary]
          [%ban ban]
      ==
    ::
    ++  messages
      %-  ot
      :~  [%rid resource]
          [%user entity]
          [%num-msgs ni]
      ==
    ::
    ++  group-summary
      (ot [%rid resource] ~)
    ::
    ++  ban
      (ot [%rid resource] [%user entity] ~)
    ++  resource
      (ot [%entity entity] [%name so] ~)
    ++  entity
      (su ;~(pfix sig fed:ag))
    --
  --
--
