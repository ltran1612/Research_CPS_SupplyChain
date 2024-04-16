% PAK1 = {C1: material-safe-for-production,
% C1: product-sufficiently-durable,
% C1: on-time-production,
% C2: on-time-delivery} 
addressedBy("cpsf:Material_Safe_For_Production", "C1").
addressedBy("cpsf:Product_Sufficiently_Durable", "C1").
addressedBy("cpsf:On_Time_Production", "C1").
addressedBy("cpsf:On_Time_Delivery", "C2").

% PAK4 {C12: on-time-payment} 
addressedBy("cpsf:On_Time_Payment", "C12").