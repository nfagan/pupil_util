function [categories, labels, blocks, trials] = pupil_make_labels_wood_hand(conditions, condition_header)

is_condition = strcmpi( condition_header, 'condition' );
is_type = strcmpi( condition_header, 'type' );
is_block = strcmpi( condition_header, 'block' );
is_trial = strcmpi( condition_header, 'trial' );
is_hand = contains( lower(condition_header), 'hand' );

blocks = conditions(:, is_block);
trials = conditions(:, is_trial);

condition_strs = new_condition_to_str( conditions(:, is_condition) );
type_strs = new_touch_type_to_str( conditions(:, is_type) );
hand_strs = hand_to_str( conditions(:, is_hand) );

block_strs = arrayfun( @(x) sprintf('block-%d', x), blocks, 'un', 0 );
trial_strs = arrayfun( @(x) sprintf('trials-%d', x), trials, 'un', 0 );

categories = { 'condition', 'touch-type', 'hand-type', 'block', 'trial' };
labels = [ condition_strs, type_strs, hand_strs, block_strs, trial_strs ];

end

function strs = hand_to_str(hand_types)

hand_type_labels = { 'real', 'wood' };
strs = cell( size(hand_types) );

for i = 1:numel(hand_type_labels)
  type_ind = hand_types == i-1;
  strs(type_ind) = hand_type_labels(i);
end


end

function strs = new_touch_type_to_str(touch_types)

touch_type_labels = { 'dynamic', 'static', 'tapping' };
strs = cell( size(touch_types) );

for i = 1:numel(touch_type_labels)
  type_ind = touch_types == i;
  strs(type_ind) = touch_type_labels(i);
end

end

function strs = new_condition_to_str(conditions)

condition_labels = { 'hand', 'arm', 'shoulder' };
strs = cell( size(conditions) );

for i = 1:numel(condition_labels)
  cond_ind = conditions == i;
  strs(cond_ind) = condition_labels(i);
end

end