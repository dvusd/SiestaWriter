StartTest(function(t) {
    var Ext = t.getExt(),
        cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {"height":null, "width":null})',
        'destroyCQ("'+xtype+'")'
    );
});