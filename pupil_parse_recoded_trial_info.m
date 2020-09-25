function [mat_info, as_parsed, categories] = pupil_parse_recoded_trial_info(raw, task_type)

task_type = pupil_task_type( task_type );

location_map = make_location_map( task_type );
touch_type_map = make_touch_type_map( task_type );
hand_type_map = make_hand_type_map();

required_cols = required_columns( task_type );
header = parse_header( raw );

required_inds = shared_utils.xls.find_in_header( required_cols, header ...
  , 'error_on_not_found', true ...
  , 'exact_match', true ...
);

rest = raw(2:end, :);
missing_rows = all( cellfun(@(x) isnumeric(x) && isnan(x), rest), 2 );
rest = rest(~missing_rows, :);

subjects = rest(:, required_inds(1));
blocks = vertcat( rest{:, required_inds(2)} );
block_order = vertcat( rest{:, required_inds(3)} );
trials = vertcat( rest{:, required_inds(4)} );
touch_locations = vertcat( rest{:, required_inds(5)} );
touch_types = vertcat( rest{:, required_inds(6)} );

blocks_str = arrayfun( @(x) sprintf('block-%d', x), blocks, 'un', 0 );
block_order_strs = arrayfun( @(x) sprintf('block-order-%d', x), block_order, 'un', 0 );
trials_str = arrayfun( @(x) sprintf('trial-%d', x), trials, 'un', 0 );
touch_locations_str = arrayfun( @(x) location_map(x), touch_locations, 'un', 0 );
touch_types_str = arrayfun( @(x) touch_type_map(x), touch_types, 'un', 0 );

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  hand_types = vertcat( rest{:, required_inds(7)} );
  hand_types_str = arrayfun( @(x) hand_type_map(x), hand_types, 'un', 0 );
end

as_parsed = struct();
as_parsed.subjects = subjects(:);
as_parsed.blocks = blocks(:);
as_parsed.block_orders = block_order(:);
as_parsed.trials = trials(:);
as_parsed.touch_locations = touch_locations(:);
as_parsed.touch_types = touch_types(:);

mat_info = [ subjects(:), trials_str(:), blocks_str(:) ...
  , block_order_strs, touch_locations_str(:), touch_types_str(:) ];

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  as_parsed.hand_types = hand_types;
  
  mat_info(:, end+1) = hand_types_str;
end

categories = { 'subject', 'trial', 'block', 'block-order', 'location touch', 'type touch' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  categories{end+1} = 'hand';
end

end

function header = parse_header(raw)

header = lower( shared_utils.cell.require_cellstr(raw(1, :)) );

end

function cols = required_columns(task_type)

cols = { 'subjects', 'block', 'block_order', 'trial', 'location touch', 'type touch' };

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  cols{end+1} = 'hand';
end

end

function touch_type_map = make_touch_type_map(task_type)

touch_type_map = containers.Map( 'keytype', 'double', 'valuetype', 'char' );

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  touch_type_map(1) = 'dynamic';
  touch_type_map(2) = 'static';
  touch_type_map(3) = 'tapping';
  
else
  touch_type_map(0) = 'control';
  touch_type_map(1) = 'social';
end

end

function location_map = make_location_map(task_type)

location_map = containers.Map( 'keytype', 'double', 'valuetype', 'char' );

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  location_map(1) = 'hand';
  location_map(2) = 'arm';
  location_map(3) = 'shoulder';
  
else
  location_map(1) = 'hand';
  location_map(2) = 'arm';
  location_map(3) = 'shoulder';
  location_map(4) = 'neck';
end

end

function hand_map = make_hand_type_map()

hand_map = containers.Map( 'keytype', 'double', 'valuetype', 'char' );
hand_map(0) = 'hand-type-real';
hand_map(1) = 'hand-type-wood';

end