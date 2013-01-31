StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        { action:'run', fn:'render', args:[cls, {}] },
        { action:'run', fn:'clickCQ', args:['tab'] },
        { action:'run', fn:'clickCQ', args:xtype+' tool[type="close"]' },
        { action:'run', fn:'destroyCQ', args:xtype }
    );
});