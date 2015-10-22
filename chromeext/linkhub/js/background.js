document.addEventListener('DOMContentLoaded', function() {
    console.log('background dom loaded');

    chrome.tabs.onUpdated.addListener( function(tabId,changeInfo,tab) {
        console.log('background new tab detected: ' + tab.title);

        chrome.pageAction.show(tabId);

        // show default icon

        // if login , check current link status
        // if saved , show icon 'on.png'


    });
});

