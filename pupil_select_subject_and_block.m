function mask = pupil_select_subject_and_block(labels)

block1_ind = [];
block2_ind = [];
block3_ind = [];
block4_ind = [];

block1_ind = fcat.mask( labels ...
  , @find, 'block-1' ...
  , @findor, {'AlessandraAngiulli_14062019', 'AlessandraMartino_14062019'} ...
);

block2_ind = fcat.mask( labels ...
  , @find, 'block-2' ...
  , @findor, {'AlessandraAngiulli_14062019', 'AlessandraMartino_14062019'} ...
);

block3_ind = fcat.mask( labels ...
  , @find, 'block-3' ...
  , @findor, {'AlessandraAngiulli_14062019', 'AlessandraMartino_14062019'} ...
);

block4_ind = fcat.mask( labels ...
  , @find, 'block-4' ...
  , @findor, {'AlessandraAngiulli_14062019', 'AlessandraMartino_14062019'} ...
);

mask = union_many( block1_ind, block2_ind, block3_ind, block4_ind );

end