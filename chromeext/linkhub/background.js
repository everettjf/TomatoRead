document.addEventListener('DOMContentLoaded', function() {
    chrome.tabs.onUpdated.addListener( function(tabId) {
        chrome.pageAction.show(tabId);
    });
});

