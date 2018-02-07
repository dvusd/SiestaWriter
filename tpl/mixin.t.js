StartTest(function(t) {
    var cls = '${class}';

    Ext.define('Ext.MixinTest',{
        extend: 'Ext.Panel',
        alias: 'widget.mixinpaneltest',
        mixins: [ cls ]
    });

    t.chainDone(
        'render("Ext.MixinTest", {})',
        'destroyCQ("panel")'
    );
});
