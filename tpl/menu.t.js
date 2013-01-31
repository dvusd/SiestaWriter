StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        { action:'run', fn:'render', args:[cls, {autoShow:true,height:null,width:null}] },
        { action:'waitFor', waitFor:'waitForCQVisible', args:xtype },
        { action:'run', fn:'destroyCQ', args:xtype }
    );
});