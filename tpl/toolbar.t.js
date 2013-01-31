StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        { action:'run', fn:'render', args:[cls, {height:null}] },
        { action:'run', fn:'destroyCQ', args:xtype }
    );
});