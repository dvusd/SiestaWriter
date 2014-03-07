StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {"autoShow":true})',
        'waitForCQVisible("'+xtype+'")',
        'clickCQ("'+xtype+' tool[type=close]")',
        'destroyCQ("'+xtype+'")'
    );
});