
// override global clog
clog = function(content){
    logInfo('app',content);
};

var linkhubApp = angular.module('linkhubApp',[]);
var linkhubScope = null;

var currentUser = null;
var currentTabID = null;

linkhubApp.controller('linkhubCtrl',['$scope','$http',function($scope,$http){
    clog('controller');
    linkhubScope = $scope;

    // 0 checking login state
    // 1 did login
    // 2 not login
    $scope.loginState = 0;

    $scope.linkUrl = '';


    $scope.openNewTab = function (relativeUrl) {
        chrome.tabs.create({
            url:serverUrl(relativeUrl)
        },function(tab){
        });
    };

    $scope.removeLink = function(){
        apiRemoveLink({
            url:$scope.linkUrl
        },function(result){
            chrome.pageAction.setIcon({
                tabId:currentTabID,
                path:'image/off.png',
            },function(){
            });
        },function(){
        });
    };
}]);


function initPageInfo(){
    var queryInfo = {
        active:true,
        currentWindow:true
    };

    chrome.tabs.query(queryInfo, function(tabs){
        clog('active tab got');
        var tab = tabs[0];
        currentTabID = tab.id;

        // Update UI
        linkhubScope.linkTitle = tab.title;
        linkhubScope.linkUrl = tab.url;
        linkhubScope.linkFavicon = tab.favIconUrl;
        linkhubScope.$apply();

        // Check login state
        apiCurrentUser(function(user){
            clog('succeed=' + user.email);
            linkhubScope.loginState = 1;
            linkhubScope.$apply();

            currentUser = user;

            // if added ,load it
            // else if not added , try add it
            apiIsExistLink({
                url:tab.url
            },function(result){
                if(result.exist){
                    clog('url is exist:' + tab.url);

                }else{
                    // Add (Fast add without tags)
                    apiAddLink({
                        title:tab.title,
                        url:tab.url
                    },function (result) {
                        // Succeed
                        chrome.pageAction.setIcon({
                            tabId:tab.id,
                            path:'image/on.png',
                        },function(){
                        });
                    },function(){
                        // Error
                    });
                }
            },function(){
                // Error
            });

        }, function () {
            clog('fail check login');
            linkhubScope.loginState = 2;
            linkhubScope.$apply();

            currentUser = null;
        });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    clog('dom loaded');

    initPageInfo();
});



