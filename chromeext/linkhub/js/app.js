/**
 * Created by everettjf on 10/22/15.
 */


var linkhubApp = angular.module('linkhubApp',[]);
var linkhubScope = null;

linkhubApp.controller('linkhubCtrl',['$scope','$http',function($scope,$http){
    console.log('controller');
    linkhubScope = $scope;

    // 0 checking login state
    // 1 did login
    // 2 not login
    $scope.loginState = 0;

    // Check login state
    apiCurrentUser(function(user){
        console.log('succeed=' + user.email);
        $scope.loginState = 1;
    }, function () {
        console.log('fail check login');
        $scope.loginState = 2;
    });

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



        // Check if added , otherwise try add it


    });
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('dom loaded');

    initPageInfo();
});



