task_type = pupil_task_type( 'wood-hand' );

bin_size = 500; % ms

% source_dir = '... reprocessed_olga/';
% dest_dir = '... binned_reprocessed/';

source_dir = '/Users/Nick/Downloads/pupil 2/reprocessed_olga';
dest_dir = '/Users/Nick/Downloads/pupil 2/binned_reprocessed';

source_mats = shared_utils.io.findmat( source_dir, true );

pupil_make_binned_processed_file( source_mats, dest_dir, bin_size, task_type, true );