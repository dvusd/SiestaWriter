StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {"autoShow":true, "height":null, "width":null})',
        'waitForCQVisible("'+xtype+'")',
        'destroyCQ("'+xtype+'")'
    );
});