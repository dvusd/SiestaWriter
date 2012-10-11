StartTest(function(t){
    var Ext = t.getExt(),
        cls = '${class}';

    t.requireOk(['Ext.ux.portal.util.Format','Ext.ux.portal.util.ResourceTypes'],function(){
        t.createModelAndThen(cls,function(model){
            t.loadModelAndThen(model,function(model){
                t.validateModelAndThen(model,function(model){
                    t.done();
                });
            });
        });
    });
});