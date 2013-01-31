StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';
    
    t.chainDone(
        'render("'+cls+'", {"height":null, "width":null})',
        'destroyCQ("'+xtype+'")'
    );
});