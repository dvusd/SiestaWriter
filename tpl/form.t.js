StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {})',
        'clickCQ("'+xtype+' field[disabled=false]{isVisible(true)}")',
        'clickCQ("'+xtype+' tool[type=close]")',
        'destroyCQ("'+xtype+'")'
    );
});