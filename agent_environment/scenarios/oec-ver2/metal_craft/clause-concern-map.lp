% PMK2 = {C4: on-time-production,
% C4: material-safe-for-production,
% C4: product-sufficiently-durable,
% C5: on-time-delivery}
addressedBy("cpsf:on-time-production", "C4").
addressedBy("cpsf:material-safe-for-production", "C4").
addressedBy("cpsf:product-sufficiently-durable", "C4").
addressedBy("cpsf:on-time-delivery", "C5").

% PMK3 = {C8: on-time-payment}
addressedBy("cpsf:on-time-delivery", "C8").