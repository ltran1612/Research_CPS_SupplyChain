:-  occur(pay(Amount1, PaymentType), Time), 
    occur(pay(Amount2, PaymentType), Time), 
    step(Time), paymentType(PaymentType), 
    Amount1 != Amount2.

:-  observe(deliver(Amount1, Quality), Time),
    observe(deliver(Amount2, Quality), Time),
    quality(Quality),
    Amount1 != Amount2.