StartTest(function(t) {
    var Ext = t.getExt(),
        cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        { action:'run', fn:'render', args:[cls, {autoShow:true}] },
        { action:'waitFor', waitFor:'waitForCQVisible', args:xtype },
        { action:'run', fn:'clickCQ', args:xtype+' tool[type="close"]' },
        { action:'run', fn:'destroyCQ', args:xtype }
    );
});