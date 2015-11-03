
// override global clog
clog = function(content){
    logInfo('app',content);
};

var mostlikelinkApp = angular.module('mostlikelinkApp',[]);
var mostlikelink = null;

var currentUser = null;
var currentTabID = null;

mostlikelinkApp.controller('mostlikelinkCtrl',['$scope','$http',function($scope,$http){
    clog('controller');
    mostlikelink = $scope;

    // 0 checking login state
    // 1 did login
    // 2 not login
    $scope.loginState = 0;

    $scope.errorInfo = '';

    $scope.linkUrl = '';
    $scope.linkTags = '';
    $scope.linkTitle = '';
    $scope.recommendTags = [];

    apiTagsRecommend(function(result){
        if(result.succeed){
            $scope.recommendTags = result.tags;
        }
    },function(){
    });

    $scope.appendTag = function (tag) {
        $scope.linkTags += ' ' + tag;
    };

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
            window.close();
        },function(){
            $scope.errorInfo = 'Failed to remove';
        });
    };

    $scope.updateLink = function () {
        apiUpdateLink({
            title:$scope.linkTitle,
            url:$scope.linkUrl,
            tags:$scope.linkTags,
        }, function (result) {
            window.close();
        },function(){
            $scope.errorInfo = 'Failed to update';
        });
    };

    $scope.onKeyDownTags = function(e){
        var keycode = window.event?e.keyCode:e.which;
        clog('keycode = ' + keycode);
        if(keycode==13) {
            $scope.updateLink();
        }
    };
    $scope.onKeyDownTitle = function(e) {
        var keycode = window.event?e.keyCode:e.which;
        clog('keycode = ' + keycode);
        if(keycode==13) {
            $scope.updateLink();
        }
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
        mostlikelink.linkTitle = tab.title;
        mostlikelink.linkUrl = tab.url;
        mostlikelink.linkFavicon = tab.favIconUrl;
        mostlikelink.$apply();

        // Check login state
        apiCurrentUser(function(user){
            clog('succeed=' + user.email);
            mostlikelink.loginState = 1;
            mostlikelink.$apply();

            currentUser = user;

            // if added ,load it
            // else if not added , try add it
            apiLinkInfo({
                url:tab.url
            },function(result){
                if(result.succeed){
                    clog('url is exist:' + result.title);

                    mostlikelink.linkTitle = result.title;
                    mostlikelink.linkTags = result.tags;
                    mostlikelink.$apply();
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
            mostlikelink.loginState = 2;
            mostlikelink.$apply();

            currentUser = null;
        });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    clog('dom loaded');

    initPageInfo();
});



