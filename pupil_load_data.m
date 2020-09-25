function outs = pupil_load_data(outer_dir, label_func)

[conditions, condition_header] = load_excel_data( outer_dir );
[categories, labels, blocks, trials] = label_func( conditions, condition_header );

folders = shared_utils.io.find( outer_dir, 'folders' );

all_events = {};
all_samples = cell( numel(folders), 1 );
all_labels = cell( numel(folders), 1 );

event_ids = {};
block_ids = nan( size(all_samples) );

folder_names = reshape( shared_utils.io.filenames(folders), [], 1 );

for i = 1:numel(folders)
  outer_p = folders{i};

  edf_file = Edf2Mat( char(shared_utils.io.find(outer_p, '.edf')) );
  log_file = fileread( fullfile(outer_p, 'eb_messages.log') );

  [events, event_ids] = pupil_edf_events( edf_file, log_file );
  events = cellfun( @round, events, 'un', 0 );
  
  samples = struct();
  samples.pupilSize = edf_file.Samples.pupilSize;
  samples.time = edf_file.Samples.time;

  all_events = [ all_events; events ];
  all_samples{i} = samples;
  
  folder_name = folder_names{i};
  folder_name = folder_name(isstrprop(folder_name, 'digit'));
  
  block_id = str2double( folder_name );
  assert( ~any(isnan(block_id)), 'Failed to parse block number for: "%s".' ...
    , folder_names{i} );
  
  block_ind = blocks == block_id;
  tmp_labels = cell( numel(events{1}), numel(categories) );
  
  for j = 1:numel(events{1})
    trial_ind = trials == j & block_ind;
    assert( nnz(trial_ind) == 1 );
    
    tmp_labels(j, :) = labels(trial_ind, :);
  end
  
  block_ids(i) = block_id;
  all_labels{i} = tmp_labels;
end

outs = struct();
outs.folder_names = folder_names;
outs.folder_paths = folders(:);
outs.events = all_events;
outs.event_ids = event_ids;
outs.samples = all_samples;
outs.labels = all_labels;
outs.categories = categories;

outs.conditions = conditions;
outs.condition_header = condition_header;

outs.block_ids = block_ids;

end

function [conditions, header] = load_excel_data(outer_dir)

excel_file = shared_utils.io.find( outer_dir, '.xlsx' );
assert( numel(excel_file) == 1, 'Expected 1 excel file in "%s"; got %d.' ...
  , outer_dir, numel(excel_file) );

[conditions, header] = xlsread( excel_file{1} );
header = header(1, :);

end