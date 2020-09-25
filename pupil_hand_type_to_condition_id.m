function ids = pupil_hand_type_to_condition_id(labels)

if ( ischar(labels) )
  labels = { labels };
end

ids = cellfun( @to_id, labels );

end

function id = to_id(label)

switch ( lower(label) )
  case {'real', 'hand-type-real'}
    id = 0;
  case {'wood', 'hand-type-wood'}
    id = 1;
  otherwise
    error( 'Unrecognized label "%s".', label );
end

end