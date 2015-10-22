document.addEventListener('DOMContentLoaded', function() {
    chrome.tabs.onUpdated.addListener( function(tabId,changeInfo,tab) {
        chrome.pageAction.show(tabId);
    });
});

