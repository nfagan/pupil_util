function ids = pupil_touch_type_to_condition_id(touch_types, task_type)

if ( nargin < 2 )
  task_type = 'original';
end

task_type = pupil_task_type( task_type );

if ( ischar(touch_types) )
  touch_types = { touch_types };
end

if ( strcmp(task_type, pupil_task_type('wood-hand')) )
  ids = cellfun( @wood_hand_to_id, touch_types );
else
  ids = cellfun( @original_to_id, touch_types );
end

end

function id = wood_hand_to_id(label)

switch ( lower(label) )
  case 'dynamic'
    id = 1;
  case 'static'
    id = 2;
  case 'tapping'
    id = 3;
  otherwise
    error( 'Unrecognized location label "%s".', label );
end

end

function id = original_to_id(label)

switch ( lower(label) )
  case 'control'
    id = 0;
  case 'social'
    id = 1;
  otherwise
    error( 'Unrecognized location label "%s".', label );
end 

end