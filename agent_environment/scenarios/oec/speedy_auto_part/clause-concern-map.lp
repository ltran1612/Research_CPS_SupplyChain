% PAK1 = {C1: material-safe-for-production,
% C1: product-sufficiently-durable,
% C1: on-time-production,
% C2: on-time-delivery} 
addressedBy("cpsf:material-safe-for-production", "C1").
addressedBy("cpsf:product-sufficiently-durable", "C1").
addressedBy("cpsf:on-time-production", "C1").
addressedBy("cpsf:on-time-delivery", "C2").

% PAK4 {C12: on-time-payment} 
addressedBy("cpsf:on-time-payment", "C12").