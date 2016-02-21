
// override global clog
clog = function(content){
    logInfo('background',content);
};

document.addEventListener('DOMContentLoaded', function() {
    clog('dom loaded');

    chrome.tabs.onUpdated.addListener( function(tabId,changeInfo,tab) {
        clog('new tab detected: ' + tab.url);
        clog(changeInfo.status);
        if(changeInfo.status != 'loading'){
            return;
        }

        chrome.pageAction.show(tabId);

        // if login , check current link status
        // if saved , show icon 'on.png'
        // Check login state
        apiCurrentUser(function(user){
            clog('succeed=' + user.name);

            apiLinkInfo({
                url:tab.url
            },function(result){
                if(result.existed){
                    clog('url is exist:' + tab.url);
                    chromeIconOn();
                }else{
                    clog('url not exist:' + tab.url);
                }
            },function(){
                // Error
            });

        }, function () {
            clog('fail check login');

            currentUser = null;
        });

    });
});

