kernelSize = 2;

%%
fromChan = chanlocs256;
toChan = chanlocs128;

[ montageIdx128 ] = mapper_pooling( fromChan, toChan, kernelSize );

%%
fromChan = chanlocs128;
toChan = chanlocs64;

[ montageIdx64 ] = mapper_pooling( fromChan, toChan, kernelSize );

%%
fromChan = chanlocs64;
toChan = chanlocs32;

[ montageIdx32 ] = mapper_pooling( fromChan, toChan, kernelSize );

%%
fromChan = chanlocs32;
toChan = chanlocs16;

[ montageIdx16 ] = mapper_pooling( fromChan, toChan, kernelSize );

%%
fromChan = chanlocs16;
toChan = chanlocs8;

[ montageIdx8 ] = mapper_pooling( fromChan, toChan, kernelSize );