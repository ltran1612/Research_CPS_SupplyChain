:-  occur(deliver(Amount1, Quality), Time), 
    occur(deliver(Amount2, Quality), Time),
    quality(Quality), step(Time),
    Amount1 != Amount2.

:-  observe(payment(Amount1, PaymentType), Time),
    observe(payment(Amount2, PaymentType), Time),
    paymentType(PaymentType),
    step(Time),
    Amount1 != Amount2.