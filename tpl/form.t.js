StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {})',
        'clickCQ("'+xtype+' field:not(combo)[disabled=false]{isVisible(true)}")',
        'clickCQ("'+xtype+' combo[disabled=false]{isVisible(true)}")',
        'clickCQ("'+xtype+' tool[type=close]")',
        'destroyCQ("'+xtype+'")'
    );
});