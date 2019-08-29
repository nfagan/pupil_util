function out_trace = pupil_mark_blinks(trace, margin, fig)

if ( nargin < 3 )
  fig = gcf();
end

ax = findobj( fig, 'type', 'axes' );

if ( isempty(ax) )
  ax = axes( 'parent', fig );
end

hold( ax, 'off' );

h = plot( 1:numel(trace), trace );

set( h, 'HitTest', 'off' );
set( ax, 'ButtonDownFcn', @click_callback );
set( fig, 'KeyPressFcn', @key_callback );
set( fig, 'CloseRequestFcn', @close_request );

selected_line = [];
should_proceed = true;
peaks = containers.Map();
peak_starts = [];
peak_stops = [];
out_trace = trace;
preview_line = [];
should_delete_fig = false;

while ( should_proceed )
  drawnow();
end

find_peaks();
remove_peaks();
cleanup();

  function preview()
    if ( ~isempty(preview_line) && isvalid(preview_line) )
      delete( preview_line );
    end
    
    preview_line = plot( ax, 1:numel(out_trace), out_trace, 'r', 'linewidth', 2 );
    set( preview_line, 'HitTest', 'off' );
  end

  function close_request(varargin)
    should_proceed = false;
    should_delete_fig = true;
  end

  function cleanup()
    set( ax, 'ButtonDownFcn', '' );
    set( fig, 'KeyPressFcn', '' );
    
    if ( should_delete_fig )
      delete( fig );
    end
  end

  function remove_peaks()
    out_trace = pupil_interpolate_blinks( trace, peak_starts, peak_stops, margin );
  end

  function find_peaks()
    peak_contents = values( peaks );
    peak_contents = sort( horzcat(peak_contents{:}) );
    
    if ( numel(peak_contents) == 1 )
      return
    end
    
    peak_starts = round( peak_contents(1:2:end) );
    peak_stops = round( peak_contents(2:2:end) );
    
    use_n = min( numel(peak_starts), numel(peak_stops) );
    
    peak_starts = peak_starts(1:use_n);
    peak_stops = peak_stops(1:use_n);
  end
  
  function key_callback(varargin)
    key = varargin{2}.Key;
    
    if ( strcmp(key, 'backspace') && has_selection() )
      line = selected_line;
      peak_id = line.UserData.peak_id;
      remove( peaks, peak_id );
      delete( line );
      deselect();
      
    elseif ( strcmp(key, 'return') )
      find_peaks();
      remove_peaks();
      preview();
      
    elseif ( strcmp(key, 'escape') )
      should_proceed = false;
    end
  end

  function tf = has_selection()
    tf = ~isempty( selected_line ) && isvalid( selected_line );
  end

  function deselect()
    if ( has_selection() )
      set( selected_line, 'color', [0, 0, 0] );
    end
    
    selected_line = [];
  end

  function click_callback(varargin)
    x = varargin{2}.IntersectionPoint(1);
    
    hold( ax, 'on' );
    lims = get( ax, 'ylim' );
    h = plot( ax, [x; x], lims(:), 'k--', 'linewidth', 4 );
    
    set( h, 'ButtonDownFcn', @mark_selected );
    id = char( java.util.UUID.randomUUID() );
    peaks(id) = x;
    set( h, 'UserData', struct('peak_id', id) );
  end

  function mark_selected(varargin)
    source = varargin{1};
    mark_selected = ~has_selection() || source ~= selected_line;
    
    deselect();
    
    if ( mark_selected )
      selected_line = source;
      set( selected_line, 'color', [1, 0, 0] );
    end
  end
end