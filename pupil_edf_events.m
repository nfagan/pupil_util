function [edf_events, event_ids] = pupil_edf_events(edf_file, log_file)

tracker_time_id = 'TRACKER_TIME';
display_fix1_id = 'DISPLAY_FIXATION1';
display_fix2_id = 'DISPLAY_FIXATION2';
begin_id = '(BEGIN)';

event_ids = { display_fix1_id, display_fix2_id };
use_begin = [true, true];

assert( numel(use_begin) == numel(event_ids) );

[log_time_points, log_identifiers, log_last] = parse_log_file( log_file );

edf_messages = edf_file.Events.Messages.info;

is_edf_tracker_time = contains_str( edf_messages, tracker_time_id );
is_log_tracker_time = contains_str( log_identifiers, tracker_time_id );

if ( nnz(is_edf_tracker_time) ~= nnz(is_log_tracker_time) )
  error( 'Expected %d %s messages in log file; got %d.', nnz(is_edf_tracker_time) ...
    , tracker_time_id, nnz(is_log_tracker_time) );
end

log_events = get_log_events( log_identifiers, log_time_points, log_last ...
  , event_ids, begin_id, use_begin );

edf_sync_times = edf_file.Events.Messages.time(is_edf_tracker_time);
log_sync_times = log_time_points(is_log_tracker_time);

edf_events = cell( size(log_events) );

for i = 1:numel(edf_events)
  edf_events{i} = interp1( log_sync_times, edf_sync_times, log_events{i}, 'linear', 'extrap' );
end

end

function log_events = get_log_events(log_identifiers, log_time_points, log_last, event_ids, begin_id, use_begin)

log_events = cell( 1, numel(event_ids) );

for i = 1:numel(event_ids)
  is_log_event = contains_str( log_identifiers, event_ids{i} );
  
  if ( use_begin(i) )
    is_log_event = is_log_event & contains_str( log_last, begin_id );
  end
  
  log_event_times = reshape( log_time_points(is_log_event), [], 1 );

  if ( any(isnan(log_event_times)) )
    error( 'Some log event times were NaN.' );
  end
  
  log_events{i} = log_event_times;
end

end

function [log_time_points, log_identifiers, log_last] = parse_log_file(log_file)

log_lines = cellfun( @(x) strsplit(x, ' '), strsplit(log_file, '\n'), 'un', 0 );
log_time_points = cellfun( @(x) str2double(x{1}), log_lines );
log_identifiers = cell( size(log_lines) );
log_last = cell( size(log_lines) );

for i = 1:numel(log_lines)
  if ( numel(log_lines{i}) < 2 )
    log_identifiers{i} = '';
  else
    log_identifiers{i} = log_lines{i}{2};
  end
  if ( all(isspace(log_lines{i}{end})) && numel(log_lines{i}) > 1 )
    log_last{i} = log_lines{i}{end-1};
  else
    log_last{i} = '';
  end
end

end

function tf = contains_str(messages, str)

tf = cellfun( @(x) ~isempty(strfind(x, str)), messages );

end