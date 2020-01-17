function traces = pupil_check_traces_rows(traces, labels)

if ( size(traces, 1) ~= size(labels, 1) )
  assert( all(isnan(traces(1, :))) && size(traces, 1) == size(labels, 1) + 1 ...
    , ['For mismatching traces and labels, expected traces to have one' ...
    , ' more row than labels, with the first additional row containing' ...
    , ' all NaN values.'] );
  
  traces = traces(2:end, :);
end

end