% normal_fluent
normal_fluent(payment). 
has_field(payment, agent). 
has_field(payment, reason). 
has_field(payment, amount). 

action(pay). 
has_argument(pay, agent).
has_argument(pay, reason).
has_argument(pay, amount).

action(receive). 
has_argument(pay, key).
has_argument(pay, reason).
has_argument(pay, amount).

% OPERATIONS
% 
% operation
%
% DYNAMIC LAWS
% payment
causes(pay, increase_amount, (), sent_payment, if, true).
causes(receive_money, decrease_amount, received_payment, (), if, true).

% available_funds
causes(pay, decrease_amount, (), available_funds, if, (have_enough_fund, ())).
causes(receive_money, increase_amount, (), available_funds, if, true). 

% receive items 
causes(receive, increase_amount, (), available_item, if, true).
causes(receive, increase_amount, (), received, ()).
% produce items 
causes(produce, increase_amount, (), available_item, if, true).
causes(produce, increase_amount, (), produced, if, true).

% deliver available_item
causes(deliver, decrease_amount, available_item, if, (have_enough_quantity, ())).
causes(deliver, increase_amount, delivered, if, (have_enough_quantity, ())).
