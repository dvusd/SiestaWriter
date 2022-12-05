StartTest(function(t){
    var cls = '${class}';

    t.chainDone(
        'createStoresAndThen("'+cls+'")',
        'loadStoreRowsAndThen("'+cls+'")',
    );
});