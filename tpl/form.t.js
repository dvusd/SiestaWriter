StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {})',
        'clickEachField("'+xtype+'")',
        'clickSelector(".x-panel-header")',
        'clickCQ("'+xtype+' tool[type=close]")',
        'destroyCQ("'+xtype+'")'
    );
});
