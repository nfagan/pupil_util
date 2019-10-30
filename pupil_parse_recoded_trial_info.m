function [mat_info, as_parsed, required_cols] = pupil_parse_recoded_trial_info(raw)

location_map = make_location_map();
touch_type_map = make_touch_type_map();

required_cols = required_columns();
header = parse_header( raw );

required_inds = shared_utils.xls.find_in_header( required_cols, header ...
  , 'error_on_not_found', true ...
  , 'exact_match', false ...
);

rest = raw(2:end, :);
missing_rows = all( cellfun(@(x) isnumeric(x) && isnan(x), rest), 2 );
rest = rest(~missing_rows, :);

subjects = rest(:, required_inds(1));
blocks = vertcat( rest{:, required_inds(2)} );
trials = vertcat( rest{:, required_inds(3)} );
touch_locations = vertcat( rest{:, required_inds(4)} );
touch_types = vertcat( rest{:, required_inds(5)} );

blocks_str = arrayfun( @(x) sprintf('block-%d', x), blocks, 'un', 0 );
trials_str = arrayfun( @(x) sprintf('trial-%d', x), trials, 'un', 0 );
touch_locations_str = arrayfun( @(x) location_map(x), touch_locations, 'un', 0 );
touch_types_str = arrayfun( @(x) touch_type_map(x), touch_types, 'un', 0 );

as_parsed = struct();
as_parsed.subjects = subjects(:);
as_parsed.blocks = blocks(:);
as_parsed.trials = trials(:);
as_parsed.touch_locations = touch_locations(:);
as_parsed.touch_types = touch_types(:);

mat_info = [ subjects(:), trials_str(:), blocks_str(:) ...
  , touch_locations_str(:), touch_types_str(:) ];

end

function header = parse_header(raw)

header = lower( shared_utils.cell.require_cellstr(raw(1, :)) );

end

function cols = required_columns()

cols = { 'subject', 'block', 'trial', 'location touch', 'type touch' };

end

function touch_type_map = make_touch_type_map()

touch_type_map = containers.Map( 'keytype', 'double', 'valuetype', 'char' );

touch_type_map(0) = 'control';
touch_type_map(1) = 'social';

end

function location_map = make_location_map()

location_map = containers.Map( 'keytype', 'double', 'valuetype', 'char' );

location_map(1) = 'hand';
location_map(2) = 'arm';
location_map(3) = 'shoulder';
location_map(4) = 'neck';

end