StartTest(function(t){
    var Ext = t.getExt(),
        cls = '${class}';

    t.createStoresAndThen(cls,function(){
        var store = Ext.getStore(cls);
        t.is(!!store,true,'Retrieved store from StoreManager');
        
        t.loadStoresAndThen(store,function(){
            t.done();
        });
    });
});