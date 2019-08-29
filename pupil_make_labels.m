function [categories, labels, blocks, trials] = pupil_make_labels(conditions, condition_header)

% condition
%   1 -> shoulder
%   2 -> neck
%   3 -> arm
%   4 -> hand
%
% type
%   0 -> nonsocial
%   1 -> social

is_condition = strcmpi( condition_header, 'condition' );
is_type = strcmpi( condition_header, 'type' );
is_block = strcmpi( condition_header, 'block' );
is_trial = strcmpi( condition_header, 'trial' );

blocks = conditions(:, is_block);
trials = conditions(:, is_trial);

condition_strs = condition_to_str( conditions(:, is_condition) );
type_strs = touch_type_to_str( conditions(:, is_type) );

block_strs = arrayfun( @(x) sprintf('block-%d', x), blocks, 'un', 0 );
trial_strs = arrayfun( @(x) sprintf('trials-%d', x), trials, 'un', 0 );

categories = { 'condition', 'touch-type', 'block', 'trial' };
labels = [ condition_strs, type_strs, block_strs, trial_strs ];

end

function strs = touch_type_to_str(touch_types)

touch_type_labels = { 'nonsocial', 'social' };
strs = cell( size(touch_types) );

for i = 1:numel(touch_type_labels)
  type_ind = touch_types == (i-1);
  strs(type_ind) = touch_type_labels(i);
end

end

function strs = condition_to_str(conditions)

condition_labels = { 'shoulder', 'neck', 'arm', 'hand' };
strs = cell( size(conditions) );

for i = 1:numel(condition_labels)
  cond_ind = conditions == i;
  strs(cond_ind) = condition_labels(i);
end

end