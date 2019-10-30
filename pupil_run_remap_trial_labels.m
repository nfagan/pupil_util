%%

xls_path = '/Users/Nick/Downloads/Plots - summary_odm.xlsx';
[~, ~, raw] = xlsread( xls_path );

[info_str, as_parsed, header] = pupil_parse_recoded_trial_info( raw );
info_labs = fcat.from( info_str, header );

%%

do_save = true;

pupil_root = '/Users/Nick/Downloads/processed_olga';
output_dir = '/Users/Nick/Downloads/reprocessed_olga';

subject_mats = shared_utils.io.find( pupil_root, '.mat', true );

for i = 1:numel(subject_mats)
  trace_info = load( subject_mats{i} );
  subject_dir = shared_utils.io.filenames( fileparts( subject_mats{i}) );
  
  [trace_info.labels, success, msgs] = pupil_remap_trial_labels( trace_info.labels, trace_info.categories ...
    , subject_dir, info_str, header );
  
  if ( do_save && success )
    new_full_p = strrep( subject_mats{i}, pupil_root, output_dir );
    shared_utils.io.require_dir( fileparts(new_full_p) );
    
    fprintf( '\n Saving "%s".', new_full_p );
    
    save( new_full_p, '-struct', 'trace_info' );
  elseif ( ~success )
    fprintf( '\n Not saving "%s".\n', subject_dir );
    
    cellfun( @warning, msgs );
  end
end

