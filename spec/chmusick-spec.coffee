describe 'chmusick grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-chmusick')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.chmusick')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.chmusick'

  it 'tokenizes comments', ->
    lines = grammar.tokenizeLines '''
    // this is a comment
    int foo; // another comment

    /*
this is a block comment
still going...
    */
    <-- this is a comment, too
    '''

    commentDoubleSlash = [
      'source.
      '
      , 'comment.line.double-slash.chmusick'
    ]
    commentDoubleSlashDefinition = commentDoubleSlash.concat('punctuation.definition.comment.chmusick')
    commentBlock = ['source.chmusick', 'comment.block.chmusick']
    commentBlockDefinition = commentBlock.concat('punctuation.definition.comment.chmusick')

    expect(lines[0][0]).toEqual value: '//', scopes: commentDoubleSlashDefinition
    expect(lines[0][1]).toEqual value: ' this is a comment', scopes: commentDoubleSlash
    expect(lines[1][2]).toEqual value: '//', scopes: commentDoubleSlashDefinition
    expect(lines[1][3]).toEqual value: ' another comment', scopes: commentDoubleSlash
    expect(lines[3][0]).toEqual value: '/*', scopes: commentBlockDefinition
    expect(lines[4][0]).toEqual value: 'this is a block comment', scopes: commentBlock
    expect(lines[5][0]).toEqual value: 'still going...', scopes: commentBlock
    expect(lines[6][0]).toEqual value: '*/', scopes: commentBlockDefinition
    expect(lines[7][0]).toEqual value: '<--', scopes: commentDoubleSlashDefinition
    expect(lines[7][1]).toEqual value: ' this is a comment, too', scopes: commentDoubleSlash

  it 'tokenizes debug print', ->
    {tokens} = grammar.tokenizeLine '<<< expression >>>;'
    debugScope = [
      'source.chmusick', 'support.function.debug.chmusick'
    ]
    expect(tokens[0]).toEqual value: '<<<', scopes: debugScope
    expect(tokens[2]).toEqual value: '>>>', scopes: debugScope

  it 'tokenizes primitive types', ->
    {tokens} = grammar.tokenizeLine '0 => int a;'
    primitiveTypes = [
      'source.chmusick', 'storage.type.chmusick'
    ]
    expect(tokens[4]).toEqual value: 'int', scopes: primitiveTypes

    {tokens} = grammar.tokenizeLine 'int float time dur void same complex ' +
      'polar string'
    [
      'int', 'float', 'time', 'dur', 'void', 'same', 'complex', 'polar', 'string'
    ].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: primitiveTypes

  it 'tokenizes control structures', ->
    {tokens} = grammar.tokenizeLine 'for(;;) {}'
    controlStructures = [
      'source.chmusick', 'keyword.control.chmusick'
    ]
    expect(tokens[0]).toEqual value: 'for', scopes: controlStructures

    {tokens} = grammar.tokenizeLine 'if else while until for repeat break continue' +
        ' return switch do'
    ['if', 'else', 'while', 'until', 'for', 'repeat', 'break'
        , 'continue', 'return', 'switch', 'do'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: controlStructures

  it 'tokenizes class storage type', ->
    classKeywords = [
      'source.chmusick', 'storage.type.class.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'class interface'
    ['class', 'interface'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: classKeywords

  it 'tokenizes class modifiers', ->
    classKeywords = [
      'source.chmusick', 'storage.modifier.class.chmusick'
    ]
    {tokens} = grammar.tokenizeLine  'extends public static pure' +
        ' implements protected private'
    ['extends', 'public', 'static', 'pure'
        , 'implements', 'protected', 'private'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: classKeywords

  it 'tokenizes language variables', ->
    classKeywords = [
      'source.chmusick', 'variable.language.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'this super'
    ['this', 'super'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: classKeywords

  it 'tokenizes other chmusick keywords', ->
    otherKeywords = [
      'source.chmusick', 'keyword.control.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'function fun spork const new'
    ['function', 'fun', 'spork', 'const', 'new'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: otherKeywords

  it 'tokenizes special values', ->
    specials = [
      'source.chmusick', 'constant.special.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'now true false maybe null NULL me samp ms' +
        ' second minute hour day week chout cherr dac adc blackhole'
    ['now', 'true', 'false', 'maybe', 'null', 'NULL', 'me'
        , 'samp', 'ms', 'second', 'minute', 'hour', 'day', 'week'
        , 'chout', 'cherr', 'dac', 'adc', 'blackhole'
        ].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes standard chmusick unit generators', ->
    specials = [
      'source.chmusick', 'support.class.ugen.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'SinOsc PulseOsc SqrOsc TriOsc SawOsc Phasor ' +
      'Noise Impulse Step Gain SndBuf HalfRect FullRect Mix2 Pan2 GenX ' +
      'CurveTable WarpTable LiSa Envelope ADSR Delay DelayA DelayL Echo JCRev ' +
      'NRev PRCRev Chorus Modulate PitShift SubNoise Blit BlitSaw BlitSquare ' +
      'WvIn WaveLoop WvOut OneZero TwoZero OnePole TwoPole PoleZero BiQuad ' +
      'Filter LPF HPF BPF BRF'
    ['SinOsc', 'PulseOsc', 'SqrOsc', 'TriOsc', 'SawOsc', 'Phasor',
      'Noise', 'Impulse', 'Step', 'Gain', 'SndBuf', 'HalfRect', 'FullRect',
      'Mix2', 'Pan2', 'GenX', 'CurveTable', 'WarpTable', 'LiSa',
      'Envelope', 'ADSR', 'Delay', 'DelayA', 'DelayL', 'Echo', 'JCRev', 'NRev',
      'PRCRev', 'Chorus', 'Modulate', 'PitShift', 'SubNoise', 'Blit', 'BlitSaw',
      'BlitSquare', 'WvIn', 'WaveLoop', 'WvOut', 'OneZero', 'TwoZero', 'OnePole',
      'TwoPole', 'PoleZero', 'BiQuad', 'Filter', 'LPF', 'HPF', 'BPF',
      'BRF'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

    {tokens} = grammar.tokenizeLine 'ResonZ Dyno SndBuf2 StkInstrument BandedWG ' +
      'BlowBotl BlowHole Bowed Brass Clarinet Flute Mandolin ModalBar Moog Saxofony ' +
      'Shakers Sitar StifKarp VoicForm FM BeeThree FMVoices HevyMetl PercFlut Rhodey ' +
      'TubeBell Wurley UGen_Multi UGen_Stereo Chubgraph Chugen FilterBasic FilterStk ' +
      'LiSa10 Gen5 Gen7 Gen9 Gen10 Gen17 CNoise BLT UGen'
    ['ResonZ', 'Dyno', 'SndBuf2', 'StkInstrument', 'BandedWG', 'BlowBotl', 'BlowHole',
      'Bowed', 'Brass', 'Clarinet', 'Flute', 'Mandolin', 'ModalBar', 'Moog', 'Saxofony',
      'Shakers', 'Sitar', 'StifKarp', 'VoicForm', 'FM', 'BeeThree', 'FMVoices', 'HevyMetl',
      'PercFlut', 'Rhodey', 'TubeBell', 'Wurley', 'UGen_Multi', 'UGen_Stereo', 'Chubgraph',
      'Chugen', 'FilterBasic', 'FilterStk', 'LiSa10', 'Gen5', 'Gen7', 'Gen9', 'Gen10',
      'Gen17', 'CNoise', 'BLT', 'UGen'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes standard chmusick unit analyzers', ->
    specials = [
      'source.chmusick', 'support.class.uana.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'UAna UAnaBlob Windowing FFT IFFT DCT IDCT ' +
      'Centroid Flux RMS RollOff Flip pilF AutoCorr XCorr ZeroX'
    ['UAna', 'UAnaBlob', 'Windowing', 'FFT', 'IFFT', 'DCT', 'IDCT',
      'Centroid', 'Flux', 'RMS', 'RollOff', 'Flip', 'pilF', 'AutoCorr',
      'XCorr', 'ZeroX'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes standard libraries and classes', ->
    specials = [
      'source.chmusick', 'support.class.library.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'Std Machine Math Shred RegEx Object'
    ['Std', 'Machine', 'Math', 'Shred', 'RegEx', 'Object'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes events and related stuff', ->
    specials = [
      'source.chmusick', 'support.class.event.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'Event MidiIn MidiMsg OscRecv OscEvent Hid ' +
      'HidMsg MidiOut OscOut OscIn OscMsg'
    ['Event', 'MidiIn', 'MidiMsg', 'OscRecv', 'OscEvent', 'Hid',
    'HidMsg', 'MidiOut', 'OscOut', 'OscIn', 'OscMsg'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes I/O stuff', ->
    specials = [
      'source.chmusick', 'support.class.io.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'IO FileIO StdOut StdErr SerialIO MidiFileIn KBHit'
    ['IO', 'FileIO', 'StdOut', 'StdErr', 'SerialIO', 'MidiFileIn', 'KBHit'
    ].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials

  it 'tokenizes ChuGins', ->
    specials = [
      'source.chmusick', 'support.class.chugin.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'ABSaturator AmbPan3 Bitcrusher MagicSine ' +
      'KasFilter FIR Pan4 Pan8 Pan16 PitchTrack GVerb Mesh2D Spectacle Elliptic ' +
      'WinFuncEnv PowerADSR FoldbackSaturator WPDiodeLadder WPKorg35'
    ['ABSaturator', 'AmbPan3', 'Bitcrusher', 'MagicSine', 'KasFilter', 'FIR',
      'Pan4', 'Pan8', 'Pan16', 'PitchTrack', 'GVerb', 'Mesh2D', 'Spectacle',
      'Elliptic', 'WinFuncEnv', 'PowerADSR', 'FoldbackSaturator', 'WPDiodeLadder',
      'WPKorg35', 'Chmusick', 'TheCooker', 'Notes','FMSynth','Synthfrog'
    ].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: specials


  it 'tokenizes numeric constants', ->
    numerics = [
      'source.chmusick', 'constant.numeric.chmusick'
    ]
    {tokens} = grammar.tokenizeLine '12 3.14 0xaaee 0Xd872 1.3e+10 3.4E-23 pi'
    ['12', '3.14', '0xaaee', '0Xd872', '1.3e+10', '3.4E-23',
    'pi'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: numerics

  it 'tokenizes operators', =>
    ops = [
      'source.chmusick', 'keyword.operator.chmusick'
    ]
    {tokens} = grammar.tokenizeLine '=> =< @=> + ++ - -- * / % +=> -=> *=> /=>' +
        ' %=> == != < > <= >= && || << >> & | ^ $ ::'
    ['=>', '=<', '@=>', '+', '++', '-', '--', '*', '/', '%', '+=>', '-=>', '*=>', '/=>'
        , '%=>', '==', '!=', '<', '>', '<=', '>=', '&&', '||', '<<', '>>', '&'
        , '|', '^', '$', '::'].forEach (element, index, arr) ->
      expect(tokens[index * 2]).toEqual value: element, scopes: ops

  it 'tokenizes string literals', =>
    {tokens} = grammar.tokenizeLine '"string literal \\"\\n"'
    doubleQuoted = ['source.chmusick', 'string.quoted.double.chmusick']
    charEscaped = doubleQuoted.concat('constant.character.escape.chmusick')
    expect(tokens[0]).toEqual value: '"'
      , scopes: doubleQuoted.concat('punctuation.definition.string.begin.chmusick')
    expect(tokens[1]).toEqual value: 'string literal '
      , scopes: doubleQuoted
    expect(tokens[2]).toEqual value: '\\"'
      , scopes: charEscaped
    expect(tokens[3]).toEqual value: '\\n'
      , scopes: charEscaped
    expect(tokens[4]).toEqual value: '"'
      , scopes: doubleQuoted.concat('punctuation.definition.string.end.chmusick')

  it 'tokenizes function calls', ->
    methods = [
      'source.chmusick', 'entity.name.function.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'a.call() otherCall()'
    expect(tokens[2]).toEqual value: 'call'
      , scopes: methods
    expect(tokens[4]).toEqual value: 'otherCall'
      , scopes: methods

  it 'tokenizes methods with chmusick op', ->
    props = [
      'source.chmusick', 'entity.name.function.chmusick'
    ]
    {tokens} = grammar.tokenizeLine 'a.prop'
    expect(tokens[2]).toEqual value: 'prop'
      , scopes: props
