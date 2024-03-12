% pay
hold_env(Receiver, notification((Sender, T), payment, Reason, Amount), T)
    :- occur_env(Sender, pay(Receiver, Reason, Amount), T), time(T).

hold_env(Receiver, notification((Sender, T), Item, Amount), T)
    :- occur_env(Sender, deliver(Receiver, Item, Amount), T), time(T).

hold_env(Receiver, notification((Sender, T), Item, Amount, Quality), T)
    :- occur_env(Sender, deliver(Receiver, Item, Amount, Quality), T), time(T).

hold_env(Ag, A, T) :- hold_env_attempt(Ag, A, T).