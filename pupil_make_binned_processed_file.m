function binned_file = pupil_make_binned_processed_file(source_mats, dest_dir, bin_size)

all_data = {};

for i = 1:numel(source_mats)
  source_file = load( source_mats{i} );
  outer_dir = shared_utils.io.filenames( fileparts(source_mats{i}) );
  
  traces = source_file.out_traces;
  labels = fcat.from( source_file.labels, source_file.categories );

  traces = pupil_check_traces_rows( traces, labels );
  [traces, t] = pupil_bin_processed_data( traces, bin_size );
  
  assert_ispair( traces, labels );
  
  blocks = fcat.parse( cellstr(labels, 'block'), 'block-' );
  trials = fcat.parse( cellstr(labels, 'trial'), 'trial-' );
  locations = pupil_location_to_condition_id( cellstr(labels, 'condition') );
  touch_types = pupil_touch_type_to_condition_id( cellstr(labels, 'touch-type') );
  
  subject_initials = repmat( {pupil_extract_initials(outer_dir)}, size(touch_types) );
  
  mat_data = [ blocks, trials, locations, touch_types, traces ];
  cell_data = arrayfun( @(x) {x}, mat_data );
  all_data = [ all_data; [subject_initials, cell_data] ];
end

if ( isempty(all_data) )
  warning( 'No data were processed.' );
  return
end

header = { 'subject', 'block', 'trial', 'location', 'touch_type' };
header = [ header, arrayfun(@(x) sprintf('time_%d', x), t, 'un', 0) ];
assert( numel(header) == size(all_data, 2), 'Header size does not match data.' );

tbl = cell2table( all_data, 'VariableNames', header );

output_filename = fullfile( dest_dir, 'binned_processed.csv' );
shared_utils.io.require_dir( dest_dir );
writetable( tbl, output_filename );

end