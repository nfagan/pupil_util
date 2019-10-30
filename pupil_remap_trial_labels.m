function [new_labels, success, msgs] = pupil_remap_trial_labels(labels, categories, subject_dir, info_str, info_header)

info_labs = fcat.from( info_str, info_header );

initials = subject_dir(isstrprop(subject_dir, 'upper'));
msgs = {};
success = true;

if ( numel(initials) ~= 2 )
  msgs{end+1} = sprintf( 'Could not locate initials for "%s".', subject_dir );
  success = false;
  initials = '<subject>';
end

new_labels = fcat.from( labels, categories );
addsetcat( new_labels, 'subject', initials );

to_replace = combs( new_labels, 'trial' );
replace_with = eachcell( @(x) strrep(x, 'trials', 'trial'), to_replace );

for i = 1:numel(to_replace)
  replace( new_labels, to_replace{i}, replace_with{i} );
end

copy_from_cats = {'location touch', 'type touch'};
assign_to_cats = {'condition', 'touch-type'};
assigned_non_matched_msg = false;

for i = 1:rows(new_labels)
  trial_ids = cellstr( new_labels, {'subject', 'trial', 'block'}, i );
  match_ind = find( info_labs, trial_ids );
  
  if ( ~isempty(match_ind) )
    assert( numel(match_ind) == 1, 'Expected 1 or 0 matches; got %d for "%s:%s".' ...
      , numel(match_ind), subject_dir, strjoin(trial_ids, ' | ') );
    
    copy_from_info = cellstr( info_labs, copy_from_cats, match_ind );
    setcat( new_labels, assign_to_cats, copy_from_info, i );
  else
    if ( ~assigned_non_matched_msg )
      msgs{end+1} = sprintf( 'No remapped trial info matched for "%s:%s".' ...
        , subject_dir, strjoin(trial_ids, ' | ') );
      assigned_non_matched_msg = true;
      success = false;
    end
    
    collapse_labs = makecollapsed( new_labels, assign_to_cats );
    setcat( new_labels, assign_to_cats, collapse_labs, i );
  end
end

new_labels = cellstr( new_labels, categories );

end