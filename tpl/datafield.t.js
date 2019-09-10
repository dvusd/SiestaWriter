StartTest(function(t) {
    var cls = '${class}',
        xtype = '${alias}';

    t.chainDone(
        'requireOk("'+cls+'")',
        function(cb){
            var field = Ext.create(cls, {});
            t.isString(field.getType());
            t.isFunction(field.convert);
            cb();
        }
    );
});