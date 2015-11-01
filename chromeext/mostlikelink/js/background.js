
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
            clog('succeed=' + user.email);

            apiLinkInfo({
                url:tab.url
            },function(result){
                if(result.succeed){
                    clog('url is exist:' + tab.url);
                    chrome.pageAction.setIcon({
                        tabId:tabId,
                        path:'image/on.png',
                    },function(){
                    });

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

