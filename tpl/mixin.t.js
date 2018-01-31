StartTest(function(t) {
    var cls = '${class}';

    t.chainDone(
        'render("Ext.Panel", { "mixins":["'+cls+'"] })',
        'destroyCQ("panel")'
    );
});