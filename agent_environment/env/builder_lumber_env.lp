% translate actions from builder and convert it to observation for lumber
observe(payment(Amount, PaymentType), Time):- occur(pay(Amount, PaymentType), Time).
#show observe/2. 