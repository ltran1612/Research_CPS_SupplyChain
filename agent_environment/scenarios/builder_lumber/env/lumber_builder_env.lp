% translate actions from lumber and convert it to observation for builder 
observe(delivered(Quantity, Quality), Time) :- occur(deliver(Quantity, Quality), Time).
#show observe/2.