/**
 * Created by everettjf on 10/22/15.
 */


var linkhubApp = angular.module('linkhubApp',[]);
var linkhubScope = null;

var currentUser = null;

linkhubApp.controller('linkhubCtrl',['$scope','$http',function($scope,$http){
    console.log('controller');
    linkhubScope = $scope;

    // 0 checking login state
    // 1 did login
    // 2 not login
    $scope.loginState = 0;


    $scope.openNewTab = function (relativeUrl) {
        chrome.tabs.create({
            url:serverUrl(relativeUrl)
        },function(tab){
        });
    };
}]);


function initPageInfo(){
    var queryInfo = {
        active:true,
        currentWindow:true
    };

    chrome.tabs.query(queryInfo, function(tabs){
        console.log('active tab got');
        var tab = tabs[0];

        // Update UI
        linkhubScope.linkTitle = tab.title;
        linkhubScope.linkUrl = tab.url;
        linkhubScope.linkFavicon = tab.favIconUrl;
        linkhubScope.$apply();

        // Check login state
        apiCurrentUser(function(user){
            console.log('succeed=' + user.email);
            linkhubScope.loginState = 1;
            linkhubScope.$apply();

            currentUser = user;

            // if added ,load it
            // else if not added , try add it



        }, function () {
            console.log('fail check login');
            linkhubScope.loginState = 2;
            linkhubScope.$apply();

            currentUser = null;
        });

    });
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('dom loaded');

    initPageInfo();
});



