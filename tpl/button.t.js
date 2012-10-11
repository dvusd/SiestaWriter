StartTest(function(t) {
    var Ext = t.getExt(),
        cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        { action:'run', fn:'render', args:[cls, {height:null, width:null}] },
        { action:'run', fn:'destroyCQ', args:xtype }
    );
});