function outs = pupil_load_processed(processed_mats)

traces = cell( numel(processed_mats), 1 );
labels = cell( size(traces) );
ts = cell( size(traces) );

for i = 1:numel(processed_mats)
  processed_file = load( processed_mats{i} );
  outer_folder = shared_utils.io.filenames( fileparts(processed_mats{i}) );
  
  labs = fcat.from( processed_file );
  psth = processed_file.out_traces(2:end, :);
  
  assert_ispair( psth, labs );
  addsetcat( labs, 'subject', outer_folder );
  
  traces{i} = psth;
  labels{i} = labs;
  ts{i} = 0:size(psth, 2)-1;
end

traces = vertcat( traces{:} );
labels = vertcat( fcat, labels{:} );

if ( isempty(ts) )
  ts = [];
else
  ts = ts{1};
end

outs = struct();
outs.traces = traces;
outs.labels = labels;
outs.t = ts;

end

