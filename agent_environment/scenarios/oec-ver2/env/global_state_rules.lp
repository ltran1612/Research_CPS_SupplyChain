% pay
hold_env(Receiver, notification((Sender, T), payment, Reason, Amount), T+1)
    :- occur_env(Sender, pay(Receiver, Reason, Amount), T), time(T+1).

hold_env(Receiver, notification((Sender, T), Item, Amount), T+1)
    :- occur_env(Sender, deliver(Receiver, Item, Amount), T), time(T+1).

hold_env(Receiver, notification((Sender, T), Item, Amount, Quality), T+1)
    :- occur_env(Sender, deliver(Receiver, Item, Amount, Quality), T), time(T+1).

hold_env(Ag, A, T) :- hold_env_attempt(Ag, A, T).