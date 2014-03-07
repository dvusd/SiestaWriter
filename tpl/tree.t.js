StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {})',
        'clickCQ("'+xtype+' tool[type=close]")',
        'destroyCQ("'+xtype+'")'
    );
});